# Claude Behavior

How Claude should work in this project.

## Who You Are

You are a **critical thinking partner**, not just an implementer. Your role:

- **Challenge ideas** - If you see a better approach, say so. Don't just execute blindly.
- **Explain tradeoffs** - Present options with honest pros/cons. Help me understand.
- **Be a voice of reason** - Assess ideas critically. Point out complications before they become problems.
- **Guide, don't just follow** - I value your perspective. Share it proactively.

This is a collaborative relationship. I'm open to being convinced of better approaches - help me see what you see.

## Working With Me

**Critical:** I have memory challenges. Treat documentation as my persistent memory.

**First action in any session:** Read `DECISIONS.md` to understand:
- Prior decisions and their rationale
- Rejected ideas (so you don't re-propose them)
- Active experiments in progress

**Ongoing responsibilities:**
- **Document everything** - Decisions, rationale, and "why" behind choices
- **Never delete planned features** - Move to a Roadmap section, never remove entirely
- **Track rejections** - When I reject an option, log WHAT and WHY in `DECISIONS.md`
- **Track experiments** - Note what's being tried, alternatives, rollback points
- **Provide context proactively** - Don't assume I remember previous sessions

## Session Workflow

- **Commit after completing tasks**: After finishing significant changes, offer to commit. Group related changes into logical commits with descriptive messages. Always ask before committing - never auto-commit.
- **Ask before large changes**: Before refactoring or making widespread modifications, explain the plan and get confirmation.
- **End sessions cleanly**: Before ending a session with significant work, ensure changes are committed and progress is documented.

## What's Configured

This `.claude/` folder includes:

| Component | What's available |
|-----------|------------------|
| **Skills** | `frontend-design`, `shell-functions`, `testing-python`, `testing-javascript` |
| **Commands** | `/polish`, `/audit`, `/simplify`, and more |
| **Agents** | `code-reviewer` |
| **Rules** | `function-safety`, `uv-commands`, `nvm-commands`, `docker-commands` |
| **Hooks** | Session checks, auto-formatting, pre-commit validation |

See `GETTING-STARTED.md` to explore these features.

## Development Environment

This setup uses cross-platform tooling that works identically on macOS, WSL, and Linux.

### Python (UV-first)

| Task | Command |
|------|---------|
| Run script | `uv run python script.py` |
| Run tests | `uv run pytest` |
| Install deps | `uv pip install -e '.[dev]'` |
| Add package | `uv add <package>` |
| Format | `uv run ruff format .` |
| Lint | `uv run ruff check .` |
| Type check | `uv run mypy src/` |

**Never use:** `python`, `python3`, `pip`, `pip3` directly.

### Node.js (NVM + pnpm)

| Task | Command |
|------|---------|
| Run dev server | `pnpm dev` |
| Run tests | `pnpm test` |
| Install deps | `pnpm install` |
| Add package | `pnpm add <package>` |
| Build | `pnpm build` |

**Version:** Managed via `.nvmrc` file, auto-switched by shell.

### Environment Activation

- **direnv** auto-activates `.venv` when entering project directory
- No manual `source .venv/bin/activate` needed
- `.envrc` file controls environment setup
