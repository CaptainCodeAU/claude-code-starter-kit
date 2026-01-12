# Settings.json Reference

The `settings.json` file configures Claude Code behavior at multiple levels with a scope-based precedence system.

## Configuration Scopes

Claude Code uses a **scope system** to determine where configurations apply:

| Scope | Location | Who It Affects | Shared? |
|-------|----------|----------------|---------|
| **Managed** | System-level `managed-settings.json` | All users on machine | Yes (deployed by IT) |
| **User** | `~/.claude/settings.json` | You, across all projects | No |
| **Project** | `.claude/settings.json` | All collaborators | Yes (committed to git) |
| **Local** | `.claude/settings.local.json` | You, in this project only | No (gitignored) |

### Managed Settings Paths

- **macOS**: `/Library/Application Support/ClaudeCode/managed-settings.json`
- **Linux/WSL**: `/etc/claude-code/managed-settings.json`
- **Windows**: `C:\Program Files\ClaudeCode\managed-settings.json`

These are system-wide paths (not user home directories) requiring administrator privileges.

### Scope Precedence

When the same setting exists in multiple scopes, higher precedence wins:

1. **Managed** (highest) - Cannot be overridden
2. **Command line arguments** - Temporary session overrides
3. **Local** - Overrides project and user settings
4. **Project** - Overrides user settings
5. **User** (lowest) - Applies when nothing else specifies

### When to Use Each Scope

| Scope | Best For |
|-------|----------|
| **Managed** | Security policies, compliance requirements, organization standards |
| **User** | Personal preferences, API keys, tools you use everywhere |
| **Project** | Team-shared settings, project-specific hooks, MCP servers |
| **Local** | Personal project overrides, machine-specific settings, testing configs |

## Complete Settings Schema

```json
{
  "permissions": {
    "allow": [],
    "deny": [],
    "ask": [],
    "additionalDirectories": [],
    "defaultMode": "default",
    "disableBypassPermissionsMode": "disable"
  },
  "hooks": {},
  "env": {},
  "model": "sonnet",
  "sandbox": {},
  "attribution": {
    "commit": "",
    "pr": ""
  },
  "statusLine": {},
  "fileSuggestion": {},
  "cleanupPeriodDays": 30,
  "alwaysThinkingEnabled": false,
  "language": "",
  "outputStyle": "",
  "enabledPlugins": {},
  "extraKnownMarketplaces": {},
  "apiKeyHelper": "",
  "companyAnnouncements": [],
  "forceLoginMethod": "",
  "forceLoginOrgUUID": "",
  "enableAllProjectMcpServers": false,
  "enabledMcpjsonServers": [],
  "disabledMcpjsonServers": [],
  "disableAllHooks": false,
  "allowManagedHooksOnly": false,
  "respectGitignore": true
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
      "Write(.env)",
      "Read(./secrets/**)"
    ],
    "ask": [
      "Bash(git push:*)",
      "Bash(git commit:*)"
    ]
  }
}
```

### Pattern Syntax

| Pattern | Meaning |
|---------|---------|
| `Tool(pattern)` | Match tool with argument pattern |
| `*` | Wildcard (any characters) |
| `:*` | Match any arguments after prefix |
| `Tool` | Match tool with no arguments |

### Common Permission Patterns

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
      "Bash(git log:*)",
      "Bash(ls:*)",
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
      "Edit(.env.*)",
      "Read(./secrets/**)"
    ]
  }
}
```

### Additional Permission Settings

| Key | Description | Example |
|-----|-------------|---------|
| `additionalDirectories` | Extra working directories Claude can access | `["../docs/", "/shared/libs/"]` |
| `defaultMode` | Default permission mode on startup | `"default"`, `"acceptEdits"`, `"plan"` |
| `disableBypassPermissionsMode` | Set to `"disable"` to block `--dangerously-skip-permissions` | `"disable"` |

## Hooks Configuration

See [02-hooks.md](./02-hooks.md) for detailed hook documentation.

```json
{
  "hooks": {
    "PreToolUse": [...],
    "PostToolUse": [...],
    "PermissionRequest": [...],
    "SessionStart": [...],
    "SessionEnd": [...],
    "UserPromptSubmit": [...],
    "Notification": [...],
    "Stop": [...],
    "SubagentStop": [...],
    "PreCompact": [...]
  }
}
```

### Hook-Related Settings

| Key | Description | Example |
|-----|-------------|---------|
| `disableAllHooks` | Disable all hooks | `true` |
| `allowManagedHooksOnly` | (Managed only) Block user/project/plugin hooks | `true` |

## Sandbox Settings

Configure bash command sandboxing (macOS/Linux only):

```json
{
  "sandbox": {
    "enabled": true,
    "autoAllowBashIfSandboxed": true,
    "excludedCommands": ["git", "docker"],
    "allowUnsandboxedCommands": true,
    "network": {
      "allowUnixSockets": ["~/.ssh/agent-socket"],
      "allowLocalBinding": true,
      "httpProxyPort": 8080,
      "socksProxyPort": 8081
    },
    "enableWeakerNestedSandbox": false
  }
}
```

| Key | Description | Default |
|-----|-------------|---------|
| `enabled` | Enable bash sandboxing | `false` |
| `autoAllowBashIfSandboxed` | Auto-approve bash when sandboxed | `true` |
| `excludedCommands` | Commands that run outside sandbox | `[]` |
| `allowUnsandboxedCommands` | Allow `dangerouslyDisableSandbox` escape hatch | `true` |
| `network.allowUnixSockets` | Unix socket paths accessible in sandbox | `[]` |
| `network.allowLocalBinding` | Allow binding to localhost (macOS only) | `false` |
| `network.httpProxyPort` | Custom HTTP proxy port | - |
| `network.socksProxyPort` | Custom SOCKS5 proxy port | - |
| `enableWeakerNestedSandbox` | Weaker sandbox for Docker (Linux, reduces security) | `false` |

## Attribution Settings

Customize attribution for git commits and pull requests:

```json
{
  "attribution": {
    "commit": "Generated with AI\n\nCo-Authored-By: AI <ai@example.com>",
    "pr": ""
  }
}
```

| Key | Description |
|-----|-------------|
| `commit` | Git commit attribution (including trailers). Empty string hides it |
| `pr` | Pull request description attribution. Empty string hides it |

**Default commit attribution:**
```
🤖 Generated with [Claude Code](https://claude.com/claude-code)

   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Note:** `attribution` replaces the deprecated `includeCoAuthoredBy` setting.

## Model Selection

```json
{
  "model": "claude-sonnet-4-5-20250929"
}
```

Options: `"opus"`, `"sonnet"`, `"haiku"`, or full model ID.

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

The script receives JSON via stdin with context information. See [statusline documentation](/en/statusline).

## File Suggestion

Configure custom `@` file path autocomplete:

```json
{
  "fileSuggestion": {
    "type": "command",
    "command": "~/.claude/file-suggestion.sh"
  }
}
```

The command receives JSON via stdin with a `query` field and outputs newline-separated file paths.

```bash
#!/bin/bash
query=$(cat | jq -r '.query')
your-repo-file-index --query "$query" | head -20
```

## MCP Server Settings

Control Model Context Protocol server behavior:

| Key | Description | Example |
|-----|-------------|---------|
| `enableAllProjectMcpServers` | Auto-approve all MCP servers in `.mcp.json` | `true` |
| `enabledMcpjsonServers` | Specific servers to approve | `["memory", "github"]` |
| `disabledMcpjsonServers` | Specific servers to reject | `["filesystem"]` |
| `allowedMcpServers` | (Managed) Allowlist of permitted servers | See below |
| `deniedMcpServers` | (Managed) Denylist of blocked servers | See below |

```json
{
  "enableAllProjectMcpServers": true,
  "enabledMcpjsonServers": ["memory", "github"],
  "disabledMcpjsonServers": ["filesystem"]
}
```

## Plugin Settings

```json
{
  "enabledPlugins": {
    "formatter@acme-tools": true,
    "deployer@acme-tools": true,
    "analyzer@security-plugins": false
  },
  "extraKnownMarketplaces": {
    "acme-tools": {
      "source": {
        "source": "github",
        "repo": "acme-corp/claude-plugins"
      }
    }
  }
}
```

### Managed Marketplace Restrictions

In `managed-settings.json` only:

```json
{
  "strictKnownMarketplaces": [
    { "source": "github", "repo": "acme-corp/approved-plugins" },
    { "source": "npm", "package": "@acme-corp/compliance-plugins" }
  ]
}
```

- `undefined`: No restrictions
- `[]`: Complete lockdown - no marketplace additions
- List: Only matching marketplaces allowed

## Other Settings

| Key | Description | Example |
|-----|-------------|---------|
| `cleanupPeriodDays` | Days before inactive sessions deleted (0 = immediate) | `30` |
| `alwaysThinkingEnabled` | Enable extended thinking by default | `true` |
| `language` | Claude's preferred response language | `"japanese"` |
| `outputStyle` | Output style adjustment | `"Explanatory"` |
| `respectGitignore` | File picker respects `.gitignore` | `true` |
| `apiKeyHelper` | Script to generate auth value | `/bin/gen_key.sh` |
| `companyAnnouncements` | Startup messages (rotated randomly) | `["Welcome!"]` |
| `forceLoginMethod` | Restrict login method | `"claudeai"` or `"console"` |
| `forceLoginOrgUUID` | Auto-select organization on login | `"uuid-here"` |
| `otelHeadersHelper` | Script for dynamic OpenTelemetry headers | `/bin/otel.sh` |
| `awsAuthRefresh` | Script to refresh AWS auth | `aws sso login` |
| `awsCredentialExport` | Script outputting AWS credentials JSON | `/bin/aws.sh` |

## Environment Variables

Set in `settings.json`:

```json
{
  "env": {
    "NODE_ENV": "development",
    "DEBUG": "app:*",
    "PATH": "${PATH}:./node_modules/.bin"
  }
}
```

### Claude Code Environment Variables

| Variable | Purpose |
|----------|---------|
| `ANTHROPIC_API_KEY` | API key for Claude SDK |
| `ANTHROPIC_AUTH_TOKEN` | Custom Authorization header value |
| `ANTHROPIC_MODEL` | Override default model |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Default Sonnet model ID |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Default Opus model ID |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Default Haiku model ID |
| `CLAUDE_CODE_USE_BEDROCK` | Use AWS Bedrock |
| `CLAUDE_CODE_USE_VERTEX` | Use Google Vertex AI |
| `CLAUDE_CODE_USE_FOUNDRY` | Use Microsoft Foundry |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Model for subagents |
| `CLAUDE_CODE_SHELL` | Override shell detection |
| `CLAUDE_CODE_SHELL_PREFIX` | Prefix for all bash commands |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | Max output tokens |
| `CLAUDE_CODE_FILE_READ_MAX_OUTPUT_TOKENS` | Max tokens for file reads |
| `CLAUDE_CONFIG_DIR` | Custom config directory |
| `MAX_THINKING_TOKENS` | Extended thinking token budget |
| `BASH_DEFAULT_TIMEOUT_MS` | Default bash timeout |
| `BASH_MAX_TIMEOUT_MS` | Maximum bash timeout |
| `BASH_MAX_OUTPUT_LENGTH` | Max bash output characters |
| `MCP_TIMEOUT` | MCP server startup timeout (ms) |
| `MCP_TOOL_TIMEOUT` | MCP tool execution timeout (ms) |
| `MAX_MCP_OUTPUT_TOKENS` | Max tokens in MCP responses (default: 25000) |
| `HTTP_PROXY` | HTTP proxy server |
| `HTTPS_PROXY` | HTTPS proxy server |
| `NO_PROXY` | Domains bypassing proxy |

### Disable Features

| Variable | Purpose |
|----------|---------|
| `DISABLE_AUTOUPDATER` | Disable auto-updates |
| `DISABLE_TELEMETRY` | Opt out of Statsig telemetry |
| `DISABLE_ERROR_REPORTING` | Opt out of Sentry reporting |
| `DISABLE_BUG_COMMAND` | Disable `/bug` command |
| `DISABLE_COST_WARNINGS` | Disable cost warnings |
| `DISABLE_PROMPT_CACHING` | Disable prompt caching (all models) |
| `DISABLE_PROMPT_CACHING_SONNET` | Disable for Sonnet only |
| `DISABLE_PROMPT_CACHING_OPUS` | Disable for Opus only |
| `DISABLE_PROMPT_CACHING_HAIKU` | Disable for Haiku only |
| `DISABLE_NON_ESSENTIAL_MODEL_CALLS` | Disable non-critical model calls |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` | Disable all non-essential traffic |
| `CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS` | Disable beta API headers |
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` | Disable background task functionality |
| `CLAUDE_CODE_DISABLE_TERMINAL_TITLE` | Disable terminal title updates |

## Tools Available to Claude

| Tool | Description | Permission Required |
|------|-------------|---------------------|
| **AskUserQuestion** | Ask user multiple choice questions | No |
| **Bash** | Execute shell commands | Yes |
| **BashOutput** | Get output from background bash | No |
| **Edit** | Make targeted file edits | Yes |
| **ExitPlanMode** | Prompt user to exit plan mode | Yes |
| **Glob** | Find files by pattern | No |
| **Grep** | Search file contents | No |
| **KillShell** | Kill background bash shell | No |
| **NotebookEdit** | Modify Jupyter notebook cells | Yes |
| **Read** | Read file contents | No |
| **Skill** | Execute skill/slash command | Yes |
| **Task** | Run sub-agent | No |
| **TodoWrite** | Manage task lists | No |
| **WebFetch** | Fetch URL content | Yes |
| **WebSearch** | Search the web | Yes |
| **Write** | Create/overwrite files | Yes |

Permission rules can be configured via `/allowed-tools` or in settings.

## Bash Tool Behavior

### Working Directory Persistence

When Claude changes directory (`cd`), subsequent bash commands run there. To reset:

```bash
CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR=1
```

### Environment Variable Persistence

Environment variables set in one bash command do NOT persist to the next. Options:

**Option 1: Activate before starting Claude**
```bash
conda activate myenv
claude
```

**Option 2: Set CLAUDE_ENV_FILE**
```bash
export CLAUDE_ENV_FILE=/path/to/env-setup.sh
claude
```

**Option 3: SessionStart hook**
```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "startup",
      "hooks": [{
        "type": "command",
        "command": "echo 'conda activate myenv' >> \"$CLAUDE_ENV_FILE\""
      }]
    }]
  }
}
```

## Project Examples

### React Project

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
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "npx prettier --write $CLAUDE_TOOL_FILE_PATH || true",
            "timeout": 10
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

### Python Project

```json
{
  "permissions": {
    "allow": [
      "Bash(uv:*)",
      "Bash(python:*)",
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
        "matcher": "Edit|Write",
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

## See Also

- [Hooks Reference](./02-hooks.md) - Complete hook documentation
- [CLAUDE.md Best Practices](./07-claude-md-best-practices.md) - Memory file configuration
- [IAM Documentation](/en/iam) - Permission system details
