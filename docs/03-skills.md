# Claude Code Skills

Skills are model-invoked capabilities that Claude autonomously decides when to use based on context. Unlike slash commands (user-invoked), Claude reads the situation and applies relevant skills automatically.

## Skills vs Slash Commands

| Aspect | Skills | Slash Commands |
|--------|--------|----------------|
| **Invocation** | Claude decides | User types `/command` |
| **Trigger** | Context-based | Explicit |
| **Use case** | Capabilities Claude should use | Actions user initiates |

## Skill Structure

```
.claude/skills/
└── my-skill/
    ├── SKILL.md           # Required: metadata + instructions
    ├── reference.md       # Optional: detailed reference
    ├── examples.md        # Optional: usage examples
    ├── scripts/           # Optional: helper scripts
    └── templates/         # Optional: file templates
```

## SKILL.md Format

```markdown
---
name: "Testing Helper"
description: "Helps write and run tests for the project"
---

# Testing Helper

## When to Use
Use this skill when the user asks about testing or when writing new features that need tests.

## Instructions
1. Check existing test patterns in `tests/` directory
2. Use pytest for Python, jest for JavaScript
3. Follow AAA pattern (Arrange, Act, Assert)

## Commands
- Run tests: `npm test` or `pytest`
- Run specific: `npm test -- --grep "pattern"`
```

## Token Impact (Critical!)

### What's Loaded at Startup
- **Only metadata**: `name` and `description` fields (~20 tokens per skill)

### What's Lazy-Loaded (On Demand)
- Full SKILL.md content
- reference.md, examples.md
- Everything in scripts/, templates/

**This is why skills are ideal for detailed instructions** - they don't cost tokens until Claude actually uses them.

## Skill Discovery

Skills are discovered from:
1. `~/.claude/skills/` - User skills (all projects)
2. `.claude/skills/` - Project skills
3. Plugin skills (if plugins enabled)

## Best Practices

### 1. Write Good Descriptions
The description is what Claude sees at startup. Make it clear:

```yaml
# Good
description: "Generates React components with TypeScript and Tailwind styling"

# Bad
description: "Component helper"
```

### 2. Use Skills for Heavy Content

❌ **Don't put in CLAUDE.md** (loads every time):
```markdown
## How to Write Tests
[500 words of detailed instructions...]
```

✅ **Put in a skill** (loads only when testing):
```
.claude/skills/testing/SKILL.md
```

### 3. Organize by Capability

```
.claude/skills/
├── testing/           # All testing-related
├── deployment/        # Deploy workflows
├── database/          # DB migrations, queries
├── api/               # API endpoint creation
└── debugging/         # Debug helpers
```

### 4. Include Examples

Skills can reference example files that are only loaded when needed:

```markdown
---
name: "API Endpoint Creator"
description: "Creates new API endpoints following project patterns"
---

# API Endpoint Creator

See [examples](./examples.md) for endpoint patterns.
See [templates](./templates/) for boilerplate.
```

## Example Skills

### Testing Skill
```markdown
---
name: "Test Writer"
description: "Writes and runs tests following project conventions"
---

# Test Writer

## When to Use
- User asks to write tests
- User asks to test a feature
- After implementing new functionality

## Project Test Setup
- Framework: pytest
- Location: `tests/`
- Naming: `test_*.py`

## Instructions
1. Check existing test patterns
2. Create test file if needed
3. Write tests using AAA pattern
4. Run with `pytest -v`
```

### Deployment Skill
```markdown
---
name: "Deployer"
description: "Handles deployment to staging and production environments"
---

# Deployer

## When to Use
- User mentions deploy, release, ship
- After significant feature completion

## Environments
- staging: Auto-deploy on PR merge
- production: Manual via `/deploy prod`

## Checklist
1. Run tests
2. Check for uncommitted changes
3. Verify environment variables
4. Run deployment script
```

## Skills in Plugins

Skills can be packaged in plugins for sharing:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json
└── skills/
    └── my-skill/
        └── SKILL.md
```

When the plugin is installed, skills become available automatically.

## Debugging Skills

```bash
# List discovered skills
/skills

# Check skill loading in debug mode
claude --debug
grep -i skill ~/.claude/debug/latest
```

## Token Optimization Summary

| Skill Component | Startup Cost | When Loaded |
|-----------------|--------------|-------------|
| name + description | ~20 tokens | Always |
| SKILL.md content | 0 | When skill is used |
| reference.md | 0 | When skill reads it |
| examples.md | 0 | When skill reads it |
| scripts/ | 0 | When executed |
| templates/ | 0 | When read |

**Bottom line**: Use skills liberally. The startup cost is minimal, and detailed content only loads when needed.
