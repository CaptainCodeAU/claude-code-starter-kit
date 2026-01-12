---
model: opus
context: fork
agent: Plan
description: Audit docs for outdated or inconsistent content
---

# Documentation Audit

Check the `docs/` folder for outdated, inconsistent, or incomplete content.

## Prerequisites

**Load the docs-maintenance skill first** for structure awareness and quality standards.

## Workflow

### Phase 1: Inventory

1. **Load current structure**
   - Read `reference/docs-structure.md` from the skill
   - List all docs in `docs/` folder
   - Note any discrepancies

2. **Gather metadata**
   - Check git history for last modified dates
   - Note file sizes/line counts
   - Identify docs that haven't been updated recently

### Phase 2: Content Audit

3. **Check each doc for:**

   **Currency**
   - When was it last updated?
   - Are there official docs updates since then?
   - Are examples using current syntax/patterns?

   **Completeness**
   - Does it follow quality standards?
   - Are there missing sections (examples, troubleshooting)?
   - Are tables comprehensive?

   **Consistency**
   - Does terminology match other docs?
   - Are cross-references valid?
   - Do formatting patterns match?

   **Template Alignment**
   - Do docs match current `templates/.claude/` files?
   - Are there discrepancies between docs and templates?

4. **Check for broken links**
   - Internal links (`./XX-filename.md`)
   - External links (if any)

### Phase 3: Report

5. **Generate audit report**

   Structure:
   ```
   # Documentation Audit Report

   **Date:** YYYY-MM-DD
   **Total docs:** XX

   ## Summary

   | Status | Count |
   |--------|-------|
   | Current | X |
   | Needs Update | X |
   | Needs Review | X |

   ## Findings

   ### High Priority
   - [File]: Issue description

   ### Medium Priority
   - [File]: Issue description

   ### Low Priority
   - [File]: Issue description

   ## Recommended Actions

   1. Action item
   2. Action item
   ```

### Phase 4: Optional Actions

6. **If user requests fixes:**
   - Create todo list for issues
   - Prioritize by severity
   - Offer to fix specific issues

## What Gets Checked

| Check | Description |
|-------|-------------|
| Last modified | Git history for staleness |
| Structure | Required sections present |
| Examples | Code blocks present and valid |
| Tables | Configuration options documented |
| Cross-refs | Internal links valid |
| Template sync | Docs match templates/ |
| Quality | Follows quality-standards.md |

## Output Options

After audit, you can:
1. **Just report** — See the findings
2. **Create todos** — Generate fix list
3. **Fix issues** — Address specific findings (will track sub-tasks)

## Example Findings

- "02-hooks.md: Last updated 2026-01-12, official docs updated since"
- "05-settings.md: Missing `apiProvider` field documentation"
- "Link to ./15-checkpoints.md should be ./15-checkpointing.md"
- "templates/.claude/settings.json has fields not documented in 05-settings.md"
