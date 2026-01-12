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
- [06-plugins.md](./06-plugins.md) - Plugin system: structure, manifest schema, components, installation, caching, debugging
- [07-claude-md-best-practices.md](./07-claude-md-best-practices.md) - Memory files: hierarchy, imports, path-specific rules
- [08-existing-global-config.md](./08-existing-global-config.md) - Existing global configuration reference
- [09-subagents.md](./09-subagents.md) - Subagents: built-in agents, custom agents, tool control, hooks, examples
- [10-slash-commands.md](./10-slash-commands.md) - Slash commands: built-in, custom, frontmatter, MCP commands, Skill tool
- [11-mcp.md](./11-mcp.md) - MCP (Model Context Protocol): servers, scopes, authentication, managed config
- [12-cli-reference.md](./12-cli-reference.md) - CLI commands, flags, and options
- [13-headless-mode.md](./13-headless-mode.md) - Headless mode: programmatic CLI usage, structured output, automation
- [14-github-actions.md](./14-github-actions.md) - GitHub Actions: CI/CD integration, workflows, cloud providers
- [15-checkpointing.md](./15-checkpointing.md) - Checkpointing: automatic tracking, rewind, recovery
- [16-interactive-mode.md](./16-interactive-mode.md) - Keyboard shortcuts, vim mode, terminal configuration
- [17-output-styles.md](./17-output-styles.md) - Output styles for non-coding use cases
- [18-model-configuration.md](./18-model-configuration.md) - Model aliases, selection, and prompt caching
- [19-statusline.md](./19-statusline.md) - Custom statusline configuration and examples
- [20-agent-sdk.md](./20-agent-sdk.md) - Agent SDK: building programmatic agents in TypeScript and Python
- [21-prompt-engineering.md](./21-prompt-engineering.md) - Prompt engineering: techniques for effective Claude prompts
- [22-troubleshooting.md](./22-troubleshooting.md) - Common issues: installation, authentication, performance, IDE integration
- [23-testing-evaluation.md](./23-testing-evaluation.md) - Testing and evaluation: success criteria, building evals, grading methods
