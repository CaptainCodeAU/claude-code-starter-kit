# Headless Mode (Agent SDK CLI)

Run Claude Code programmatically from scripts, CI/CD pipelines, and automation workflows using the `-p` flag.

## Overview

The Agent SDK provides the same tools, agent loop, and context management that power interactive Claude Code. It's available as:

- **CLI** (`claude -p`) - For scripts and CI/CD (this document)
- **Python SDK** - For programmatic control with native objects
- **TypeScript SDK** - For Node.js applications

This document covers CLI usage. For Python and TypeScript SDKs with structured outputs and tool approval callbacks, see the [Agent SDK documentation](https://platform.claude.com/docs/en/agent-sdk/overview).

## Basic Usage

Add `-p` (or `--print`) to run Claude Code non-interactively:

```bash
claude -p "What does the auth module do?"
```

All [CLI options](/en/cli-reference) work with `-p`, including:
- `--continue` for continuing conversations
- `--allowedTools` for auto-approving tools
- `--output-format` for structured output

## Output Formats

### Plain Text (Default)

```bash
claude -p "Summarize this project"
```

### JSON with Metadata

Returns structured JSON with result, session ID, and metadata:

```bash
claude -p "Summarize this project" --output-format json
```

The text result is in the `result` field:

```bash
# Extract just the text result
claude -p "Summarize this project" --output-format json | jq -r '.result'
```

### Streaming JSON

Newline-delimited JSON for real-time streaming:

```bash
claude -p "Analyze this codebase" --output-format stream-json
```

### Structured Output with JSON Schema

Get output conforming to a specific schema:

```bash
claude -p "Extract the main function names from auth.py" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}'
```

Response includes metadata with structured output in `structured_output` field:

```bash
# Extract structured output
claude -p "Extract function names" \
  --output-format json \
  --json-schema '...' \
  | jq '.structured_output'
```

## Auto-Approving Tools

Use `--allowedTools` to let Claude use tools without prompting:

```bash
# Allow file operations and bash
claude -p "Run tests and fix failures" \
  --allowedTools "Bash,Read,Edit"
```

### Tool Patterns

| Pattern | Matches |
|---------|---------|
| `Bash` | All bash commands |
| `Bash(git:*)` | Git commands only |
| `Read` | File reading |
| `Edit` | File editing |
| `Write` | File creation |
| `Glob` | File pattern matching |
| `Grep` | Content searching |

### Example: Auto-Approve Git Commands

```bash
claude -p "Review staged changes and create a commit" \
  --allowedTools "Bash(git diff:*),Bash(git log:*),Bash(git status:*),Bash(git commit:*)"
```

## System Prompt Customization

### Append to Default Prompt

Add instructions while keeping Claude Code's default behavior:

```bash
claude -p "Review this code" \
  --append-system-prompt "You are a security engineer. Focus on vulnerabilities."
```

### Replace System Prompt

Fully replace the default prompt:

```bash
claude -p "Analyze the architecture" \
  --system-prompt "You are a software architect. Be concise."
```

## Continuing Conversations

### Continue Most Recent

```bash
# First request
claude -p "Review this codebase for performance issues"

# Continue the same conversation
claude -p "Now focus on the database queries" --continue
claude -p "Generate a summary of all issues found" --continue
```

### Resume Specific Session

Capture session ID for multiple parallel conversations:

```bash
# Start and capture session ID
session_id=$(claude -p "Start a review" --output-format json | jq -r '.session_id')

# Resume specific session
claude -p "Continue that review" --resume "$session_id"
```

## Common Patterns

### Create a Commit

```bash
claude -p "Look at my staged changes and create an appropriate commit" \
  --allowedTools "Bash(git diff:*),Bash(git log:*),Bash(git status:*),Bash(git commit:*)"
```

### Pipe Content to Claude

```bash
# Analyze PR diff
gh pr diff "$1" | claude -p "Review this diff for security issues" \
  --append-system-prompt "You are a security engineer."

# Analyze log file
cat error.log | claude -p "What's causing these errors?"
```

### Run Tests and Fix

```bash
claude -p "Run the test suite and fix any failures" \
  --allowedTools "Bash,Read,Edit"
```

### Code Review with JSON Output

```bash
gh pr diff "$1" | claude -p "Review for issues" \
  --output-format json \
  --json-schema '{
    "type": "object",
    "properties": {
      "issues": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "severity": {"type": "string"},
            "description": {"type": "string"},
            "line": {"type": "number"}
          }
        }
      }
    }
  }'
```

### Batch Processing

```bash
# Process multiple files
for file in src/*.py; do
  claude -p "Add docstrings to $file" --allowedTools "Read,Edit"
done
```

### Parallel Execution

```bash
# Run reviews in parallel
claude -p "Review auth.py" --allowedTools "Read" &
claude -p "Review database.py" --allowedTools "Read" &
wait
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Invalid arguments |

## Environment Variables

These environment variables affect headless mode:

| Variable | Purpose |
|----------|---------|
| `ANTHROPIC_API_KEY` | API key for authentication |
| `ANTHROPIC_MODEL` | Override default model |
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | Max output tokens |
| `BASH_DEFAULT_TIMEOUT_MS` | Default bash timeout |

## Comparison with Interactive Mode

| Feature | Interactive | Headless (`-p`) |
|---------|-------------|-----------------|
| User prompts | Multiple, interactive | Single, via flag |
| Tool approval | Interactive prompts | `--allowedTools` |
| Output | Rich terminal UI | Text/JSON |
| Session | Persistent | Single or resumed |
| Use case | Development | Automation, CI/CD |

## Integration with CI/CD

Headless mode is the foundation for [GitHub Actions](./14-github-actions.md):

```yaml
# In GitHub Actions workflow
- run: |
    claude -p "Review this PR" \
      --allowedTools "Read,Glob,Grep" \
      --output-format json
```

## Token Impact

Same as interactive mode - each invocation consumes tokens based on:
- Input prompt length
- Context (files read, previous conversation)
- Output length
- Model used

## Troubleshooting

### No Output

```bash
# Add --debug for verbose output
claude -p "test" --debug
```

### Timeout Issues

```bash
# Increase bash timeout
BASH_DEFAULT_TIMEOUT_MS=300000 claude -p "Run long tests" --allowedTools "Bash"
```

### Permission Denied

```bash
# Explicitly allow needed tools
claude -p "Edit files" --allowedTools "Read,Edit,Write"
```

## See Also

- [GitHub Actions](./14-github-actions.md) - Using headless mode in CI/CD
- [Settings Reference](./05-settings-reference.md) - Environment variables
- [Agent SDK](https://platform.claude.com/docs/en/agent-sdk/overview) - Python and TypeScript SDKs
