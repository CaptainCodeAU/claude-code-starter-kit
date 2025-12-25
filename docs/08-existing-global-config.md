# Existing Global Configuration Reference

This documents the current user-level Claude Code configuration at `~/.claude/settings.json` as of 2024-12-25.

## Global Settings

```json
{
  "cleanupPeriodDays": 0,
  "includeCoAuthoredBy": false,
  "model": "opus",
  "alwaysThinkingEnabled": true
}
```

## Permissions

### Auto-Allowed
```json
{
  "allow": [
    "Bash(npm create:*)",
    "Bash(npm install)",
    "Bash(npm install:*)",
    "Bash(npx tailwindcss init:*)",
    "Bash(npm run:*)",
    "Bash(npm run dev:*)",
    "Bash(npm run build:*)",
    "Bash(npm run preview:*)",
    "Bash(tree:*)",
    "Bash(npx playwright:*)",
    "Bash(node:*)",
    "Bash(find:*)",
    "Read(/Users/admin/.claude/**)",
    "Bash(git status)",
    "Bash(git diff)"
  ]
}
```

### Requires Confirmation
```json
{
  "ask": [
    "Bash(git commit:*)",
    "Bash(git push:*)"
  ]
}
```

## Hooks

### PreToolUse: Pre-Commit Validation
```json
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
```

### PostToolUse: Auto-Actions

**On Write:**
```json
{
  "matcher": "Write",
  "hooks": [
    {
      "type": "command",
      "command": "echo 'File written successfully'",
      "timeout": 5
    }
  ]
}
```

**On Edit (Prettier):**
```json
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
```

**On MultiEdit (Run Tests):**
```json
{
  "matcher": "MultiEdit",
  "hooks": [
    {
      "type": "command",
      "command": "npm test -- --passWithNoTests --watchAll=false",
      "timeout": 60
    }
  ]
}
```

### SessionStart: Environment Checks
```json
{
  "hooks": [
    {
      "type": "command",
      "command": "~/.claude/hooks/check-uncommitted.sh",
      "timeout": 5
    },
    {
      "type": "command",
      "command": "~/.claude/hooks/check-env-encryption.sh",
      "timeout": 5
    }
  ]
}
```

## Global Hook Scripts

### ~/.claude/hooks/check-uncommitted.sh
Shows git status at session start:
- Displays "✓ Working tree clean" if no changes
- Shows count of uncommitted changes
- Only runs in git repos

### ~/.claude/hooks/check-env-encryption.sh
Security check for .env files:
- Warns if dotenvx not installed
- Alerts on unencrypted .env files
- Warns if .env.keys missing
- Checks .env variants (.env.local, .env.development, etc.)

## Status Line

Custom status line script:
```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline-command.sh"
  }
}
```

Displays:
- Current directory
- Git branch + dirty status
- Model name
- Output style
- Context usage % (color-coded)

**Note:** Fixed permission issue on 2024-12-25 (`chmod +x` was missing).

## Disabled Plugins

```json
{
  "enabledPlugins": {
    "security-guidance@claude-plugins-official": false,
    "explanatory-output-style@claude-plugins-official": false
  }
}
```

## Key Insights

1. **Opus model preferred** with extended thinking enabled
2. **Immediate cleanup** (cleanupPeriodDays: 0)
3. **No co-authored-by** in commits
4. **Pre-commit hooks** run lint + build
5. **Auto-formatting** with Prettier on Edit
6. **Security checks** at session start for .env files
7. **Git safety** - commits/pushes require confirmation

## Template Considerations

When creating project templates:
- These global hooks run first, project hooks can add to them
- Project settings.json can override or extend permissions
- Project hooks can be more specific (e.g., Python formatter instead of Prettier)
- Consider what should stay global vs. project-specific
