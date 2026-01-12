# Subagents

Subagents are specialized AI assistants that handle specific types of tasks. Each subagent runs in its own context window with a custom system prompt, specific tool access, and independent permissions. When Claude encounters a task that matches a subagent's description, it delegates to that subagent, which works independently and returns results.

## Why Use Subagents

Subagents help you:

- **Preserve context** - Keep exploration and implementation out of your main conversation
- **Enforce constraints** - Limit which tools a subagent can use
- **Control costs** - Route tasks to faster, cheaper models like Haiku
- **Specialize behavior** - Use focused system prompts for specific domains
- **Reuse configurations** - Share subagents across projects with user-level definitions

## Built-in Subagents

Claude Code includes several built-in subagents that Claude automatically uses when appropriate.

| Subagent | Model | Tools | Purpose |
|----------|-------|-------|---------|
| **Explore** | Haiku | Read-only | Fast codebase search and analysis |
| **Plan** | Inherits | Read-only | Research for planning mode |
| **general-purpose** | Inherits | All | Complex multi-step tasks |
| **Bash** | Inherits | Bash | Terminal commands in separate context |
| **statusline-setup** | Sonnet | Read, Edit | Configure status line via `/statusline` |
| **Claude Code Guide** | Haiku | Docs | Answer questions about Claude Code features |

### Explore

A fast, read-only agent optimized for searching and analyzing codebases. Claude delegates to Explore when it needs to search or understand a codebase without making changes. When invoking Explore, Claude specifies a thoroughness level: **quick** for targeted lookups, **medium** for balanced exploration, or **very thorough** for comprehensive analysis.

### Plan

A research agent used during plan mode to gather context before presenting a plan. When you're in plan mode and Claude needs to understand your codebase, it delegates research to the Plan subagent.

### general-purpose

A capable agent for complex, multi-step tasks that require both exploration and action. Claude delegates to general-purpose when the task requires both exploration and modification, complex reasoning to interpret results, or multiple dependent steps.

---

## Creating Custom Subagents

Subagents are defined in Markdown files with YAML frontmatter. You can create them interactively with `/agents` or manually as files.

### Using the /agents Command

The `/agents` command provides an interactive interface for managing subagents:

```
/agents
```

This lets you:
- View all available subagents (built-in, user, project, and plugin)
- Create new subagents with guided setup or Claude generation
- Edit existing subagent configuration and tool access
- Delete custom subagents
- See which subagents are active when duplicates exist

### Subagent File Locations

Subagents are stored in different locations depending on scope. When multiple subagents share the same name, higher-priority locations win.

| Location | Scope | Priority |
|----------|-------|----------|
| `--agents` CLI flag | Current session only | 1 (highest) |
| `.claude/agents/` | Current project | 2 |
| `~/.claude/agents/` | All your projects | 3 |
| Plugin's `agents/` | Where plugin is enabled | 4 (lowest) |

**Project subagents** (`.claude/agents/`) are ideal for subagents specific to a codebase. Check them into version control so your team can use and improve them collaboratively.

**User subagents** (`~/.claude/agents/`) are personal subagents available in all your projects.

**CLI-defined subagents** exist only for that session and aren't saved to disk:

```bash
claude --agents '{
  "code-reviewer": {
    "description": "Expert code reviewer. Use proactively after code changes.",
    "prompt": "You are a senior code reviewer. Focus on code quality, security, and best practices.",
    "tools": ["Read", "Grep", "Glob", "Bash"],
    "model": "sonnet"
  }
}'
```

### Writing Subagent Files

Subagent files use YAML frontmatter for configuration, followed by the system prompt in Markdown:

```markdown
---
name: code-reviewer
description: Reviews code for quality and best practices
tools: Read, Glob, Grep
model: sonnet
---

You are a code reviewer. When invoked, analyze the code and provide
specific, actionable feedback on quality, security, and best practices.
```

The frontmatter defines the subagent's metadata and configuration. The body becomes the system prompt that guides the subagent's behavior. Subagents receive only this system prompt (plus basic environment details like working directory), not the full Claude Code system prompt.

**Note:** Subagents are loaded at session start. If you create a subagent by manually adding a file, restart your session or use `/agents` to load it immediately.

---

## Frontmatter Reference

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier using lowercase letters and hyphens |
| `description` | Yes | When Claude should delegate to this subagent |
| `tools` | No | Tools the subagent can use. Inherits all tools if omitted |
| `disallowedTools` | No | Tools to deny, removed from inherited or specified list |
| `model` | No | Model to use: `sonnet`, `opus`, `haiku`, or `inherit`. Defaults to `sonnet` |
| `permissionMode` | No | Permission mode: `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, or `plan` |
| `skills` | No | Skills to load into the subagent's context at startup |
| `hooks` | No | Lifecycle hooks scoped to this subagent |

### Model Selection

The `model` field controls which AI model the subagent uses:

- **sonnet** - Default, balanced capability and speed
- **opus** - Most capable, for complex tasks
- **haiku** - Fastest, lowest cost, for simple tasks
- **inherit** - Use the same model as the main conversation

### Permission Modes

The `permissionMode` field controls how the subagent handles permission prompts:

| Mode | Behavior |
|------|----------|
| `default` | Standard permission checking with prompts |
| `acceptEdits` | Auto-accept file edits |
| `dontAsk` | Auto-deny permission prompts (explicitly allowed tools still work) |
| `bypassPermissions` | Skip all permission checks (use with caution) |
| `plan` | Plan mode (read-only exploration) |

If the parent uses `bypassPermissions`, this takes precedence and cannot be overridden.

---

## Tool Control

### Available Tools

Subagents can use any of Claude Code's internal tools. By default, subagents inherit all tools from the main conversation, including MCP tools.

Common tools include:
- `Read`, `Write`, `Edit` - File operations
- `Bash` - Shell commands
- `Glob`, `Grep` - File search
- `WebFetch`, `WebSearch` - Web access
- `Task` - Spawn subagents
- `LSP` - Language server operations

### Restricting Tools

Use the `tools` field (allowlist) or `disallowedTools` field (denylist):

```yaml
---
name: safe-researcher
description: Research agent with restricted capabilities
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
---
```

### Disabling Specific Subagents

Prevent Claude from using specific subagents by adding them to the `deny` array in settings:

```json
{
  "permissions": {
    "deny": ["Task(Explore)", "Task(my-custom-agent)"]
  }
}
```

Or use the CLI flag:

```bash
claude --disallowedTools "Task(Explore)"
```

### Conditional Validation with Hooks

For dynamic control over tool usage, use `PreToolUse` hooks to validate operations before they execute:

```yaml
---
name: db-reader
description: Execute read-only database queries
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---
```

The validation script reads JSON input via stdin and exits with code 2 to block operations:

```bash
#!/bin/bash
# ./scripts/validate-readonly-query.sh

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Block SQL write operations (case-insensitive)
if echo "$COMMAND" | grep -iE '\b(INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|TRUNCATE)\b' > /dev/null; then
  echo "Blocked: Only SELECT queries are allowed" >&2
  exit 2
fi

exit 0
```

---

## Hooks in Subagents

Subagents can define hooks that run during their lifecycle. There are two ways to configure hooks.

### Hooks in Subagent Frontmatter

Define hooks directly in the subagent's markdown file. These hooks only run while that specific subagent is active:

| Event | Matcher Input | When It Fires |
|-------|---------------|---------------|
| `PreToolUse` | Tool name | Before the subagent uses a tool |
| `PostToolUse` | Tool name | After the subagent uses a tool |
| `Stop` | (none) | When the subagent finishes |

Example with multiple hooks:

```yaml
---
name: code-reviewer
description: Review code changes with automatic linting
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-command.sh $TOOL_INPUT"
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/run-linter.sh"
---
```

### Project-Level Hooks for Subagent Events

Configure hooks in `settings.json` that respond to subagent lifecycle events in the main session:

| Event | Matcher Input | When It Fires |
|-------|---------------|---------------|
| `SubagentStart` | Agent type name | When a subagent begins execution |
| `SubagentStop` | Agent type name | When a subagent completes |

```json
{
  "hooks": {
    "SubagentStart": [
      {
        "matcher": "db-agent",
        "hooks": [
          { "type": "command", "command": "./scripts/setup-db-connection.sh" }
        ]
      }
    ],
    "SubagentStop": [
      {
        "matcher": "db-agent",
        "hooks": [
          { "type": "command", "command": "./scripts/cleanup-db-connection.sh" }
        ]
      }
    ]
  }
}
```

---

## Working with Subagents

### Automatic Delegation

Claude automatically delegates tasks based on:
- The task description in your request
- The `description` field in subagent configurations
- Current context

To encourage proactive delegation, include phrases like "use proactively" in your subagent's description field.

You can also request a specific subagent explicitly:

```
Use the test-runner subagent to fix failing tests
Have the code-reviewer subagent look at my recent changes
```

### Foreground vs Background Execution

Subagents can run in the foreground (blocking) or background (concurrent):

**Foreground subagents** block the main conversation until complete. Permission prompts and clarifying questions are passed through to you.

**Background subagents** run concurrently while you continue working. They inherit the parent's permissions and auto-deny anything not pre-approved. MCP tools are not available in background subagents.

You can:
- Ask Claude to "run this in the background"
- Press **Ctrl+B** to background a running task

To disable background tasks, set `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1`.

### Resuming Subagents

Each subagent invocation creates a new instance with fresh context. To continue an existing subagent's work, ask Claude to resume it:

```
Use the code-reviewer subagent to review the authentication module
[Agent completes]

Continue that code review and now analyze the authorization logic
[Claude resumes the subagent with full context from previous conversation]
```

Resumed subagents retain their full conversation history, including all previous tool calls, results, and reasoning.

Subagent transcripts are stored at `~/.claude/projects/{project}/{sessionId}/subagents/` as `agent-{agentId}.jsonl`.

### Context Management

**Auto-compaction**: Subagents support automatic compaction using the same logic as the main conversation. When a subagent's context approaches its limit, Claude Code summarizes older messages to free up space.

**Transcript persistence**: Subagent transcripts persist independently of the main conversation:
- Main conversation compaction doesn't affect subagent transcripts
- Transcripts persist within their session
- Automatic cleanup based on `cleanupPeriodDays` setting (default: 30 days)

---

## Example Subagents

### Code Reviewer (Read-Only)

A read-only subagent that reviews code without modifying it:

```markdown
---
name: code-reviewer
description: Expert code review specialist. Proactively reviews code for quality, security, and maintainability. Use immediately after writing or modifying code.
tools: Read, Grep, Glob, Bash
model: inherit
---

You are a senior code reviewer ensuring high standards of code quality and security.

When invoked:
1. Run git diff to see recent changes
2. Focus on modified files
3. Begin review immediately

Review checklist:
- Code is clear and readable
- Functions and variables are well-named
- No duplicated code
- Proper error handling
- No exposed secrets or API keys
- Input validation implemented
- Good test coverage
- Performance considerations addressed

Provide feedback organized by priority:
- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (consider improving)

Include specific examples of how to fix issues.
```

### Debugger

A subagent that can both analyze and fix issues:

```markdown
---
name: debugger
description: Debugging specialist for errors, test failures, and unexpected behavior. Use proactively when encountering any issues.
tools: Read, Edit, Bash, Grep, Glob
---

You are an expert debugger specializing in root cause analysis.

When invoked:
1. Capture error message and stack trace
2. Identify reproduction steps
3. Isolate the failure location
4. Implement minimal fix
5. Verify solution works

Debugging process:
- Analyze error messages and logs
- Check recent code changes
- Form and test hypotheses
- Add strategic debug logging
- Inspect variable states

For each issue, provide:
- Root cause explanation
- Evidence supporting the diagnosis
- Specific code fix
- Testing approach
- Prevention recommendations

Focus on fixing the underlying issue, not the symptoms.
```

### Data Scientist

A domain-specific subagent for data analysis:

```markdown
---
name: data-scientist
description: Data analysis expert for SQL queries, BigQuery operations, and data insights. Use proactively for data analysis tasks and queries.
tools: Bash, Read, Write
model: sonnet
---

You are a data scientist specializing in SQL and BigQuery analysis.

When invoked:
1. Understand the data analysis requirement
2. Write efficient SQL queries
3. Use BigQuery command line tools (bq) when appropriate
4. Analyze and summarize results
5. Present findings clearly

Key practices:
- Write optimized SQL queries with proper filters
- Use appropriate aggregations and joins
- Include comments explaining complex logic
- Format results for readability
- Provide data-driven recommendations

For each analysis:
- Explain the query approach
- Document any assumptions
- Highlight key findings
- Suggest next steps based on data

Always ensure queries are efficient and cost-effective.
```

### Database Query Validator

A subagent with conditional validation via hooks:

```markdown
---
name: db-reader
description: Execute read-only database queries. Use when analyzing data or generating reports.
tools: Bash
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
---

You are a database analyst with read-only access. Execute SELECT queries to answer questions about the data.

When asked to analyze data:
1. Identify which tables contain the relevant data
2. Write efficient SELECT queries with appropriate filters
3. Present results clearly with context

You cannot modify data. If asked to INSERT, UPDATE, DELETE, or modify schema, explain that you only have read access.
```

---

## When to Use What

### Use Subagents When

- The task produces verbose output you don't need in your main context
- You want to enforce specific tool restrictions or permissions
- The work is self-contained and can return a summary
- You want to isolate high-volume operations (tests, logs, documentation)
- Running parallel research on independent topics

### Use the Main Conversation When

- The task needs frequent back-and-forth or iterative refinement
- Multiple phases share significant context (planning → implementation → testing)
- You're making a quick, targeted change
- Latency matters (subagents start fresh and may need time to gather context)

### Use Skills When

- You want reusable prompts or workflows that run in the main conversation context
- You need capabilities that don't require isolated context
- Complex workflows that shouldn't spawn separate agents

**Note:** Subagents cannot spawn other subagents. If your workflow requires nested delegation, use Skills or chain subagents from the main conversation.

---

## Common Patterns

### Isolate High-Volume Operations

One of the most effective uses for subagents is isolating operations that produce large amounts of output:

```
Use a subagent to run the test suite and report only the failing tests with their error messages
```

The verbose output stays in the subagent's context while only the relevant summary returns to your main conversation.

### Run Parallel Research

For independent investigations, spawn multiple subagents to work simultaneously:

```
Research the authentication, database, and API modules in parallel using separate subagents
```

Each subagent explores its area independently, then Claude synthesizes the findings.

### Chain Subagents

For multi-step workflows, ask Claude to use subagents in sequence:

```
Use the code-reviewer subagent to find performance issues, then use the optimizer subagent to fix them
```

Each subagent completes its task and returns results to Claude, which then passes relevant context to the next subagent.

---

## Token Impact

| Aspect | Impact |
|--------|--------|
| Subagent invocation | Minimal overhead in main context |
| Subagent results | Returned summary adds to main context |
| Subagent transcripts | Stored separately, don't count against main |
| Multiple subagents | Each has isolated context, watch for result accumulation |

**Best practice:** Design subagents to return concise summaries rather than verbose output.

---

## See Also

- [Skills](03-skills.md) - Lazy-loaded capabilities for the main conversation
- [Hooks](02-hooks.md) - Event handlers for automation
- [Settings Reference](05-settings-reference.md) - Permission and tool configuration
