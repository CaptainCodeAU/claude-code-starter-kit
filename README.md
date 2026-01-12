# claude-code-starter-kit

Batteries-included `.claude/` templates for bootstrapping new projects with Claude Code. Smart hooks, lazy-loaded skills, modular commands, and lean configs designed for token efficiency.

---

## Table of Contents

- [Overview](#overview)
- [The Problem](#the-problem)
- [The Solution](#the-solution)
- [Key Features](#key-features)
- [Design Principles](#design-principles)
- [Project Structure](#project-structure)
- [Token Efficiency](#token-efficiency)
- [Quick Start](#quick-start)
- [Template Usage Workflow](#template-usage-workflow)
- [Content Addition Workflow](#content-addition-workflow)
- [Components Reference](#components-reference)
  - [CLAUDE.md Files](#claudemd-files)
  - [Settings Configuration](#settings-configuration)
  - [Hooks](#hooks)
  - [Rules](#rules)
  - [Skills](#skills)
  - [Commands](#commands)
  - [Agents](#agents)
- [Documentation Reference](#documentation-reference)
- [Architecture Deep Dive](#architecture-deep-dive)
- [User Context](#user-context)
- [Roadmap](#roadmap)
- [License](#license)

---

## Overview

This is a **template repository** that provides ready-made Claude Code configurations for new projects. Instead of starting from scratch every time you create a project, you copy the `templates/` folder, consult `TEMPLATE-GUIDE.md` for your project type, and delete what you don't need.

Think of it as "create-react-app" for Claude Code configurations.

**What's included:**
- Pre-configured `settings.json` with smart hooks
- Universal hooks that auto-detect project types (Python, JavaScript, Go, etc.)
- Modular slash commands for design, quality, and development workflows
- Lazy-loaded skills for domain expertise
- Rules for enforcing development standards
- Custom subagents for specialized tasks
- Comprehensive documentation (23 reference docs)

---

## The Problem

Every new project starts with the same friction:

1. **Manual recreation** - Rewriting hooks, skills, and CLAUDE.md from scratch
2. **Forgotten patterns** - Not remembering which permissions to enable or which hooks worked well
3. **Lost context** - Skills and documentation references from previous projects don't carry over
4. **Token waste** - Loading unnecessary content into Claude's context
5. **Inconsistency** - Different projects have different quality levels of Claude configuration

---

## The Solution

**One master folder contains everything.** Copy it, consult the guide, delete what you don't need.

The system is designed around these core ideas:

1. **Single source of truth** - All templates live in `templates/.claude/`
2. **Smart auto-detection** - Hooks detect your project type and act accordingly
3. **Lazy loading** - Heavy content (skills, commands) loads only when needed
4. **Modular components** - Keep what you need, delete what you don't
5. **Token efficiency** - Everything optimized for minimal context usage

---

## Key Features

### Smart Universal Hooks

Hooks auto-detect your project type. `post-edit-format.sh` knows to use `ruff` for Python files and `prettier` for JavaScript. You don't need separate configurations for different stacks.

```bash
# Example: post-edit-format.sh behavior
# If file is .py → runs ruff format + ruff check --fix
# If file is .js/.ts → runs prettier --write
# If file is .sh → runs shfmt
# All automatic based on file extension
```

### Lazy-Loaded Skills

Skills provide domain expertise without token cost at startup. Only ~20 tokens for metadata; full content loads when Claude actually uses the skill.

```
# Skill structure
skills/
└── frontend-design/
    ├── SKILL.md          # Loaded on-demand (~2000 tokens)
    └── reference-docs/   # Additional context if needed
```

### Modular Slash Commands

17 ready-to-use slash commands for design and development workflows:

| Category | Commands |
|----------|----------|
| Design Intensity | `/bolder`, `/quieter`, `/simplify`, `/colorize` |
| Quality & Polish | `/audit`, `/critique`, `/polish`, `/optimize` |
| UX & Content | `/clarify`, `/onboard`, `/delight`, `/harden` |
| Specialized | `/animate`, `/adapt`, `/extract`, `/normalize` |

### Comprehensive Rules

Always-on constraints that guide Claude's behavior:

- **function-safety.md** - Search for callers before modifying functions
- **uv-commands.md** - Use `uv` instead of direct `python`/`pip`
- **nvm-commands.md** - Use `nvm`/`pnpm` instead of direct `npm`
- **docker-commands.md** - Common Docker patterns and shell functions

### Custom Subagents

Specialized agents for specific tasks:

- **code-reviewer** - Thorough code reviews with read-only tools

---

## Design Principles

### 1. Single Master Folder

Everything lives in one `templates/.claude/` folder. No duplication. Update once, applies everywhere.

**Why:** Duplication leads to drift. A single source of truth ensures consistency.

### 2. Smart Auto-Detection

Hooks detect project type automatically. No manual configuration needed for basic setups.

```bash
# session-start.sh detects:
# - pyproject.toml → Python project
# - package.json → Node.js project
# - Both → Fullstack project
```

**Why:** Reduces friction. You shouldn't need to edit `settings.json` just because you're using Python instead of JavaScript.

### 3. Lazy Loading for Token Efficiency

Heavy content loads only when needed:

| Component | Startup Cost | When Loaded |
|-----------|--------------|-------------|
| CLAUDE.md | ~50-150 tokens | Always |
| settings.json | Zero | Parsed, not in context |
| hooks/ | Zero | Executed, not in context |
| skills/ | ~20 tokens each | On-demand when used |
| commands/ | Zero | When invoked |
| rules/ | Full content | Always (use sparingly) |

**Why:** Context is precious. Every token loaded at startup reduces capacity for actual work.

### 4. Modular Components

Keep what you need, delete what you don't. The `TEMPLATE-GUIDE.md` shows exactly what each project type needs.

**Why:** A React project doesn't need Python testing skills. A CLI tool doesn't need frontend design commands.

### 5. Documentation as Memory

All decisions, rejections, and experiments are tracked in `DECISIONS.md`. This serves as external memory.

**Why:** The user has memory challenges. Documentation preserves the "why" behind choices and prevents re-proposing rejected ideas.

---

## Project Structure

```
claude-code-starter-kit/
├── README.md                      # This file (comprehensive documentation)
├── CLAUDE.md                      # Project instructions for Claude
├── DECISIONS.md                   # Decision journal (tracks choices, rejections)
├── DOCS-UPDATE-GUIDE.md           # Guide for updating documentation
├── DOCS-UPDATE-PROGRESS.md        # Progress tracking for doc updates
│
├── _input/                        # Content staging folder
│   └── README.md                  # Instructions for content addition
│
├── docs/                          # Reference documentation (23 files)
│   ├── 01-overview.md             # Structure and token impact
│   ├── 02-hooks.md                # Complete hook reference
│   ├── 03-skills.md               # Skill creation and lazy loading
│   ├── 04-token-management.md     # Optimization strategies
│   ├── 05-settings-reference.md   # Complete settings.json reference
│   ├── 06-plugins.md              # Plugin system reference
│   ├── 07-claude-md-best-practices.md  # Memory files best practices
│   ├── 08-existing-global-config.md    # User's global config reference
│   ├── 09-subagents.md            # Custom subagents documentation
│   ├── 10-slash-commands.md       # Built-in/custom commands
│   ├── 11-mcp.md                  # MCP servers and authentication
│   ├── 12-cli-reference.md        # CLI commands and flags
│   ├── 13-headless-mode.md        # Programmatic CLI usage
│   ├── 14-github-actions.md       # CI/CD integration
│   ├── 15-checkpointing.md        # Automatic tracking and recovery
│   ├── 16-interactive-mode.md     # Keyboard shortcuts, vim mode
│   ├── 17-output-styles.md        # Custom output styles
│   ├── 18-model-configuration.md  # Model aliases and selection
│   ├── 19-statusline.md           # Custom statusline configuration
│   ├── 20-agent-sdk.md            # Building programmatic agents
│   ├── 21-prompt-engineering.md   # Prompting techniques
│   ├── 22-troubleshooting.md      # Common issues and solutions
│   └── 23-testing-evaluation.md   # Success criteria and evals
│
├── templates/                     # Master templates (copy these)
│   ├── CLAUDE.md                  # Project context template
│   ├── DECISIONS.md               # Decision journal template
│   ├── GETTING-STARTED.md         # Hands-on feature tour
│   ├── TEMPLATE-GUIDE.md          # What to keep/delete per project type
│   │
│   └── .claude/                   # The master folder to copy
│       ├── CLAUDE.md              # Behavior template (Claude workflow)
│       ├── settings.json          # Universal settings with smart hooks
│       │
│       ├── hooks/                 # Automation scripts (4 files)
│       │   ├── agent-notify.sh    # macOS notification when agent completes
│       │   ├── post-edit-format.sh    # Auto-format after edits
│       │   ├── pre-commit.sh      # Run checks before commits
│       │   └── session-start.sh   # Environment checks on session start
│       │
│       ├── rules/                 # Always-on constraints (4 files)
│       │   ├── docker-commands.md     # Docker patterns and functions
│       │   ├── function-safety.md     # Search callers before modifying
│       │   ├── nvm-commands.md        # NVM/pnpm enforcement
│       │   └── uv-commands.md         # UV command enforcement
│       │
│       ├── commands/              # Slash commands (17 files)
│       │   ├── adapt.md           # Adapt for different contexts
│       │   ├── animate.md         # Add animations/micro-interactions
│       │   ├── audit.md           # Comprehensive quality audit
│       │   ├── bolder.md          # Amplify safe/boring designs
│       │   ├── clarify.md         # Improve unclear UX copy
│       │   ├── colorize.md        # Add strategic color
│       │   ├── critique.md        # UX design critique
│       │   ├── delight.md         # Add moments of joy
│       │   ├── extract.md         # Extract to design system
│       │   ├── harden.md          # Improve resilience (i18n, errors)
│       │   ├── normalize.md       # Align with design system
│       │   ├── onboard.md         # Design onboarding flows
│       │   ├── optimize.md        # Performance optimization
│       │   ├── polish.md          # Final quality pass
│       │   ├── quieter.md         # Tone down overly bold designs
│       │   ├── simplify.md        # Strip to essence
│       │   └── teach-impeccable.md    # One-time design context setup
│       │
│       └── agents/                # Custom subagents (1 file)
│           └── code-reviewer.md   # Thorough code reviews
│
├── src/                           # Python source code
│   └── claude_code_starter_kit/
│       ├── __init__.py            # Package initialization
│       ├── cli.py                 # CLI implementation
│       └── core.py                # Core functionality
│
├── tests/                         # Test suite
│   ├── __init__.py
│   └── test_main.py
│
├── .claude/                       # Active Claude config for this project
│   ├── settings.local.json
│   └── commands/
│       └── inventory.md           # /inventory command for stock-take
│
├── pyproject.toml                 # Python project configuration
├── .envrc                         # Direnv configuration
├── .python-version                # Python version (3.12)
└── .gitignore
```

---

## Token Efficiency

This system is designed to minimize context usage. Understanding token costs helps you make informed decisions about what to include.

### Token Cost by Component

| Component | Loaded at Startup? | Token Cost | Notes |
|-----------|-------------------|------------|-------|
| Root CLAUDE.md | Yes | ~50-150 | Keep minimal |
| .claude/CLAUDE.md | Yes | ~100-200 | Behavior config |
| settings.json | Parsed only | Zero | Not in context |
| hooks/*.sh | Executed only | Zero | Not in context |
| skills/*.md | Metadata only | ~20 each | Content on-demand |
| commands/*.md | Never | Zero | Loaded when invoked |
| agents/*.md | Metadata only | ~50 each | Full content on invoke |
| rules/*.md | Yes, fully | Varies | Use sparingly |

### Optimization Strategies

1. **Keep CLAUDE.md lean** - 50-150 tokens ideal
2. **Use skills for documentation** - Heavy content loads on-demand
3. **Minimize rules** - Every rule loads fully at startup
4. **Reference, don't include** - Point to docs instead of embedding

### Example Token Budget

A well-optimized project might look like:

```
Root CLAUDE.md:         100 tokens
.claude/CLAUDE.md:      150 tokens
4 skills (metadata):     80 tokens
1 agent (metadata):      50 tokens
4 rules (full):         800 tokens
-----------------------------------
Total startup cost:   1,180 tokens
```

Compare to poorly optimized:

```
Bloated CLAUDE.md:    2,000 tokens
Embedded docs:        5,000 tokens
10 rules:             3,000 tokens
-----------------------------------
Total startup cost:  10,000 tokens  ❌
```

---

## Quick Start

### For New Projects

```bash
# 1. Copy the templates folder to your new project
cp -r /path/to/claude-code-starter-kit/templates/* ~/my-new-project/

# 2. Consult TEMPLATE-GUIDE.md for your project type
#    It shows what to keep (✓) and delete (✗)

# 3. Customize the root CLAUDE.md with your project info

# 4. Delete unused components
#    - Skills you don't need
#    - Commands not relevant to your stack
#    - Rules that don't apply

# 5. Start Claude Code
cd ~/my-new-project && claude
```

### Example: Python CLI Project

```bash
# Copy templates
cp -r templates/* ~/my-python-cli/

# Keep:
# - hooks/ (all - they auto-detect Python)
# - rules/uv-commands.md, function-safety.md
# - skills/testing-python/ (if exists)

# Delete:
# - rules/nvm-commands.md (no Node.js)
# - commands/ for frontend (animate, colorize, etc.)
# - skills/frontend-design/ (no frontend)

# Customize CLAUDE.md
# Add your project description, stack info, conventions
```

### Example: React Frontend Project

```bash
# Copy templates
cp -r templates/* ~/my-react-app/

# Keep:
# - hooks/ (all - they auto-detect JavaScript)
# - rules/nvm-commands.md
# - commands/ for design (all of them)
# - skills/frontend-design/

# Delete:
# - rules/uv-commands.md (no Python)
# - skills/testing-python/ (no Python)

# Customize CLAUDE.md
```

---

## Template Usage Workflow

### Step 1: Copy Templates

```bash
cp -r /path/to/claude-code-starter-kit/templates/* ~/your-project/
```

This gives you:
- `CLAUDE.md` - Project context template
- `DECISIONS.md` - Decision journal
- `GETTING-STARTED.md` - Feature tour
- `TEMPLATE-GUIDE.md` - Component reference
- `.claude/` - Full configuration folder

### Step 2: Consult TEMPLATE-GUIDE.md

Open `TEMPLATE-GUIDE.md` and find your project type column. It shows:

| Component | Python CLI | React | FastAPI | Fullstack |
|-----------|-----------|-------|---------|-----------|
| uv-commands.md | ✓ | ✗ | ✓ | ✓ |
| nvm-commands.md | ✗ | ✓ | ✗ | ✓ |
| frontend-design/ | ✗ | ✓ | ✗ | ✓ |
| testing-python/ | ✓ | ✗ | ✓ | ✓ |

### Step 3: Customize CLAUDE.md

Edit the root `CLAUDE.md` to describe your specific project:

```markdown
# My Awesome Project

Brief description of what this project does.

## Stack

- Language: Python 3.12
- Framework: Typer + Rich
- Testing: pytest

## Commands

```bash
uv run python main.py      # Run script
uv run pytest              # Run tests
uv run ruff check .        # Lint
```

## Conventions

- Use uv for all Python operations
- All CLI commands use Typer
- Rich for terminal output
```

### Step 4: Delete Unused Components

Based on `TEMPLATE-GUIDE.md`, remove what you don't need:

```bash
# Example: Pure Python project - remove Node.js related
rm .claude/rules/nvm-commands.md

# Example: Backend only - remove frontend commands
rm .claude/commands/{animate,colorize,bolder,quieter}.md

# Example: No Docker needed
rm .claude/rules/docker-commands.md
```

### Step 5: Start Using

```bash
cd ~/your-project
claude
```

Claude will automatically:
- Read your customized CLAUDE.md
- Apply rules from `.claude/rules/`
- Make skills available on-demand
- Enable slash commands

---

## Content Addition Workflow

The `_input/` folder is a staging area for adding new content to the starter kit. It enables a collaborative workflow where you and Claude work together to determine the best location for new content.

### How It Works

```
┌─────────────────────────────────────────────────────────┐
│  1. DROP                                                │
│     Place files/code/folders in _input/                 │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  2. ANALYZE                                             │
│     Start Claude Code session                           │
│     Ask Claude to read CLAUDE.md and _input/ contents   │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  3. BRAINSTORM                                          │
│     Discuss together where content fits best:           │
│     - templates/.claude/skills/ (lazy-loaded)           │
│     - templates/.claude/hooks/ (automation)             │
│     - templates/.claude/rules/ (always-on constraints)  │
│     - templates/.claude/commands/ (slash commands)      │
│     - docs/ (reference documentation)                   │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  4. IMPLEMENT                                           │
│     Claude moves content to appropriate location        │
│     Updates TEMPLATE-GUIDE.md if needed                 │
└─────────────────────────────────────────────────────────┘
                          ↓
┌─────────────────────────────────────────────────────────┐
│  5. CLEAN                                               │
│     Remove processed content from _input/               │
│     _input/ should be empty before pushing              │
└─────────────────────────────────────────────────────────┘
```

### Example: Adding a New Skill

```bash
# 1. Drop your reference documentation into _input/
cp ~/my-notes/react-query-patterns.md _input/

# 2. Start Claude Code
claude

# 3. Ask Claude to process it
> "Read the content in _input/ and help me add it as a skill"

# 4. Claude analyzes and suggests:
#    "This looks like React Query best practices. I recommend:
#     - Create templates/.claude/skills/react-query/
#     - Add SKILL.md with the core patterns
#     - Reference docs can go in a subdirectory"

# 5. After implementation, clean up
rm _input/react-query-patterns.md
```

### Example: Adding a New Hook

```bash
# 1. Drop your script into _input/
cp ~/scripts/lint-on-save.sh _input/

# 2. Start Claude and discuss
> "I want to add this as a hook. What do you think?"

# 3. Claude reviews and may suggest:
#    "This could be integrated into post-edit-format.sh
#     or added as a new hook if the trigger is different.
#     What event should trigger this?"

# 4. Implement and clean up
```

### Placement Decision Guide

When adding new content, consider:

| If content is... | Place in... | Because... |
|-----------------|-------------|------------|
| Heavy documentation | `skills/` | Lazy-loaded, no startup cost |
| Always-on rules | `rules/` | Loaded at startup (use sparingly) |
| Invokable workflows | `commands/` | Zero cost until invoked |
| Automation scripts | `hooks/` | Executed, not in context |
| Specialized AI tasks | `agents/` | Low startup cost, full on invoke |
| Reference for humans | `docs/` | Not loaded by Claude |

### Before Pushing to GitHub

Always verify:

```bash
# _input/ should be empty
ls _input/
# Should only show README.md

# TEMPLATE-GUIDE.md should be updated if you added components
git diff templates/TEMPLATE-GUIDE.md
```

---

## Components Reference

### CLAUDE.md Files

There are two CLAUDE.md files with different purposes:

#### Root CLAUDE.md (Project Context)

Location: `templates/CLAUDE.md`

**Purpose:** Tells Claude about your specific project.

**Contents:**
- Project description
- Tech stack
- Common commands
- Project structure overview
- Conventions specific to this project

**Example:**

```markdown
# My API Server

REST API for user management built with FastAPI.

## Stack
- Language: Python 3.12
- Framework: FastAPI
- Database: PostgreSQL
- ORM: SQLAlchemy

## Commands
```bash
uv run uvicorn main:app --reload    # Dev server
uv run pytest                        # Tests
uv run alembic upgrade head          # Migrations
```

## Conventions
- All endpoints in src/api/routes/
- Models in src/models/
- Use Pydantic for validation
```

#### .claude/CLAUDE.md (Behavior Config)

Location: `templates/.claude/CLAUDE.md`

**Purpose:** Tells Claude how to work and behave.

**Contents:**
- Claude's role (critical thinking partner)
- Session workflow expectations
- Tool and environment references
- Development environment setup (UV, NVM, pnpm)

**Key sections:**

```markdown
## Who You Are
You are a **critical thinking partner**, not just an implementer.
- Challenge ideas if you see a better approach
- Explain tradeoffs with honest pros/cons
- Guide, don't just follow

## Session Workflow
- Commit after completing tasks (ask before committing)
- Ask before large changes
- End sessions cleanly with changes committed

## Development Environment
- Python: UV-first (never direct python/pip)
- Node.js: NVM + pnpm (never npm)
- direnv auto-activates .venv
```

### Settings Configuration

Location: `templates/.claude/settings.json`

The settings file configures permissions, hooks, and environment variables.

**Current configuration:**

```json
{
  "permissions": {
    "allow": [],
    "ask": [],
    "deny": []
  },
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/agent-notify.sh",
            "timeout": 30
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/agent-notify.sh",
            "timeout": 30
          }
        ]
      }
    ]
  },
  "env": {}
}
```

**Hook Events Available:**

| Event | Trigger | Use Case |
|-------|---------|----------|
| `PreToolUse` | Before any tool runs | Validation, logging |
| `PostToolUse` | After any tool runs | Formatting, cleanup |
| `SessionStart` | When session begins | Environment checks |
| `UserPromptSubmit` | Before prompt processes | Input validation |
| `Notification` | When Claude sends notification | Alerts |
| `Stop` | When main agent stops | Completion notification |
| `SubagentStop` | When subagent stops | Completion notification |
| `PreCompact` | Before context compaction | Backup, logging |

### Hooks

Location: `templates/.claude/hooks/`

Hooks are shell scripts that execute in response to Claude Code events.

#### agent-notify.sh

**Trigger:** Stop, SubagentStop events

**Purpose:** Audio notification when agent completes a task (macOS)

**Features:**
- Uses macOS `say` for text-to-speech
- Sends Notification Center alert
- Extracts task summary from transcript
- Graceful fallback if not on macOS

**Example output:**
```
Agent finished: Implement user authentication
```

#### post-edit-format.sh

**Trigger:** PostToolUse (after Edit/Write tools)

**Purpose:** Auto-format files after Claude edits them

**Behavior by file type:**

| Extension | Formatter Used |
|-----------|---------------|
| `.py` | ruff format + ruff check --fix |
| `.js`, `.jsx`, `.ts`, `.tsx` | prettier --write |
| `.json` | prettier --write |
| `.md` | prettier --write |
| `.sh`, `.bash`, `.zsh` | shfmt -w -i 4 |
| `.yaml`, `.yml` | prettier --write |

#### pre-commit.sh

**Trigger:** PreToolUse (before git commit)

**Purpose:** Run checks before commits

**Checks performed:**

For Python projects (pyproject.toml present):
- ruff check
- mypy (if src/ exists)

For Node.js projects (package.json present):
- TypeScript (tsc --noEmit)
- ESLint

#### session-start.sh

**Trigger:** SessionStart

**Purpose:** Environment checks when session begins

**Checks performed:**
- Detects project type (Python/Node/Fullstack)
- Verifies .venv exists (Python)
- Checks uv.lock and .python-version (Python)
- Checks .nvmrc and node_modules (Node.js)
- Shows git branch and uncommitted changes

**Example output:**
```
✓ .venv exists
✓ uv.lock present
✓ Python version: 3.12
✓ Git branch: main (2 uncommitted changes)
```

### Rules

Location: `templates/.claude/rules/`

Rules are always-on constraints loaded at startup. Use sparingly as they consume tokens.

#### function-safety.md

**Purpose:** Prevent breaking changes to shared functions

**Key requirements:**
1. Search for all callers before modifying ANY function
2. Analyze each call site to verify expectations
3. Create impact assessment listing affected callers
4. Only then propose changes

**Red flags requiring extra scrutiny:**
- Utility/helper functions (many callers)
- Generic names (create_*, setup_*, update_*)
- Functions in shared/common files
- Functions modifying global state

#### uv-commands.md

**Purpose:** Enforce UV for all Python operations

**Command replacements:**

| Wrong | Correct |
|-------|---------|
| `python script.py` | `uv run python script.py` |
| `pip install pkg` | `uv pip install pkg` |
| `python -m pytest` | `uv run pytest` |
| `pip freeze` | `uv pip freeze` |

**Advanced patterns included:**
- Virtual environment creation with specific Python versions
- Editable install with extras
- Dependency syncing

#### nvm-commands.md

**Purpose:** Enforce NVM/pnpm for Node.js operations

**Command replacements:**

| Wrong | Correct |
|-------|---------|
| `npm install` | `pnpm install` |
| `npm run dev` | `pnpm dev` |
| `npx create-app` | `pnpm dlx create-app` |
| `npm install -g pkg` | `pnpm add -g pkg` |

#### docker-commands.md

**Purpose:** Common Docker patterns for development

**Includes:**
- Container lifecycle commands
- Cleanup commands
- Development database setup (PostgreSQL, Qdrant)
- Docker Compose patterns
- Available shell functions (pg_dev_start/stop, qdrant_start/stop, etc.)

### Skills

Location: `templates/.claude/skills/`

Skills provide domain expertise that loads on-demand. Each skill is a folder with:

```
skill-name/
├── SKILL.md           # Main content (loaded when skill is used)
└── reference-docs/    # Optional additional context
```

**Token efficiency:** Only ~20 tokens at startup for skill metadata. Full content loads when Claude invokes the skill.

**Currently planned/available skills:**

| Skill | Purpose |
|-------|---------|
| frontend-design | Production-grade UI with anti-AI-slop guidelines |
| shell-functions | Best practices for .zsh/.bash, UV/NVM patterns |
| testing-python | Python test isolation and proper uv usage |
| testing-javascript | Jest and Vitest testing practices |

**Creating a new skill:**

```markdown
<!-- skills/my-skill/SKILL.md -->
---
name: my-skill
description: Brief description for the skill index
---

# Skill Name

Full content here. This only loads when Claude uses the skill.

## Section 1
...

## Section 2
...
```

### Commands

Location: `templates/.claude/commands/`

Slash commands are invokable workflows that load when called (zero startup cost).

**Structure:**

```markdown
---
name: command-name
description: What this command does
args:
  - name: target
    description: Optional argument description
    required: false
---

Command instructions here...
```

**Available commands by category:**

#### Design Intensity Commands

| Command | Purpose |
|---------|---------|
| `/bolder` | Amplify safe/boring designs with more visual impact |
| `/quieter` | Tone down overly bold designs, reduce visual noise |
| `/simplify` | Strip designs to their essence, remove unnecessary complexity |
| `/colorize` | Add strategic color to improve hierarchy and mood |

#### Quality & Polish Commands

| Command | Purpose |
|---------|---------|
| `/audit` | Comprehensive audit across accessibility, performance, theming, responsive |
| `/critique` | UX design critique with actionable feedback |
| `/polish` | Final quality pass before shipping (alignment, spacing, consistency) |
| `/optimize` | Performance optimization (Core Web Vitals, bundle size, runtime) |

#### UX & Content Commands

| Command | Purpose |
|---------|---------|
| `/clarify` | Improve unclear UX copy and microcopy |
| `/onboard` | Design onboarding flows and empty states |
| `/delight` | Add moments of joy and personality |
| `/harden` | Improve resilience (i18n, error handling, edge cases) |

#### Specialized Commands

| Command | Purpose |
|---------|---------|
| `/animate` | Add animations and micro-interactions |
| `/adapt` | Adapt designs for different contexts (mobile, dark mode, etc.) |
| `/extract` | Extract patterns to design system components |
| `/normalize` | Align implementation with design system |
| `/teach-impeccable` | One-time design context setup |

**Example command usage:**

```
> /polish header

Claude will:
1. Load the polish.md command content
2. Reference the frontend-design skill
3. Perform systematic polish checks
4. Fix alignment, spacing, consistency issues
```

### Agents

Location: `templates/.claude/agents/`

Custom subagents for specialized tasks. Low startup cost (~50 tokens metadata), full content when invoked.

#### code-reviewer.md

**Purpose:** Thorough code reviews focusing on correctness, security, performance, and maintainability.

**Tools available:** Read, Glob, Grep, Bash (read-only operations)

**Review dimensions:**
- Correctness (edge cases, bugs, type issues)
- Security (injection, auth, secrets)
- Performance (queries, loops, memory)
- Maintainability (clarity, DRY, complexity)
- Testing (coverage, edge cases, meaningfulness)

**Output format:**
- Critical (Must Fix)
- Important (Should Fix)
- Suggestions (Nice to Have)

---

## Documentation Reference

The `docs/` folder contains 23 comprehensive reference documents organized by topic.

### Core Configuration (01-08)

| Document | Contents |
|----------|----------|
| 01-overview.md | Project structure and token impact summary |
| 02-hooks.md | Complete hook reference (events, input/output, decision control) |
| 03-skills.md | Skill creation, lazy loading behavior |
| 04-token-management.md | What consumes context, optimization strategies |
| 05-settings-reference.md | Complete settings.json reference (scopes, permissions, sandbox, MCP) |
| 06-plugins.md | Plugin system reference (why not for bootstrapping) |
| 07-claude-md-best-practices.md | Memory files (hierarchy, imports, path-specific rules) |
| 08-existing-global-config.md | User's global ~/.claude setup reference |

### Extensibility (09-11)

| Document | Contents |
|----------|----------|
| 09-subagents.md | Custom subagents, tool control, hooks |
| 10-slash-commands.md | Built-in/custom commands, frontmatter, Skill tool |
| 11-mcp.md | MCP servers, scopes, authentication |

### CLI & Automation (12-15)

| Document | Contents |
|----------|----------|
| 12-cli-reference.md | CLI commands, flags, options |
| 13-headless-mode.md | Programmatic CLI usage, structured output |
| 14-github-actions.md | CI/CD integration, workflows |
| 15-checkpointing.md | Automatic tracking, rewind, recovery |

### UI & Configuration (16-19)

| Document | Contents |
|----------|----------|
| 16-interactive-mode.md | Keyboard shortcuts, vim mode, terminal config |
| 17-output-styles.md | Custom output styles for different use cases |
| 18-model-configuration.md | Model aliases, selection, prompt caching |
| 19-statusline.md | Custom statusline configuration |

### Advanced Topics (20-23)

| Document | Contents |
|----------|----------|
| 20-agent-sdk.md | Building programmatic agents (TypeScript/Python) |
| 21-prompt-engineering.md | Prompting techniques and patterns |
| 22-troubleshooting.md | Common issues and solutions |
| 23-testing-evaluation.md | Success criteria, building evals |

---

## Architecture Deep Dive

### Why This Structure?

The project structure reflects core design decisions:

```
templates/
├── CLAUDE.md              # ← Project context (what the project IS)
├── .claude/
│   ├── CLAUDE.md          # ← Behavior config (how Claude WORKS)
│   ├── settings.json      # ← Permissions and hooks (WHAT can happen)
│   ├── hooks/             # ← Automation (WHEN things happen)
│   ├── rules/             # ← Constraints (what MUST/MUST NOT happen)
│   ├── skills/            # ← Domain knowledge (EXPERTISE on demand)
│   ├── commands/          # ← Workflows (user-INVOKED processes)
│   └── agents/            # ← Specialists (DELEGATED tasks)
```

### Information Flow

```
┌──────────────────────────────────────────────────────────┐
│                    SESSION START                          │
└──────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────┐
│  Load CLAUDE.md files (always)                           │
│  Load rules/* (always - full content)                    │
│  Load skills metadata (~20 tokens each)                  │
│  Load agents metadata (~50 tokens each)                  │
│  Execute session-start.sh hook                           │
└──────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────┐
│                    USER INTERACTION                       │
└──────────────────────────────────────────────────────────┘
                          │
          ┌───────────────┼───────────────┐
          ▼               ▼               ▼
    ┌──────────┐    ┌──────────┐    ┌──────────┐
    │ /command │    │ Use skill│    │ Use agent│
    │ invoked  │    │          │    │          │
    └──────────┘    └──────────┘    └──────────┘
          │               │               │
          ▼               ▼               ▼
    Load command    Load skill      Load agent
    content         full content    full content
          │               │               │
          └───────────────┼───────────────┘
                          ▼
┌──────────────────────────────────────────────────────────┐
│                    TOOL EXECUTION                         │
└──────────────────────────────────────────────────────────┘
                          │
          ┌───────────────┼───────────────┐
          ▼               ▼               ▼
    PreToolUse       (tool runs)     PostToolUse
    hooks                            hooks
                                     (e.g., format)
```

### Settings Scope Hierarchy

Claude Code settings can exist at multiple levels:

```
~/.claude/settings.json           # User global (lowest priority)
    ↓
.claude/settings.json             # Project (checked into git)
    ↓
.claude/settings.local.json       # Local project (not in git, highest priority)
```

Settings are merged, with more specific scopes overriding less specific ones.

---

## User Context

### Working with This User

The creator of this project has **anterograde memory challenges**. This impacts how documentation should be maintained:

1. **Documentation is external memory** - Everything must be written down
2. **Never delete planned features** - Move to Roadmap, don't remove
3. **Track rejections with reasoning** - Prevents re-proposing rejected ideas
4. **Append-only logs** - Decisions Log at bottom, always append
5. **Quote user's words** - Preserve exact reasoning when available

### DECISIONS.md Structure

The decision journal tracks:

```markdown
## User Interaction Patterns
How this user works (examples for future Claude sessions)

## Rejected Ideas Archive
Ideas considered but rejected (don't re-propose)

## Active Experiments
Current experiments with rollback points

## Decisions Log
Append-only log of decisions (most recent at bottom)
```

### Pattern Examples

**Challenge and Correct:** User will challenge Claude when something seems off. Apply existing knowledge consistently.

**Preserve Intent:** When updating docs, planned-but-not-built features must be preserved (move to Roadmap, never delete).

**Experiment with Rollback:** Sometimes multiple approaches are shortlisted. Document current approach, alternatives, and rollback points.

---

## Roadmap

### Planned CLAUDE.md Templates

| Template | Purpose | Status |
|----------|---------|--------|
| CLAUDE-python-cli.md | Python CLI tools (Typer, Rich, pytest) | Planned |
| CLAUDE-react.md | React frontends (Vite, Tailwind, shadcn/ui) | Planned |
| CLAUDE-fastapi.md | FastAPI backends (SQLAlchemy, Alembic) | Planned |
| CLAUDE-fullstack.md | React + FastAPI combined | Planned |
| CLAUDE-devops.md | Ansible, Docker, infrastructure | Planned |

### Planned Features

- [ ] `output-styles/` folder with custom output style examples
- [ ] CLI tool (`claude-init react`) for one-command setup
- [ ] Interactive wizard for custom configurations
- [ ] More skill templates for common libraries
- [ ] Community template sharing

---

## About README.md vs CLAUDE.md

This repo contains two markdown files at the root with different purposes:

| File | Audience | Purpose | Style |
|------|----------|---------|-------|
| README.md | **Humans & LLMs** | Comprehensive documentation | Verbose, friendly, extensive |
| CLAUDE.md | **Claude** | Runtime instructions | Minimal, directive, token-optimized |

**README.md** (this file) is extensive - designed to be front-loaded into an LLM for complete project understanding.

**CLAUDE.md** is minimal - every word costs tokens during Claude Code sessions. It references other resources rather than duplicating content.

When creating your own projects, follow the same pattern:
- README.md → Documentation for humans and project onboarding
- CLAUDE.md → Runtime instructions for Claude

---

## License

Personal toolkit. Use as you see fit.
