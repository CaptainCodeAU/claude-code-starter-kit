# Documentation Update Progress

Tracks progress across documentation update sessions. See [DOCS-UPDATE-GUIDE.md](./DOCS-UPDATE-GUIDE.md) for the master plan, URLs, and meta-prompt.

---

## Quick Status

| Session | Description | Status | Completed |
|---------|-------------|--------|-----------|
| 1 | Core Configuration | ✅ Done | 2026-01-12 |
| 2 | Extensibility | ⏳ Pending | - |
| 3 | Advanced Features | ⏳ Pending | - |
| 4 | UI & CLI | ⏳ Pending | - |
| 5 | Agent SDK | ⏳ Pending | - |
| 6 | Prompt Engineering | ⏳ Pending | - |
| 7 | Testing & Polish | ⏳ Pending | - |

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

## Session 2: Extensibility ⏳

**Status:** Pending

### Topics to Cover

#### Topic 2: Subagents
- **Target:** `docs/09-subagents.md` (new)
- **URL:** `code.claude.com/docs/en/subagents.md`
- **Status:** ⏳ Pending

#### Topic 3: Slash Commands
- **Target:** `docs/10-slash-commands.md` (new)
- **URL:** `code.claude.com/docs/en/slash-commands.md`
- **Status:** ⏳ Pending

#### Topic 6: Plugins
- **Target:** `docs/06-plugins.md` (expand existing)
- **URL:** `code.claude.com/docs/en/plugins.md`
- **Status:** ⏳ Pending

---

## Session 3: Advanced Features ⏳

**Status:** Pending

### Topics to Cover

#### Topic 7: MCP
- **Target:** `docs/11-mcp.md` (new)
- **URLs:**
  - `code.claude.com/docs/en/mcp.md`
  - `code.claude.com/docs/en/mcp-guide.md`
- **Status:** ⏳ Pending

#### Topic 10: Headless Mode
- **Target:** `docs/13-headless-mode.md` (new)
- **URL:** `code.claude.com/docs/en/headless.md`
- **Status:** ⏳ Pending

#### Topic 11: GitHub Actions
- **Target:** `docs/14-github-actions.md` (new)
- **URL:** `code.claude.com/docs/en/github-actions.md`
- **Status:** ⏳ Pending

#### Topic 12: Checkpointing
- **Target:** TBD
- **URL:** `code.claude.com/docs/en/checkpointing.md`
- **Status:** ⏳ Pending

---

## Session 4: UI & CLI ⏳

**Status:** Pending

### Topics to Cover

#### Topic 9: CLI Reference
- **Target:** `docs/12-cli-reference.md` (new)
- **URL:** `code.claude.com/docs/en/cli.md`
- **Status:** ⏳ Pending

#### Topic 13: Interactive Mode
- **Target:** TBD
- **URL:** `code.claude.com/docs/en/interactive-mode.md`
- **Status:** ⏳ Pending

#### Topic 14: Terminal Config
- **Target:** TBD
- **URL:** `code.claude.com/docs/en/terminal.md`
- **Status:** ⏳ Pending

#### Topic 8: Output Styles
- **Target:** TBD
- **URL:** `code.claude.com/docs/en/output-styles.md`
- **Status:** ⏳ Pending

#### Topic 15: Model Config
- **Target:** TBD
- **URL:** `code.claude.com/docs/en/model-configuration.md`
- **Status:** ⏳ Pending

#### Topic 16: Statusline
- **Target:** TBD
- **URL:** `code.claude.com/docs/en/statusline.md`
- **Status:** ⏳ Pending

---

## Session 5: Agent SDK ⏳

**Status:** Pending

### Topics to Cover

#### Topic 18: Agent SDK
- **Target:** `docs/15-agent-sdk.md` (new, large)
- **URLs:**
  - `platform.claude.com/docs/en/agent-sdk/overview.md`
  - `platform.claude.com/docs/en/agent-sdk/quickstart.md`
  - `platform.claude.com/docs/en/agent-sdk/typescript.md`
  - `platform.claude.com/docs/en/agent-sdk/typescript-v2-preview.md`
  - `platform.claude.com/docs/en/agent-sdk/python.md`
  - `platform.claude.com/docs/en/agent-sdk/migration-guide.md`
  - `platform.claude.com/docs/en/agent-sdk/hosting.md`
- **Status:** ⏳ Pending

---

## Session 6: Prompt Engineering ⏳

**Status:** Pending

### Topics to Cover

#### Topic 19: Prompt Engineering
- **Target:** `docs/16-prompt-engineering.md` (new, large)
- **URLs:**
  - `platform.claude.com/docs/en/prompt-engineering/overview.md`
  - `platform.claude.com/docs/en/prompt-engineering/key-techniques.md`
  - `platform.claude.com/docs/en/prompt-engineering/thinking.md`
  - `platform.claude.com/docs/en/prompt-engineering/multimodal.md`
  - `platform.claude.com/docs/en/prompt-engineering/agentic.md`
  - `platform.claude.com/docs/en/prompt-engineering/tool-use.md`
  - `platform.claude.com/docs/en/prompt-engineering/citations.md`
  - `platform.claude.com/docs/en/prompt-engineering/prompt-caching.md`
  - `platform.claude.com/docs/en/prompt-engineering/prompt-improver.md`
- **Status:** ⏳ Pending

---

## Session 7: Testing & Polish ⏳

**Status:** Pending

### Topics to Cover

#### Topic 17: Troubleshooting
- **Target:** `docs/18-troubleshooting.md` (new)
- **URL:** `code.claude.com/docs/en/troubleshooting.md`
- **Status:** ⏳ Pending

#### Topic 20: Testing & Evaluation
- **Target:** `docs/17-testing-evaluation.md` (new)
- **URLs:**
  - `platform.claude.com/docs/en/testing/overview.md`
  - `platform.claude.com/docs/en/testing/eval-tool.md`
- **Status:** ⏳ Pending

#### Final Polish
- [ ] Cross-reference all docs for consistency
- [ ] Verify all internal links work
- [ ] Check template files align with final docs
- [ ] Review token efficiency claims

---

## Notes for Future Sessions

When starting a new session:
1. Read this file first to understand what's done
2. Read `DOCS-UPDATE-GUIDE.md` for the meta-prompt and URL format
3. Copy the meta-prompt into the new session
4. Specify which session/topics to work on
5. After completing work, update this progress file

**URL Format Reminder:** Append `.md` to documentation URLs for cleaner markdown output.
