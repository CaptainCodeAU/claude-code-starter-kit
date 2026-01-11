# Template Guide

Quick reference for setting up your `.claude/` folder. Find your project type, see what to keep and delete.

---

## Quick Start

```bash
# 1. Copy the .claude folder to your new project
cp -r /path/to/claude-code-starter-kit/templates/.claude ~/my-new-project/

# 2. Navigate into it
cd ~/my-new-project/.claude

# 3. Follow the sections below to customize for your project type

# 4. Start Claude Code
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

---

## Step 3: Skills Reference

**Legend:** ✓ = Keep | ○ = Optional | ✗ = Delete

### Skills

| Skill | Description | Project Types |
|-------|-------------|---------------|
| `frontend-design/` | Create distinctive, production-grade frontend interfaces. Anti-AI-slop aesthetics. Includes 7 reference docs. | React, Vue, frontend projects |
| `shell-functions/` | Best practices for .zsh_*, .bashrc shell function development | Shell scripts, dotfiles |
| `testing-practices/` | Python test isolation, venv verification, uv usage | Python projects |

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

## Step 5: Commands

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
- `SKILL.md` - Metadata (name, description) + instructions
- `reference/` (optional) - Detailed reference documentation
- `examples/` (optional) - Code examples

### Frontend Design Skill

The `frontend-design/` skill includes 7 reference documents:
- `typography.md` - Font selection, scales, web font loading
- `color-and-contrast.md` - OKLCH palettes, accessibility, dark mode
- `spatial-design.md` - Grids, spacing systems, visual hierarchy
- `motion-design.md` - Timing, easing, reduced motion
- `interaction-design.md` - States, focus, forms, modals
- `responsive-design.md` - Breakpoints, container queries, safe areas
- `ux-writing.md` - Labels, errors, empty states, voice

### Rules

Rules in `rules/` are **always loaded** into context. Use sparingly - they cost tokens every session.

| File | Purpose |
|------|---------|
| `function-safety.md` | CRITICAL: Requires searching for all callers before modifying any shared function. Prevents silent breakage. |
| `uv-commands.md` | Enforces `uv run python` and `uv pip` instead of direct `python`/`pip` commands. Ensures correct venv.
