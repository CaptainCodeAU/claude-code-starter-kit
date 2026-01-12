# CLI Reference

Complete reference for Claude Code command-line interface, including commands and flags.

## CLI Commands

| Command | Description | Example |
|---------|-------------|---------|
| `claude` | Start interactive REPL | `claude` |
| `claude "query"` | Start REPL with initial prompt | `claude "explain this project"` |
| `claude -p "query"` | Query via SDK, then exit | `claude -p "explain this function"` |
| `cat file \| claude -p "query"` | Process piped content | `cat logs.txt \| claude -p "explain"` |
| `claude -c` | Continue most recent conversation in current directory | `claude -c` |
| `claude -c -p "query"` | Continue via SDK | `claude -c -p "Check for type errors"` |
| `claude -r "<session>" "query"` | Resume session by ID or name | `claude -r "auth-refactor" "Finish this PR"` |
| `claude update` | Update to latest version | `claude update` |
| `claude mcp` | Configure Model Context Protocol servers | See [MCP documentation](./11-mcp.md) |

---

## CLI Flags

### Core Flags

| Flag | Description | Example |
|------|-------------|---------|
| `--print`, `-p` | Print response without interactive mode (SDK mode) | `claude -p "query"` |
| `--continue`, `-c` | Load the most recent conversation in current directory | `claude --continue` |
| `--resume`, `-r` | Resume a specific session by ID or name | `claude --resume auth-refactor` |
| `--version`, `-v` | Output the version number | `claude -v` |
| `--verbose` | Enable verbose logging (helpful for debugging) | `claude --verbose` |
| `--debug` | Enable debug mode with optional category filtering | `claude --debug "api,mcp"` |

### Model Selection

| Flag | Description | Example |
|------|-------------|---------|
| `--model` | Set model with alias or full name | `claude --model opus` |
| `--fallback-model` | Automatic fallback when default overloaded (print mode) | `claude -p --fallback-model sonnet "query"` |

See [Model Configuration](./18-model-configuration.md) for model aliases and settings.

### Working Directories

| Flag | Description | Example |
|------|-------------|---------|
| `--add-dir` | Add additional working directories for Claude to access | `claude --add-dir ../apps ../lib` |

### Session Management

| Flag | Description | Example |
|------|-------------|---------|
| `--session-id` | Use a specific session ID (must be valid UUID) | `claude --session-id "550e8400-..."` |
| `--fork-session` | Create new session ID when resuming (use with --resume or --continue) | `claude --resume abc123 --fork-session` |

### System Prompt Customization

| Flag | Description | Example |
|------|-------------|---------|
| `--system-prompt` | Replace the entire system prompt with custom text | `claude --system-prompt "You are a Python expert"` |
| `--system-prompt-file` | Load system prompt from a file (print mode only) | `claude -p --system-prompt-file ./prompt.txt "query"` |
| `--append-system-prompt` | Append custom text to the end of default prompt | `claude --append-system-prompt "Always use TypeScript"` |

**When to use each:**

- **`--system-prompt`**: Complete control over behavior. Removes all default Claude Code instructions.
- **`--system-prompt-file`**: Load prompts from files for reproducibility and version control.
- **`--append-system-prompt`**: Add instructions while keeping default capabilities (safest option).

Note: `--system-prompt` and `--system-prompt-file` are mutually exclusive.

### Tool Control

| Flag | Description | Example |
|------|-------------|---------|
| `--tools` | Restrict which built-in tools Claude can use | `claude --tools "Bash,Edit,Read"` |
| `--allowedTools` | Tools that execute without permission prompts | `--allowedTools "Bash(git log:*)" "Read"` |
| `--disallowedTools` | Tools removed from model context entirely | `--disallowedTools "Edit" "Write"` |

**Tool control values:**
- Empty string `""` - Disable all tools
- `"default"` - All tools available
- Tool names - Comma-separated list like `"Bash,Edit,Read"`

### Agent Configuration

| Flag | Description | Example |
|------|-------------|---------|
| `--agent` | Specify an agent for the current session | `claude --agent my-custom-agent` |
| `--agents` | Define custom subagents dynamically via JSON | See below |

See [Subagents](./09-subagents.md) for more on custom agents.

### Output Control

| Flag | Description | Example |
|------|-------------|---------|
| `--output-format` | Output format for print mode: `text`, `json`, `stream-json` | `claude -p "query" --output-format json` |
| `--input-format` | Input format for print mode: `text`, `stream-json` | `claude -p --input-format stream-json` |
| `--json-schema` | Get validated JSON output matching a schema (print mode) | `claude -p --json-schema '{"type":"object",...}' "query"` |
| `--include-partial-messages` | Include partial streaming events (requires stream-json) | `claude -p --output-format stream-json --include-partial-messages "query"` |
| `--max-turns` | Limit agentic turns (print mode only) | `claude -p --max-turns 3 "query"` |

### MCP Configuration

| Flag | Description | Example |
|------|-------------|---------|
| `--mcp-config` | Load MCP servers from JSON files or strings | `claude --mcp-config ./mcp.json` |
| `--strict-mcp-config` | Only use MCP servers from --mcp-config | `claude --strict-mcp-config --mcp-config ./mcp.json` |

See [MCP documentation](./11-mcp.md) for server configuration.

### Permissions and Settings

| Flag | Description | Example |
|------|-------------|---------|
| `--permission-mode` | Begin in a specified permission mode | `claude --permission-mode plan` |
| `--permission-prompt-tool` | MCP tool to handle permission prompts (non-interactive) | `claude -p --permission-prompt-tool mcp_auth_tool "query"` |
| `--dangerously-skip-permissions` | Skip permission prompts (use with caution) | `claude --dangerously-skip-permissions` |
| `--settings` | Path to settings JSON file or JSON string | `claude --settings ./settings.json` |
| `--setting-sources` | Comma-separated list of setting sources to load | `claude --setting-sources user,project` |

### Plugins

| Flag | Description | Example |
|------|-------------|---------|
| `--plugin-dir` | Load plugins from directories for this session only | `claude --plugin-dir ./my-plugins` |

### IDE and Browser

| Flag | Description | Example |
|------|-------------|---------|
| `--ide` | Auto-connect to IDE if exactly one valid IDE available | `claude --ide` |
| `--chrome` | Enable Chrome browser integration | `claude --chrome` |
| `--no-chrome` | Disable Chrome browser integration | `claude --no-chrome` |

### API Configuration

| Flag | Description | Example |
|------|-------------|---------|
| `--betas` | Beta headers to include in API requests (API key users) | `claude --betas interleaved-thinking` |

---

## Agents Flag Format

The `--agents` flag accepts a JSON object defining custom subagents:

```bash
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer. Use proactively after code changes.",
    "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  },
  "debugger": {
    "description": "Debugging specialist for errors and test failures.",
    "prompt": "You are an expert debugger. Analyze errors, identify root causes, and provide fixes."
  }
}'
```

### Agent Definition Fields

| Field | Required | Description |
|-------|----------|-------------|
| `description` | Yes | Natural language description of when to invoke the subagent |
| `prompt` | Yes | System prompt guiding the subagent's behavior |
| `tools` | No | Array of tools the subagent can use (e.g., `["Read", "Edit", "Bash"]`). Inherits all if omitted |
| `model` | No | Model alias: `sonnet`, `opus`, or `haiku`. Uses default subagent model if omitted |

---

## Common Usage Patterns

### Non-Interactive (SDK Mode)

```bash
# Simple query
claude -p "What does this function do?"

# Process file content
cat error.log | claude -p "Explain these errors"

# JSON output for scripting
claude -p "List all TODO comments" --output-format json

# Structured output with schema
claude -p --json-schema '{"type":"object","properties":{"files":{"type":"array"}}}' "Find config files"
```

### Session Management

```bash
# Continue last conversation
claude -c

# Resume named session
claude -r "feature-auth" "Continue implementing login"

# Fork a session (new ID, same history)
claude --resume abc123 --fork-session "Try a different approach"
```

### Custom Configuration

```bash
# Use Opus model
claude --model opus

# Add project instructions
claude --append-system-prompt "Follow our coding standards in CONTRIBUTING.md"

# Restrict to safe tools
claude --tools "Read,Grep,Glob"

# Load custom settings
claude --settings ./custom-settings.json
```

### Automation

```bash
# Skip all permission prompts (dangerous)
claude --dangerously-skip-permissions -p "Run tests"

# Auto-approve specific tools
claude -p --allowedTools "Bash(npm test:*)" "Run the test suite"

# Limit turns for bounded execution
claude -p --max-turns 5 "Refactor this function"
```

---

## See Also

- [Interactive Mode](./16-interactive-mode.md) - Keyboard shortcuts and interactive features
- [Headless Mode](./13-headless-mode.md) - Detailed SDK/print mode usage
- [Subagents](./09-subagents.md) - Custom subagent configuration
- [MCP](./11-mcp.md) - Model Context Protocol servers
- [Settings Reference](./05-settings-reference.md) - Configuration options
