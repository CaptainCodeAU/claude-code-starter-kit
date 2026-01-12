# Documentation Update Progress

Tracks progress across documentation update sessions. See [DOCS-UPDATE-GUIDE.md](./DOCS-UPDATE-GUIDE.md) for the master plan, URLs, and meta-prompt.

---

## Quick Status

| Session | Description | Status | Completed |
|---------|-------------|--------|-----------|
| 1 | Core Configuration | ✅ Done | 2026-01-12 |
| 2 | Extensibility | ✅ Done | 2026-01-12 |
| 3 | Advanced Features | ✅ Done | 2026-01-12 |
| 4 | UI & CLI | ✅ Done | 2026-01-12 |
| 5 | Agent SDK | ✅ Done | 2026-01-12 |
| 6 | Prompt Engineering | ✅ Done | 2026-01-12 |
| 7 | Testing & Polish | ✅ Done | 2026-01-12 |

---

## Session 1: Core Configuration ✅

**Status:** Complete
**Date:** 2026-01-12

### Topics Covered

#### Topic 1: Hooks
- **Target:** `docs/02-hooks.md`
- **Status:** ✅ Updated
- **Before:** ~218 lines
- **After:** ~770 lines

**Sub-tasks completed:**
- [x] Added prompt-based hooks (`type: "prompt"` with LLM evaluation)
- [x] Added plugin hooks section (`CLAUDE_PLUGIN_ROOT`)
- [x] Added component hooks (skills, agents, slash commands with `once: true`)
- [x] Added event-specific matchers (Notification, SessionStart, PreCompact)
- [x] Expanded tool input schemas (Bash, Write, Edit, Read)
- [x] Added PreToolUse decision control (`allow`/`deny`/`ask`, `updatedInput`)
- [x] Added PermissionRequest decision control
- [x] Added PostToolUse decision control (`additionalContext`)
- [x] Added UserPromptSubmit decision control
- [x] Added Stop/SubagentStop decision control (`stop_hook_active`)
- [x] Added `CLAUDE_CODE_REMOTE` environment variable
- [x] Added markdown formatter Python example
- [x] Added bash command validator example
- [x] Added custom notifications example
- [x] Added intelligent stop hook example

#### Topic 4: Memory/CLAUDE.md
- **Target:** `docs/07-claude-md-best-practices.md`
- **Status:** ✅ Updated
- **Before:** ~291 lines
- **After:** ~468 lines

**Sub-tasks completed:**
- [x] Added enterprise policy to memory hierarchy (system-level paths)
- [x] Added memory lookup behavior (recursive discovery, subtree inclusion)
- [x] Expanded import syntax (`@path/import` with full examples)
- [x] Added path-specific rules (YAML frontmatter with `paths` field)
- [x] Added glob pattern syntax table
- [x] Added rule subdirectories documentation
- [x] Added symlinks support for sharing rules
- [x] Added user-level rules (`~/.claude/rules/`)
- [x] Added `/init` command for bootstrapping
- [x] Added `/memory` command details
- [x] Added organization-level memory management

#### Topic 5: Settings
- **Target:** `docs/05-settings-reference.md`
- **Status:** ✅ Updated
- **Before:** ~314 lines
- **After:** ~593 lines

**Sub-tasks completed:**
- [x] Added configuration scopes section (Managed/User/Project/Local)
- [x] Added managed settings paths (macOS, Linux, Windows)
- [x] Added scope precedence explanation
- [x] Added sandbox settings (complete configuration)
- [x] Added attribution settings (replaces `includeCoAuthoredBy`)
- [x] Added MCP server settings section
- [x] Added plugin settings and marketplace restrictions
- [x] Added `apiKeyHelper`, `companyAnnouncements`, `forceLoginMethod`
- [x] Added `fileSuggestion`, `respectGitignore`, `outputStyle`, `language`
- [x] Added hook-related settings (`disableAllHooks`, `allowManagedHooksOnly`)
- [x] Added complete environment variables table (~40 variables)
- [x] Added disable feature variables table
- [x] Added tools available to Claude table
- [x] Added bash tool behavior (working dir, env var persistence)

### Additional Updates
- [x] Updated `docs/01-overview.md` - Added agents folder, updated doc index descriptions
- [x] Verified `templates/.claude/settings.json` - No changes needed
- [x] Verified `templates/TEMPLATE-GUIDE.md` - Already covers newer features

---

## Session 2: Extensibility ✅

**Status:** Complete
**Date:** 2026-01-12

### Topics Covered

#### Topic 2: Subagents
- **Target:** `docs/09-subagents.md` (new)
- **Status:** ✅ Created
- **Lines:** 579

**Sub-tasks completed:**
- [x] Built-in subagents table (Explore, Plan, general-purpose, Bash, statusline-setup, Claude Code Guide)
- [x] Creating custom subagents (file locations, `/agents` command)
- [x] YAML frontmatter reference (name, description, tools, model, permissionMode, skills, hooks)
- [x] Tool control (tools/disallowedTools, permission modes, conditional validation with hooks)
- [x] Hooks in subagents (frontmatter hooks, project-level SubagentStart/SubagentStop)
- [x] Working with subagents (automatic delegation, foreground/background, resuming, context management)
- [x] Four practical examples (code reviewer, debugger, data scientist, db query validator)
- [x] When to use what (subagents vs skills vs main conversation)
- [x] Common patterns (isolate high-volume, parallel research, chain subagents)
- [x] Token impact section

#### Topic 3: Slash Commands
- **Target:** `docs/10-slash-commands.md` (new)
- **Status:** ✅ Created
- **Lines:** 566

**Sub-tasks completed:**
- [x] Built-in commands table (~40 commands)
- [x] Custom slash commands (project and personal locations)
- [x] Command features (namespacing, arguments `$ARGUMENTS`/`$1`/`$2`, bash execution, file references)
- [x] Frontmatter reference table (allowed-tools, argument-hint, context, agent, model, hooks, etc.)
- [x] Plugin commands (namespacing, structure)
- [x] MCP slash commands (format, dynamic discovery, permissions)
- [x] The Skill tool (what it invokes, character budget, disabling)
- [x] Skills vs slash commands comparison table
- [x] Practical examples (git commit, code review with hooks, multi-file analysis)
- [x] Token impact section

#### Topic 6: Plugins
- **Target:** `docs/06-plugins.md` (expanded)
- **Status:** ✅ Updated
- **Before:** 190 lines
- **After:** 727 lines

**Sub-tasks completed:**
- [x] When to use plugins vs standalone comparison
- [x] Complete plugin structure diagram
- [x] Plugin manifest schema (complete with required/metadata/component path fields)
- [x] `${CLAUDE_PLUGIN_ROOT}` environment variable
- [x] All plugin components (commands, agents, skills, hooks, MCP servers, LSP servers)
- [x] Installation & management CLI commands
- [x] Installation scopes table (user, project, local, managed)
- [x] Plugin caching (how it works, path traversal, external dependencies)
- [x] Debugging & troubleshooting (debug mode, common issues table, hook/MCP troubleshooting)
- [x] Directory structure errors section
- [x] Version management (semantic versioning, best practices)
- [x] Converting standalone to plugin (migration steps, what changes)

### Additional Updates
- [x] Updated `docs/01-overview.md` - Added entries for 09-subagents.md and 10-slash-commands.md, updated 06-plugins.md description

---

## Session 3: Advanced Features ✅

**Status:** Complete
**Date:** 2026-01-12

### Topics Covered

#### Topic 7: MCP
- **Target:** `docs/11-mcp.md` (new)
- **Status:** ✅ Created
- **Lines:** ~600

**Sub-tasks completed:**
- [x] Overview and capabilities (what MCP enables)
- [x] Installing MCP servers (HTTP, SSE deprecated, stdio)
- [x] Option ordering and command syntax
- [x] Managing servers (list, get, remove, /mcp command)
- [x] Dynamic tool updates (list_changed notifications)
- [x] Installation scopes (local, project, user) with precedence
- [x] Configuration files (.mcp.json format, env var expansion)
- [x] Adding from JSON and importing from Claude Desktop
- [x] Plugin-provided MCP servers (CLAUDE_PLUGIN_ROOT, lifecycle)
- [x] Authentication (OAuth 2.0, bearer tokens)
- [x] Using MCP resources (@ mention syntax)
- [x] MCP prompts as slash commands (/mcp__server__prompt)
- [x] Output limits and MAX_MCP_OUTPUT_TOKENS
- [x] Claude Code as MCP server (claude mcp serve)
- [x] Managed MCP configuration (exclusive vs policy-based)
- [x] Allowlist/denylist by name, command, URL patterns
- [x] Practical examples (Sentry, GitHub, PostgreSQL)
- [x] Troubleshooting and Windows notes

#### Topic 10: Headless Mode
- **Target:** `docs/13-headless-mode.md` (new)
- **Status:** ✅ Created
- **Lines:** ~300

**Sub-tasks completed:**
- [x] Overview (Agent SDK CLI relationship)
- [x] Basic usage (-p / --print flag)
- [x] Output formats (text, json, stream-json)
- [x] Structured output with --json-schema
- [x] Auto-approving tools (--allowedTools patterns)
- [x] System prompt customization (--append-system-prompt, --system-prompt)
- [x] Continuing conversations (--continue, --resume)
- [x] Common patterns (commits, piping, batch processing, parallel execution)
- [x] Exit codes
- [x] Comparison with interactive mode
- [x] CI/CD integration notes

#### Topic 11: GitHub Actions
- **Target:** `docs/14-github-actions.md` (new)
- **Status:** ✅ Created
- **Lines:** ~550

**Sub-tasks completed:**
- [x] Overview and capabilities
- [x] Quick setup (/install-github-app)
- [x] Manual setup (GitHub App, secrets, workflow file)
- [x] Basic workflow example
- [x] Configuration (parameters, prompts, claude_args)
- [x] Workflow examples (code review, daily reports, comments)
- [x] Common use cases
- [x] AWS Bedrock integration (OIDC, workflow)
- [x] Google Vertex AI integration (workload identity, workflow)
- [x] Creating custom GitHub App
- [x] Best practices (CLAUDE.md, security, performance, cost)
- [x] Migration from beta to v1.0
- [x] Breaking changes reference table
- [x] Troubleshooting

#### Topic 12: Checkpointing
- **Target:** `docs/15-checkpointing.md` (new)
- **Status:** ✅ Created
- **Lines:** ~130

**Sub-tasks completed:**
- [x] How checkpoints work (automatic tracking, persistence)
- [x] What gets tracked (Edit, Write vs Bash)
- [x] Rewinding changes (Esc+Esc, /rewind, options)
- [x] Use cases (exploring, recovering, iterating)
- [x] Limitations (bash, external changes, not replacement for git)
- [x] Configuration (cleanupPeriodDays)

### Additional Updates
- [x] Updated `docs/01-overview.md` - Added entries for 11, 13, 14, 15

---

## Session 4: UI & CLI ✅

**Status:** Complete
**Date:** 2026-01-12

### Topics Covered

#### CLI Reference
- **Target:** `docs/12-cli-reference.md` (new)
- **Status:** ✅ Created
- **Lines:** ~220

**Sub-tasks completed:**
- [x] CLI commands table (claude, -p, -c, -r, update, mcp)
- [x] Core flags section
- [x] Model selection flags
- [x] Session management flags
- [x] System prompt customization flags (--system-prompt, --append-system-prompt, --system-prompt-file)
- [x] Tool control flags (--tools, --allowedTools, --disallowedTools)
- [x] Agent configuration flags (--agent, --agents)
- [x] Output control flags (--output-format, --json-schema, --max-turns)
- [x] MCP configuration flags
- [x] Permissions and settings flags
- [x] Agents flag JSON format documentation
- [x] Common usage patterns section

#### Interactive Mode + Terminal Config
- **Target:** `docs/16-interactive-mode.md` (new)
- **Status:** ✅ Created
- **Lines:** ~350

**Sub-tasks completed:**
- [x] macOS Option key setup (iTerm2, Terminal.app, VS Code)
- [x] General controls table (Ctrl+C, Ctrl+D, Ctrl+L, Ctrl+O, etc.)
- [x] Text editing shortcuts (Ctrl+K, Ctrl+U, Ctrl+Y, Alt+B/F)
- [x] Theme and display shortcuts
- [x] Multiline input methods table
- [x] Quick commands section (/, !, @)
- [x] Complete Vim editor mode reference (mode switching, navigation, editing, text objects)
- [x] Command history and reverse search (Ctrl+R)
- [x] Background bash commands (Ctrl+B, task IDs, common commands)
- [x] Bash mode (! prefix)
- [x] Terminal configuration (themes, line breaks, notifications, large inputs)

#### Output Styles
- **Target:** `docs/17-output-styles.md` (new)
- **Status:** ✅ Created
- **Lines:** ~200

**Sub-tasks completed:**
- [x] Built-in styles (Default, Explanatory, Learning)
- [x] How output styles work (system prompt modification)
- [x] Changing output style (/output-style command)
- [x] Creating custom output styles (file locations, format)
- [x] Frontmatter reference table (name, description, keep-coding-instructions)
- [x] Example: Research Assistant custom style
- [x] Example: Code Mentor custom style
- [x] Comparisons (vs CLAUDE.md, vs --append-system-prompt, vs Agents, vs Slash Commands)

#### Model Configuration
- **Target:** `docs/18-model-configuration.md` (new)
- **Status:** ✅ Created
- **Lines:** ~180

**Sub-tasks completed:**
- [x] Model aliases table (default, sonnet, opus, haiku, sonnet[1m], opusplan)
- [x] opusplan hybrid mode explanation
- [x] Setting model methods (4 ways with priority order)
- [x] Special model behavior (default, extended context [1m])
- [x] Environment variables table (ANTHROPIC_DEFAULT_*_MODEL, CLAUDE_CODE_SUBAGENT_MODEL)
- [x] Prompt caching configuration (DISABLE_PROMPT_CACHING variables)
- [x] Model selection guidelines
- [x] Cost considerations

#### Statusline
- **Target:** `docs/19-statusline.md` (new)
- **Status:** ✅ Created
- **Lines:** ~280

**Sub-tasks completed:**
- [x] Creating statusline via /statusline command
- [x] Settings.json configuration format
- [x] How statusline works (300ms updates, ANSI support)
- [x] Complete JSON input structure documentation
- [x] Available fields table (model, workspace, cost, context_window)
- [x] Simple bash example
- [x] Git-aware bash example
- [x] Python example
- [x] Node.js example
- [x] Helper functions approach
- [x] Context window usage calculation
- [x] Tips and troubleshooting

### Additional Updates
- [x] Updated `docs/01-overview.md` - Added entries for 12, 16-19

---

## Session 5: Agent SDK ✅

**Status:** Complete
**Date:** 2026-01-12

### Topics Covered

#### Topic 18: Agent SDK
- **Target:** `docs/20-agent-sdk.md` (new)
- **Status:** ✅ Created
- **Lines:** ~700

**Sub-tasks completed:**
- [x] Overview and SDK vs CLI comparison
- [x] Installation & setup (TypeScript, Python, API keys)
- [x] Quick start examples in both languages
- [x] TypeScript SDK reference (query function, Options type, Query interface, Message types)
- [x] Python SDK reference (query vs ClaudeSDKClient, ClaudeAgentOptions, Message types, Error types)
- [x] Built-in tools reference table
- [x] Custom tools & MCP integration (tool decorator, createSdkMcpServer)
- [x] Hooks in SDK (events, callback patterns, examples)
- [x] Subagents (AgentDefinition, programmatic definition)
- [x] Sessions & continuity (resume, fork, ClaudeSDKClient multi-turn)
- [x] Permissions & security (canUseTool callbacks, sandbox settings)
- [x] Hosting & deployment (requirements, patterns, providers)
- [x] TypeScript V2 preview (send/stream pattern, unstable API)
- [x] Migration guide (package rename, breaking changes)
- [x] Best practices section

### Additional Updates
- [x] Updated `docs/01-overview.md` - Added entry for 20-agent-sdk.md

---

## Session 6: Prompt Engineering ✅

**Status:** Complete
**Date:** 2026-01-12

### Topics Covered

#### Topic 19: Prompt Engineering
- **Target:** `docs/21-prompt-engineering.md` (new)
- **Status:** ✅ Created
- **Lines:** ~750

**Sub-tasks completed:**
- [x] Introduction and overview
- [x] Be Clear and Direct (golden rule, context, specificity, sequential steps)
- [x] Multishot Prompting (examples, diversity, `<example>` tags)
- [x] Chain of Thought (basic, guided, structured CoT with examples)
- [x] XML Tags (common patterns, nesting, output structure)
- [x] System Prompts / Role Prompting (role patterns, examples)
- [x] Prefill Responses (JSON control, preamble skipping, character maintenance)
- [x] Chain Complex Prompts (subtasks, self-correction chains)
- [x] Long Context Tips (document placement, structure, quote extraction)
- [x] Extended Thinking Tips (when to use, general vs step-by-step, reflection)
- [x] Prompt Generator Tool overview
- [x] Claude Code Application Summary (CLAUDE.md, skills, commands, subagents)
- [x] Anti-Patterns & Troubleshooting guide
- [x] Quick Reference tables (technique selection, component mapping)
- [x] Resources and cross-references

### Additional Updates
- [x] Updated `docs/01-overview.md` - Added entry for 21-prompt-engineering.md

---

## Session 7: Testing & Polish ✅

**Status:** Complete
**Date:** 2026-01-12

### Topics Covered

#### Topic 17: Troubleshooting
- **Target:** `docs/22-troubleshooting.md` (new)
- **Status:** ✅ Created
- **Lines:** ~380

**Sub-tasks completed:**
- [x] Installation issues (Windows/WSL npm detection, nvm conflicts, PATH)
- [x] Linux/Mac native installation instructions
- [x] Windows native (Git Bash requirement, PATH setup)
- [x] Permissions and authentication troubleshooting
- [x] Configuration file locations table
- [x] Managed file locations (macOS, Linux, Windows)
- [x] Reset configuration commands
- [x] Performance and stability (CPU, memory, hangs)
- [x] Search and discovery issues (ripgrep installation)
- [x] WSL disk performance solutions
- [x] IDE integration issues (JetBrains/WSL2 networking)
- [x] Escape key conflicts in JetBrains terminals
- [x] Markdown formatting issues (language tags, spacing)
- [x] Diagnostic commands table (/doctor, /bug, /compact, /logout)
- [x] Getting help section

#### Topic 20: Testing & Evaluation
- **Target:** `docs/23-testing-evaluation.md` (new)
- **Status:** ✅ Created
- **Lines:** ~560

**Sub-tasks completed:**
- [x] Overview and prompt engineering cycle
- [x] SMART criteria framework (Specific, Measurable, Achievable, Relevant)
- [x] Good vs bad criteria examples table
- [x] Common success criteria (task fidelity, consistency, relevance, tone, privacy, context, latency, cost)
- [x] Building evals and test cases design principles
- [x] Edge cases to consider
- [x] Example: Exact match evaluation (sentiment analysis)
- [x] Example: Cosine similarity (consistency)
- [x] Example: ROUGE-L (summarization)
- [x] Example: LLM-based Likert scale (tone)
- [x] Example: LLM-based binary classification (privacy)
- [x] Example: LLM-based ordinal scale (context utilization)
- [x] Grading methods (code-based, human, LLM-based)
- [x] Tips for LLM-based grading
- [x] Claude Code application (hooks, skills, CLAUDE.md, workflow)

#### Final Polish
- [x] Cross-reference all docs for consistency (verified 23 docs, ~90 internal links)
- [x] Verify all internal links work (all `./XX-filename.md` links valid)
- [x] Check template files align with final docs (settings.json, skills, commands verified)
- [x] Updated `docs/01-overview.md` with entries for 22-troubleshooting.md and 23-testing-evaluation.md

### Final Documentation Summary

| Metric | Value |
|--------|-------|
| Total docs | 23 |
| Total lines | ~11,000 |
| Internal cross-references | ~90 |
| New docs this session | 2 |
| Sessions completed | 7/7 |

---

## Notes for Future Sessions

When starting a new session:
1. Read this file first to understand what's done
2. Read `DOCS-UPDATE-GUIDE.md` for the meta-prompt and URL format
3. Copy the meta-prompt into the new session
4. Specify which session/topics to work on
5. After completing work, update this progress file

**URL Format Reminder:** Append `.md` to documentation URLs for cleaner markdown output.
