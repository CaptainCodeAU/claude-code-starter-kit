---
model: opus
context: fork
agent: Plan
description: Update docs from official Claude documentation
argument-hint: [--dry-run|--draft] URL or file path
---

# Documentation Sync

Update the `docs/` folder with content from official Claude documentation.

## Prerequisites

**Load the docs-maintenance skill first** for quality standards and structure awareness.

## Your Input

You've been given: `$ARGUMENTS`

### Arguments

| Argument | Description |
|----------|-------------|
| `--dry-run` | Show what would change without making any edits |
| `--draft` | Create alternate file with `.draft.md` suffix instead of updating original |
| (none) | Normal mode — update the target file directly |

### Input Sources

- URLs to official Claude documentation (append `.md` suffix if missing)
- File paths to downloaded markdown files

### Examples

```bash
# Normal update
/docs-sync https://code.claude.com/docs/en/hooks.md

# Preview changes without editing
/docs-sync --dry-run https://code.claude.com/docs/en/hooks.md

# Create draft for comparison
/docs-sync --draft https://code.claude.com/docs/en/hooks.md
# Creates: docs/02-hooks.draft.md (original untouched)
```

## Mode Behaviors

### Normal Mode (default)

Updates the target file directly, appends changelog entry.

### Dry-Run Mode (`--dry-run`)

1. Performs all analysis (fetch, compare, plan)
2. Shows detailed report of what WOULD change:
   - Sections to add
   - Content to update
   - Line count changes
3. **Does NOT edit any files**
4. **Does NOT append to changelog**

Output format:
```
## Dry-Run Report: XX-filename.md

**Source:** [URL]
**Current lines:** ~XXX
**Estimated after:** ~YYY

### Changes that would be made:

- [ ] Add section: "New Feature X"
- [ ] Update section: "Configuration" (outdated fields)
- [ ] Add examples for Y
- [ ] Update troubleshooting

To apply these changes, run without --dry-run flag.
```

### Draft Mode (`--draft`)

1. Performs full update workflow
2. Creates new file: `docs/XX-filename.draft.md`
3. Original file remains untouched
4. **Does NOT append to changelog** (until draft is accepted)

After creating draft:
```
Draft created: docs/02-hooks.draft.md

To compare:
  diff docs/02-hooks.md docs/02-hooks.draft.md

To accept draft:
  mv docs/02-hooks.draft.md docs/02-hooks.md
  # Then manually add changelog entry or run /docs-sync again
```

## Workflow

### Phase 1: Preparation

1. **Parse arguments**
   - Check for `--dry-run` or `--draft` flags
   - Extract URL(s) or file path(s)

2. **Fetch source content**
   - For URLs: Use WebFetch (ensure `.md` suffix)
   - For files: Read the file content
   - If fetch fails, ask user to paste content

3. **Identify target doc**
   - Determine which `docs/XX-*.md` file this content belongs in
   - If new topic, propose next available number

4. **Read existing doc thoroughly**
   - Load the full target doc
   - Understand its current structure
   - Note existing sections and organization

### Phase 2: Planning

5. **Analyze gaps and updates**
   - What's new in the source that's missing from our doc?
   - What's outdated in our doc?
   - What structure changes are needed?

6. **Create update plan**
   - List specific sections to add/update
   - Note where new content will be inserted
   - Ensure structure is preserved

7. **Present plan for approval**
   - Show what will change
   - **If `--dry-run`:** Stop here, output report, done
   - Otherwise: Get user confirmation before proceeding

### Phase 3: Execution

8. **Apply incremental updates**
   - **If `--draft`:** Write to `XX-filename.draft.md`
   - **Otherwise:** Update original file
   - Add new sections in appropriate locations
   - Update outdated content
   - Preserve existing structure
   - Track each change as a sub-task

9. **Update ancillary files if needed** (skip if `--draft`)
   - `docs/01-overview.md` — if adding new doc
   - `templates/` files — if conventions changed

### Phase 4: Documentation

10. **Append changelog entry** (skip if `--dry-run` or `--draft`)
    - Add entry to `docs/CHANGELOG.md`
    - Include all sub-tasks tracked during execution
    - Format per skill guidelines

## Quality Checklist

Before completing (normal mode only):
- [ ] Existing structure preserved
- [ ] New content follows quality standards
- [ ] Examples included where appropriate
- [ ] Tables used for configuration options
- [ ] Cross-references added where relevant
- [ ] Changelog entry appended with sub-tasks

## Example Sub-tasks

When tracking changes, note specifics like:
- "Added OAuth 2.0 authentication section"
- "Updated hook events table with new PreCompact event"
- "Added troubleshooting section for common errors"
- "Expanded examples with Python code snippets"
