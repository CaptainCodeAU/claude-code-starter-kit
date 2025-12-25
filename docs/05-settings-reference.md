# Settings.json Reference

The `settings.json` file configures Claude Code behavior at user or project level.

## File Locations

| File | Scope | Shared via Git? |
|------|-------|-----------------|
| `~/.claude/settings.json` | User (all projects) | No |
| `.claude/settings.json` | Project | Yes |
| `.claude/settings.local.json` | Project local | No (gitignored) |

## Complete Schema

```json
{
  "permissions": {
    "allow": [],
    "deny": [],
    "ask": [],
    "defaultMode": "default"
  },
  "hooks": {},
  "env": {},
  "model": "sonnet",
  "statusLine": {},
  "cleanupPeriodDays": 30,
  "includeCoAuthoredBy": true,
  "alwaysThinkingEnabled": false,
  "enabledPlugins": {}
}
```

## Permissions

Control what Claude can do without asking.

### Permission Rules

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run:*)",
      "Bash(git status)",
      "Read(./**)",
      "Edit(./**)"
    ],
    "deny": [
      "Bash(rm -rf:*)",
      "Write(.env)"
    ],
    "ask": [
      "Bash(git push:*)",
      "Bash(git commit:*)"
    ],
    "defaultMode": "default"
  }
}
```

### Pattern Syntax

- `Tool(pattern)` - Match tool with argument pattern
- `*` - Wildcard (any characters)
- `:*` - Match any arguments after prefix

### Common Permission Patterns

```json
{
  "allow": [
    "Bash(npm run:*)",
    "Bash(npm install)",
    "Bash(npm test:*)",
    "Bash(npx:*)",
    "Bash(git status)",
    "Bash(git diff)",
    "Bash(git log:*)",
    "Bash(ls:*)",
    "Bash(tree:*)",
    "Bash(find:*)",
    "Bash(node:*)",
    "Bash(python:*)",
    "Read(./**)",
    "Glob(./**)",
    "Grep(./**)"
  ],
  "ask": [
    "Bash(git commit:*)",
    "Bash(git push:*)",
    "Bash(git checkout:*)"
  ],
  "deny": [
    "Bash(rm -rf:*)",
    "Bash(sudo:*)",
    "Write(.env)",
    "Write(.env.*)",
    "Edit(.env)",
    "Edit(.env.*)"
  ]
}
```

## Hooks Configuration

See [02-hooks.md](./02-hooks.md) for detailed hook documentation.

```json
{
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "SessionStart": [...],
    "SessionEnd": [...],
    "UserPromptSubmit": [...],
    "Notification": [...],
    "Stop": [...],
    "SubagentStop": [...],
    "PreCompact": [...],
    "PermissionRequest": [...]
  }
}
```

## Environment Variables

Set environment variables for all Claude Code bash commands:

```json
{
  "env": {
    "NODE_ENV": "development",
    "DEBUG": "app:*",
    "PATH": "${PATH}:./node_modules/.bin"
  }
}
```

## Model Selection

```json
{
  "model": "opus"
}
```

Options: `"opus"`, `"sonnet"`, `"haiku"`

## Status Line

Custom status line display:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline-command.sh"
  }
}
```

The script receives JSON via stdin with:
- `workspace.current_dir`
- `model.display_name`
- `output_style.name`
- `context_window.current_usage`
- `context_window.context_window_size`

## Cleanup Period

How long to keep inactive session data:

```json
{
  "cleanupPeriodDays": 30
}
```

Set to `0` for immediate cleanup.

## Co-Authored-By

Include co-authored-by in commit messages:

```json
{
  "includeCoAuthoredBy": true
}
```

## Extended Thinking

Enable extended thinking for complex tasks:

```json
{
  "alwaysThinkingEnabled": true
}
```

Note: Uses up to 31,999 thinking tokens per request.

## Plugin Management

Enable/disable plugins:

```json
{
  "enabledPlugins": {
    "security-guidance@claude-plugins-official": false,
    "formatter@my-marketplace": true
  }
}
```

## Project-Specific Example

`.claude/settings.json` for a React project:

```json
{
  "permissions": {
    "allow": [
      "Bash(npm run:*)",
      "Bash(npm install)",
      "Bash(npm test:*)",
      "Bash(npx:*)",
      "Bash(git status)",
      "Bash(git diff)",
      "Read(./**)",
      "Glob(./**)"
    ],
    "ask": [
      "Bash(git commit:*)",
      "Bash(git push:*)"
    ]
  },
  "hooks": {
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
    ],
    "PreToolUse": [
      {
        "matcher": "Bash(git commit:*)",
        "hooks": [
          {
            "type": "command",
            "command": "npm run lint && npm run typecheck",
            "timeout": 30
          }
        ]
      }
    ]
  },
  "env": {
    "NODE_ENV": "development"
  }
}
```

## Python Project Example

```json
{
  "permissions": {
    "allow": [
      "Bash(python:*)",
      "Bash(pip:*)",
      "Bash(uv:*)",
      "Bash(pytest:*)",
      "Bash(ruff:*)",
      "Bash(git status)",
      "Bash(git diff)",
      "Read(./**)"
    ],
    "ask": [
      "Bash(git commit:*)",
      "Bash(git push:*)"
    ]
  },
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "ruff format $CLAUDE_TOOL_FILE_PATH && ruff check --fix $CLAUDE_TOOL_FILE_PATH || true",
            "timeout": 10
          }
        ]
      }
    ]
  },
  "env": {
    "PYTHONPATH": "${PYTHONPATH}:./src"
  }
}
```

## Token Impact

**ZERO** - settings.json is parsed by the system, not loaded into Claude's context.
