# claude-code-starter-kit

Batteries-included `.claude/` templates for bootstrapping new projects with Claude Code. Smart hooks, lazy-loaded skills, and lean configs.

## The Problem

Every new project starts with the same friction:
- Manually recreating Claude Code hooks
- Forgetting which permissions to enable
- Rewriting CLAUDE.md from scratch
- Losing the skills and patterns that made previous projects smooth
- Not remembering which libraries need documentation references

## The Solution

This is your personal "create-react-app" for Claude Code configurations. One master `.claude/` folder contains everything. Copy it, consult the guide, delete what you don't need.

## Quick Start

```bash
# 1. Copy the master .claude folder to your new project
cp -r /path/to/ClaudeCode_Skills_Maker/templates/.claude ~/my-new-project/

# 2. Open TEMPLATE-GUIDE.md, find your project type column
#    See what to keep (✓) and delete (✗)

# 3. Pick your CLAUDE.md template and rename it
cd ~/my-new-project/.claude
mv CLAUDE-react.md CLAUDE.md

# 4. Delete the other CLAUDE templates
rm CLAUDE-python-cli.md CLAUDE-fastapi.md CLAUDE-fullstack.md CLAUDE-devops.md

# 5. Delete skills you don't need (check TEMPLATE-GUIDE.md)
rm -rf skills/testing-pytest skills/cli-typer skills/api-fastapi

# 6. Done! Start Claude Code
cd ~/my-new-project && claude
```

## Project Structure

```
ClaudeCode_Skills_Maker/
├── README.md                    # You're reading this (for humans)
├── CLAUDE.md                    # Project context (for Claude)
├── docs/                        # Research and reference documentation
│   ├── 01-overview.md
│   ├── 02-hooks.md
│   ├── 03-skills.md
│   ├── 04-token-management.md
│   ├── 05-settings-reference.md
│   ├── 06-plugins.md
│   ├── 07-claude-md-best-practices.md
│   └── 08-existing-global-config.md
└── templates/
    ├── TEMPLATE-GUIDE.md        # Master reference - what to keep/delete
    └── .claude/                 # The master folder (copy this)
        ├── CLAUDE.md            # Minimal fallback
        ├── CLAUDE-python-cli.md # Python CLI template
        ├── CLAUDE-react.md      # React template
        ├── CLAUDE-fastapi.md    # FastAPI template
        ├── CLAUDE-fullstack.md  # Full-stack template
        ├── CLAUDE-devops.md     # DevOps template
        ├── settings.json        # Universal (rarely needs editing)
        ├── hooks/               # Smart hooks (auto-detect language)
        │   ├── agent-notify.sh      # Audio alert when agent completes (macOS)
        │   ├── post-edit-format.sh
        │   ├── pre-commit.sh
        │   └── session-start.sh
        ├── skills/              # Project-specific (delete unused)
        └── rules/
```

## Key Design Decisions

### Single Master Folder
Everything lives in one `.claude/` folder. No duplication across multiple templates. Update once, applies everywhere.

### Smart Universal Hooks
Hooks auto-detect your project type. `post-edit-format.sh` knows to use `ruff` for Python and `prettier` for JavaScript. You don't need to edit `settings.json` for different stacks.

### Multiple CLAUDE.md Templates
Pre-written context files for each project type. Pick one, rename it to `CLAUDE.md`, delete the others. Minimal editing required.

### Skills for Documentation
Library documentation (React Query, shadcn/ui, Typer, etc.) lives in skills. They're lazy-loaded - zero token cost until Claude actually uses them. Perfect for newer libraries Claude might not know well.

### TEMPLATE-GUIDE.md
A comprehensive table showing every component, what it does, and which project types need it. Designed for quick scanning when you can't remember what something is for.

## Token Efficiency

This system is designed to minimize context usage:

| Component | Loaded at Startup? | Token Cost |
|-----------|-------------------|------------|
| CLAUDE.md | Yes | ~50-150 tokens |
| settings.json | Parsed only | Zero |
| hooks/ | Executed only | Zero |
| skills/ | Metadata only | ~20 tokens each |
| Skill content | On-demand | Zero until used |
| rules/ | Yes, fully | Keep minimal |

## What's in the Docs

The `docs/` folder contains comprehensive research on Claude Code configuration:

| Document | Contents |
|----------|----------|
| `01-overview.md` | Project structure, token impact summary |
| `02-hooks.md` | All hook events, patterns, examples |
| `03-skills.md` | Creating skills, lazy loading behavior |
| `04-token-management.md` | What consumes context, optimization |
| `05-settings-reference.md` | Complete settings.json reference |
| `06-plugins.md` | Plugin system (why not for bootstrapping) |
| `07-claude-md-best-practices.md` | Writing efficient CLAUDE.md |
| `08-existing-global-config.md` | Current global ~/.claude setup |

---

## About README.md vs CLAUDE.md

This repo contains two markdown files at the root:

| File | Audience | Purpose |
|------|----------|---------|
| `README.md` | **Humans** | You're reading it. Documentation for people. |
| `CLAUDE.md` | **Claude** | Loaded into Claude's context. Instructions for the AI. |

**README.md** is verbose and friendly - written for humans browsing the repo.

**CLAUDE.md** is minimal and directive - every word costs tokens, optimized for AI consumption.

When creating your own projects, follow the same pattern:
- README.md → Documentation for humans
- CLAUDE.md → Instructions for Claude

---

## Future Plans

- [ ] CLI tool (`claude-init react`) for one-command setup
- [ ] Interactive wizard for custom configurations
- [ ] More skill templates for common libraries
- [ ] Community template sharing

---

## License

Personal toolkit. Use as you see fit.
