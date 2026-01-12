---
model: opus
context: fork
agent: Plan
description: Update docs from official Claude documentation
argument-hint: [URL or file path]
---

# Documentation Sync

Update the `docs/` folder with content from official Claude documentation.

## Prerequisites

**Load the docs-maintenance skill first** for quality standards and structure awareness.

## Your Input

You've been given: `$ARGUMENTS`

This should be one or more:
- URLs to official Claude documentation (append `.md` suffix if missing)
- File paths to downloaded markdown files

## Workflow

### Phase 1: Preparation

1. **Fetch source content**
   - For URLs: Use WebFetch (ensure `.md` suffix)
   - For files: Read the file content
   - If fetch fails, ask user to paste content

2. **Identify target doc**
   - Determine which `docs/XX-*.md` file this content belongs in
   - If new topic, propose next available number

3. **Read existing doc thoroughly**
   - Load the full target doc
   - Understand its current structure
   - Note existing sections and organization

### Phase 2: Planning

4. **Analyze gaps and updates**
   - What's new in the source that's missing from our doc?
   - What's outdated in our doc?
   - What structure changes are needed?

5. **Create update plan**
   - List specific sections to add/update
   - Note where new content will be inserted
   - Ensure structure is preserved

6. **Present plan for approval**
   - Show what will change
   - Get user confirmation before proceeding

### Phase 3: Execution

7. **Apply incremental updates**
   - Add new sections in appropriate locations
   - Update outdated content
   - Preserve existing structure
   - Track each change as a sub-task

8. **Update ancillary files if needed**
   - `docs/01-overview.md` — if adding new doc
   - `templates/` files — if conventions changed

### Phase 4: Documentation

9. **Append changelog entry**
   - Add entry to `docs/CHANGELOG.md`
   - Include all sub-tasks tracked during execution
   - Format per skill guidelines

## Quality Checklist

Before completing:
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
