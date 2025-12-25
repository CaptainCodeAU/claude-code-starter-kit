# Claude Code Hooks

Hooks are user-defined shell commands that execute at specific points in Claude Code's lifecycle. They provide deterministic control over behavior.

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

## Configuration Location

Hooks are configured in `settings.json`:

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

## Matcher Patterns

- **Exact match**: `Write` (matches only Write tool)
- **Regex**: `Edit|Write` (matches Edit or Write)
- **Wildcard**: `*` or empty (matches all tools)
- **Bash patterns**: `Bash(git commit:*)` (matches git commit commands)
- **MCP tools**: `mcp__server__tool`

## Hook Input/Output

### Input (via stdin)
Hooks receive JSON with context:
```json
{
  "tool_name": "Edit",
  "tool_input": {
    "file_path": "/path/to/file.js",
    "old_string": "...",
    "new_string": "..."
  }
}
```

### Output (exit codes)

| Exit Code | Meaning | Behavior |
|-----------|---------|----------|
| 0 | Success | stdout shown in verbose mode (except SessionStart/UserPromptSubmit where it's added to context) |
| 2 | Blocking error | stderr fed back to Claude, operation blocked |
| Other | Non-blocking error | Shown in verbose mode |

### JSON Output Control

Return JSON to stdout for structured control:
```json
{
  "continue": true,
  "stopReason": "string",
  "suppressOutput": true,
  "systemMessage": "Warning shown to user"
}
```

### PreToolUse Specific Output

```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow",
    "permissionDecisionReason": "Matched whitelist",
    "updatedInput": { "field": "modified value" }
  }
}
```

## Environment Variables

Available in hook scripts:
- `CLAUDE_PROJECT_DIR` - Project root (absolute path)
- `CLAUDE_TOOL_FILE_PATH` - File path for file-related tools (PostToolUse)
- `CLAUDE_ENV_FILE` - Path to write persistent env vars (SessionStart only)

## Example Hooks

### Auto-format on Edit
```json
{
  "PostToolUse": [
    {
      "matcher": "Edit",
      "hooks": [
        {
          "type": "command",
          "command": "npx prettier --write $CLAUDE_TOOL_FILE_PATH || true",
          "timeout": 10
        }
      ]
    }
  ]
}
```

### Pre-commit Validation
```json
{
  "PreToolUse": [
    {
      "matcher": "Bash(git commit:*)",
      "hooks": [
        {
          "type": "command",
          "command": "npm run lint && npm run build",
          "timeout": 30
        }
      ]
    }
  ]
}
```

### Session Start Checks
```json
{
  "SessionStart": [
    {
      "hooks": [
        {
          "type": "command",
          "command": ".claude/hooks/check-environment.sh",
          "timeout": 5
        }
      ]
    }
  ]
}
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
          "command": "python3 -c \"import json,sys; d=json.load(sys.stdin); p=d.get('tool_input',{}).get('file_path',''); sys.exit(2 if '.env' in p or '.git/' in p else 0)\""
        }
      ]
    }
  ]
}
```

## SessionStart Special Features

### Persistent Environment Variables
```bash
#!/bin/bash
# SessionStart hook can set env vars that persist for all bash commands
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo 'export NODE_ENV=production' >> "$CLAUDE_ENV_FILE"
  echo 'export PATH="$PATH:./node_modules/.bin"' >> "$CLAUDE_ENV_FILE"
fi
exit 0
```

### Output Goes to Context
Unlike other hooks, SessionStart stdout is added to Claude's context (not just shown in verbose mode). Use this to inform Claude about project state.

## Debugging Hooks

```bash
# Enable debug mode
claude --debug

# View hook execution in logs
grep -i hook ~/.claude/debug/latest

# Test hooks manually
echo '{"tool_name":"Edit","tool_input":{"file_path":"test.js"}}' | .claude/hooks/my-hook.sh
```

## Security Best Practices

1. **Quote variables**: Use `"$VAR"` not `$VAR`
2. **Validate paths**: Check for `..` traversal
3. **Use absolute paths**: Reference `$CLAUDE_PROJECT_DIR`
4. **Skip sensitive files**: Never process `.env`, `.git/`, credentials
5. **Set timeouts**: Prevent runaway scripts

## Token Impact

**ZERO** - Hook configurations and scripts do not consume context tokens. They are parsed/executed by the system, not loaded into Claude's context.
