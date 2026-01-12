# Claude Code Project Configuration Overview

This documentation covers how to configure Claude Code at the project level using the `.claude/` folder.

## Purpose

This project maintains reusable `.claude/` folder templates that can be copied into any project to provide "batteries-included" Claude Code configuration for different use cases (Python CLI, React, DevOps, etc.).

## Key Concepts

### Configuration Hierarchy

Claude Code reads configuration from multiple levels (in order of precedence):

1. **Enterprise/Managed**: `/Library/Application Support/ClaudeCode/` (macOS)
2. **User-level**: `~/.claude/`
3. **Project-level**: `./.claude/`
4. **Local overrides**: `./.claude/settings.local.json` (gitignored)

### What Goes in `.claude/`

```
.claude/
├── CLAUDE.md              # Project context and rules (loaded into context)
├── settings.json          # Hooks, permissions, config (parsed, not in context)
├── settings.local.json    # Local overrides, gitignored (parsed, not in context)
├── hooks/                 # Hook scripts (executed, not in context)
├── scripts/               # Helper scripts (executed, not in context)
├── skills/                # Agent skills (metadata loaded, content lazy)
├── commands/              # Slash commands (loaded when invoked)
├── agents/                # Custom subagents (metadata only at startup)
└── rules/                 # Additional rules (ALL loaded into context)
```

## Token Impact Summary

| Component | Loaded at Startup? | Token Impact |
|-----------|-------------------|--------------|
| **CLAUDE.md** | Yes, fully | HIGH |
| **rules/*.md** | Yes, fully | HIGH |
| **settings.json** | Parsed only | ZERO |
| **Hooks config** | Parsed only | ZERO |
| **Hook scripts** | Executed only | ZERO |
| **Skills** | Metadata only | LOW (~100 tokens each) |
| **Skill content** | On-demand | ZERO at startup |
| **Agents** | Metadata only | LOW (~50 tokens each) |
| **Commands** | On invocation | ZERO at startup |

## Design Principles

1. **Keep CLAUDE.md lean** - Every word costs tokens
2. **Use skills for detailed instructions** - They're lazy-loaded
3. **Use rules sparingly** - Only for always-on constraints
4. **Put heavy content in skills** - Loaded only when needed

## Documentation Index

- [01-overview.md](./01-overview.md) - This file
- [02-hooks.md](./02-hooks.md) - Complete hook reference: events, input/output, decision control, prompt-based hooks
- [03-skills.md](./03-skills.md) - Creating and using skills: progressive disclosure, authoring best practices
- [04-token-management.md](./04-token-management.md) - Context and token optimization strategies
- [05-settings-reference.md](./05-settings-reference.md) - Complete settings.json reference: scopes, permissions, sandbox, MCP, plugins
- [06-plugins.md](./06-plugins.md) - Plugin system (for reference)
- [07-claude-md-best-practices.md](./07-claude-md-best-practices.md) - Memory files: hierarchy, imports, path-specific rules
- [08-existing-global-config.md](./08-existing-global-config.md) - Existing global configuration reference
