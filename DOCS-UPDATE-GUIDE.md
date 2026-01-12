# Documentation Update Guide

Use this guide to update the `docs/` folder with the latest official Claude Code documentation.

---

## Important: URL Format

**Always append `.md` to URLs when fetching documentation!**

The Claude documentation sites serve markdown versions that are cleaner and more complete:

```
# Instead of:
https://code.claude.com/docs/en/settings

# Use:
https://code.claude.com/docs/en/settings.md
```

This applies to both:
- `code.claude.com/docs/en/*.md`
- `platform.claude.com/docs/en/**/*.md`

---

## Meta-Prompt (Copy This Into Fresh Chat - Run in PLAN MODE)

```
# Documentation Update Task for claude-code-starter-kit

## Project Context

This is the `claude-code-starter-kit` repository - a batteries-included `.claude/` template collection for bootstrapping new projects with Claude Code. It contains:

- `docs/` - Reference documentation (01-overview.md through 08-existing-global-config.md)
- `templates/.claude/` - Ready-to-copy configuration templates (hooks, skills, rules, commands, settings.json)
- `templates/TEMPLATE-GUIDE.md` - Quick reference for what to keep/delete per project type
- `CLAUDE.md` - Project instructions

## Big Picture & Vision

This project is expanding to become a comprehensive resource for Claude Code power users. Future scope includes:

- **Prompt engineering** - Best practices, templates, and patterns
- **Agent SDK** - Building custom agents in TypeScript and Python
- **Testing & evaluation** - Defining success criteria, developing test suites
- **Plugin development** - Creating and publishing to marketplaces
- **Advanced automation** - Headless mode, GitHub Actions, CI/CD integration
- **Memory & context** - Statusline configuration, memory management
- **Advanced hooks** - Complex hook patterns and workflows

The documentation should serve as both a quick-start guide AND a comprehensive reference that users can rely on instead of constantly checking official docs.

## Your Task

You are running in **PLAN MODE**. Your job is to:

1. **Analyze** - Read current docs and the URLs I provide
2. **Plan** - Create a structured plan for updates (what files to create/update, what content to add)
3. **Track** - Use TodoWrite to track progress across multiple topics
4. **Execute** - After plan approval, implement updates thoroughly

### Workflow

1. **Read the URLs I provide** - Use WebFetch with `.md` suffix (e.g., `https://code.claude.com/docs/en/hooks.md`). If a URL times out or fails, I'll paste the content directly.

2. **Read current docs** - Check what currently exists in `docs/` for this topic. Identify gaps.

3. **Read related template files** - Check `templates/.claude/` for any related configuration.

4. **Plan updates** - Create a detailed plan covering:
   - Which files to update vs create new
   - What sections to add
   - What examples to include
   - Template files that need updates

5. **Update comprehensively** - After plan approval:
   - All new features and fields
   - Complete configuration options with tables
   - Multiple practical examples (from official docs)
   - Troubleshooting sections
   - Best practices and anti-patterns
   - Token/performance implications where relevant

6. **Update ancillary files**:
   - `templates/TEMPLATE-GUIDE.md` - If new components affect it
   - `docs/01-overview.md` - Update documentation index
   - Template files in `templates/.claude/` - If conventions changed

7. **Consider new docs files** - Topics may warrant dedicated files. Suggested numbering:
   - 09-subagents.md
   - 10-slash-commands.md
   - 11-mcp.md
   - 12-cli-reference.md
   - 13-headless-mode.md
   - 14-github-actions.md
   - 15-agent-sdk.md
   - 16-prompt-engineering.md
   - 17-testing-evaluation.md
   - (adjust as needed based on content scope)

### Quality Standards

- **Include examples** - Always include practical, complete examples from official documentation
- **Use tables** - Configuration options, field references, and comparisons work well as tables
- **Be comprehensive** - Cover all fields, options, and edge cases
- **Add troubleshooting** - Include common issues and solutions
- **Keep token efficiency notes** - This project cares about context window usage
- **Cross-reference** - Link between related docs where helpful

### Existing Docs Structure

```
docs/
├── 01-overview.md           # Structure, token impact, design principles
├── 02-hooks.md              # Hook events and configuration
├── 03-skills.md             # Skills (comprehensive - recently updated)
├── 04-token-management.md   # Context optimization
├── 05-settings-reference.md # settings.json reference
├── 06-plugins.md            # Plugin system
├── 07-claude-md-best-practices.md
└── 08-existing-global-config.md
```

### How to Handle URLs

1. **Always add `.md` suffix** to documentation URLs
2. If fetch fails ("Prompt is too long" or timeout), tell me and I'll paste the content
3. Search the web for additional context if needed

### Edge Cases & Nuances

- **Large topics** - Some topics (Agent SDK, Prompt Engineering) may be too large for one doc. Consider splitting or creating focused subsections.
- **Overlapping content** - Some topics overlap (e.g., hooks appear in settings, skills, and their own doc). Cross-reference rather than duplicate.
- **Template updates** - When updating templates, ensure they follow the latest conventions from official docs.
- **Version sensitivity** - Note if features are beta or recently changed.
- **Platform differences** - Some features differ between Claude Code CLI, API, and claude.ai. Note these differences.

## Ready?

Once you confirm you understand, I'll provide:
1. The topic(s) to cover
2. The relevant URLs to read
3. Any additional content if URLs fail

Start by reading the current docs folder structure and TEMPLATE-GUIDE.md to understand what exists.
```

---

## Topics and URLs

### 1. Hooks

**Target doc:** `docs/02-hooks.md`
**Template files:** `templates/.claude/hooks/`, `templates/.claude/settings.json`

**URLs (remember to add .md suffix):**
```
https://code.claude.com/docs/en/hooks.md
https://code.claude.com/docs/en/hooks-guide.md
```

**Cover:**
- Hook events (PreToolUse, PostToolUse, Stop, etc.)
- Hook configuration in settings.json
- Hook scripts vs inline commands
- Matchers and patterns
- The `once: true` option
- Hooks in skills
- Practical examples

---

### 2. Subagents

**Target doc:** `docs/09-subagents.md` (new)
**Template files:** `templates/.claude/agents/` (create if needed)

**URLs:**
```
https://code.claude.com/docs/en/sub-agents.md
```

**Cover:**
- Built-in subagents (Explore, Plan, general-purpose)
- Custom subagents in `.claude/agents/`
- YAML frontmatter fields (name, description, skills, allowed-tools, model, etc.)
- Skills integration with subagents
- When to use subagents vs skills
- Examples

---

### 3. Slash Commands

**Target doc:** `docs/10-slash-commands.md` (new) or section in existing
**Template files:** `templates/.claude/commands/`

**URLs:**
```
https://code.claude.com/docs/en/slash-commands.md
```

**Cover:**
- Command file format (YAML frontmatter + prompt)
- Args configuration
- Built-in commands vs custom commands
- The Skill tool
- User-invocable vs model-invocable
- Examples

---

### 4. Memory / CLAUDE.md

**Target doc:** `docs/07-claude-md-best-practices.md`
**Template files:** `templates/.claude/CLAUDE.md`, `templates/.claude/CLAUDE-*.md`

**URLs:**
```
https://code.claude.com/docs/en/memory.md
```

**Cover:**
- CLAUDE.md hierarchy (root, .claude/, nested directories)
- CLAUDE.local.md
- The /memory command
- Best practices for context efficiency
- What to include vs exclude

---

### 5. Settings Reference

**Target doc:** `docs/05-settings-reference.md`
**Template files:** `templates/.claude/settings.json`

**URLs:**
```
https://code.claude.com/docs/en/settings.md
```

**Cover:**
- Complete settings.json schema
- All permission types
- Hook configuration format
- Environment variables
- settings.local.json

---

### 6. Plugins

**Target doc:** `docs/06-plugins.md`
**Template files:** Plugin structure examples

**URLs:**
```
https://code.claude.com/docs/en/plugins.md
https://code.claude.com/docs/en/plugins-reference.md
https://code.claude.com/docs/en/plugin-marketplaces.md
https://code.claude.com/docs/en/discover-plugins.md
```

**Cover:**
- Plugin directory structure
- plugin.json format
- Skills in plugins
- Commands in plugins
- Publishing to marketplaces
- Discovering and installing plugins

---

### 7. MCP (Model Context Protocol)

**Target doc:** `docs/11-mcp.md` (new)
**Template files:** MCP configuration in settings

**URLs:**
```
https://code.claude.com/docs/en/mcp.md
```

**Cover:**
- MCP server configuration
- Built-in vs custom MCP servers
- MCP tools usage
- When to use MCP vs other options

---

### 8. Output Styles

**Target doc:** Section in settings or new file
**Template files:** Settings configuration

**URLs:**
```
https://code.claude.com/docs/en/output-styles.md
```

**Cover:**
- Output format options
- Verbosity levels
- Markdown rendering
- Configuration options

---

### 9. CLI Reference

**Target doc:** `docs/12-cli-reference.md` (new)
**Template files:** N/A

**URLs:**
```
https://code.claude.com/docs/en/cli-reference.md
```

**Cover:**
- All CLI flags and options
- Environment variables
- Configuration precedence
- Common usage patterns

---

### 10. Headless Mode

**Target doc:** `docs/13-headless-mode.md` (new)
**Template files:** N/A

**URLs:**
```
https://code.claude.com/docs/en/headless.md
```

**Cover:**
- Running Claude Code without interactive UI
- Scripting and automation use cases
- Input/output handling
- Integration patterns

---

### 11. GitHub Actions

**Target doc:** `docs/14-github-actions.md` (new)
**Template files:** Example workflow files

**URLs:**
```
https://code.claude.com/docs/en/github-actions.md
```

**Cover:**
- Setting up Claude Code in GitHub Actions
- Workflow examples
- Authentication and secrets
- Common CI/CD patterns

---

### 12. Checkpointing

**Target doc:** Section in appropriate doc or new file
**Template files:** N/A

**URLs:**
```
https://code.claude.com/docs/en/checkpointing.md
```

**Cover:**
- What checkpointing does
- When checkpoints are created
- Restoring from checkpoints
- Configuration options

---

### 13. Interactive Mode

**Target doc:** Section in CLI reference or overview
**Template files:** N/A

**URLs:**
```
https://code.claude.com/docs/en/interactive-mode.md
```

**Cover:**
- Interactive mode features
- Keyboard shortcuts
- UI elements
- Customization

---

### 14. Terminal Configuration

**Target doc:** Section in settings or new file
**Template files:** N/A

**URLs:**
```
https://code.claude.com/docs/en/terminal-config.md
```

**Cover:**
- Terminal-specific settings
- Color schemes
- Font and display options

---

### 15. Model Configuration

**Target doc:** Section in settings or new file
**Template files:** Settings configuration

**URLs:**
```
https://code.claude.com/docs/en/model-config.md
```

**Cover:**
- Model selection
- Model-specific settings
- Cost considerations
- When to use which model

---

### 16. Statusline

**Target doc:** Section in appropriate doc or new file
**Template files:** N/A

**URLs:**
```
https://code.claude.com/docs/en/statusline.md
```

**Cover:**
- Statusline configuration
- Available indicators
- Customization options

---

### 17. Troubleshooting

**Target doc:** `docs/18-troubleshooting.md` (new) or sections in each doc
**Template files:** N/A

**URLs:**
```
https://code.claude.com/docs/en/troubleshooting.md
```

**Cover:**
- Common issues and solutions
- Debug mode
- Logging
- Getting help

---

### 18. Agent SDK (Comprehensive)

**Target doc:** `docs/15-agent-sdk.md` (new) - may need multiple files
**Template files:** Example agent configurations

**URLs:**
```
https://platform.claude.com/docs/en/agent-sdk/overview.md
https://platform.claude.com/docs/en/agent-sdk/quickstart.md
https://platform.claude.com/docs/en/agent-sdk/typescript.md
https://platform.claude.com/docs/en/agent-sdk/typescript-v2-preview.md
https://platform.claude.com/docs/en/agent-sdk/python.md
https://platform.claude.com/docs/en/agent-sdk/migration-guide.md
https://platform.claude.com/docs/en/agent-sdk/hosting.md
```

**Cover:**
- SDK overview and architecture
- TypeScript SDK
- Python SDK
- Building custom agents
- Skills in SDK
- Hosting agents
- Migration from v1 to v2

---

### 19. Prompt Engineering

**Target doc:** `docs/16-prompt-engineering.md` (new) - may need multiple files
**Template files:** Prompt templates

**URLs:**
```
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/overview.md
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prompt-generator.md
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/multishot-prompting.md
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/chain-of-thought.md
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/use-xml-tags.md
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/system-prompts.md
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/prefill-claudes-response.md
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/chain-prompts.md
https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/long-context-tips.md
```

**Cover:**
- Prompt engineering fundamentals
- Multishot prompting
- Chain of thought
- XML tags usage
- System prompts
- Prefilling responses
- Chaining prompts
- Long context strategies

---

### 20. Testing & Evaluation

**Target doc:** `docs/17-testing-evaluation.md` (new)
**Template files:** Test configuration examples

**URLs:**
```
https://platform.claude.com/docs/en/test-and-evaluate/define-success.md
https://platform.claude.com/docs/en/test-and-evaluate/develop-tests.md
```

**Cover:**
- Defining success criteria
- Developing test suites
- Evaluation strategies
- Metrics and measurement

---

## Quick Reference

### URL Patterns

**Claude Code docs:**
```
https://code.claude.com/docs/en/{topic}.md
```

**Platform/API docs:**
```
https://platform.claude.com/docs/en/{category}/{topic}.md
```

**Find all available pages:**
```
https://code.claude.com/docs/llms.txt
```

---

## Suggested Topic Groupings for Sessions

Since some topics are large, consider grouping by session:

### Session 1: Core Configuration
- Hooks (+ hooks-guide)
- Settings
- Memory/CLAUDE.md

### Session 2: Extensibility
- Subagents
- Slash Commands
- Plugins (all 4 URLs)

### Session 3: Advanced Features
- MCP
- Headless Mode
- GitHub Actions
- Checkpointing

### Session 4: UI & CLI
- CLI Reference
- Interactive Mode
- Terminal Config
- Output Styles
- Statusline
- Model Config

### Session 5: Agent SDK
- All 7 Agent SDK URLs
- May need dedicated session due to scope

### Session 6: Prompt Engineering
- All 9 prompt engineering URLs
- May need dedicated session due to scope

### Session 7: Testing & Polish
- Testing & Evaluation
- Troubleshooting
- Cross-doc consistency review

---

## Workflow Example

1. Copy the meta-prompt into a fresh chat (in Plan mode)
2. Wait for Claude to confirm understanding
3. Paste this:

```
Topic: Hooks

URLs to read (remember .md suffix):
1. https://code.claude.com/docs/en/hooks.md
2. https://code.claude.com/docs/en/hooks-guide.md

Please start by reading the current docs/02-hooks.md and templates/.claude/hooks/ files, then fetch the URLs above.
```

4. Review the plan Claude creates
5. Approve to proceed with implementation
6. If URL fetch fails, paste the page content directly
7. Review Claude's updates
8. Commit changes

---

## After Completing All Updates

Once all topics are updated:

1. Review `docs/01-overview.md` - ensure documentation index is complete
2. Review `templates/TEMPLATE-GUIDE.md` - ensure all components are listed
3. Check for consistency across docs (terminology, formatting, cross-references)
4. Consider a "getting started" guide that ties everything together
5. Update this guide if new topics emerge
