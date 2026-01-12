# Inventory Command

Run a comprehensive stock-take of all Claude Code configuration components. Covers both:
- `templates/` folder (what gets copied to new projects)
- `.claude/` folder (project-level meta-features for maintaining this repo)

Produce a visually rich, color-coded report.

## Output Format Guidelines

**Use colors and emoji throughout for visual clarity:**
- 🟢 / Green text → Implemented, Complete, Healthy
- 🟡 / Yellow text → Stub, Planned, Needs attention
- 🔴 / Red text → Missing, Not created, Error
- Use **bold** for important counts and labels
- Use section dividers (`---`) between major sections

---

## Output Structure

Generate the report in this exact order:

### 1. 🏥 Health Check

Start with an attention-grabbing health summary. Check for:
- Stub hooks that need implementation
- Planned templates not yet created (CLAUDE-python-cli.md, etc.)
- Missing folders (output-styles/)
- Skills without SKILL.md
- Unconfigured settings
- Project-level meta-features status (docs-maintenance skill, docs commands)

**Format as a colored checklist with sub-bullets for any ⚠️ or 🔴 items:**

```
🏥 **HEALTH CHECK**

✅ All skills have SKILL.md files
✅ Settings configured with 2 hook events
✅ All hooks implemented (agent-notify, post-edit-format, pre-commit, session-start)
✅ 4 rules configured (function-safety, uv-commands, nvm-commands, docker-commands)
✅ Meta-features active (docs-maintenance skill, 4 project commands)

⚠️ 5 planned CLAUDE.md templates not created
   • CLAUDE-python-cli.md — Python CLI tools (Typer, Rich, pytest)
   • CLAUDE-react.md — React frontends (Vite, Tailwind, shadcn/ui)
   • CLAUDE-fastapi.md — FastAPI backends (SQLAlchemy, Alembic)
   • CLAUDE-fullstack.md — React + FastAPI combined
   • CLAUDE-devops.md — Ansible, Docker, infrastructure

⚠️ output-styles/ folder doesn't exist
   • No custom output styles defined yet
```

**This section is the single source of truth for what needs attention.** The Quick Dashboard Details column should only describe what's complete (green items).

---

### 2. 📊 Quick Dashboard

Provide a compact summary with counts, status indicators, and helpful context:

```
📊 **QUICK DASHBOARD**

| Component | Count | Status | Details |
|-----------|-------|--------|---------|
| Hooks | 4 | 🟢 All implemented | agent-notify, post-edit-format, pre-commit, session-start |
| Rules | 4 | 🟢 Complete | function-safety, uv-commands, nvm-commands, docker-commands |
| Skills | 4 | 🟢 All have SKILL.md | frontend-design, shell-functions, testing-python, testing-javascript |
| Commands | 17 | 🟢 Complete | Design workflow: polish, audit, animate, etc. |
| Agents | 1 | 🟢 Complete | Code reviewer with read-only tools |
| Output Styles | 0 | 🔴 None | (see Health Check) |
| CLAUDE.md Templates | 2 | 🟡 5 planned | ✅ Root context, behavior config, decision journal |
```

**Details column guidance:**
- Focus on what's **complete** (green items)
- For rows with 🟡/🔴 status, describe the working parts; pending items are listed in Health Check
- Use "(see Health Check)" for rows that are entirely incomplete

---

### 3. 📁 Detailed Sections

#### 3.1 Hooks
List all files in `templates/.claude/hooks/`:

| Filename | Status | Description |
|----------|--------|-------------|
| `file.sh` | 🟢 Implemented / 🟡 Stub | What this hook does when triggered |

Example descriptions:
- `agent-notify.sh` → "macOS notification when agent completes"
- `post-edit-format.sh` → "Auto-format files after edits"
- `pre-commit.sh` → "Run checks before commits"
- `session-start.sh` → "Setup tasks when session begins"

#### 3.2 Rules
List all `.md` files in `templates/.claude/rules/`:

| Filename | Description |
|----------|-------------|
| `rule.md` | Full description of what this rule enforces and why |

Example descriptions:
- `function-safety.md` → "Requires searching for all callers before modifying shared functions"
- `uv-commands.md` → "Enforces using uv instead of direct python/pip commands"
- `nvm-commands.md` → "Enforces nvm for Node version management and pnpm instead of npm"
- `docker-commands.md` → "Common Docker patterns for dev environments (postgres, qdrant, etc.)"

#### 3.3 Skills
List folders in `templates/.claude/skills/`:

| Skill | SKILL.md | Reference | Description |
|-------|----------|-----------|-------------|
| `name/` | ✅/❌ | Count | What this skill provides |

**Important:** Check for `reference/` subfolder (not `reference-docs/`). Count files in `skill-name/reference/` if it exists.

Example output:
```
| Skill | SKILL.md | Reference | Description |
|-------|----------|-----------|-------------|
| `frontend-design/` | ✅ | 7 files | Production-grade UI with anti-AI-slop guidelines |
| `shell-functions/` | ✅ | 0 | Best practices for .zsh/.bash, UV/NVM patterns |
| `testing-python/` | ✅ | 0 | Python test isolation and proper uv usage |
| `testing-javascript/` | ✅ | 0 | JavaScript/TypeScript testing with Jest and Vitest |
```

#### 3.4 Commands (Grouped by Purpose)

**Design Intensity:**
| Command | Description |
|---------|-------------|
| `/bolder` | Amplify safe/boring designs |
| `/quieter` | Tone down overly bold designs |
| `/simplify` | Strip to essence |
| `/colorize` | Add strategic color |

**Quality & Polish:**
| Command | Description |
|---------|-------------|
| `/audit` | Comprehensive quality audit |
| `/critique` | UX design critique |
| `/polish` | Final quality pass |
| `/optimize` | Performance optimization |

**UX & Content:**
| Command | Description |
|---------|-------------|
| `/clarify` | Improve unclear UX copy |
| `/onboard` | Design onboarding flows |
| `/delight` | Add moments of joy |
| `/harden` | Improve resilience (i18n, errors) |

**Specialized:**
| Command | Description |
|---------|-------------|
| `/animate` | Add animations/micro-interactions |
| `/adapt` | Adapt for different contexts |
| `/extract` | Extract to design system |
| `/normalize` | Align with design system |

**Setup:**
| Command | Description |
|---------|-------------|
| `/teach-impeccable` | One-time design context setup |

#### 3.5 Agents
List `.md` files in `templates/.claude/agents/`:

| Agent | Model | Tools | Description |
|-------|-------|-------|-------------|
| `name.md` | model | tool list | What this agent does |

Example:
- `code-reviewer.md` → "Thorough code reviews with read-only tools"

#### 3.6 Output Styles
List `.md` files in `templates/.claude/output-styles/`. If folder missing or empty: "🔴 None (folder doesn't exist)"

#### 3.7 CLAUDE.md Templates
List `CLAUDE*.md` and `DECISIONS.md` in `templates/` and `templates/.claude/`:

| Location | File | Type | Description |
|----------|------|------|-------------|
| path | filename | Base/Behavior/etc. | What this template provides |

Example:
- `templates/CLAUDE.md` → "Project context placeholder for customization"
- `templates/DECISIONS.md` → "Decision journal with examples for memory support"
- `templates/.claude/CLAUDE.md` → "Claude behavior config: session workflow, commit patterns"

#### 3.8 Project-Level Meta-Features

Report on `.claude/` folder (this repo's own tooling, NOT in templates):

**Skills:**
| Skill | Purpose | User-Invocable |
|-------|---------|----------------|
| `docs-maintenance/` | Quality standards, structure awareness for doc updates | No (internal) |

**Commands:**
| Command | Description | Mode |
|---------|-------------|------|
| `/docs-sync` | Update docs from official Claude documentation | Opus + Plan agent |
| `/docs-refine` | Synthesize best practices from articles | Opus + Plan agent |
| `/docs-audit` | Audit docs for outdated content | Opus + Plan agent |
| `/inventory` | This command — stock-take report | Default |

**Features:**
- `--dry-run` flag for `/docs-sync` — preview changes without editing
- `--draft` flag for `/docs-sync` — create alternate file for comparison

#### 3.9 Settings
Report on `templates/.claude/settings.json` in tabular format:

**Hook Events:**
| Event | Command | Description |
|-------|---------|-------------|
| `Stop` | `agent-notify.sh` | Triggered when main agent completes |
| `SubagentStop` | `agent-notify.sh` | Triggered when subagent completes |

If no hooks configured: "None configured"

**Permissions:**
| Type | Entries | Description |
|------|---------|-------------|
| `allow` | (list or "empty") | Pre-approved tool patterns |
| `deny` | (list or "empty") | Blocked tool patterns |

**Other Settings (if present):**
| Setting | Value | Description |
|---------|-------|-------------|
| `model` | (if set) | Default model override |
| `apiProvider` | (if set) | API provider configuration |
| `trustTools` | (if set) | Auto-approved tools |

If a setting isn't present, omit it from the table.

---

### 4. 🔗 Dependencies

Show relationships between components:

```
🔗 **DEPENDENCIES**

frontend-design skill ← used by 16 commands
  └─ /adapt, /animate, /audit, /bolder, /clarify, /colorize,
     /critique, /delight, /extract, /harden, /normalize,
     /onboard, /optimize, /polish, /quieter, /simplify

code-reviewer agent ← standalone (no skill dependencies)
```

---

### 5. 🎯 Suggested Next Actions

Based on gaps identified in Health Check, provide a prioritized action list:

```
🎯 **SUGGESTED NEXT ACTIONS**

Priority:
1. 🟡 Implement stub hooks (see Health Check for list)
2. 🟡 Create output-styles/ folder with at least one example style

When Ready:
3. 🔴 Create planned CLAUDE.md templates (see Health Check for list)

Or if everything is complete:
✅ Templates are comprehensive! Consider:
   • Adding more skills for other domains
   • Creating project-type-specific commands
   • Contributing back to the starter kit
```

**Note:** Don't repeat the detailed lists here—refer to Health Check where items are already listed with descriptions.

---

### 6. 📅 Last Modified (Optional)

If useful, show when key files were last modified using relative dates:

```
📅 **RECENT CHANGES**

| File | Modified |
|------|----------|
| frontend-design/SKILL.md | 2 days ago |
| settings.json | today |
```

Use `ls -la` or `stat` to get modification times. Skip this section if not informative.

---

## Cross-Reference Check

Compare against `README.md` and `TEMPLATE-GUIDE.md` to identify:
- Items mentioned but not created
- Items created but not documented
- Inconsistencies between docs and actual files

Report any discrepancies in the Health Check section.
