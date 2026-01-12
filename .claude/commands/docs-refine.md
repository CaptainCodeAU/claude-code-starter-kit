---
model: opus
context: fork
agent: Plan
description: Synthesize best practices from articles into guidelines
argument-hint: [URL or file path]
---

# Documentation Refine

Synthesize best practices, methodologies, or commentary into actionable guidelines.

## Prerequisites

**Load the docs-maintenance skill first** for quality standards and structure awareness.

## Your Input

You've been given: `$ARGUMENTS`

This should be one or more:
- URLs to articles, blog posts, or commentary about Claude Code
- File paths to downloaded content
- Topics to research and synthesize

## What This Command Is For

Unlike `/docs-sync` which updates from official docs, this command handles:
- Best practices articles
- Community methodologies
- Expert commentary
- "Layer on top" guidance that enhances official features

**Examples:**
- Guidelines for writing effective CLAUDE.md files
- Best practices for structuring skills
- Patterns for effective hook usage
- Methodologies for prompt engineering in Claude Code context

## Workflow

### Phase 1: Content Analysis

1. **Fetch source content**
   - For URLs: Use WebFetch
   - For files: Read the file content
   - If fetch fails, ask user to paste content

2. **Analyze the content**
   - What actionable guidance does it contain?
   - What's the core methodology or pattern?
   - How does it relate to existing docs/templates?

3. **Summarize key insights**
   - Present main points to user
   - Identify what's most valuable

### Phase 2: Interactive Refinement

4. **Discuss with user**
   - Which insights are most relevant?
   - What should be emphasized?
   - Are there project-specific adaptations needed?

5. **Determine target location**
   - Should this go in `docs/`? (reference material)
   - Should this go in `templates/`? (applied to templates)
   - Should this be a new file or update existing?

6. **Draft the guideline**
   - Create structured, actionable content
   - Follow quality standards from skill

7. **Review with user**
   - Present draft for feedback
   - Iterate until satisfied

### Phase 3: Implementation

8. **Create or update target file**
   - Apply the refined guideline
   - Preserve existing structure if updating
   - Track changes as sub-tasks

9. **Update related files if needed**
   - Cross-reference from related docs
   - Update index if new doc added

### Phase 4: Documentation

10. **Append changelog entry**
    - Add entry to `docs/CHANGELOG.md`
    - Note this is from commentary/best practices (not official)
    - Include all sub-tasks

## Quality Checklist

Before completing:
- [ ] Content is actionable, not just informational
- [ ] Clearly marked if not from official sources
- [ ] Follows project quality standards
- [ ] User has reviewed and approved
- [ ] Changelog entry appended with sub-tasks

## Example Outputs

This command might produce:
- A new section in an existing doc
- A new best practices guide
- Updates to template files based on guidelines
- A methodology document in docs/
