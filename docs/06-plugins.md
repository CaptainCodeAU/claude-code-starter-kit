# Claude Code Plugins

Plugins extend Claude Code with additional capabilities. This doc covers the plugin system for reference, though for project bootstrapping, direct `.claude/` configuration is preferred.

## Why Plugins Are NOT for Bootstrapping

| What You Want | What Plugins Do |
|---------------|-----------------|
| Run before Claude Code starts | Run after Claude Code starts |
| Create `.claude/` folder | Cannot auto-create project files |
| External scaffolding | Internal extensions |

**For bootstrapping new projects, use a separate CLI tool or script to copy `.claude/` templates.**

## Plugin Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # Required: manifest
├── commands/                 # Slash commands
│   └── my-command.md
├── agents/                   # Custom agents
│   └── my-agent.md
├── skills/                   # Agent skills
│   └── my-skill/
│       └── SKILL.md
├── hooks/
│   └── hooks.json           # Plugin hooks
├── .mcp.json                # MCP servers
└── .lsp.json                # LSP servers
```

## Plugin Manifest

`.claude-plugin/plugin.json`:

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "My helpful plugin",
  "author": "Your Name"
}
```

## Plugin Components

### Slash Commands
User-invoked via `/plugin-name:command`

```markdown
<!-- commands/hello.md -->
# Hello Command

Responds with a friendly greeting.

## Usage
/my-plugin:hello [name]
```

### Skills
Model-invoked (Claude decides when to use)

```markdown
<!-- skills/helper/SKILL.md -->
---
name: "Helper"
description: "Helps with common tasks"
---

# Helper Skill

Instructions for Claude...
```

### Hooks
Event handlers in `hooks/hooks.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format.sh"
          }
        ]
      }
    ]
  }
}
```

### MCP Servers
`.mcp.json`:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "node",
      "args": ["${CLAUDE_PLUGIN_ROOT}/mcp/server.js"]
    }
  }
}
```

## Installation

```bash
# Interactive menu
/plugin

# Direct install
claude plugin install my-plugin@marketplace

# With scope
claude plugin install my-plugin --scope project
```

## Installation Scopes

| Scope | Settings File | Shared? |
|-------|---------------|---------|
| `user` | `~/.claude/settings.json` | No |
| `project` | `.claude/settings.json` | Yes (git) |
| `local` | `.claude/settings.local.json` | No |

## Plugin Caching

When installed, plugins are:
1. Copied to `~/.claude/plugins/cache/`
2. Run from the cached copy
3. Isolated from original source

This means:
- Plugins can't reference files outside their directory
- Changes require reinstallation
- Symlinks within plugin directory work

## Enabling/Disabling

In settings.json:

```json
{
  "enabledPlugins": {
    "my-plugin@marketplace": true,
    "other-plugin@marketplace": false
  }
}
```

## When to Use Plugins

✅ **Use plugins for:**
- Sharing functionality across teams
- Distributing via marketplaces
- Complex, self-contained features
- MCP server integrations

❌ **Don't use plugins for:**
- Project bootstrapping
- Simple project-specific config
- Things that need to run before Claude starts

## Token Impact

- **Plugin manifest**: Loaded (minimal)
- **Plugin commands**: Lazy-loaded when invoked
- **Plugin skills**: Metadata only at startup
- **Plugin hooks**: Parsed, not in context

## Alternative: Direct Configuration

For project-specific needs, prefer direct `.claude/` configuration:

```
.claude/
├── settings.json      # Hooks, permissions
├── skills/            # Project skills
└── CLAUDE.md          # Project context
```

This is simpler, more transparent, and doesn't require plugin management.
