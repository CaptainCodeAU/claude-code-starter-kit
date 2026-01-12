# Decision Journal

Tracks decisions, rejections, and experiments for this project. This file serves as external memory - preserving the "why" behind choices and the journey of how we got here.

**Why this exists:** The user has memory challenges. This log ensures nothing is lost - not just what was chosen, but what was rejected and why.

**Structure:** Reference sections at top, append-only Decisions Log at bottom.

---

## How to Use This File

### When making decisions:
1. Log the decision with context (append to bottom)
2. List options that were considered
3. Note which options were rejected and WHY
4. If experimenting, mark current approach and alternatives

### When pivoting:
1. Update the original entry with outcome
2. Document: what we tried → why it failed → what we're trying now

---

## User Interaction Patterns

Examples of how this user works, to help future Claude sessions understand.

### Pattern: Challenge and Correct

The user will challenge Claude when something seems off. Example from 2026-01-12:

> **Claude:** "Should the Decision Journal live in CLAUDE.md itself or a separate file? I'd lean toward B..."
>
> **User:** "Do you know the purpose of CLAUDE.md file? If not, perhaps the first thing for you would be to look it up."

Claude had suggested option A as viable despite knowing CLAUDE.md should stay lean. User's challenge was a reminder to apply existing knowledge consistently.

**Lesson:** Don't propose options that contradict established principles. If you know something, apply it.

---

### Pattern: Preserve Intent, Not Just State

When updating documentation, user expects planned-but-not-built features to be preserved:

> **User:** "knowing me, its just a matter of time that I will forget what those files were... and if they even existed"

**Lesson:** When something is planned but doesn't exist yet, don't delete it. Move it to Roadmap, add a note, or create a placeholder - but never lose the intent.

---

### Pattern: Quote User's Own Words

When documenting rejections, include the user's actual reasoning when available. This:
1. Preserves their exact thinking
2. Helps future sessions understand nuance
3. Prevents mischaracterization of their intent

Example: See "Referencing DOCS-UPDATE Files" decision in the log below - includes `**User's words:**` field.

---

### Pattern: Experiment with Rollback

User sometimes shortlists multiple approaches and tries one first:

> **User:** "there are also times when I narrow down a few approaches... and I decide to try one of the shortlisted ones first (with an option to rollback and try another one)"

When this happens, document:
- Current approach being tried
- Shortlisted alternatives (in priority order)
- Clear rollback point
- Update with outcome when known

---

## Rejected Ideas Archive

Ideas that were considered but rejected. Kept here so they're not re-proposed.

### Project-Type Specific settings.json Files

**Proposed:** Have separate settings.json for each project type (settings-python.json, settings-react.json, etc.)

**Rejected because:**
- Hooks are smart and auto-detect project type
- One universal settings.json is simpler
- Users can customize after copying

**Date:** Pre-2026 (original design decision)

---

### Plugins for Bootstrapping

**Proposed:** Use Claude Code plugin system for distributing templates

**Rejected because:**
- Plugins are for extending Claude Code functionality
- Templates are meant to be copied and customized
- Plugin caching would prevent local modifications

**Date:** Pre-2026 (documented in docs/06-plugins.md)

---

## Active Experiments

*None currently active.*

<!-- Template for experiments:
### [Date]: [Experiment Name]

**Trying:** [Current approach]

**Shortlisted alternatives:**
1. [Alternative 1]
2. [Alternative 2]

**Rollback point:** [How to revert if this doesn't work]

**Status:** In Progress / Succeeded / Failed

**Outcome:** [What happened, learnings]
-->

---

## Template: New Decision Entry

```markdown
### [Date]: [Decision Title]

**Context:** [What problem or question prompted this]

**Options considered:**
1. [Option 1]
2. [Option 2]
3. [Option 3]

**Decision:** [Which option was chosen]

**Rejected:**
- [Option X]: [Why it was rejected]
- [Option Y]: [Why it was rejected]

**Rationale:** [Deeper explanation if needed]

**Outcome:** [Fill in later - what happened]
```

---

## Decisions Log

*Append new entries below. Most recent at bottom.*

---

### 2026-01-12: Documentation Update Tracking

**Context:** Need to track progress across documentation update sessions (spanning multiple chat windows).

**Options considered:**
1. Track in CLAUDE.md itself
2. Track in a separate progress file
3. Don't track, rely on memory

**Decision:** Option 2 - Created `DOCS-UPDATE-PROGRESS.md`

**Rejected:**
- Option 1: CLAUDE.md should stay lean (token cost)
- Option 3: User has memory challenges, would lose track

**Outcome:** Working well. Progress file tracks sessions, topics, and sub-tasks.

---

### 2026-01-12: Decision Journal Location

**Context:** Where to store decision tracking and experiment logs.

**Options considered:**
1. In CLAUDE.md itself (simpler, all in one place)
2. In a separate DECISIONS.md file (cleaner separation)

**Decision:** Option 2 - Separate file

**Rejected:**
- Option 1: CLAUDE.md is loaded at startup, every token costs. A decision journal would bloat it.

**Rationale:** Decision journals grow over time. Keeping it separate means zero token cost at startup, can be referenced when needed.

---

### 2026-01-12: Referencing DOCS-UPDATE Files in CLAUDE.md

**Context:** Claude suggested adding references to DOCS-UPDATE-GUIDE.md and DOCS-UPDATE-PROGRESS.md in CLAUDE.md.

**Options considered:**
1. Add references to both files in CLAUDE.md
2. Keep them separate, don't reference from CLAUDE.md

**Decision:** Option 2 - Don't add references yet

**Rejected:**
- Option 1: User said the docs-update workflow is "ad-hoc" for now. Later wants it "more streamlined and part of the project's own functionality itself... like a meta-feature." Will revisit when ready to formalize.

**User's words:** "later I would like it more streamlined and part of the project's own functionality itself... like a meta-feature of sorts perhaps... we will revisit it at that point... not now."

---

### 2026-01-12: CLAUDE.md Structure Section Update

**Context:** CLAUDE.md listed template files (CLAUDE-python-cli.md, CLAUDE-react.md, etc.) that don't exist yet.

**First attempt:** Claude tried to simply remove the non-existent files from the list.

**User feedback:** Rejected. User pointed out their memory challenges - removing planned features means losing track of what was intended.

**Final decision:**
1. Update Structure to show what actually exists
2. Add note: "Project-type-specific CLAUDE.md templates are planned but not yet created"
3. Create Roadmap section to preserve the planned templates

**Lesson:** Never silently remove planned features. Always preserve intent, even if not yet built.

---

### 2026-01-12: Decision Journal File Structure

**Context:** Decisions Log section was in the middle of the file.

**User feedback:** "It probably makes more sense for Decisions Log to be the last section... That way, you are always APPENDING to it."

**Decision:** Reorganized file - reference material at top, append-only log at bottom.

**Rationale:** Logs grow over time. Having them at the end means:
- New entries are simply appended
- No need to navigate past growing log to find reference sections
- Clear separation: static reference vs. dynamic log

---

### 2026-01-12: Template Alignment with UV/NVM Cross-Platform Setup

**Context:** User shared their complete shell configuration (.zshrc, .zsh_python_functions, .zsh_node_functions, .zsh_docker_functions, etc.) that they use across all machines (macOS, WSL, Linux). The templates needed to reflect this actual setup.

**Changes made:**

**Rules (3 files):**
- Created `nvm-commands.md` - Enforces NVM/pnpm for Node.js
- Created `docker-commands.md` - Common Docker patterns and shell functions
- Updated `uv-commands.md` - Added advanced UV patterns (venv creation, sync, add)

**Hooks (3 files):**
- Updated `session-start.sh` - Environment detection (venv, node_modules, git status)
- Updated `post-edit-format.sh` - Auto-format (ruff, prettier, shfmt)
- Updated `pre-commit.sh` - Language-aware checks (ruff, tsc, eslint)

**Documentation (3 files):**
- Updated `templates/CLAUDE.md` - UV/NVM command examples
- Updated `templates/.claude/CLAUDE.md` - Dev environment section with Python/Node tables
- Updated `TEMPLATE-GUIDE.md` - Added new rules/skills, updated hook descriptions

**Skills (2 files):**
- Created `testing-javascript/SKILL.md` - Jest + Vitest testing practices
- Updated `shell-functions/SKILL.md` - UV/NVM integration patterns

**Key decisions:**
- Hooks execute auto-fix (not advisory) - ruff/prettier modify files directly
- JavaScript testing covers both Jest and Vitest equally
- Docker content is rules only (not a full skill) - keeps it lean

**User preferences incorporated:**
- UV-first Python (never direct python/pip)
- NVM + pnpm for Node.js (never npm)
- direnv for automatic venv activation
- Cross-platform consistency (same patterns on macOS, WSL, Linux)

---

### 2026-01-12: Python CLI Scaffolding Purpose

**Context:** User asked what `pyproject.toml`, `src/`, `tests/`, `main.py`, `uv.lock` are for in a template repository.

**Purpose:** These are scaffolding for a planned CLI tool (`claude-init`) mentioned in the Roadmap. The CLI would enable one-command project setup:

```bash
claude-init react ~/my-project  # Bootstrap a React project with templates
```

**Current state:** Placeholder code only ("Hello World"). Not yet implemented.

**Decision:** Keep these files for future CLI development.

**Files involved:**
- `pyproject.toml` - Python project config, dependencies, tool settings
- `uv.lock` - Dependency lock file (auto-generated by UV)
- `main.py` - Simple entry point script
- `src/claude_code_starter_kit/` - Package source (cli.py, core.py)
- `tests/` - Test suite skeleton

---

### 2026-01-13: Docs Maintenance Meta-Feature Implementation

**Context:** User wanted to convert the ad-hoc `DOCS-UPDATE-GUIDE.md` and `DOCS-UPDATE-PROGRESS.md` workflow into integrated tooling for maintaining the starter kit's documentation.

**Problem solved:**
1. Docs need periodic updates when official Claude docs change
2. Updates must be incremental (preserve structure, don't rewrite)
3. Two use cases: official doc sync AND best practices synthesis
4. Previous workflow required manual mode/model switching

**Solution chosen:** Option 3 — Skill + Commands hybrid

**Why this approach:**
- Skill contains shared domain knowledge (quality standards, structure awareness)
- Commands provide clear entry points for different use cases
- Reference files keep skill lean while providing detailed guidance
- Commands enforce Opus model via frontmatter
- Commands use `context: fork` + `agent: Plan` for planning-focused execution

**Components created:**

```
.claude/
├── skills/docs-maintenance/
│   ├── SKILL.md                    # Core instructions
│   └── reference/
│       ├── quality-standards.md    # Detailed quality criteria
│       └── docs-structure.md       # Current docs/ organization
│
└── commands/
    ├── docs-sync.md                # UC1: Official doc updates
    ├── docs-refine.md              # UC2: Best practices synthesis
    └── docs-audit.md               # UC3: Check for outdated content
```

**Changelog integration:** Commands track sub-tasks during execution and append detailed entries to `docs/CHANGELOG.md`.

**Migration:** After confirming this works, user will manually delete:
- `DOCS-UPDATE-GUIDE.md` (content moved to skill)
- `DOCS-UPDATE-PROGRESS.md` (content moved to `docs/CHANGELOG.md`)
