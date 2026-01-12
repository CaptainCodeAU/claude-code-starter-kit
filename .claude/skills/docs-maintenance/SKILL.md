---
name: docs-maintenance
description: Maintains starter kit documentation. Quality standards, incremental update patterns, structure awareness. Internal skill for docs-sync, docs-refine, and docs-audit commands.
user-invocable: false
---

# Documentation Maintenance

Internal skill for maintaining the `docs/` folder in claude-code-starter-kit.

## Core Principles

### 1. Read Before Write (Critical)

**Never modify a doc without first reading it thoroughly.**

Before any update:
1. Read the existing doc completely
2. Understand its structure and organization
3. Identify what sections exist
4. Plan incremental changes that preserve structure

### 2. Incremental Updates

Updates should ADD to existing content, not replace it:
- Preserve existing section structure
- Add new sections in appropriate locations
- Update existing content where it's outdated
- Never delete content unless explicitly requested

### 3. Quality Standards

See [reference/quality-standards.md](reference/quality-standards.md) for detailed criteria.

**Summary:**
- Include practical examples from official docs
- Use tables for configuration options and field references
- Be comprehensive (all fields, options, edge cases)
- Add troubleshooting sections
- Note token efficiency implications
- Cross-reference related docs

## URL Handling

**Always append `.md` suffix to documentation URLs:**

```
# Correct
https://code.claude.com/docs/en/hooks.md

# Incorrect
https://code.claude.com/docs/en/hooks
```

**URL patterns:**
- Claude Code: `code.claude.com/docs/en/{topic}.md`
- Platform/API: `platform.claude.com/docs/en/{category}/{topic}.md`
- Index of all pages: `code.claude.com/docs/llms.txt`

## Docs Structure

See [reference/docs-structure.md](reference/docs-structure.md) for current organization.

## Changelog Integration

After completing updates, append an entry to `docs/CHANGELOG.md`:

```markdown
## YYYY-MM-DD: Brief Description

**Source:** [URL or file path]

### filename.md — Created/Updated

**Lines:** ~XXX (or **Before:** ~XXX | **After:** ~YYY for updates)

Sub-tasks completed:
- [x] What was added or changed
- [x] Another specific change
```

**Track sub-tasks during execution** — note each significant change as you make it, then include all sub-tasks in the changelog entry.

## Workflow for Updates

### For Official Doc Updates (/docs-sync)

1. Receive URL(s) or file path(s)
2. Fetch source content (append `.md` to URLs)
3. Read existing target doc thoroughly
4. Identify gaps and outdated content
5. Plan incremental changes
6. Execute updates preserving structure
7. Append changelog entry with sub-tasks

### For Best Practices Synthesis (/docs-refine)

1. Receive article/commentary URL(s) or file(s)
2. Analyze content for actionable guidelines
3. Discuss with user to refine
4. Determine target location (docs/ or templates/)
5. Create or update target file
6. Append changelog entry with sub-tasks

### For Audits (/docs-audit)

1. Load docs-structure.md for current state
2. Check each doc for:
   - Currency (when last updated vs source)
   - Broken or outdated links
   - Inconsistencies with templates/
   - Missing cross-references
3. Generate audit report
4. Optionally create fix list

## Edge Cases

- **Large topics**: Consider splitting across multiple docs or focused subsections
- **Overlapping content**: Cross-reference rather than duplicate
- **Beta features**: Note version sensitivity
- **Platform differences**: Note CLI vs API vs claude.ai differences
