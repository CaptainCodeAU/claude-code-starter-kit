# Claude Code Skills

Skills are modular capabilities that extend Claude with specialized expertise. They package instructions, metadata, and optional resources (scripts, templates, reference files) that Claude automatically uses when relevant to your request.

A Skill is a markdown file that teaches Claude how to do something specific: reviewing PRs using your team's standards, generating commit messages in your preferred format, or querying your company's database schema. When you ask Claude something that matches a Skill's purpose, Claude automatically applies it.

Unlike prompts (conversation-level instructions for one-off tasks), Skills load on-demand and eliminate the need to repeatedly provide the same guidance across multiple conversations.

## Skills vs Other Options

Claude Code offers several ways to customize behavior. The key difference: **Skills are triggered automatically by Claude** based on your request, while slash commands require you to type `/command` explicitly.

| Use this | When you want to... | When it runs |
|----------|---------------------|--------------|
| **Skills** | Give Claude specialized knowledge (e.g., "review PRs using our standards") | Claude chooses when relevant |
| **Slash commands** | Create reusable prompts (e.g., `/deploy staging`) | You type `/command` to run it |
| **CLAUDE.md** | Set project-wide instructions (e.g., "use TypeScript strict mode") | Loaded into every conversation |
| **Subagents** | Delegate tasks to a separate context with its own tools | Claude delegates, or you invoke explicitly |
| **Hooks** | Run scripts on events (e.g., lint on file save) | Fires on specific tool events |
| **MCP servers** | Connect Claude to external tools and data sources | Claude calls MCP tools as needed |

**Skills vs. subagents**: Skills add knowledge to the current conversation. Subagents run in a separate context with their own tools. Use Skills for guidance and standards; use subagents when you need isolation or different tool access.

**Skills vs. MCP**: Skills tell Claude *how* to use tools; MCP *provides* the tools. For example, an MCP server connects Claude to your database, while a Skill teaches Claude your data model and query patterns.

## How Skills Work

Skills are **model-invoked**: Claude decides which Skills to use based on your request. You don't need to explicitly call a Skill. Claude automatically applies relevant Skills when your request matches their description.

### Progressive Disclosure: Three-Tier Loading

Skills use a three-tier information model that minimizes context usage:

| Level | When Loaded | Token Cost | Content |
|-------|-------------|------------|---------|
| **Level 1: Metadata** | Always (at startup) | ~100 tokens per skill | `name` and `description` from YAML frontmatter |
| **Level 2: Instructions** | When skill is triggered | Under 5k tokens | SKILL.md body with instructions and guidance |
| **Level 3: Resources** | As needed | Effectively unlimited | Bundled files (reference docs, scripts) accessed via bash |

This architecture means you can install many Skills without context penalty—Claude only knows each Skill exists and when to use it until actually needed.

### Discovery → Activation → Execution

When you send a request, Claude follows these steps:

1. **Discovery**: At startup, Claude loads only the name and description of each available Skill. This keeps startup fast while giving Claude enough context to know when each Skill might be relevant.

2. **Activation**: When your request matches a Skill's description, Claude asks to use the Skill. You'll see a confirmation prompt before the full `SKILL.md` is loaded into context.

3. **Execution**: Claude follows the Skill's instructions, loading referenced files or running bundled scripts as needed.

## Where Skills Live

Where you store a Skill determines who can use it:

| Location | Path | Applies to |
|----------|------|------------|
| **Enterprise** | See managed settings | All users in your organization |
| **Personal** | `~/.claude/skills/` | You, across all projects |
| **Project** | `.claude/skills/` | Anyone working in this repository |
| **Plugin** | Bundled with plugins | Anyone with the plugin installed |

If two Skills have the same name, the higher row wins: managed overrides personal, personal overrides project, and project overrides plugin.

## Skill Structure

```
.claude/skills/
└── my-skill/
    ├── SKILL.md           # Required: metadata + instructions
    ├── REFERENCE.md       # Optional: detailed reference (loaded as needed)
    ├── EXAMPLES.md        # Optional: usage examples (loaded as needed)
    ├── scripts/           # Optional: executable scripts (run via bash)
    │   └── helper.py
    └── templates/         # Optional: file templates (read when needed)
```

## SKILL.md Format

Every Skill requires a `SKILL.md` file with YAML frontmatter:

```yaml
---
name: processing-pdfs
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
---

# PDF Processing

## Quick Start

Use pdfplumber for text extraction:

```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

## Advanced Features

**Form filling**: See [FORMS.md](FORMS.md) for complete guide
**API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
```

## YAML Frontmatter Reference

### Required Fields

| Field | Requirements |
|-------|--------------|
| `name` | Max 64 chars. Lowercase letters, numbers, hyphens only. No XML tags. Cannot contain "anthropic" or "claude". Should match the directory name. |
| `description` | Max 1024 chars. Non-empty. No XML tags. Should include WHAT the skill does AND WHEN to use it. Claude uses this to decide when to apply the Skill. |

### Optional Fields

| Field | Description |
|-------|-------------|
| `allowed-tools` | Tools Claude can use without asking permission when this Skill is active. Supports comma-separated values or YAML-style lists. |
| `model` | Model to use when this Skill is active (e.g., `claude-sonnet-4-20250514`). Defaults to the conversation's model. |
| `context` | Set to `fork` to run the Skill in a forked sub-agent context with its own conversation history. |
| `agent` | Specify which agent type to use when `context: fork` is set (e.g., `Explore`, `Plan`, `general-purpose`, or a custom agent name). Only applicable with `context: fork`. |
| `hooks` | Define hooks scoped to this Skill's lifecycle. Supports `PreToolUse`, `PostToolUse`, and `Stop` events. |
| `user-invocable` | Controls whether the Skill appears in the slash command menu. Defaults to `true`. Does not affect automatic discovery. |
| `disable-model-invocation` | When `true`, blocks programmatic invocation via the Skill tool. Skill still appears in slash menu. |

### allowed-tools Examples

Limit which tools Claude can use when a Skill is active:

```yaml
---
name: reading-files-safely
description: Read files without making changes. Use when you need read-only file access.
allowed-tools: Read, Grep, Glob
---
```

Or as a YAML list:

```yaml
---
name: reading-files-safely
description: Read files without making changes. Use when you need read-only file access.
allowed-tools:
  - Read
  - Grep
  - Glob
---
```

When this Skill is active, Claude can only use the specified tools without needing to ask for permission. Useful for:
- Read-only Skills that shouldn't modify files
- Skills with limited scope (e.g., only data analysis, no file writing)
- Security-sensitive workflows

### context: fork Example

Run a Skill in an isolated sub-agent context with its own conversation history:

```yaml
---
name: code-analysis
description: Analyze code quality and generate detailed reports
context: fork
agent: Explore
---
```

### hooks Example

Skills can define hooks that run during the Skill's lifecycle:

```yaml
---
name: secure-operations
description: Perform operations with additional security checks
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/security-check.sh $TOOL_INPUT"
          once: true
---
```

The `once: true` option runs the hook only once per session. Hooks defined in a Skill are scoped to that Skill's execution and automatically cleaned up when the Skill finishes.

### Controlling Skill Visibility

| Setting | Slash menu | Skill tool | Auto-discovery | Use case |
|---------|------------|------------|----------------|----------|
| `user-invocable: true` (default) | Visible | Allowed | Yes | Skills you want users to invoke directly |
| `user-invocable: false` | Hidden | Allowed | Yes | Skills Claude can use but users shouldn't invoke manually |
| `disable-model-invocation: true` | Visible | Blocked | Yes | Skills you want users to invoke but not Claude programmatically |

Example of a model-only Skill:

```yaml
---
name: internal-review-standards
description: Apply internal code review standards when reviewing pull requests
user-invocable: false
---
```

## Writing Effective Descriptions

The description is critical for skill selection—Claude uses it to choose the right Skill from potentially 100+ available Skills.

### Always Write in Third Person

The description is injected into the system prompt. Inconsistent point-of-view causes discovery problems.

```yaml
# Good
description: "Processes Excel files and generates reports"

# Avoid
description: "I can help you process Excel files"
description: "You can use this to process Excel files"
```

### Be Specific and Include Key Terms

Include both what the Skill does AND when to use it:

```yaml
# Good - specific with triggers
description: "Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction."

# Good - includes key terms
description: "Analyze Excel spreadsheets, create pivot tables, generate charts. Use when analyzing Excel files, spreadsheets, tabular data, or .xlsx files."

# Bad - too vague
description: "Helps with documents"
description: "Processes data"
```

### Naming Conventions

Use **gerund form** (verb + -ing) for skill names:

```yaml
# Good (gerund form)
name: processing-pdfs
name: analyzing-spreadsheets
name: testing-code
name: explaining-code
name: generating-commit-messages

# Acceptable alternatives
name: pdf-processing
name: spreadsheet-analysis

# Avoid
name: helper
name: utils
name: tools
```

## Progressive Disclosure Patterns

Keep SKILL.md as an overview that points to detailed materials. Keep `SKILL.md` **under 500 lines** for optimal performance.

### Pattern 1: High-Level Guide with References

```markdown
---
name: pdf-processing
description: Extracts text and tables from PDF files...
---

# PDF Processing

## Quick Start

Extract text with pdfplumber:
```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

## Advanced Features

**Form filling**: See [FORMS.md](FORMS.md) for complete guide
**API reference**: See [REFERENCE.md](REFERENCE.md) for all methods
**Examples**: See [EXAMPLES.md](EXAMPLES.md) for common patterns
```

Claude loads FORMS.md, REFERENCE.md, or EXAMPLES.md only when needed.

### Pattern 2: Domain-Specific Organization

For Skills with multiple domains:

```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── reference/
    ├── finance.md (revenue, billing metrics)
    ├── sales.md (opportunities, pipeline)
    ├── product.md (API usage, features)
    └── marketing.md (campaigns, attribution)
```

```markdown
# BigQuery Data Analysis

## Available datasets

**Finance**: Revenue, ARR, billing → See [reference/finance.md](reference/finance.md)
**Sales**: Opportunities, pipeline, accounts → See [reference/sales.md](reference/sales.md)
**Product**: API usage, features, adoption → See [reference/product.md](reference/product.md)
**Marketing**: Campaigns, attribution, email → See [reference/marketing.md](reference/marketing.md)

## Quick search

Find specific metrics using grep:

```bash
grep -i "revenue" reference/finance.md
grep -i "pipeline" reference/sales.md
```
```

When a user asks about revenue, Claude reads only `reference/finance.md`.

### Key Guidelines

- Keep SKILL.md body **under 500 lines** for optimal performance
- Keep references **one level deep** from SKILL.md (avoid nested references)
- Use **descriptive file names**: `form_validation_rules.md`, not `doc2.md`
- Always use **forward slashes** in paths: `reference/guide.md`, not `reference\guide.md`

## Bundling Executable Scripts

Scripts provide deterministic operations without consuming context—only the output enters the context window:

```
pdf-skill/
├── SKILL.md
└── scripts/
    ├── analyze_form.py
    ├── fill_form.py
    └── validate.py
```

In `SKILL.md`, tell Claude to run the script rather than read it:

```markdown
## Utility Scripts

**analyze_form.py**: Extract all form fields from PDF

```bash
python scripts/analyze_form.py input.pdf > fields.json
```

**validate.py**: Check PDFs for required fields

```bash
python scripts/validate.py document.pdf
```
```

**Key principle**: Scripts should handle errors explicitly rather than punting to Claude. Provide helpful error messages.

Scripts are useful for:
- Complex validation logic that would be verbose to describe in prose
- Data processing that's more reliable as tested code than generated code
- Operations that benefit from consistency across uses

## Workflow Patterns

### Checklists for Complex Tasks

For multi-step operations, provide a checklist Claude can track:

```markdown
## PDF Form Filling Workflow

Copy this checklist and check off items as you complete them:

```
Task Progress:
- [ ] Step 1: Analyze the form (run analyze_form.py)
- [ ] Step 2: Create field mapping (edit fields.json)
- [ ] Step 3: Validate mapping (run validate_fields.py)
- [ ] Step 4: Fill the form (run fill_form.py)
- [ ] Step 5: Verify output (run verify_output.py)
```
```

### Feedback Loops

Implement validate → fix → repeat patterns:

```markdown
## Document Editing Process

1. Make your edits to the document
2. **Validate immediately**: `python scripts/validate.py output/`
3. If validation fails:
   - Review the error message carefully
   - Fix the issues
   - Run validation again
4. **Only proceed when validation passes**
```

## Skills and Subagents

### Give a Subagent Access to Skills

Subagents do not automatically inherit Skills from the main conversation. To give a custom subagent access to specific Skills, list them in the subagent's `skills` field:

```yaml
# .claude/agents/code-reviewer.md
---
name: code-reviewer
description: Review code for quality and best practices
skills: pr-review, security-check
---
```

The full content of each listed Skill is injected into the subagent's context at startup, not just made available for invocation. If the `skills` field is omitted, no Skills are loaded for that subagent.

**Note**: Built-in agents (Explore, Plan, general-purpose) do not have access to your Skills. Only custom subagents you define in `.claude/agents/` with an explicit `skills` field can use Skills.

### Run a Skill in a Subagent Context

Use `context: fork` and `agent` to run a Skill in a forked subagent with its own separate context:

```yaml
---
name: code-analysis
description: Analyze code quality and generate detailed reports
context: fork
agent: Explore
---
```

## Complete Examples

### Example 1: Create Your First Skill (Step-by-Step)

This example creates a personal Skill that teaches Claude to explain code using visual diagrams and analogies.

**Step 1: Check available Skills**

```
What Skills are available?
```

**Step 2: Create the Skill directory**

```bash
mkdir -p ~/.claude/skills/explaining-code
```

**Step 3: Write SKILL.md**

Create `~/.claude/skills/explaining-code/SKILL.md`:

```yaml
---
name: explaining-code
description: Explains code with visual diagrams and analogies. Use when explaining how code works, teaching about a codebase, or when the user asks "how does this work?"
---

When explaining code, always include:

1. **Start with an analogy**: Compare the code to something from everyday life
2. **Draw a diagram**: Use ASCII art to show the flow, structure, or relationships
3. **Walk through the code**: Explain step-by-step what happens
4. **Highlight a gotcha**: What's a common mistake or misconception?

Keep explanations conversational. For complex concepts, use multiple analogies.
```

**Step 4: Verify the Skill**

```
What Skills are available?
```

You should see `explaining-code` in the list.

**Step 5: Test the Skill**

```
How does this code work?
```

Claude should include an analogy and ASCII diagram in its explanation.

### Example 2: Commit Message Generator (Simple Single-File)

```
commit-helper/
└── SKILL.md
```

```yaml
---
name: generating-commit-messages
description: Generates clear commit messages from git diffs. Use when writing commit messages or reviewing staged changes.
---

# Generating Commit Messages

## Instructions

1. Run `git diff --staged` to see changes
2. Suggest a commit message with:
   - Summary under 50 characters
   - Detailed description
   - Affected components

## Best practices

- Use present tense ("Add feature" not "Added feature")
- Explain what and why, not how
- Reference issue numbers when applicable

## Examples

**Good commit message:**
```
feat(auth): add OAuth2 support for Google login

- Implement OAuth2 flow with PKCE
- Add token refresh handling
- Store tokens in secure cookie

Closes #123
```

**Bad commit message:**
```
fixed stuff
```
```

### Example 3: Code Review Skill with Tool Restrictions

```yaml
---
name: reviewing-code
description: Reviews code for quality, security, and best practices. Use when the user asks for code review, feedback on code, or wants to improve code quality.
allowed-tools: Read, Grep, Glob
---

# Code Review

## When to Use
- User asks for code review
- User wants feedback on implementation
- Before merging pull requests

## Review Checklist
1. **Security**: Check for injection, XSS, auth issues
2. **Performance**: Look for N+1 queries, memory leaks
3. **Readability**: Clear naming, appropriate comments
4. **Testing**: Verify test coverage for changes

## Reference Files
- **Security checklist**: See [SECURITY.md](SECURITY.md)
- **Performance patterns**: See [PERFORMANCE.md](PERFORMANCE.md)
```

### Example 4: Multi-File PDF Processing Skill

```
pdf-processing/
├── SKILL.md              # Overview and quick start
├── FORMS.md              # Form field mappings and filling instructions
├── REFERENCE.md          # API details for pypdf and pdfplumber
└── scripts/
    ├── fill_form.py      # Utility to populate form fields
    └── validate.py       # Checks PDFs for required fields
```

**`SKILL.md`**:

```yaml
---
name: pdf-processing
description: Extract text, fill forms, merge PDFs. Use when working with PDF files, forms, or document extraction. Requires pypdf and pdfplumber packages.
allowed-tools: Read, Bash
---

# PDF Processing

## Quick start

Extract text:
```python
import pdfplumber
with pdfplumber.open("doc.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

For form filling, see [FORMS.md](FORMS.md).
For detailed API reference, see [REFERENCE.md](REFERENCE.md).

## Utility scripts

To validate a PDF:
```bash
python scripts/validate.py document.pdf
```

To fill a form:
```bash
python scripts/fill_form.py template.pdf data.json output.pdf
```

## Requirements

Packages must be installed in your environment:
```bash
pip install pypdf pdfplumber
```
```

**Note**: If your Skill requires external packages, list them in the description. Packages must be installed in your environment before Claude can use them.

### Example 5: Database Migration Skill

```yaml
---
name: managing-migrations
description: Creates and runs database migrations safely. Use when user mentions migrations, schema changes, or database updates.
---

# Database Migrations

## Critical Rules
- **Always backup before migrating**
- **Test migrations on staging first**
- **Never modify existing migrations**

## Commands

```bash
# Create new migration
python scripts/create_migration.py "add_user_email"

# Run pending migrations
python scripts/migrate.py --verify --backup

# Rollback last migration
python scripts/rollback.py --steps 1
```

## Validation

Run exactly this script before deploying:
```bash
python scripts/validate_migrations.py
```

Do not modify the command or add flags.

## Common Patterns

### Adding a column
```sql
ALTER TABLE users ADD COLUMN email VARCHAR(255);
```

### Adding an index
```sql
CREATE INDEX idx_users_email ON users(email);
```

### Renaming with zero downtime
1. Add new column
2. Backfill data
3. Update application to write to both
4. Migrate reads to new column
5. Drop old column
```

### Example 6: Skill with Hooks

```yaml
---
name: secure-file-operations
description: Perform file operations with security validation. Use when working with sensitive files or directories.
hooks:
  PreToolUse:
    - matcher: "Write"
      hooks:
        - type: command
          command: "./scripts/validate-path.sh $TOOL_INPUT"
  PostToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/audit-log.sh $TOOL_INPUT $TOOL_OUTPUT"
---

# Secure File Operations

All file operations are validated before execution and logged for audit purposes.

## Allowed paths
- `./src/` - Source code
- `./tests/` - Test files
- `./docs/` - Documentation

## Blocked paths
- `./secrets/`
- `./.env*`
- `./credentials/`
```

## Security Considerations

**Only use Skills from trusted sources**: those you created yourself or obtained from Anthropic.

Skills provide Claude with new capabilities through instructions and code. A malicious Skill can direct Claude to invoke tools or execute code in ways that don't match the Skill's stated purpose.

If you must use a Skill from an untrusted source:
- Audit all files: SKILL.md, scripts, images, resources
- Look for unusual patterns: unexpected network calls, file access, operations that don't match the stated purpose
- Be especially careful with Skills that fetch data from external URLs

## Pre-Built Agent Skills

Anthropic provides pre-built Skills for common document tasks:

| Skill | ID | Description |
|-------|-----|-------------|
| PowerPoint | `pptx` | Create presentations, edit slides |
| Excel | `xlsx` | Create spreadsheets, analyze data, generate charts |
| Word | `docx` | Create documents, edit content |
| PDF | `pdf` | Generate formatted PDF documents |

These are available on Claude.ai and via the Claude API (not in Claude Code directly).

## Platform Availability

Skills work across Claude's ecosystem:

| Platform | Custom Skills | Pre-Built Skills | Notes |
|----------|---------------|------------------|-------|
| Claude Code | Filesystem-based | — | Full network access |
| Claude.ai | Upload as zip | Built-in | Network access varies |
| Claude API | Upload via API | Via container param | No network access |
| Claude Agent SDK | Filesystem-based | — | Configure via `settingSources` |

## Distribution Options

You can share Skills in several ways:

- **Project Skills**: Commit `.claude/skills/` to version control. Anyone who clones the repository gets the Skills.
- **Plugins**: To share Skills across multiple repositories, create a `skills/` directory in your plugin with Skill folders containing `SKILL.md` files.
- **Managed**: Administrators can deploy Skills organization-wide through managed settings.

## Developing Skills Iteratively

The most effective approach involves Claude itself:

1. **Complete a task without a Skill**: Work through a problem, noting what information you repeatedly provide
2. **Ask Claude to create a Skill**: "Create a Skill that captures this pattern we just used"
3. **Review for conciseness**: Remove unnecessary explanations (Claude is already smart)
4. **Test with real requests**: Observe whether Claude finds the right information
5. **Iterate based on observation**: Refine based on how Claude actually uses the Skill

## Troubleshooting

### View and Test Skills

To see which Skills Claude has access to:
```
What Skills are available?
```

To test a specific Skill, ask Claude to do a task that matches the Skill's description.

### Skill Not Triggering

The description field is how Claude decides whether to use your Skill. Vague descriptions like "Helps with documents" don't give Claude enough information.

A good description answers two questions:
1. **What does this Skill do?** List the specific capabilities.
2. **When should Claude use it?** Include trigger terms users would mention.

```yaml
# Good
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.

# Bad
description: Helps with documents
```

### Skill Doesn't Load

**Check the file path.** Skills must be in the correct directory with the exact filename `SKILL.md` (case-sensitive):

| Type | Path |
|------|------|
| Personal | `~/.claude/skills/my-skill/SKILL.md` |
| Project | `.claude/skills/my-skill/SKILL.md` |
| Plugin | `skills/my-skill/SKILL.md` inside the plugin directory |

**Check the YAML syntax.** Invalid YAML in the frontmatter prevents the Skill from loading:
- Frontmatter must start with `---` on line 1 (no blank lines before it)
- Must end with `---` before the Markdown content
- Use spaces for indentation (not tabs)

**Run debug mode:**
```bash
claude --debug
```

### Skill Has Errors

**Check dependencies are installed.** If your Skill uses external packages, they must be installed in your environment before Claude can use them.

**Check script permissions.** Scripts need execute permissions:
```bash
chmod +x scripts/*.py
```

**Check file paths.** Use forward slashes (Unix style) in all paths:
- Good: `scripts/helper.py`
- Bad: `scripts\helper.py`

### Multiple Skills Conflict

If Claude uses the wrong Skill or seems confused between similar Skills, the descriptions are probably too similar. Make each description distinct by using specific trigger terms.

Instead of two Skills with "data analysis" in both descriptions, differentiate them: one for "sales data in Excel files and CRM exports" and another for "log files and system metrics".

### Plugin Skills Not Appearing

Clear the plugin cache and reinstall:

```bash
rm -rf ~/.claude/plugins/cache
```

Then restart Claude Code and reinstall the plugin.

If Skills still don't appear, verify the plugin's directory structure:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── my-skill/
        └── SKILL.md
```

## Anti-Patterns to Avoid

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Deeply nested references | Claude may only partially read files | Keep references one level deep |
| Windows-style paths | Breaks on Unix systems | Always use forward slashes |
| Too many options | Confusing for Claude | Provide a default with escape hatch |
| Time-sensitive info | Becomes outdated | Use "old patterns" section |
| Verbose explanations | Wastes context tokens | Assume Claude knows common concepts |
| Magic numbers | Claude can't justify values | Document why values were chosen |
| Vague descriptions | Skill won't trigger | Include specific keywords and triggers |
| Missing "when to use" | Claude doesn't know when to apply | Always include trigger conditions |

## Token Budget Guidelines

| Content | Target |
|---------|--------|
| SKILL.md body | Under 500 lines |
| Description | Under 1024 chars |
| Metadata (name + description) | ~100 tokens per skill |

**Key principle**: Be concise. Claude is already smart—only add context Claude doesn't already have.

## Token Optimization Summary

| Skill Component | Startup Cost | When Loaded |
|-----------------|--------------|-------------|
| name + description | ~100 tokens | Always |
| SKILL.md content | 0 | When skill is triggered |
| Reference files | 0 | When skill reads them |
| Scripts | 0 | Output only, when executed |
| Templates | 0 | When read |

**Bottom line**: Use skills liberally. The startup cost is minimal, and detailed content only loads when needed. Skills let Claude access effectively unlimited context without loading everything simultaneously.
