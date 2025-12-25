# CLAUDE.md Best Practices

CLAUDE.md is fully loaded into context at startup. Every word costs tokens. This guide covers how to write effective, efficient CLAUDE.md files.

## Token Cost Reality

- **1 word ≈ 1.3 tokens**
- 100 words ≈ 130 tokens
- Each token costs money per message
- CLAUDE.md is loaded for EVERY interaction

**Target: 50-200 tokens for most projects**

## File Locations

| File | Purpose | Loaded When |
|------|---------|-------------|
| `./CLAUDE.md` | Project root context | Always |
| `./.claude/CLAUDE.md` | Alternative location | Always |
| `./.claude/rules/*.md` | Modular rules | Always |
| `./CLAUDE.local.md` | Local additions | Always |
| `./subdir/CLAUDE.md` | Directory-specific | When reading files there |

## Structure Template

```markdown
# Project Name

Brief one-line description.

## Stack
[Comma-separated list of key technologies]

## Key Commands
- Dev: `command`
- Test: `command`
- Build: `command`

## Conventions
- [Critical rule 1]
- [Critical rule 2]
- [Critical rule 3]

## Notes
[Any critical context Claude must always know]
```

## Examples by Project Type

### Python CLI (50 tokens)

```markdown
# MyCLI

Python CLI tool using Typer and Rich.

## Stack
Python 3.12, Typer, Rich, pytest

## Commands
- Run: `python -m mycli`
- Test: `pytest -v`
- Lint: `ruff check --fix .`

## Conventions
- Use typer for CLI, rich for output
- All commands need --help
- Tests in tests/ mirror src/
```

### React Frontend (60 tokens)

```markdown
# MyApp

React SPA with TypeScript.

## Stack
React 18, TypeScript, Vite, Tailwind, shadcn/ui

## Commands
- Dev: `npm run dev`
- Test: `npm test`
- Build: `npm run build`

## Conventions
- Components in src/components/
- Use shadcn/ui components
- Tailwind for styling, no CSS files
```

### FastAPI Backend (70 tokens)

```markdown
# MyAPI

REST API with FastAPI.

## Stack
Python 3.12, FastAPI, SQLAlchemy, PostgreSQL, pytest

## Commands
- Dev: `uvicorn app.main:app --reload`
- Test: `pytest -v`
- Migrate: `alembic upgrade head`

## Conventions
- Endpoints in app/routers/
- Models in app/models/
- All endpoints need tests
- Use Pydantic for validation
```

### Full-Stack (100 tokens)

```markdown
# MyProject

Full-stack app with React frontend and FastAPI backend.

## Stack
Frontend: React, TypeScript, Vite, Tailwind
Backend: Python, FastAPI, SQLAlchemy, PostgreSQL

## Structure
- `/frontend` - React app
- `/backend` - FastAPI app
- `/docker` - Docker configs

## Commands
- Dev: `docker-compose up`
- Test frontend: `cd frontend && npm test`
- Test backend: `cd backend && pytest`

## Conventions
- API types shared via OpenAPI
- All endpoints need frontend integration tests
```

## What NOT to Include

### 1. Detailed How-To Guides
❌ Bad (200 tokens):
```markdown
## How to Add a New Endpoint
1. Create a new file in app/routers/
2. Define the router with APIRouter()
3. Add your endpoint functions...
[continues for 20 more lines]
```

✅ Good (10 tokens):
```markdown
## Adding Endpoints
See .claude/skills/api/
```

### 2. Full Documentation
❌ Bad:
```markdown
## API Documentation
### GET /users
Returns list of users...
### POST /users
Creates a new user...
[entire API reference]
```

✅ Good:
```markdown
API docs: See OpenAPI at /docs
```

### 3. Code Examples
❌ Bad:
```markdown
## Example Component
\`\`\`tsx
import React from 'react';
// ... 50 lines of code
\`\`\`
```

✅ Good:
```markdown
Component patterns: See src/components/examples/
```

### 4. Every Convention
❌ Bad:
```markdown
- Use const not let
- Use arrow functions
- Use template literals
- Use destructuring
- Use spread operator
[50 more rules]
```

✅ Good:
```markdown
Style: ESLint + Prettier enforced via hooks
```

## Using Rules Directory

For more complex projects, use `.claude/rules/`:

```
.claude/
├── CLAUDE.md           # Minimal, links to rules
└── rules/
    ├── security.md     # Security constraints
    ├── testing.md      # Testing requirements
    └── api.md          # API conventions
```

CLAUDE.md:
```markdown
# MyProject

See .claude/rules/ for detailed conventions.
```

**Warning**: All rules files are loaded at startup too. Keep them focused.

## Leveraging Nested CLAUDE.md

Directory-specific CLAUDE.md files are only loaded when Claude reads files there:

```
project/
├── CLAUDE.md              # Always loaded (minimal)
├── src/
│   └── api/
│       └── CLAUDE.md      # Loaded when working in src/api/
└── tests/
    └── CLAUDE.md          # Loaded when working in tests/
```

This is more token-efficient than putting everything in root CLAUDE.md.

## Local Additions

Use `CLAUDE.local.md` for personal notes (not committed):

```markdown
# Local Notes

- My API key is in .env.local
- Use `make quick-test` for fast iteration
- TODO: Refactor auth module
```

## Import Syntax

Reference other files (resolved recursively, max depth 5):

```markdown
# Project

@.claude/rules/security.md
@.claude/rules/testing.md
```

**Note**: Imported content is loaded immediately, so use sparingly.

## Measuring Efficiency

```bash
# Count words (multiply by 1.3 for tokens)
wc -w .claude/CLAUDE.md

# Check all loaded files
wc -w CLAUDE.md .claude/CLAUDE.md .claude/rules/*.md 2>/dev/null

# In Claude Code
/context
```

## Summary Checklist

- [ ] Under 200 tokens for typical projects
- [ ] Stack listed concisely
- [ ] Key commands included
- [ ] Only critical conventions (3-5 max)
- [ ] Detailed guides moved to skills
- [ ] Code examples in separate files
- [ ] Using nested CLAUDE.md for large projects
- [ ] Rules directory for modular organization
