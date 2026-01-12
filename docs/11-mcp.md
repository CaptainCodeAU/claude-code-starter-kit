# MCP (Model Context Protocol)

MCP is an open standard for connecting Claude Code to external tools, databases, and APIs. MCP servers give Claude access to hundreds of integrations.

## What You Can Do with MCP

With MCP servers connected, you can ask Claude Code to:

- **Implement features from issue trackers**: "Add the feature described in JIRA issue ENG-4521 and create a PR on GitHub."
- **Analyze monitoring data**: "Check Sentry and Statsig for errors in the last 24 hours."
- **Query databases**: "Find users who signed up this week from our PostgreSQL database."
- **Integrate designs**: "Update our email template based on the new Figma designs."
- **Automate workflows**: "Create Gmail drafts inviting users to a feedback session."

## Installing MCP Servers

MCP servers can be installed in three ways.

### Option 1: Remote HTTP Server (Recommended)

HTTP servers are the recommended option for cloud-based services:

```bash
# Basic syntax
claude mcp add --transport http <name> <url>

# Example: Connect to Notion
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Example with Bearer token
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"
```

### Option 2: Remote SSE Server (Deprecated)

SSE (Server-Sent Events) transport is deprecated. Use HTTP where available:

```bash
# Basic syntax
claude mcp add --transport sse <name> <url>

# Example: Connect to Asana
claude mcp add --transport sse asana https://mcp.asana.com/sse

# Example with authentication
claude mcp add --transport sse private-api https://api.company.com/sse \
  --header "X-API-Key: your-key-here"
```

### Option 3: Local Stdio Server

Stdio servers run as local processes. Ideal for direct system access or custom scripts:

```bash
# Basic syntax
claude mcp add [options] <name> -- <command> [args...]

# Example: Add Airtable server
claude mcp add --transport stdio --env AIRTABLE_API_KEY=YOUR_KEY airtable \
  -- npx -y airtable-mcp-server
```

### Option Ordering

All options must come **before** the server name. The `--` separates the name from the command:

```bash
# Correct: options, then name, then -- command
claude mcp add --transport stdio --env KEY=value myserver -- npx server

# The command after -- can have its own flags
claude mcp add --transport stdio myserver -- python server.py --port 8080
```

### Windows Users

On native Windows (not WSL), stdio servers using `npx` require the `cmd /c` wrapper:

```bash
claude mcp add --transport stdio my-server -- cmd /c npx -y @some/package
```

Without `cmd /c`, you'll encounter "Connection closed" errors.

## Managing Servers

```bash
# List all configured servers
claude mcp list

# Get details for a specific server
claude mcp get github

# Remove a server
claude mcp remove github

# Within Claude Code: check server status
/mcp
```

### Dynamic Tool Updates

Claude Code supports MCP `list_changed` notifications. When an MCP server updates its available tools, prompts, or resources, Claude Code automatically refreshes without reconnection.

## Installation Scopes

MCP servers can be configured at three scope levels.

| Scope | Storage Location | Visibility | Use Case |
|-------|------------------|------------|----------|
| **Local** | `~/.claude.json` (per-project) | You only, this project | Personal dev servers, experiments, sensitive credentials |
| **Project** | `.mcp.json` (repo root) | All collaborators | Team-shared tools, version-controlled config |
| **User** | `~/.claude.json` (global) | You, all projects | Personal utilities, frequently-used services |

### Specifying Scope

```bash
# Local scope (default)
claude mcp add --transport http stripe https://mcp.stripe.com

# Explicit local scope
claude mcp add --transport http stripe --scope local https://mcp.stripe.com

# Project scope (creates .mcp.json)
claude mcp add --transport http paypal --scope project https://mcp.paypal.com/mcp

# User scope (cross-project)
claude mcp add --transport http hubspot --scope user https://mcp.hubspot.com/anthropic
```

### Scope Precedence

When servers with the same name exist at multiple scopes:

1. **Local** (highest priority)
2. **Project**
3. **User** (lowest priority)

### Project Scope Approval

For security, Claude Code prompts for approval before using project-scoped servers from `.mcp.json` files. Reset approval choices with:

```bash
claude mcp reset-project-choices
```

## Configuration Files

### .mcp.json Format

Project-scoped servers are stored in `.mcp.json` at the project root:

```json
{
  "mcpServers": {
    "database": {
      "command": "/path/to/server",
      "args": ["--config", "db.json"],
      "env": {
        "DB_URL": "postgresql://..."
      }
    },
    "remote-api": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}"
      }
    }
  }
}
```

### Environment Variable Expansion

Claude Code supports environment variable expansion in `.mcp.json`:

| Syntax | Behavior |
|--------|----------|
| `${VAR}` | Expands to value of `VAR` |
| `${VAR:-default}` | Uses `VAR` if set, otherwise `default` |

**Expansion locations:** `command`, `args`, `env`, `url`, `headers`

```json
{
  "mcpServers": {
    "api-server": {
      "type": "http",
      "url": "${API_BASE_URL:-https://api.example.com}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}"
      }
    }
  }
}
```

If a required variable is not set and has no default, Claude Code fails to parse the config.

### Adding from JSON

Add servers directly from JSON configuration:

```bash
# HTTP server
claude mcp add-json weather-api '{"type":"http","url":"https://api.weather.com/mcp"}'

# Stdio server
claude mcp add-json local-db '{"type":"stdio","command":"/path/to/server","args":["--port","8080"]}'
```

### Importing from Claude Desktop

Import existing servers from Claude Desktop (macOS and WSL only):

```bash
# Import servers interactively
claude mcp add-from-claude-desktop

# Add to user scope
claude mcp add-from-claude-desktop --scope user
```

## Plugin-Provided MCP Servers

Plugins can bundle MCP servers that start automatically when the plugin is enabled.

### Plugin MCP Configuration

In `.mcp.json` at plugin root:

```json
{
  "database-tools": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
    "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
    "env": {
      "DB_URL": "${DB_URL}"
    }
  }
}
```

Or inline in `plugin.json`:

```json
{
  "name": "my-plugin",
  "mcpServers": {
    "plugin-api": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/api-server",
      "args": ["--port", "8080"]
    }
  }
}
```

### Plugin MCP Features

| Feature | Description |
|---------|-------------|
| **Automatic lifecycle** | Servers start when plugin enables (restart Claude Code for changes) |
| **Environment variables** | Use `${CLAUDE_PLUGIN_ROOT}` for plugin-relative paths |
| **User environment** | Access same variables as manually configured servers |
| **Multiple transports** | Supports stdio, SSE, and HTTP |

### Viewing Plugin Servers

```bash
# Within Claude Code
/mcp
```

Plugin servers appear with indicators showing their plugin origin.

## Authentication

### OAuth 2.0 for Remote Servers

Many cloud-based MCP servers require authentication:

1. Add the server:
   ```bash
   claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
   ```

2. Authenticate within Claude Code:
   ```
   > /mcp
   ```
   Follow the browser steps to login.

### Authentication Tips

- Tokens are stored securely and refreshed automatically
- Use "Clear authentication" in `/mcp` menu to revoke access
- If browser doesn't open, copy the provided URL
- OAuth works with HTTP servers

## Using MCP Resources

MCP servers can expose resources that you reference with `@` mentions.

### Reference Syntax

```
@server:protocol://resource/path
```

### Examples

```
# Single resource
> Can you analyze @github:issue://123 and suggest a fix?

# With documentation
> Please review the API docs at @docs:file://api/authentication

# Multiple resources
> Compare @postgres:schema://users with @docs:file://database/user-model
```

### Resource Features

- Resources appear in `@` mention autocomplete
- Paths are fuzzy-searchable
- Content is fetched as attachments automatically
- Resources can contain text, JSON, or structured data

## MCP Prompts as Slash Commands

MCP servers can expose prompts that become slash commands.

### Command Format

```
/mcp__servername__promptname
```

### Examples

```
# List PRs from GitHub
> /mcp__github__list_prs

# Create issue with arguments
> /mcp__jira__create_issue "Bug in login flow" high

# Review specific PR
> /mcp__github__pr_review 456
```

### Prompt Features

- Discovered dynamically from connected servers
- Arguments parsed based on prompt parameters
- Results injected into conversation
- Server/prompt names normalized (spaces → underscores)

## Output Limits

MCP tool outputs have token limits to protect context:

| Setting | Default | Description |
|---------|---------|-------------|
| Warning threshold | 10,000 tokens | Warning displayed |
| Maximum limit | 25,000 tokens | Hard limit |

### Increasing the Limit

```bash
# Set higher limit for large outputs
export MAX_MCP_OUTPUT_TOKENS=50000
claude
```

Use for servers that query large datasets, generate detailed reports, or process extensive logs.

## Claude Code as MCP Server

Claude Code can act as an MCP server for other applications:

```bash
# Start as stdio MCP server
claude mcp serve
```

### Claude Desktop Configuration

Add to `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "claude-code": {
      "type": "stdio",
      "command": "claude",
      "args": ["mcp", "serve"],
      "env": {}
    }
  }
}
```

**Note:** If `claude` isn't in PATH, use the full path:

```bash
# Find full path
which claude
```

Then use the full path in configuration:

```json
{
  "mcpServers": {
    "claude-code": {
      "type": "stdio",
      "command": "/full/path/to/claude",
      "args": ["mcp", "serve"],
      "env": {}
    }
  }
}
```

### Exposed Tools

The server provides access to Claude's tools: View, Edit, LS, etc. Your MCP client is responsible for user confirmation of tool calls.

## Managed MCP Configuration (Enterprise)

For organizations needing centralized control, Claude Code supports two options.

### Option 1: Exclusive Control with managed-mcp.json

Deploy a fixed set of servers that users cannot modify.

**Managed settings paths:**

| Platform | Path |
|----------|------|
| macOS | `/Library/Application Support/ClaudeCode/managed-mcp.json` |
| Linux/WSL | `/etc/claude-code/managed-mcp.json` |
| Windows | `C:\Program Files\ClaudeCode\managed-mcp.json` |

**Format (same as .mcp.json):**

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "company-internal": {
      "type": "stdio",
      "command": "/usr/local/bin/company-mcp-server",
      "args": ["--config", "/etc/company/mcp-config.json"]
    }
  }
}
```

### Option 2: Policy-Based Control

Allow users to add servers within restrictions using `allowedMcpServers` and `deniedMcpServers` in managed settings.

**Restriction types:**

| Type | Field | Matches |
|------|-------|---------|
| By name | `serverName` | Configured server name |
| By command | `serverCommand` | Exact command array for stdio |
| By URL | `serverUrl` | URL pattern with wildcards |

Each entry must have exactly **one** of these fields.

**Example configuration:**

```json
{
  "allowedMcpServers": [
    { "serverName": "github" },
    { "serverName": "sentry" },
    { "serverCommand": ["npx", "-y", "@modelcontextprotocol/server-filesystem"] },
    { "serverUrl": "https://mcp.company.com/*" },
    { "serverUrl": "https://*.internal.corp/*" }
  ],
  "deniedMcpServers": [
    { "serverName": "dangerous-server" },
    { "serverUrl": "https://*.untrusted.com/*" }
  ]
}
```

### Command Matching (Stdio)

- Command arrays must match **exactly** (command + all arguments in order)
- `["npx", "-y", "server"]` does NOT match `["npx", "server"]`
- When allowlist has command entries, stdio servers must match one

### URL Pattern Matching (Remote)

- Use `*` as wildcard for any characters
- `https://mcp.company.com/*` - all paths on domain
- `https://*.example.com/*` - any subdomain
- `http://localhost:*/*` - any port on localhost

### Allowlist/Denylist Behavior

| List | undefined | Empty `[]` | With entries |
|------|-----------|------------|--------------|
| `allowedMcpServers` | No restrictions | Complete lockdown | Only matching allowed |
| `deniedMcpServers` | Nothing blocked | Nothing blocked | Matching blocked |

**Denylist always takes precedence** - blocked servers stay blocked even if allowlisted.

## Practical Examples

### Monitor Errors with Sentry

```bash
# 1. Add Sentry server
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# 2. Authenticate
> /mcp

# 3. Debug issues
> "What are the most common errors in the last 24 hours?"
> "Show me the stack trace for error ID abc123"
```

### Connect to GitHub

```bash
# 1. Add GitHub server
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# 2. Authenticate if needed
> /mcp

# 3. Work with GitHub
> "Review PR #456 and suggest improvements"
> "Create a new issue for the bug we just found"
```

### Query PostgreSQL

```bash
# 1. Add database server with connection string
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://readonly:pass@prod.db.com:5432/analytics"

# 2. Query naturally
> "What's our total revenue this month?"
> "Show me the schema for the orders table"
```

## Settings Reference

MCP-related settings in `settings.json`:

| Key | Description |
|-----|-------------|
| `enableAllProjectMcpServers` | Auto-approve all servers in `.mcp.json` |
| `enabledMcpjsonServers` | Specific servers to approve |
| `disabledMcpjsonServers` | Specific servers to reject |
| `allowedMcpServers` | (Managed) Allowlist of permitted servers |
| `deniedMcpServers` | (Managed) Denylist of blocked servers |

See [Settings Reference](./05-settings-reference.md) for complete documentation.

## Environment Variables

| Variable | Purpose | Default |
|----------|---------|---------|
| `MCP_TIMEOUT` | Server startup timeout (ms) | - |
| `MCP_TOOL_TIMEOUT` | Tool execution timeout (ms) | - |
| `MAX_MCP_OUTPUT_TOKENS` | Max tokens in MCP responses | 25000 |

## Troubleshooting

### Common Issues

| Problem | Solution |
|---------|----------|
| "Connection closed" on Windows | Use `cmd /c npx` wrapper for stdio servers |
| Server not responding | Check `/mcp` for status, verify authentication |
| Tools not appearing | Restart Claude Code after MCP config changes |
| "Prompt is too long" | Increase `MAX_MCP_OUTPUT_TOKENS` or paginate responses |
| OAuth not working | Ensure using HTTP transport (not SSE or stdio) |

### Debug Tips

- Use `/mcp` to check server status and authentication
- Check server logs for connection errors
- Verify environment variables are set correctly
- For plugin servers, restart Claude Code after changes

## Token Impact

| Component | Token Cost |
|-----------|------------|
| MCP configuration | ZERO (parsed, not in context) |
| MCP tools | Loaded on-demand |
| MCP resources | Fetched when referenced |
| MCP prompts | Executed when invoked |

## See Also

- [Settings Reference](./05-settings-reference.md) - MCP settings in settings.json
- [Plugins](./06-plugins.md) - Plugin-provided MCP servers
- [Slash Commands](./10-slash-commands.md) - MCP prompts as commands
