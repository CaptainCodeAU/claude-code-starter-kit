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
- `reference.md` (optional) - Detailed documentation
- `examples/` (optional) - Code examples

### Rules

Rules in `rules/` are **always loaded** into context. Use sparingly - they cost tokens every session.

| File | Purpose |
|------|---------|
| `function-safety.md` | CRITICAL: Requires searching for all callers before modifying any shared function. Prevents silent breakage. |
| `uv-commands.md` | Enforces `uv run python` and `uv pip` instead of direct `python`/`pip` commands. Ensures correct venv.
