# Token and Context Management

Understanding what consumes tokens helps design efficient `.claude/` configurations.

## Context Window Basics

- **Opus 4.5**: 200k token context window
- **System prompt + tools**: ~18k tokens (fixed overhead)
- **Autocompact buffer**: ~45k tokens reserved
- **Usable space**: ~137k tokens for messages + CLAUDE.md + rules

Check current usage: `/context`

## What Loads at Startup

### Always Loaded (Token Cost)

| Source | Impact | Notes |
|--------|--------|-------|
| `CLAUDE.md` (root) | Full content | Keep lean! |
| `.claude/CLAUDE.md` | Full content | Keep lean! |
| `.claude/rules/*.md` | All files, full content | Use sparingly |
| `CLAUDE.local.md` | Full content | For local additions |
| Parent CLAUDE.md files | Full content | Traverses up to root |

### Parsed Only (Zero Token Cost)

| Source | Notes |
|--------|-------|
| `settings.json` | Permissions, hooks, config |
| `settings.local.json` | Local overrides |
| Hook configurations | Just parsed for execution |
| Plugin manifests | Just metadata |

### Lazy Loaded (Zero Startup Cost)

| Source | When Loaded |
|--------|-------------|
| Skill SKILL.md content | When Claude uses the skill |
| Skill supporting files | When skill references them |
| Nested CLAUDE.md (in subdirs) | When Claude reads files in that dir |
| Plugin commands | When invoked |

## Token Optimization Strategies

### 1. Keep CLAUDE.md Minimal

```markdown
# Project Name

## Stack
Python 3.12, FastAPI, PostgreSQL, Redis

## Key Conventions
- Use ruff for formatting
- All endpoints need tests
- Follow existing patterns

## Quick Reference
- Run: `make dev`
- Test: `make test`
- Deploy: See .claude/skills/deploy/
```

**Target: 50-150 tokens**

### 2. Move Details to Skills

❌ **In CLAUDE.md** (always loaded):
```markdown
## Testing Guide
To write tests, follow these steps:
1. Create a file in tests/ matching the module name
2. Import pytest and the module under test
3. Use fixtures for database connections
4. Follow the AAA pattern...
[300 more words]
```

✅ **In skill** (loaded on demand):
```
.claude/skills/testing/SKILL.md
```

CLAUDE.md just says:
```markdown
- Testing: See .claude/skills/testing/
```

### 3. Use Rules Only for Constraints

Rules are always loaded. Use them for:
- Security constraints
- Code style requirements
- Things that must ALWAYS be checked

Don't use rules for:
- How-to guides
- Detailed procedures
- Reference documentation

### 4. Leverage Nested CLAUDE.md

Instead of one huge root CLAUDE.md, use directory-specific ones:

```
project/
├── CLAUDE.md              # Minimal, project-wide
├── src/
│   └── api/
│       └── CLAUDE.md      # API-specific (loaded when working here)
├── tests/
│   └── CLAUDE.md          # Test-specific (loaded when working here)
└── scripts/
    └── CLAUDE.md          # Scripts-specific
```

Nested files are **only loaded when Claude reads files in that directory**.

### 5. Skill Metadata Matters

Skill descriptions are always loaded (~100 tokens each). Make them count:

```yaml
# Good - Clear, actionable
description: "Creates FastAPI endpoints with validation, tests, and OpenAPI docs"

# Bad - Vague, wastes tokens
description: "Helps with API stuff"
```

## Measuring Token Usage

### Check Context
```
/context
```

Shows breakdown:
- System prompt: ~2.9k
- System tools: ~15.2k
- Messages: varies
- Free space: remaining

### Estimate CLAUDE.md Cost

```bash
# Rough token count (words × 1.3)
wc -w .claude/CLAUDE.md
# Multiply result by 1.3
```

### Debug Mode

```bash
claude --debug
# Check logs for loading info
```

## Token Budget Guidelines

| Project Type | CLAUDE.md Target | Rules Target | Skills |
|-------------|------------------|--------------|--------|
| Simple script | 30-50 tokens | 0 | 0-2 |
| Small project | 50-100 tokens | 0-1 files | 2-5 |
| Medium project | 100-200 tokens | 1-2 files | 5-10 |
| Large project | 200-500 tokens | 2-3 files | 10+ |

## Anti-Patterns

### 1. Documentation in CLAUDE.md
❌ Don't include full documentation
✅ Reference external files or skills

### 2. Copy-Paste from READMEs
❌ Don't duplicate README content
✅ Say "See README.md for setup"

### 3. Detailed Code Examples
❌ Don't include large code samples
✅ Put examples in skills or reference files

### 4. Every Possible Rule
❌ Don't list every coding convention
✅ State key principles, let Claude infer

## Auto-Compact Behavior

When context exceeds 95% capacity:
1. Claude automatically summarizes older messages
2. Recent messages preserved in full
3. CLAUDE.md and rules always preserved
4. Manual compact: `/compact`

## Cost Implications

- Larger context = more tokens = higher cost
- Background compaction uses additional tokens (~$0.04/session)
- Efficient CLAUDE.md = lower per-message cost
