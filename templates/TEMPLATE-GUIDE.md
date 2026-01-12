# Template Guide

Quick reference for setting up your `.claude/` folder. Find your project type, see what to keep and delete.

**New here?** Start with [GETTING-STARTED.md](./GETTING-STARTED.md) for a hands-on tour of all features.

---

## Quick Start

```bash
# 1. Copy the .claude folder to your new project
cp -r /path/to/claude-code-starter-kit/templates/.claude ~/my-new-project/

# 2. Copy the getting started guide (optional but recommended)
cp /path/to/claude-code-starter-kit/templates/GETTING-STARTED.md ~/my-new-project/.claude/

# 3. Navigate into it
cd ~/my-new-project/.claude

# 4. Follow the sections below to customize for your project type

# 5. Start Claude Code
cd ~/my-new-project && claude
```

---

## Step 1: Choose Your CLAUDE.md

| Project Type | Use This File | Then Delete |
|--------------|---------------|-------------|
| *(Add project types as templates are created)* | | |

---

## Step 2: Hooks

| Hook | What It Does | Delete If... |
|------|--------------|--------------|
| `agent-notify.sh` | Audio + visual notification when agent finishes (macOS) | You don't want audio alerts |
| `post-edit-format.sh` | Auto-formats files after edits (stub) | N/A - customize for your stack |
| `pre-commit.sh` | Runs before git commits (stub) | N/A - customize for your stack |
| `session-start.sh` | Runs when Claude Code starts (stub) | N/A - customize for your stack |

### Available Hook Events

| Event | When It Fires | Common Uses |
|-------|--------------|-------------|
| `PreToolUse` | Before Claude uses a tool | Validate inputs, block dangerous commands |
| `PostToolUse` | After a tool completes | Format output, add context, log actions |
| `Stop` | When main agent finishes | Notifications, cleanup, summaries |
| `SubagentStop` | When a subagent finishes | Notifications for background tasks |
| `SessionStart` | When Claude Code starts | Environment checks, welcome messages |
| `UserPromptSubmit` | When user submits a prompt | Validate/modify user input |
| `Notification` | When Claude sends a notification | Custom notification handling |
| `PreCompact` | Before context compaction | Save important context |
| `PermissionRequest` | When permission is requested | Auto-approve/deny patterns |

---

## Step 3: Skills Reference

**Legend:** ✓ = Keep | ○ = Optional | ✗ = Delete

### Skills

| Skill | Name | Description | Project Types |
|-------|------|-------------|---------------|
| `frontend-design/` | `frontend-design` | Create distinctive, production-grade frontend interfaces. Anti-AI-slop aesthetics. Includes 7 reference docs. | React, Vue, frontend projects |
| `shell-functions/` | `developing-shell-functions` | Best practices for .zsh_*, .bashrc shell function development | Shell scripts, dotfiles |
| `testing-practices/` | `testing-python` | Python test isolation, venv verification, uv usage | Python projects |

### Documentation Skills

| Skill | Description | When to Keep |
|-------|-------------|--------------|
| *(Add doc skills as they are created)* | | |

---

## Step 4: Rules

| Rule | Description | Delete If... |
|------|-------------|--------------|
| `function-safety.md` | Search for callers before modifying shared functions | Never - always keep |
| `uv-commands.md` | Enforce `uv` instead of direct python/pip commands | Not using uv for Python |

---

## Step 5: Agents (Subagents)

Custom subagents run in isolated contexts with their own tool permissions.

| Agent | Purpose | When to Keep |
|-------|---------|--------------|
| `code-reviewer/` | Code review with specific focus areas | Code review workflows |
| *(Add your custom agents)* | | |

### Agent Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier (lowercase, hyphens) |
| `description` | Yes | When Claude should delegate to this agent |
| `tools` | No | Allowed tools (e.g., `["Read", "Glob", "Grep"]`) |
| `disallowedTools` | No | Blocked tools |
| `model` | No | Override model (e.g., `haiku` for fast tasks) |
| `permissionMode` | No | `default`, `bypassPermissions`, `alwaysAsk` |
| `skills` | No | Array of skill names to load |
| `hooks` | No | Agent-scoped hooks |

---

## Step 6: Output Styles

Custom output styles modify Claude's communication approach.

| Style | Purpose | When to Keep |
|-------|---------|--------------|
| *(Add custom styles as created)* | | |

### Output Style Frontmatter

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Display name for the style |
| `description` | Yes | What this style does |
| `keep-coding-instructions` | No | Set `true` to preserve coding behavior (default: `false`) |

**Location:** `.claude/output-styles/` or `~/.claude/output-styles/`

**Trigger:** `/output-style` command or `outputStyle` in settings.json

---

## Step 7: Commands

Commands are slash-invoked workflows (e.g., `/polish`, `/audit`).

### Frontend Design Commands

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/adapt` | Adapt designs to different contexts (mobile, tablet, dark mode) | When design needs context-specific variations |
| `/animate` | Add purposeful animations and micro-interactions | After core design is complete, add motion |
| `/audit` | Comprehensive quality audit (a11y, performance, theming) | Before shipping, to find issues |
| `/bolder` | Make timid designs more impactful | When design lacks visual impact |
| `/clarify` | Improve unclear UX copy, error messages, labels | When copy is confusing or generic |
| `/colorize` | Add strategic color to monochromatic designs | When design feels too gray/neutral |
| `/critique` | Evaluate design from UX perspective | For honest feedback on design effectiveness |
| `/delight` | Add moments of joy, personality, surprises | When design is functional but joyless |
| `/extract` | Extract reusable components to design system | When patterns should be systematized |
| `/harden` | Improve resilience (i18n, errors, edge cases) | Before production, handle real-world data |
| `/normalize` | Align with design system standards | When feature diverges from design system |
| `/onboard` | Design/improve onboarding and empty states | When first-time experience needs work |
| `/optimize` | Improve performance (loading, rendering, bundle) | When interface feels slow |
| `/polish` | Final quality pass before shipping | Last step before release |
| `/quieter` | Tone down overly bold/aggressive designs | When design is too intense |
| `/simplify` | Strip designs to their essence | When design is cluttered or complex |
| `/teach-impeccable` | One-time setup to gather design context | Start of new frontend project |

**Note:** Many commands reference the `frontend-design` skill. Keep them together.

---

## Quick Delete Commands

*(Add per-project-type delete commands as templates are built)*

---

## Component Descriptions

### Hooks

| File | Purpose |
|------|---------|
| `agent-notify.sh` | Audio notification (macOS `say`) + Notification Center alert when agent completes. Triggers on Stop/SubagentStop events. |
| `post-edit-format.sh` | Auto-formats files after edits. Detects file type. (Stub) |
| `pre-commit.sh` | Runs before git commits. Detects project type. (Stub) |
| `session-start.sh` | Runs when Claude Code starts. Startup checks. (Stub) |

### Skills Structure

Each skill folder contains:
- `SKILL.md` - Required: YAML frontmatter (name, description) + markdown instructions
- `reference/` (optional) - Detailed reference documentation (loaded as needed)
- `examples/` (optional) - Code examples (loaded as needed)
- `scripts/` (optional) - Executable scripts (run via bash, output only enters context)

**YAML frontmatter fields:**

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Max 64 chars, lowercase letters/numbers/hyphens only. Should match directory name. |
| `description` | Yes | Max 1024 chars. Include WHAT the skill does AND WHEN to use it. |
| `allowed-tools` | No | Limits which tools Claude can use when skill is active. |
| `model` | No | Override model when skill is active (e.g., `claude-sonnet-4-20250514`). |
| `context` | No | Set to `fork` to run in isolated sub-agent context. |
| `agent` | No | Agent type when `context: fork` (e.g., `Explore`, `Plan`). |
| `hooks` | No | Define `PreToolUse`, `PostToolUse`, `Stop` hooks scoped to this skill. |
| `user-invocable` | No | Set `false` to hide from slash menu (Claude can still use it). |

### Frontend Design Skill

The `frontend-design/` skill includes 7 reference documents:
- `typography.md` - Font selection, scales, web font loading
- `color-and-contrast.md` - OKLCH palettes, accessibility, dark mode
- `spatial-design.md` - Grids, spacing systems, visual hierarchy
- `motion-design.md` - Timing, easing, reduced motion
- `interaction-design.md` - States, focus, forms, modals
- `responsive-design.md` - Breakpoints, container queries, safe areas
- `ux-writing.md` - Labels, errors, empty states, voice

### Agents

Each agent folder contains:
- `AGENT.md` - Required: YAML frontmatter (name, description, tools) + markdown instructions
- Agent runs in isolated context with specified tool permissions

**Token cost:** ~50 tokens per agent (metadata only at startup)

### Output Styles

Each output style file contains:
- `style-name.md` - YAML frontmatter (name, description) + markdown instructions

**Token cost:** Zero at startup (loaded when selected via `/output-style`)

### Rules

Rules in `rules/` are **always loaded** into context. Use sparingly - they cost tokens every session.

| File | Purpose |
|------|---------|
| `function-safety.md` | CRITICAL: Requires searching for all callers before modifying any shared function. Prevents silent breakage. |
| `uv-commands.md` | Enforces `uv run python` and `uv pip` instead of direct `python`/`pip` commands. Ensures correct venv.
