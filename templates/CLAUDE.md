# Project Name

Brief description of what this project does.

## Stack

- Language: [e.g., Python 3.12, TypeScript 5.x]
- Framework: [e.g., FastAPI, React, None]
- Database: [e.g., PostgreSQL, SQLite, None]
- Key dependencies: [e.g., pytest, Tailwind CSS]

## Commands

```bash
# Python Development
uv run python main.py           # Run script
uv run pytest                   # Run tests
uv run ruff check .             # Lint
uv run ruff format .            # Format

# Node.js Development
pnpm dev                        # Development server
pnpm test                       # Run tests
pnpm build                      # Build for production

# Setup Commands
python_setup 3.13 dev           # Setup Python project
node_setup                      # Setup Node project
```

## Project Structure

```
[Brief overview of key directories - delete or modify as needed]
```

## Conventions

- **Python:** Use `uv` for all operations (never direct `python` or `pip`)
- **Node.js:** Use `pnpm` for packages, `nvm` manages versions via `.nvmrc`
- **Environment:** direnv auto-activates `.venv` on directory entry
- **Formatting:** ruff (Python), prettier (JS/TS), auto-applied via hooks
- [Add project-specific conventions here]

## Important Context

[Any critical information Claude should know about this project]

---

<!--
TEMPLATE INSTRUCTIONS (delete this section when customizing):

This is the ROOT CLAUDE.md - it tells Claude about your PROJECT.
Keep it lean (~50-150 tokens ideal) - every word costs context.

There's also .claude/CLAUDE.md which tells Claude HOW TO WORK.
Together they give Claude both project context and workflow guidance.

For detailed guidance, see docs/07-claude-md-best-practices.md
-->
