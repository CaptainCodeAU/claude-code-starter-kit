# Claude Code Plugins

Plugins extend Claude Code with additional capabilities including slash commands, subagents, skills, hooks, MCP servers, and LSP servers. This doc covers the plugin system comprehensively.

## When to Use Plugins vs Standalone Configuration

| Approach | Command Names | Best For |
|----------|---------------|----------|
| **Standalone** (`.claude/` directory) | `/hello` | Personal workflows, project-specific customizations, quick experiments |
| **Plugins** (with `.claude-plugin/plugin.json`) | `/plugin-name:hello` | Sharing with teammates, distributing to community, versioned releases |

**Use standalone configuration when:**
- Customizing Claude Code for a single project
- Configuration is personal and doesn't need sharing
- Experimenting before packaging
- You want short command names like `/hello`

**Use plugins when:**
- Sharing functionality with your team or community
- Need the same commands/agents across multiple projects
- Want version control and easy updates
- Distributing through a marketplace
- You're okay with namespaced commands like `/my-plugin:hello`

**Recommendation:** Start with standalone configuration in `.claude/` for quick iteration, then convert to a plugin when you're ready to share.

---

## Plugin Structure

A complete plugin follows this structure:

```
my-plugin/
├── .claude-plugin/           # Metadata directory (required)
│   └── plugin.json          # Plugin manifest (required)
├── commands/                 # Slash commands
│   └── hello.md
├── agents/                   # Custom subagents
│   └── reviewer.md
├── skills/                   # Agent Skills
│   └── code-review/
│       └── SKILL.md
├── hooks/                    # Event handlers
│   └── hooks.json
├── .mcp.json                # MCP server configurations
├── .lsp.json                # LSP server configurations
├── scripts/                 # Hook and utility scripts
│   └── format.sh
├── LICENSE
└── README.md
```

**Important:** The `.claude-plugin/` directory contains only `plugin.json`. All other directories (commands/, agents/, skills/, hooks/) must be at the plugin root level, not inside `.claude-plugin/`.

---

## Plugin Manifest

The `.claude-plugin/plugin.json` file defines your plugin's metadata and configuration.

### Minimal Manifest

```json
{
  "name": "my-plugin",
  "description": "A helpful plugin",
  "version": "1.0.0"
}
```

### Complete Schema

```json
{
  "name": "plugin-name",
  "version": "1.2.0",
  "description": "Brief plugin description",
  "author": {
    "name": "Author Name",
    "email": "author@example.com",
    "url": "https://github.com/author"
  },
  "homepage": "https://docs.example.com/plugin",
  "repository": "https://github.com/author/plugin",
  "license": "MIT",
  "keywords": ["keyword1", "keyword2"],
  "commands": ["./custom/commands/special.md"],
  "agents": "./custom/agents/",
  "skills": "./custom/skills/",
  "hooks": "./config/hooks.json",
  "mcpServers": "./mcp-config.json",
  "lspServers": "./.lsp.json",
  "outputStyles": "./styles/"
}
```

### Required Fields

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Unique identifier (kebab-case, no spaces). Used as command namespace. |

### Metadata Fields

| Field | Type | Description |
|-------|------|-------------|
| `version` | string | Semantic version (e.g., `"2.1.0"`) |
| `description` | string | Brief explanation of plugin purpose |
| `author` | object | Author info: `name`, `email`, `url` |
| `homepage` | string | Documentation URL |
| `repository` | string | Source code URL |
| `license` | string | License identifier (e.g., `"MIT"`, `"Apache-2.0"`) |
| `keywords` | array | Discovery tags |

### Component Path Fields

| Field | Type | Description |
|-------|------|-------------|
| `commands` | string\|array | Additional command files/directories |
| `agents` | string\|array | Additional agent files |
| `skills` | string\|array | Additional skill directories |
| `hooks` | string\|object | Hook config path or inline config |
| `mcpServers` | string\|object | MCP config path or inline config |
| `lspServers` | string\|object | LSP config path or inline config |
| `outputStyles` | string\|array | Additional output style files |

**Path behavior:** Custom paths supplement default directories—they don't replace them. All paths must be relative and start with `./`.

### Environment Variables

**`${CLAUDE_PLUGIN_ROOT}`** - Contains the absolute path to your plugin directory. Use this in hooks, MCP servers, and scripts:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/process.sh"
          }
        ]
      }
    ]
  }
}
```

---

## Plugin Components

### Commands

Plugins add custom slash commands that are namespaced with the plugin name.

**Location:** `commands/` directory in plugin root

**File format:** Markdown files with YAML frontmatter

```markdown
<!-- commands/hello.md -->
---
description: Greet the user with a friendly message
---

Greet the user warmly and ask how you can help them today.
```

**Invocation:** `/plugin-name:hello`

Commands support all features of custom slash commands: arguments (`$ARGUMENTS`, `$1`, `$2`), bash execution (`!`), file references (`@`), and hooks in frontmatter.

See [Slash Commands](10-slash-commands.md) for complete command documentation.

### Agents (Subagents)

Plugins can provide specialized subagents for specific tasks.

**Location:** `agents/` directory in plugin root

**File format:** Markdown files with YAML frontmatter

```markdown
---
name: security-reviewer
description: Reviews code for security vulnerabilities
tools: Read, Grep, Glob
model: sonnet
---

You are a security expert. Review code for vulnerabilities including:
- Injection attacks (SQL, command, XSS)
- Authentication/authorization issues
- Data exposure risks
- Insecure dependencies
```

Plugin agents appear in the `/agents` interface and Claude can invoke them automatically based on task context.

See [Subagents](09-subagents.md) for complete agent documentation.

### Skills

Plugins can include Agent Skills that extend Claude's capabilities. Skills are model-invoked—Claude autonomously decides when to use them.

**Location:** `skills/` directory in plugin root

**Structure:**

```
skills/
└── code-review/
    ├── SKILL.md
    ├── reference.md (optional)
    └── scripts/ (optional)
```

**SKILL.md format:**

```yaml
---
name: code-review
description: Reviews code for best practices and potential issues
---

When reviewing code, check for:
1. Code organization and structure
2. Error handling
3. Security concerns
4. Test coverage
```

See [Skills](03-skills.md) for complete skill documentation.

### Hooks

Plugins can provide event handlers that respond to Claude Code events automatically.

**Location:** `hooks/hooks.json` in plugin root, or inline in `plugin.json`

**Format:**

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/format-code.sh"
          }
        ]
      }
    ]
  }
}
```

**Available events:**

| Event | When It Fires |
|-------|---------------|
| `PreToolUse` | Before Claude uses any tool |
| `PostToolUse` | After Claude successfully uses any tool |
| `PostToolUseFailure` | After Claude tool execution fails |
| `PermissionRequest` | When a permission dialog is shown |
| `UserPromptSubmit` | When user submits a prompt |
| `Notification` | When Claude Code sends notifications |
| `Stop` | When Claude attempts to stop |
| `SubagentStart` | When a subagent is started |
| `SubagentStop` | When a subagent attempts to stop |
| `SessionStart` | At the beginning of sessions |
| `SessionEnd` | At the end of sessions |
| `PreCompact` | Before conversation history is compacted |

**Hook types:**

| Type | Description |
|------|-------------|
| `command` | Execute shell commands or scripts |
| `prompt` | Evaluate a prompt with an LLM |
| `agent` | Run an agentic verifier with tools |

See [Hooks](02-hooks.md) for complete hook documentation.

### MCP Servers

Plugins can bundle Model Context Protocol (MCP) servers to connect Claude Code with external tools and services.

**Location:** `.mcp.json` in plugin root, or inline in `plugin.json`

**Format:**

```json
{
  "mcpServers": {
    "plugin-database": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
      "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
      "env": {
        "DB_PATH": "${CLAUDE_PLUGIN_ROOT}/data"
      }
    },
    "plugin-api-client": {
      "command": "npx",
      "args": ["@company/mcp-server", "--plugin-mode"],
      "cwd": "${CLAUDE_PLUGIN_ROOT}"
    }
  }
}
```

Plugin MCP servers:
- Start automatically when the plugin is enabled
- Appear as standard MCP tools in Claude's toolkit
- Can be configured independently of user MCP servers

### LSP Servers

Plugins can provide Language Server Protocol (LSP) servers for real-time code intelligence.

**Location:** `.lsp.json` in plugin root, or inline in `plugin.json`

**Format:**

```json
{
  "go": {
    "command": "gopls",
    "args": ["serve"],
    "extensionToLanguage": {
      ".go": "go"
    }
  }
}
```

**Required fields:**

| Field | Description |
|-------|-------------|
| `command` | The LSP binary to execute (must be in PATH) |
| `extensionToLanguage` | Maps file extensions to language identifiers |

**Optional fields:**

| Field | Description |
|-------|-------------|
| `args` | Command-line arguments for the LSP server |
| `transport` | Communication transport: `stdio` (default) or `socket` |
| `env` | Environment variables |
| `initializationOptions` | Options passed during initialization |
| `settings` | Settings passed via `workspace/didChangeConfiguration` |
| `startupTimeout` | Max time to wait for server startup (milliseconds) |
| `shutdownTimeout` | Max time for graceful shutdown (milliseconds) |
| `restartOnCrash` | Automatically restart if server crashes |
| `maxRestarts` | Maximum restart attempts |

**Important:** LSP plugins configure how Claude Code connects to a language server, but they don't include the server itself. You must install the language server binary separately.

---

## Installation & Management

### Interactive Management

Use `/plugin` in Claude Code for interactive plugin management:
- Browse available plugins
- Install/uninstall plugins
- Enable/disable plugins
- View plugin errors

### CLI Commands

**Install a plugin:**

```bash
# Install to user scope (default)
claude plugin install formatter@my-marketplace

# Install to project scope (shared with team)
claude plugin install formatter@my-marketplace --scope project

# Install to local scope (gitignored)
claude plugin install formatter@my-marketplace --scope local
```

**Uninstall a plugin:**

```bash
claude plugin uninstall <plugin> [--scope user|project|local]
```

**Enable a disabled plugin:**

```bash
claude plugin enable <plugin> [--scope user|project|local]
```

**Disable without uninstalling:**

```bash
claude plugin disable <plugin> [--scope user|project|local]
```

**Update to latest version:**

```bash
claude plugin update <plugin> [--scope user|project|local|managed]
```

### Local Development

Test plugins during development with the `--plugin-dir` flag:

```bash
claude --plugin-dir ./my-plugin
```

Load multiple plugins:

```bash
claude --plugin-dir ./plugin-one --plugin-dir ./plugin-two
```

---

## Installation Scopes

When you install a plugin, you choose a scope that determines where it's available:

| Scope | Settings File | Use Case |
|-------|---------------|----------|
| `user` | `~/.claude/settings.json` | Personal plugins, all projects (default) |
| `project` | `.claude/settings.json` | Team plugins, version controlled |
| `local` | `.claude/settings.local.json` | Project-specific, gitignored |
| `managed` | `managed-settings.json` | Read-only, update only |

### Enabling/Disabling in Settings

```json
{
  "enabledPlugins": {
    "my-plugin@marketplace": true,
    "other-plugin@marketplace": false
  }
}
```

---

## Plugin Caching

For security and verification, Claude Code copies plugins to a cache directory rather than using them in-place.

### How Caching Works

When you install a plugin:
1. Plugin files are copied to `~/.claude/plugins/cache/`
2. Claude Code runs from the cached copy
3. The plugin is isolated from the original source

This means:
- Plugins can't reference files outside their directory
- Changes to the source require reinstallation
- Symlinks within the plugin directory are honored

### Path Traversal Limitations

Plugins cannot reference files outside their copied directory structure. Paths like `../shared-utils` won't work after installation.

### Working with External Dependencies

**Option 1: Use symlinks**

Create symbolic links within your plugin directory:

```bash
# Inside your plugin directory
ln -s /path/to/shared-utils ./shared-utils
```

The symlinked content will be copied into the plugin cache.

**Option 2: Restructure your marketplace**

Set the plugin path to a parent directory and specify component paths explicitly:

```json
{
  "name": "my-plugin",
  "source": "./",
  "description": "Plugin that needs root-level access",
  "commands": ["./plugins/my-plugin/commands/"],
  "agents": ["./plugins/my-plugin/agents/"]
}
```

---

## Debugging & Troubleshooting

### Debug Mode

Use `claude --debug` to see plugin loading details:

```bash
claude --debug
```

This shows:
- Which plugins are being loaded
- Any errors in plugin manifests
- Command, agent, and hook registration
- MCP server initialization

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Plugin not loading | Invalid `plugin.json` | Validate JSON syntax |
| Commands not appearing | Wrong directory structure | Ensure `commands/` at root, not in `.claude-plugin/` |
| Hooks not firing | Script not executable | Run `chmod +x script.sh` |
| MCP server fails | Missing `${CLAUDE_PLUGIN_ROOT}` | Use variable for all plugin paths |
| Path errors | Absolute paths used | All paths must be relative and start with `./` |
| LSP `Executable not found` | Language server not installed | Install the binary |

### Hook Troubleshooting

**Hook script not executing:**
1. Check the script is executable: `chmod +x ./scripts/your-script.sh`
2. Verify the shebang line: `#!/bin/bash` or `#!/usr/bin/env bash`
3. Check the path uses `${CLAUDE_PLUGIN_ROOT}`
4. Test the script manually

**Hook not triggering:**
1. Verify event name is correct (case-sensitive)
2. Check matcher pattern matches your tools
3. Confirm hook type is valid

### MCP Server Troubleshooting

**Server not starting:**
1. Check command exists and is executable
2. Verify paths use `${CLAUDE_PLUGIN_ROOT}`
3. Check logs with `claude --debug`
4. Test server manually outside Claude Code

**Tools not appearing:**
1. Ensure server is properly configured
2. Verify MCP protocol implementation
3. Check for connection timeouts

### Directory Structure Errors

**Components missing after install:**

Correct structure (components at plugin root):
```
my-plugin/
├── .claude-plugin/
│   └── plugin.json      ← Only manifest here
├── commands/            ← At root level
├── agents/              ← At root level
└── hooks/               ← At root level
```

Incorrect (components inside `.claude-plugin/`):
```
my-plugin/
├── .claude-plugin/
│   ├── plugin.json
│   ├── commands/        ← WRONG
│   └── agents/          ← WRONG
```

---

## Version Management

Follow semantic versioning for plugin releases:

```json
{
  "name": "my-plugin",
  "version": "2.1.0"
}
```

**Version format:** `MAJOR.MINOR.PATCH`

- **MAJOR** - Breaking changes (incompatible API changes)
- **MINOR** - New features (backward-compatible additions)
- **PATCH** - Bug fixes (backward-compatible fixes)

**Best practices:**
- Start at `1.0.0` for your first stable release
- Update version in `plugin.json` before distributing changes
- Document changes in a `CHANGELOG.md` file
- Use pre-release versions like `2.0.0-beta.1` for testing

---

## Converting Standalone to Plugin

If you have custom commands, skills, or hooks in `.claude/`, you can convert them to a plugin.

### Migration Steps

**1. Create plugin structure:**

```bash
mkdir -p my-plugin/.claude-plugin
```

**2. Create the manifest:**

```json
// my-plugin/.claude-plugin/plugin.json
{
  "name": "my-plugin",
  "description": "Migrated from standalone configuration",
  "version": "1.0.0"
}
```

**3. Copy your files:**

```bash
# Copy commands
cp -r .claude/commands my-plugin/

# Copy agents (if any)
cp -r .claude/agents my-plugin/

# Copy skills (if any)
cp -r .claude/skills my-plugin/
```

**4. Migrate hooks:**

Create `my-plugin/hooks/hooks.json` and copy the `hooks` object from your settings:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [{ "type": "command", "command": "npm run lint:fix $FILE" }]
      }
    ]
  }
}
```

**5. Test your plugin:**

```bash
claude --plugin-dir ./my-plugin
```

### What Changes After Migration

| Standalone (`.claude/`) | Plugin |
|-------------------------|--------|
| Only available in one project | Can be shared via marketplaces |
| Files in `.claude/commands/` | Files in `plugin-name/commands/` |
| Hooks in `settings.json` | Hooks in `hooks/hooks.json` |
| Short command names (`/hello`) | Namespaced (`/my-plugin:hello`) |
| Must manually copy to share | Install with `/plugin install` |

After migrating, you can remove the original files from `.claude/` to avoid duplicates.

---

## Token Impact

| Component | Token Cost |
|-----------|------------|
| Plugin manifest | Loaded (minimal) |
| Plugin commands | Lazy-loaded when invoked |
| Plugin skills | Metadata only at startup |
| Plugin hooks | Parsed, not in context |
| Plugin agents | Description in context for delegation |

---

## Distributing Plugins

### Creating a Marketplace

Plugins are distributed through marketplaces (git repositories with `marketplace.json`):

```json
{
  "plugins": [
    {
      "name": "formatter",
      "source": "./plugins/formatter",
      "description": "Auto-format code on save"
    }
  ]
}
```

### Publishing

1. Add documentation (`README.md`)
2. Use semantic versioning
3. Create or use a marketplace
4. Test with others before wider distribution

---

## See Also

- [Slash Commands](10-slash-commands.md) - Command development details
- [Subagents](09-subagents.md) - Agent configuration
- [Skills](03-skills.md) - Skill authoring
- [Hooks](02-hooks.md) - Event handling
- [Settings Reference](05-settings-reference.md) - Configuration options
