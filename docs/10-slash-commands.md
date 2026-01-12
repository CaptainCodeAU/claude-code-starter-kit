# Slash Commands

Slash commands control Claude's behavior during an interactive session. They can be built-in commands, custom commands you define, or commands from plugins.

## Built-in Commands

Claude Code includes many built-in slash commands:

| Command | Purpose |
|---------|---------|
| `/add-dir` | Add additional working directories |
| `/agents` | Manage custom AI subagents for specialized tasks |
| `/bashes` | List and manage background tasks |
| `/bug` | Report bugs (sends conversation to Anthropic) |
| `/clear` | Clear conversation history |
| `/compact [instructions]` | Compact conversation with optional focus instructions |
| `/config` | Open the Settings interface (Config tab) |
| `/context` | Visualize current context usage as a colored grid |
| `/cost` | Show token usage statistics |
| `/doctor` | Check the health of your Claude Code installation |
| `/exit` | Exit the REPL |
| `/export [filename]` | Export the current conversation to a file or clipboard |
| `/help` | Get usage help |
| `/hooks` | Manage hook configurations for tool events |
| `/ide` | Manage IDE integrations and show status |
| `/init` | Initialize project with `CLAUDE.md` guide |
| `/install-github-app` | Set up Claude GitHub Actions for a repository |
| `/login` | Switch Anthropic accounts |
| `/logout` | Sign out from your Anthropic account |
| `/mcp` | Manage MCP server connections and OAuth authentication |
| `/memory` | Edit `CLAUDE.md` memory files |
| `/model` | Select or change the AI model |
| `/output-style [style]` | Set the output style directly or from a selection menu |
| `/permissions` | View or update permissions |
| `/plan` | Enter plan mode directly from the prompt |
| `/plugin` | Manage Claude Code plugins |
| `/pr-comments` | View pull request comments |
| `/privacy-settings` | View and update your privacy settings |
| `/release-notes` | View release notes |
| `/rename <name>` | Rename the current session for easier identification |
| `/remote-env` | Configure remote session environment |
| `/resume [session]` | Resume a conversation by ID or name |
| `/review` | Request code review |
| `/rewind` | Rewind the conversation and/or code |
| `/sandbox` | Enable sandboxed bash tool with filesystem and network isolation |
| `/security-review` | Complete a security review of pending changes |
| `/stats` | Visualize daily usage, session history, and model preferences |
| `/status` | Open Settings interface (Status tab) |
| `/statusline` | Set up Claude Code's status line UI |
| `/teleport` | Resume a remote session from claude.ai |
| `/terminal-setup` | Install Shift+Enter key binding for newlines |
| `/theme` | Change the color theme |
| `/todos` | List current TODO items |
| `/usage` | Show plan usage limits and rate limit status |
| `/vim` | Enter vim mode for alternating insert and command modes |

---

## Custom Slash Commands

Custom slash commands allow you to define frequently used prompts as Markdown files that Claude Code can execute.

### Command Locations

| Location | Scope | Description |
|----------|-------|-------------|
| `.claude/commands/` | Project | Shared with team via version control |
| `~/.claude/commands/` | Personal | Available across all your projects |

When listed in `/help`, project commands show "(project)" and personal commands show "(user)" after their description.

### Creating Commands

Commands are Markdown files where the filename becomes the command name:

```bash
# Create a project command
mkdir -p .claude/commands
echo "Analyze this code for performance issues and suggest optimizations:" > .claude/commands/optimize.md

# Create a personal command
mkdir -p ~/.claude/commands
echo "Review this code for security vulnerabilities:" > ~/.claude/commands/security-review.md
```

**Autocomplete:** Slash command autocomplete works anywhere in your input, not just at the beginning. Type `/` at any position to see available commands.

### Command Priority

If a project command and user command share the same name, the project command takes precedence and the user command is silently ignored.

---

## Command Features

### Namespacing with Subdirectories

Use subdirectories to group related commands. Subdirectories appear in the command description but don't affect the command name:

- `.claude/commands/frontend/component.md` creates `/component` with description "(project:frontend)"
- `~/.claude/commands/component.md` creates `/component` with description "(user)"

Commands in different subdirectories can share names since the subdirectory appears in the description to distinguish them.

### Arguments

Pass dynamic values to commands using argument placeholders.

**All arguments with `$ARGUMENTS`:**

```markdown
<!-- .claude/commands/fix-issue.md -->
Fix issue #$ARGUMENTS following our coding standards
```

Usage:
```
/fix-issue 123 high-priority
# $ARGUMENTS becomes: "123 high-priority"
```

**Individual arguments with `$1`, `$2`, etc.:**

```markdown
<!-- .claude/commands/review-pr.md -->
Review PR #$1 with priority $2 and assign to $3
```

Usage:
```
/review-pr 456 high alice
# $1 becomes "456", $2 becomes "high", $3 becomes "alice"
```

### Bash Command Execution

Execute bash commands before the slash command runs using the `!` prefix with backticks. The output is included in the command context.

**Important:** You must include `allowed-tools` with the `Bash` tool in the frontmatter.

```markdown
---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, create a single git commit.
```

### File References

Include file contents in commands using the `@` prefix:

```markdown
# Reference a specific file
Review the implementation in @src/utils/helpers.js

# Reference multiple files
Compare @src/old-version.js with @src/new-version.js
```

### Extended Thinking

Slash commands can trigger extended thinking by including extended thinking keywords in the prompt (like "think step by step" or "reason through this carefully").

---

## Frontmatter Reference

Command files support YAML frontmatter for metadata and configuration:

| Field | Purpose | Default |
|-------|---------|---------|
| `allowed-tools` | List of tools the command can use | Inherits from conversation |
| `argument-hint` | Arguments hint shown in autocomplete | None |
| `context` | Set to `fork` to run in a sub-agent context | Inline (no fork) |
| `agent` | Agent type when `context: fork` is set | `general-purpose` |
| `description` | Brief description of the command | First line from prompt |
| `model` | Specific model to use | Inherits from conversation |
| `disable-model-invocation` | Prevent the Skill tool from calling this | `false` |
| `hooks` | Hooks scoped to this command's execution | None |

### Example with Full Frontmatter

```markdown
---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
argument-hint: [message]
description: Create a git commit
model: claude-3-5-haiku-20241022
---

Create a git commit with message: $ARGUMENTS
```

### Example with Positional Arguments

```markdown
---
argument-hint: [pr-number] [priority] [assignee]
description: Review pull request
---

Review PR #$1 with priority $2 and assign to $3.
Focus on security, performance, and code style.
```

### Defining Hooks in Commands

Slash commands can define hooks that run during execution:

```markdown
---
description: Deploy to staging with validation
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-deploy.sh"
          once: true
---

Deploy the current branch to staging environment.
```

The `once: true` option runs the hook only once per session. Hooks defined in a command are scoped to that command's execution and are automatically cleaned up when the command finishes.

---

## Plugin Commands

Plugins can provide custom slash commands that integrate seamlessly with Claude Code.

### How Plugin Commands Work

- **Namespaced**: Commands use the format `/plugin-name:command-name` to avoid conflicts
- **Automatically available**: Once a plugin is installed and enabled, its commands appear in `/help`
- **Fully integrated**: Support all command features (arguments, frontmatter, bash execution, file references)

### Plugin Command Structure

Plugin commands are stored in the `commands/` directory of the plugin root:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
└── commands/
    └── hello.md
```

### Invocation Patterns

```bash
# Direct command (when no conflicts)
/command-name

# Plugin-prefixed (when needed for disambiguation)
/plugin-name:command-name

# With arguments
/command-name arg1 arg2
```

---

## MCP Slash Commands

MCP servers can expose prompts as slash commands that become available in Claude Code.

### Command Format

MCP commands follow the pattern:

```
/mcp__<server-name>__<prompt-name> [arguments]
```

### Dynamic Discovery

MCP commands are automatically available when:
- An MCP server is connected and active
- The server exposes prompts through the MCP protocol
- The prompts are successfully retrieved during connection

### Arguments

MCP prompts can accept arguments defined by the server:

```bash
# Without arguments
/mcp__github__list_prs

# With arguments
/mcp__github__pr_review 456
/mcp__jira__create_issue "Bug title" high
```

### Managing MCP Connections

Use the `/mcp` command to:
- View all configured MCP servers
- Check connection status
- Authenticate with OAuth-enabled servers
- Clear authentication tokens
- View available tools and prompts from each server

### MCP Permissions

To approve all tools from an MCP server:
- `mcp__github` (approves all GitHub tools)
- `mcp__github__*` (wildcard syntax, same effect)

To approve specific tools:
- `mcp__github__get_issue`
- `mcp__github__list_issues`

---

## The Skill Tool

The `Skill` tool allows Claude to programmatically invoke both custom slash commands and Agent Skills during a conversation.

### What the Skill Tool Can Invoke

| Type | Location | Requirements |
|------|----------|--------------|
| Custom slash commands | `.claude/commands/` or `~/.claude/commands/` | Must have `description` frontmatter |
| Agent Skills | `.claude/skills/` or `~/.claude/skills/` | Must not have `disable-model-invocation: true` |

Built-in commands like `/compact` and `/init` are **not** available through this tool.

### Encouraging Claude to Use Commands

To encourage Claude to use the Skill tool, reference the command by name (including the slash) in your prompts or `CLAUDE.md`:

```
Run /write-unit-test when you are about to start writing tests.
```

### Character Budget

The Skill tool includes a character budget to limit context usage. This prevents token overflow when many commands and Skills are available.

- **Default limit**: 15,000 characters
- **Custom limit**: Set via `SLASH_COMMAND_TOOL_CHAR_BUDGET` environment variable

When the budget is exceeded, Claude sees only a subset of available items. A warning in `/context` shows how many are included.

### Disabling the Skill Tool

To prevent Claude from programmatically invoking any commands or Skills:

```bash
/permissions
# Add to deny rules: Skill
```

This removes the Skill tool and all command/Skill descriptions from context.

### Disabling Specific Commands

To prevent a specific command from being invoked programmatically via the Skill tool, add to its frontmatter:

```yaml
---
disable-model-invocation: true
---
```

This also removes the item's metadata from context.

### Permission Rules

The permission rules support:
- **Exact match**: `Skill(commit)` (allows only `commit` with no arguments)
- **Prefix match**: `Skill(review-pr:*)` (allows `review-pr` with any arguments)

---

## Skills vs Slash Commands

### When to Use Slash Commands

**Quick, frequently used prompts:**
- Simple prompt snippets you use often
- Quick reminders or templates
- Frequently used instructions that fit in one file

**Examples:**
- `/review` → "Review this code for bugs and suggest improvements"
- `/explain` → "Explain this code in simple terms"
- `/optimize` → "Analyze this code for performance issues"

### When to Use Skills

**Comprehensive capabilities with structure:**
- Complex workflows with multiple steps
- Capabilities requiring scripts or utilities
- Knowledge organized across multiple files
- Team workflows you want to standardize

**Examples:**
- PDF processing Skill with form-filling scripts and validation
- Data analysis Skill with reference docs for different data types
- Documentation Skill with style guides and templates

### Key Differences

| Aspect | Slash Commands | Agent Skills |
|--------|----------------|--------------|
| **Complexity** | Simple prompts | Complex capabilities |
| **Structure** | Single .md file | Directory with SKILL.md + resources |
| **Discovery** | Explicit invocation (`/command`) | Automatic (based on context) |
| **Files** | One file only | Multiple files, scripts, templates |
| **Scope** | Project or personal | Project or personal |

### Example Comparison

**As a slash command:**

```markdown
# .claude/commands/review.md
Review this code for:
- Security vulnerabilities
- Performance issues
- Code style violations
```

Usage: `/review` (manual invocation)

**As a Skill:**

```
.claude/skills/code-review/
├── SKILL.md (overview and workflows)
├── SECURITY.md (security checklist)
├── PERFORMANCE.md (performance patterns)
├── STYLE.md (style guide reference)
└── scripts/
    └── run-linters.sh
```

Usage: "Can you review this code?" (automatic discovery)

The Skill provides richer context, validation scripts, and organized reference material.

---

## Practical Examples

### Git Commit Command

A command that gathers git context and creates commits:

```markdown
---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*)
argument-hint: [optional commit message]
description: Create a well-formatted git commit
---

## Context

- Current git status: !`git status`
- Staged changes: !`git diff --cached`
- Unstaged changes: !`git diff`
- Current branch: !`git branch --show-current`
- Recent commits for style reference: !`git log --oneline -5`

## Your task

Based on the changes above, create a git commit.

If a message was provided: $ARGUMENTS
Otherwise, write a concise commit message based on the changes.

Follow conventional commit format when appropriate.
```

### Code Review with Hooks

A command with validation hooks:

```markdown
---
description: Security-focused code review
allowed-tools: Read, Grep, Glob
hooks:
  PostToolUse:
    - matcher: "Read"
      hooks:
        - type: command
          command: "./scripts/check-sensitive-files.sh"
---

Perform a security-focused code review of the current changes.

Focus on:
1. Input validation and sanitization
2. Authentication and authorization
3. Data exposure risks
4. Injection vulnerabilities
5. Dependency security

Provide findings organized by severity.
```

### Multi-File Analysis

A command that references multiple files:

```markdown
---
argument-hint: [component-name]
description: Analyze a React component and its tests
---

Analyze the following React component and its associated files:

Component: @src/components/$1/$1.tsx
Styles: @src/components/$1/$1.css
Tests: @src/components/$1/$1.test.tsx

Provide feedback on:
1. Component structure and readability
2. State management approach
3. Test coverage and quality
4. Accessibility considerations
```

---

## Token Impact

| Component | Token Cost |
|-----------|------------|
| Command file content | Loaded when invoked |
| `$ARGUMENTS` and `$1`, `$2`, etc. | Replaced with actual values |
| Bash output (`!` prefix) | Included in context |
| File references (`@` prefix) | File contents included |
| Skill tool metadata | Up to 15,000 chars (configurable) |

**Best practices:**
- Keep command prompts focused and concise
- Use file references sparingly for large files
- Set `disable-model-invocation: true` for commands you only invoke manually

---

## See Also

- [Skills](03-skills.md) - Complex, multi-file capabilities
- [Subagents](09-subagents.md) - Specialized AI assistants
- [Plugins](06-plugins.md) - Distributing commands via plugins
- [Hooks](02-hooks.md) - Event-driven automation
