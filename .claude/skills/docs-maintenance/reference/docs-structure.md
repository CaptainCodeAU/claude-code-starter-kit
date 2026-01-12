# Documentation Structure

Current organization of the `docs/` folder.

## File Listing

| File | Topic | Description |
|------|-------|-------------|
| `01-overview.md` | Overview | Structure, token impact, design principles |
| `02-hooks.md` | Hooks | Hook events, configuration, decision control |
| `03-skills.md` | Skills | Comprehensive skills reference |
| `04-token-management.md` | Tokens | Context optimization strategies |
| `05-settings-reference.md` | Settings | Complete settings.json reference |
| `06-plugins.md` | Plugins | Plugin system, manifest, distribution |
| `07-claude-md-best-practices.md` | Memory | CLAUDE.md hierarchy, imports, rules |
| `08-existing-global-config.md` | Global | User's existing global configuration |
| `09-subagents.md` | Subagents | Custom agents, tool control, examples |
| `10-slash-commands.md` | Commands | Built-in and custom slash commands |
| `11-mcp.md` | MCP | Model Context Protocol servers |
| `12-cli-reference.md` | CLI | Command-line flags and options |
| `13-headless-mode.md` | Headless | Non-interactive usage, scripting |
| `14-github-actions.md` | CI/CD | GitHub Actions integration |
| `15-checkpointing.md` | Checkpoints | Automatic tracking, rewinding |
| `16-interactive-mode.md` | Interactive | Keyboard shortcuts, vim mode |
| `17-output-styles.md` | Styles | Custom output styles |
| `18-model-configuration.md` | Models | Model selection, aliases, costs |
| `19-statusline.md` | Statusline | Custom statusline configuration |
| `20-agent-sdk.md` | SDK | TypeScript/Python Agent SDK |
| `21-prompt-engineering.md` | Prompts | Techniques and patterns |
| `22-troubleshooting.md` | Troubleshooting | Common issues and solutions |
| `23-testing-evaluation.md` | Testing | Success criteria, building evals |
| `CHANGELOG.md` | Changelog | Documentation update history |

## Groupings

### Core Configuration (01-08)
Foundation docs covering basic setup and configuration.

### Extensibility (09-11)
Extending Claude Code with custom components.

### CLI & Automation (12-15)
Command-line usage and automation.

### UI & Configuration (16-19)
Interface customization and display options.

### Advanced Topics (20-23)
SDK, prompt engineering, testing, troubleshooting.

## Numbering Convention

- Use two-digit prefix: `01-`, `02-`, etc.
- Maintain sequential ordering
- New docs get next available number
- Group related docs in adjacent numbers

## Source URLs

**Claude Code docs:**
```
https://code.claude.com/docs/en/{topic}.md
```

**Platform/API docs:**
```
https://platform.claude.com/docs/en/{category}/{topic}.md
```

**Index of available pages:**
```
https://code.claude.com/docs/llms.txt
```

## Related Locations

- `templates/.claude/` — Configuration templates
- `templates/TEMPLATE-GUIDE.md` — What to keep/delete per project
- `CLAUDE.md` — Project instructions (references docs)
