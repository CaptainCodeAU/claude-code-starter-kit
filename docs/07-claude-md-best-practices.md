# CLAUDE.md Best Practices

CLAUDE.md files (and related memory files) are loaded into context at startup. Every word costs tokens. This guide covers how to write effective, efficient memory files.

## Memory Hierarchy

Claude Code loads memory from multiple locations in order of precedence:

| Memory Type | Location | Purpose | Shared With |
|-------------|----------|---------|-------------|
| **Enterprise policy** | System-level `CLAUDE.md`* | Organization-wide instructions | All users |
| **User memory** | `~/.claude/CLAUDE.md` | Personal preferences | Just you (all projects) |
| **User rules** | `~/.claude/rules/*.md` | Personal modular rules | Just you (all projects) |
| **Project memory** | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Team-shared instructions | Team (via git) |
| **Project rules** | `./.claude/rules/*.md` | Modular project rules | Team (via git) |
| **Local memory** | `./CLAUDE.local.md` | Personal project preferences | Just you (gitignored) |
| **Nested memory** | `./subdir/CLAUDE.md` | Directory-specific context | Team (via git) |

*Enterprise policy paths:
- **macOS**: `/Library/Application Support/ClaudeCode/CLAUDE.md`
- **Linux/WSL**: `/etc/claude-code/CLAUDE.md`
- **Windows**: `C:\Program Files\ClaudeCode\CLAUDE.md`

## Memory Lookup Behavior

Claude Code discovers memory recursively:

1. **Parent traversal**: Starting from cwd, recurses up to (but not including) root, reading any `CLAUDE.md` or `CLAUDE.local.md` files found

2. **Subtree discovery**: CLAUDE.md files nested in subdirectories under cwd are discovered but only included when Claude reads files in those subtrees

3. **Priority**: Higher-level files (enterprise, user) are loaded first, providing a foundation that more specific memories build upon

```
project/
├── CLAUDE.md              # Always loaded (from cwd)
├── src/
│   └── api/
│       └── CLAUDE.md      # Loaded only when working in src/api/
└── tests/
    └── CLAUDE.md          # Loaded only when working in tests/
```

## Quick Start

Bootstrap a CLAUDE.md for your project:

```
/init
```

Or create manually with minimal content.

## Token Cost Reality

- **1 word ≈ 1.3 tokens**
- 100 words ≈ 130 tokens
- Each token costs money per message
- CLAUDE.md is loaded for EVERY interaction

**Target: 50-200 tokens for most projects**

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

## Import Syntax

CLAUDE.md files can import other files using `@path/to/import`:

```markdown
See @README for project overview and @package.json for npm commands.

# Additional Instructions
- git workflow @docs/git-instructions.md
```

### Import Rules

- Both relative and absolute paths are allowed
- Home directory imports work: `@~/.claude/my-project-instructions.md`
- Imports inside code spans and code blocks are ignored
- Imports are resolved recursively (max depth: 5)
- Use `/memory` command to see loaded files

### Team-Friendly Imports

Allow team members to provide individual instructions without committing:

```markdown
# Team Overrides
@~/.claude/my-project-instructions.md
```

This works better than CLAUDE.local.md across multiple git worktrees.

## Modular Rules with `.claude/rules/`

For larger projects, organize instructions into focused rule files:

```
.claude/
├── CLAUDE.md           # Minimal main file
└── rules/
    ├── code-style.md   # Code style guidelines
    ├── testing.md      # Testing conventions
    └── security.md     # Security requirements
```

All `.md` files in `.claude/rules/` are automatically loaded as project memory.

### Path-Specific Rules

Scope rules to specific files using YAML frontmatter:

```markdown
---
paths:
  - "src/api/**/*.ts"
---

# API Development Rules

- All API endpoints must include input validation
- Use the standard error response format
- Include OpenAPI documentation comments
```

Rules without a `paths` field apply to all files.

### Glob Patterns

| Pattern | Matches |
|---------|---------|
| `**/*.ts` | All TypeScript files in any directory |
| `src/**/*` | All files under `src/` |
| `*.md` | Markdown files in project root |
| `src/components/*.tsx` | React components in specific directory |

Multiple patterns allowed:

```markdown
---
paths:
  - "src/**/*.ts"
  - "lib/**/*.ts"
  - "tests/**/*.test.ts"
---
```

Brace expansion supported:

```markdown
---
paths:
  - "src/**/*.{ts,tsx}"
  - "{src,lib}/**/*.ts"
---
```

### Rule Subdirectories

Organize rules into folders:

```
.claude/rules/
├── frontend/
│   ├── react.md
│   └── styles.md
├── backend/
│   ├── api.md
│   └── database.md
└── general.md
```

All `.md` files are discovered recursively.

### Symlinks

Share common rules across projects:

```bash
# Symlink a shared rules directory
ln -s ~/shared-claude-rules .claude/rules/shared

# Symlink individual files
ln -s ~/company-standards/security.md .claude/rules/security.md
```

Symlinks are resolved normally. Circular symlinks are detected and handled gracefully.

### User-Level Rules

Personal rules that apply to all your projects:

```
~/.claude/rules/
├── preferences.md    # Your coding preferences
└── workflows.md      # Your preferred workflows
```

User-level rules load before project rules (project rules have higher priority).

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

## Local Additions

Use `CLAUDE.local.md` for personal notes (automatically gitignored):

```markdown
# Local Notes

- My API key is in .env.local
- Use `make quick-test` for fast iteration
- TODO: Refactor auth module
```

## Managing Memory

### View Loaded Memory

```
/memory
```

Opens memory files in your system editor and shows what's loaded.

### Measuring Efficiency

```bash
# Count words (multiply by 1.3 for tokens)
wc -w .claude/CLAUDE.md

# Check all loaded files
wc -w CLAUDE.md .claude/CLAUDE.md .claude/rules/*.md 2>/dev/null

# In Claude Code
/context
```

## Organization-Level Memory

Organizations can deploy centrally managed CLAUDE.md files:

1. Create the managed memory file at the enterprise policy location
2. Deploy via configuration management (MDM, Group Policy, Ansible, etc.)
3. All users on the machine will receive these instructions

This ensures consistent standards across all developer machines.

## Best Practices Summary

### Do

- [ ] Keep under 200 tokens for typical projects
- [ ] List stack concisely
- [ ] Include key commands
- [ ] Limit to 3-5 critical conventions
- [ ] Move detailed guides to skills
- [ ] Put code examples in separate files
- [ ] Use nested CLAUDE.md for large projects
- [ ] Use rules directory for modular organization
- [ ] Use path-specific rules for targeted guidance

### Don't

- [ ] Include full documentation
- [ ] Add code examples inline
- [ ] List every coding convention
- [ ] Duplicate content between files
- [ ] Include API references

## Token Impact

| Component | Token Cost | Notes |
|-----------|------------|-------|
| CLAUDE.md | ~50-200 | Target range for most projects |
| rules/*.md | Variable | All loaded at startup |
| Nested CLAUDE.md | Conditional | Only when working in that subtree |
| CLAUDE.local.md | Variable | Personal additions |

**Goal**: Minimize startup token cost while providing essential context.

## See Also

- [Token Management](./04-token-management.md) - Context optimization strategies
- [Skills Reference](./03-skills.md) - Move detailed content to skills
- [Settings Reference](./05-settings-reference.md) - Configuration options
