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

Hooks are **smart** - they auto-detect your project type.

| Hook | What It Does | Delete If... |
|------|--------------|--------------|
| *(Add hooks as they are configured)* | | |

---

## Step 3: Skills Reference

**Legend:** ✓ = Keep | ○ = Optional | ✗ = Delete

### Skills

| Skill | Description | Project Types |
|-------|-------------|---------------|
| *(Add skills as they are created)* | | |

### Documentation Skills

| Skill | Description | When to Keep |
|-------|-------------|--------------|
| *(Add doc skills as they are created)* | | |

---

## Step 4: Rules

| Rule | Description | Delete If... |
|------|-------------|--------------|
| *(Add rules as they are created)* | | |

---

## Quick Delete Commands

*(Add per-project-type delete commands as templates are built)*

---

## Component Descriptions

### Hooks

| File | Purpose |
|------|---------|
| `post-edit-format.sh` | Auto-formats files after edits. Detects file type. |
| `pre-commit.sh` | Runs before git commits. Detects project type. |
| `session-start.sh` | Runs when Claude Code starts. Startup checks. |

### Skills Structure

Each skill folder contains:
- `SKILL.md` - Metadata (name, description) + instructions
- `reference.md` (optional) - Detailed documentation
- `examples/` (optional) - Code examples

### Rules

Rules in `rules/` are **always loaded** into context. Use sparingly - they cost tokens every session.
