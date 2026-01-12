# Claude Code Hooks

Hooks are user-defined shell commands that execute at specific points in Claude Code's lifecycle. They provide deterministic control over behavior, ensuring certain actions always happen rather than relying on the LLM to choose to run them.

## Available Hook Events

| Event | When It Runs | Common Use Cases |
|-------|-------------|------------------|
| `PreToolUse` | Before tool executes | Block/modify tool calls, validation |
| `PostToolUse` | After tool completes | Auto-formatting, run tests, logging |
| `PermissionRequest` | When permission dialog shown | Auto-allow/deny based on rules |
| `UserPromptSubmit` | Before Claude processes prompt | Validate, add context |
| `Notification` | When Claude sends notifications | Custom notification handling |
| `Stop` | When main agent finishes | Decide if Claude should continue |
| `SubagentStop` | When subagent completes | Evaluate subagent completion |
| `PreCompact` | Before context compaction | Pre-compaction logic |
| `SessionStart` | When session starts/resumes | Load context, environment setup |
| `SessionEnd` | When session ends | Cleanup, logging, state saving |

## Configuration

### Basic Structure

Hooks are configured in `settings.json` files:
- `~/.claude/settings.json` - User settings (all projects)
- `.claude/settings.json` - Project settings (shared with team)
- `.claude/settings.local.json` - Local project settings (not committed)

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolPattern",
        "hooks": [
          {
            "type": "command",
            "command": "your-command",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Hook Types

#### Command Hooks (type: "command")

Execute bash commands:

```json
{
  "type": "command",
  "command": "your-command-here",
  "timeout": 30
}
```

#### Prompt-Based Hooks (type: "prompt")

Use an LLM (Haiku) to evaluate decisions. Best for `Stop` and `SubagentStop`:

```json
{
  "type": "prompt",
  "prompt": "Evaluate if Claude should stop: $ARGUMENTS. Check if all tasks are complete.",
  "timeout": 30
}
```

The LLM must respond with JSON:
```json
{
  "ok": true,
  "reason": "Explanation for the decision"
}
```

- `ok: true` allows the action
- `ok: false` with `reason` prevents it and shows reason to Claude

### Matcher Patterns

Matchers control which tools trigger the hook (for PreToolUse, PermissionRequest, PostToolUse):

| Pattern | Matches |
|---------|---------|
| `Write` | Exact match - only Write tool |
| `Edit\|Write` | Regex - Edit or Write |
| `Notebook.*` | Regex - NotebookEdit, NotebookRead, etc. |
| `*` or `""` | Wildcard - all tools |
| `mcp__server__tool` | MCP tools with specific pattern |

For events without matchers (UserPromptSubmit, Stop, SubagentStop, SessionStart, SessionEnd), omit the matcher field.

### Event-Specific Matchers

**Notification matchers:**
- `permission_prompt` - Permission requests
- `idle_prompt` - When Claude waiting for input (60+ seconds idle)
- `auth_success` - Authentication success
- `elicitation_dialog` - MCP tool elicitation input

**SessionStart matchers:**
- `startup` - Initial startup
- `resume` - From `--resume`, `--continue`, or `/resume`
- `clear` - From `/clear`
- `compact` - From auto or manual compact

**PreCompact matchers:**
- `manual` - Invoked from `/compact`
- `auto` - Invoked from auto-compact

### Project-Specific Hook Scripts

Use `$CLAUDE_PROJECT_DIR` to reference scripts in your project:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/check-style.sh"
          }
        ]
      }
    ]
  }
}
```

## Plugin Hooks

Plugins can provide hooks that merge with your configuration:

```json
{
  "description": "Automatic code formatting",
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format.sh",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

Plugin hooks use `${CLAUDE_PLUGIN_ROOT}` for the plugin directory path.

## Hooks in Skills, Agents, and Slash Commands

Hooks can be defined in component frontmatter, scoped to that component's lifecycle:

**Supported events:** `PreToolUse`, `PostToolUse`, `Stop`

**Skill example:**
```yaml
---
name: secure-operations
description: Perform operations with security checks
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/security-check.sh"
---
```

**Agent example:**
```yaml
---
name: code-reviewer
description: Review code changes
hooks:
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/run-linter.sh"
---
```

**Additional option for skills and slash commands:**
- `once: true` - Run hook only once per session, then remove it

## Hook Input

Hooks receive JSON via stdin with session information and event-specific data.

### Common Fields

```json
{
  "session_id": "abc123",
  "transcript_path": "/path/to/transcript.jsonl",
  "cwd": "/current/working/directory",
  "permission_mode": "default",
  "hook_event_name": "PreToolUse"
}
```

Permission modes: `"default"`, `"plan"`, `"acceptEdits"`, `"dontAsk"`, `"bypassPermissions"`

### PreToolUse Input

#### Bash Tool
```json
{
  "tool_name": "Bash",
  "tool_input": {
    "command": "npm run build",
    "description": "Build the project",
    "timeout": 120000,
    "run_in_background": false
  },
  "tool_use_id": "toolu_01ABC123..."
}
```

#### Write Tool
```json
{
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.txt",
    "content": "file content"
  }
}
```

#### Edit Tool
```json
{
  "tool_name": "Edit",
  "tool_input": {
    "file_path": "/path/to/file.txt",
    "old_string": "original text",
    "new_string": "replacement text",
    "replace_all": false
  }
}
```

#### Read Tool
```json
{
  "tool_name": "Read",
  "tool_input": {
    "file_path": "/path/to/file.txt",
    "offset": 0,
    "limit": 100
  }
}
```

### PostToolUse Input

Includes `tool_response` in addition to `tool_input`:

```json
{
  "tool_name": "Write",
  "tool_input": {
    "file_path": "/path/to/file.txt",
    "content": "file content"
  },
  "tool_response": {
    "filePath": "/path/to/file.txt",
    "success": true
  }
}
```

### Notification Input

```json
{
  "message": "Claude needs your permission to use Bash",
  "notification_type": "permission_prompt"
}
```

### UserPromptSubmit Input

```json
{
  "prompt": "Write a function to calculate factorial"
}
```

### Stop/SubagentStop Input

```json
{
  "stop_hook_active": true
}
```

`stop_hook_active` is true when already continuing due to a stop hook. Check this to prevent infinite loops.

### PreCompact Input

```json
{
  "trigger": "manual",
  "custom_instructions": ""
}
```

### SessionStart Input

```json
{
  "source": "startup"
}
```

### SessionEnd Input

```json
{
  "reason": "exit"
}
```

Reasons: `"clear"`, `"logout"`, `"prompt_input_exit"`, `"other"`

## Hook Output

### Exit Code Control

| Exit Code | Meaning | Behavior |
|-----------|---------|----------|
| 0 | Success | stdout shown in verbose mode; for UserPromptSubmit/SessionStart, stdout added to context |
| 2 | Blocking error | stderr fed back to Claude, operation blocked |
| Other | Non-blocking error | stderr shown in verbose mode |

### Exit Code 2 Behavior by Event

| Event | Exit Code 2 Behavior |
|-------|---------------------|
| `PreToolUse` | Blocks tool call, shows stderr to Claude |
| `PermissionRequest` | Denies permission, shows stderr to Claude |
| `PostToolUse` | Shows stderr to Claude (tool already ran) |
| `UserPromptSubmit` | Blocks prompt, erases it, shows stderr to user |
| `Stop` | Blocks stoppage, shows stderr to Claude |
| `SubagentStop` | Blocks stoppage, shows stderr to subagent |
| `Notification` | N/A, shows stderr to user only |
| `SessionStart` | N/A, shows stderr to user only |
| `SessionEnd` | N/A, shows stderr to user only |

### JSON Output Control

Return JSON to stdout for structured control (only processed with exit code 0):

```json
{
  "continue": true,
  "stopReason": "string",
  "suppressOutput": true,
  "systemMessage": "Warning shown to user"
}
```

- `continue: false` stops Claude after hooks run
- `stopReason` accompanies `continue: false` with reason for user (not Claude)
- `suppressOutput: true` hides stdout from transcript mode

### PreToolUse Decision Control

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "Matched whitelist",
    "updatedInput": {
      "field_to_modify": "new value"
    }
  }
}
```

Decisions:
- `"allow"` - Bypass permission system
- `"deny"` - Block tool call (reason shown to Claude)
- `"ask"` - Ask user to confirm

Use `updatedInput` to modify tool parameters before execution.

### PermissionRequest Decision Control

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "allow",
      "updatedInput": {
        "command": "npm run lint"
      }
    }
  }
}
```

For `"deny"`, include `"message"` (reason for model) and optional `"interrupt": true` to stop Claude.

### PostToolUse Decision Control

```json
{
  "decision": "block",
  "reason": "Explanation for decision",
  "hookSpecificOutput": {
    "hookEventName": "PostToolUse",
    "additionalContext": "Additional information for Claude"
  }
}
```

- `"block"` prompts Claude with `reason`
- `additionalContext` adds context for Claude

### UserPromptSubmit Decision Control

```json
{
  "decision": "block",
  "reason": "Security policy violation",
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "Additional context for Claude"
  }
}
```

- Plain text stdout (simpler): Added as context
- JSON with `additionalContext`: More structured control
- `"block"` prevents prompt processing, erases it from context

### Stop/SubagentStop Decision Control

```json
{
  "decision": "block",
  "reason": "Tasks incomplete - continue working"
}
```

- `"block"` prevents stopping; `reason` required for Claude to know how to proceed

### SessionStart Decision Control

```json
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "Context loaded from environment"
  }
}
```

## Environment Variables

Available in hook scripts:

| Variable | Description |
|----------|-------------|
| `CLAUDE_PROJECT_DIR` | Project root (absolute path) |
| `CLAUDE_TOOL_FILE_PATH` | File path for file-related tools (PostToolUse) |
| `CLAUDE_ENV_FILE` | Path to write persistent env vars (SessionStart only) |
| `CLAUDE_CODE_REMOTE` | `"true"` if running in remote/web environment, empty for local CLI |

## SessionStart Special Features

### Persistent Environment Variables

SessionStart hooks can set environment variables that persist for all subsequent bash commands:

```bash
#!/bin/bash
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export NODE_ENV=production' >> "$CLAUDE_ENV_FILE"
  echo 'export API_KEY=your-api-key' >> "$CLAUDE_ENV_FILE"
  echo 'export PATH="$PATH:./node_modules/.bin"' >> "$CLAUDE_ENV_FILE"
fi
exit 0
```

### Persisting Environment from Setup Commands

Capture environment changes from setup commands like `nvm use`:

```bash
#!/bin/bash
ENV_BEFORE=$(export -p | sort)

# Run setup commands
source ~/.nvm/nvm.sh
nvm use 20

if [ -n "$CLAUDE_ENV_FILE" ]; then
  ENV_AFTER=$(export -p | sort)
  comm -13 <(echo "$ENV_BEFORE") <(echo "$ENV_AFTER") >> "$CLAUDE_ENV_FILE"
fi
exit 0
```

### Output Goes to Context

Unlike other hooks, SessionStart stdout is added to Claude's context (not just shown in verbose mode).

## Working with MCP Tools

MCP tools follow the pattern `mcp__<server>__<tool>`:
- `mcp__memory__create_entities`
- `mcp__filesystem__read_file`
- `mcp__github__search_repositories`

Target specific MCP tools or entire servers:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "mcp__memory__.*",
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Memory operation' >> ~/mcp.log"
          }
        ]
      }
    ]
  }
}
```

## Example Hooks

### Auto-Format TypeScript

```json
{
  "PostToolUse": [
    {
      "matcher": "Edit|Write",
      "hooks": [
        {
          "type": "command",
          "command": "jq -r '.tool_input.file_path' | { read f; [[ \"$f\" == *.ts ]] && npx prettier --write \"$f\"; } || true"
        }
      ]
    }
  ]
}
```

### Markdown Formatter

Create `.claude/hooks/markdown_formatter.py`:

```python
#!/usr/bin/env python3
import json
import sys
import re
import os

def detect_language(code):
    s = code.strip()
    if re.search(r'^\s*[{\[]', s):
        try:
            json.loads(s)
            return 'json'
        except:
            pass
    if re.search(r'^\s*def\s+\w+\s*\(', s, re.M):
        return 'python'
    if re.search(r'\b(function\s+\w+\s*\(|const\s+\w+\s*=)', s):
        return 'javascript'
    if re.search(r'^#!.*\b(bash|sh)\b', s, re.M):
        return 'bash'
    return 'text'

def format_markdown(content):
    def add_lang(match):
        indent, info, body, closing = match.groups()
        if not info.strip():
            lang = detect_language(body)
            return f"{indent}```{lang}\n{body}{closing}\n"
        return match.group(0)

    pattern = r'(?ms)^([ \t]{0,3})```([^\n]*)\n(.*?)(\n\1```)\s*$'
    content = re.sub(pattern, add_lang, content)
    content = re.sub(r'\n{3,}', '\n\n', content)
    return content.rstrip() + '\n'

try:
    data = json.load(sys.stdin)
    path = data.get('tool_input', {}).get('file_path', '')

    if not path.endswith(('.md', '.mdx')):
        sys.exit(0)

    if os.path.exists(path):
        with open(path, 'r') as f:
            content = f.read()
        formatted = format_markdown(content)
        if formatted != content:
            with open(path, 'w') as f:
                f.write(formatted)
            print(f"Fixed markdown: {path}")
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
```

### Bash Command Validator

```python
#!/usr/bin/env python3
import json
import re
import sys

RULES = [
    (r"\bgrep\b(?!.*\|)", "Use 'rg' instead of 'grep'"),
    (r"\bfind\s+\S+\s+-name\b", "Use 'rg --files' instead of 'find -name'"),
]

try:
    data = json.load(sys.stdin)
except json.JSONDecodeError as e:
    print(f"Invalid JSON: {e}", file=sys.stderr)
    sys.exit(1)

if data.get("tool_name") != "Bash":
    sys.exit(0)

command = data.get("tool_input", {}).get("command", "")
issues = [msg for pattern, msg in RULES if re.search(pattern, command)]

if issues:
    for msg in issues:
        print(f"• {msg}", file=sys.stderr)
    sys.exit(2)
```

### Block Sensitive Files

```json
{
  "PreToolUse": [
    {
      "matcher": "Edit|Write",
      "hooks": [
        {
          "type": "command",
          "command": "python3 -c \"import json,sys; d=json.load(sys.stdin); p=d.get('tool_input',{}).get('file_path',''); sys.exit(2 if any(x in p for x in ['.env', '.git/', 'secrets/']) else 0)\""
        }
      ]
    }
  ]
}
```

### Custom Notifications

```json
{
  "Notification": [
    {
      "matcher": "permission_prompt",
      "hooks": [
        {
          "type": "command",
          "command": "notify-send 'Claude Code' 'Permission needed'"
        }
      ]
    },
    {
      "matcher": "idle_prompt",
      "hooks": [
        {
          "type": "command",
          "command": "notify-send 'Claude Code' 'Awaiting input'"
        }
      ]
    }
  ]
}
```

### Intelligent Stop Hook

```json
{
  "Stop": [
    {
      "hooks": [
        {
          "type": "prompt",
          "prompt": "Evaluate if Claude should stop. Context: $ARGUMENTS\n\nCheck if:\n1. All requested tasks are complete\n2. Any errors need addressing\n3. Follow-up work is needed\n\nRespond: {\"ok\": true} to stop, or {\"ok\": false, \"reason\": \"explanation\"} to continue.",
          "timeout": 30
        }
      ]
    }
  ]
}
```

## Security Best Practices

1. **Quote variables**: Use `"$VAR"` not `$VAR`
2. **Validate paths**: Check for `..` traversal
3. **Use absolute paths**: Reference `$CLAUDE_PROJECT_DIR`
4. **Skip sensitive files**: Never process `.env`, `.git/`, credentials
5. **Set timeouts**: Prevent runaway scripts
6. **Test manually**: Verify hooks work before relying on them

## Hook Execution Details

- **Timeout**: 60 seconds default, configurable per command
- **Parallelization**: All matching hooks run in parallel
- **Deduplication**: Identical hook commands are deduplicated
- **Environment**: Runs in current directory with Claude Code's environment

## Debugging

```bash
# Enable debug mode
claude --debug

# View hook execution details
grep -i hook ~/.claude/debug/latest

# Test hooks manually
echo '{"tool_name":"Edit","tool_input":{"file_path":"test.js"}}' | .claude/hooks/my-hook.sh
```

Use `/hooks` command in Claude Code to view registered hooks and verify configuration.

## Token Impact

**ZERO** - Hook configurations and scripts do not consume context tokens. They are parsed/executed by the system, not loaded into Claude's context.

## See Also

- [Settings Reference](./05-settings-reference.md) - Hook configuration in settings.json
- [Skills Reference](./03-skills.md) - Hooks in skill frontmatter
