# Output Styles

Adapt Claude Code for uses beyond software engineering. Output styles modify Claude Code's system prompt to change how it behaves and responds.

## What Output Styles Do

Output styles allow you to use Claude Code as any type of agent while keeping its core capabilities:
- Running local scripts
- Reading/writing files
- Tracking TODOs
- Tool execution

By default, Claude Code is optimized for software engineering. Output styles let you change this focus.

---

## Built-in Output Styles

### Default

The standard system prompt designed for efficient software engineering tasks.

### Explanatory

Provides educational "Insights" between helping you complete tasks. Helps you understand:
- Implementation choices
- Codebase patterns
- Why certain approaches are preferred

### Learning

Collaborative, learn-by-doing mode:
- Shares "Insights" while coding
- Asks you to contribute small, strategic pieces of code
- Adds `TODO(human)` markers in your code for you to implement

---

## How Output Styles Work

Output styles directly modify Claude Code's system prompt:

1. **All output styles** exclude instructions for efficient output (responding concisely)
2. **Custom output styles** exclude coding instructions unless `keep-coding-instructions: true`
3. **All output styles** have their custom instructions added to the end of the system prompt
4. **All output styles** trigger reminders to adhere to style instructions during conversation

---

## Changing Your Output Style

### Via Command

```bash
# Open menu to select style
/output-style

# Switch directly to a style
/output-style explanatory
/output-style learning
/output-style default
```

### Via Settings

Changes are saved to `.claude/settings.local.json` (local project level). You can also directly edit the `outputStyle` field in settings at any level:

```json
{
  "outputStyle": "explanatory"
}
```

---

## Creating Custom Output Styles

Custom output styles are Markdown files with YAML frontmatter and prompt content.

### File Locations

| Location | Scope |
|----------|-------|
| `~/.claude/output-styles/` | User-level (all projects) |
| `.claude/output-styles/` | Project-level |

### File Format

```markdown
---
name: My Custom Style
description: A brief description displayed in the /output-style menu
keep-coding-instructions: false
---

# Custom Style Instructions

You are an interactive CLI tool that helps users with [specific purpose].

## Specific Behaviors

[Define how the assistant should behave in this style...]

## Response Format

[Define output formatting, structure, etc...]
```

### Frontmatter Reference

| Field | Purpose | Default |
|-------|---------|---------|
| `name` | Display name for the style | File name |
| `description` | Description shown in `/output-style` menu | None |
| `keep-coding-instructions` | Keep software engineering parts of default prompt | `false` |

### Example: Research Assistant

```markdown
---
name: Research Assistant
description: Focused on research and information gathering
keep-coding-instructions: false
---

# Research Assistant

You are a research assistant that helps users gather, analyze, and synthesize information.

## Core Behaviors

1. **Ask clarifying questions** before diving into research
2. **Cite sources** whenever making claims
3. **Distinguish facts from opinions** clearly
4. **Summarize findings** with key takeaways

## Response Format

- Start with a brief summary
- Use bullet points for key findings
- Include source references where applicable
- End with suggested follow-up questions
```

### Example: Code Mentor

```markdown
---
name: Code Mentor
description: Educational focus with explanations
keep-coding-instructions: true
---

# Code Mentor Mode

You are a patient code mentor focused on teaching.

## Teaching Approach

1. **Explain concepts before showing code**
2. **Break down complex solutions** into steps
3. **Highlight common pitfalls** and how to avoid them
4. **Encourage questions** and exploration

## When Writing Code

- Add educational comments explaining the "why"
- Show alternative approaches when relevant
- Point out best practices as you go
```

---

## Comparisons

### Output Styles vs CLAUDE.md

| Aspect | Output Styles | CLAUDE.md |
|--------|---------------|-----------|
| **Effect** | Modifies/replaces system prompt | Adds as user message after system prompt |
| **Scope** | Changes Claude's core behavior | Adds context and project-specific instructions |
| **Coding instructions** | Can remove them | Never affects default behavior |
| **Use case** | Change how Claude operates | Add project context |

### Output Styles vs --append-system-prompt

| Aspect | Output Styles | --append-system-prompt |
|--------|---------------|------------------------|
| **Effect** | Can modify or replace default prompt | Only appends to default prompt |
| **Persistence** | Saved in settings | Per-session only |
| **Configuration** | Markdown files with frontmatter | Command-line argument |
| **Coding instructions** | Can remove them | Always kept |

### Output Styles vs Agents

| Aspect | Output Styles | Agents |
|--------|---------------|--------|
| **Scope** | Main conversation loop | Specific tasks |
| **What changes** | Only system prompt | Model, tools, permissions, context |
| **Invocation** | Global mode change | Invoked for specific work |
| **Use case** | Change Claude's persona | Delegate specialized work |

### Output Styles vs Custom Slash Commands

Think of them as:
- **Output styles**: "Stored system prompts"
- **Custom slash commands**: "Stored prompts"

| Aspect | Output Styles | Slash Commands |
|--------|---------------|----------------|
| **Scope** | Session-wide behavior | Single invocation |
| **Persistence** | Stays active | One-time execution |
| **Purpose** | Change how Claude behaves | Run a specific action |

---

## Token Impact

Output styles are applied at the system prompt level:

| Component | Token Impact |
|-----------|--------------|
| Built-in style switch | Minimal (modifies existing prompt) |
| Custom style content | Added to system prompt (varies by length) |

Keep custom output styles concise for best performance.

---

## See Also

- [CLAUDE.md Best Practices](./07-claude-md-best-practices.md) - Project context and memory
- [Subagents](./09-subagents.md) - Specialized agents for specific tasks
- [Slash Commands](./10-slash-commands.md) - Interactive commands
- [Settings Reference](./05-settings-reference.md) - Configuration options
