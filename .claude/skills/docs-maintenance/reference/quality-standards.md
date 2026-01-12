# Documentation Quality Standards

Standards for updating and creating documentation in the starter kit.

## Content Requirements

### Examples

- **Always include practical examples** from official documentation
- Show complete, runnable code snippets
- Include both simple and advanced usage
- Show configuration before/after when relevant

### Tables

Use tables for:
- Configuration options with fields, types, defaults, descriptions
- Command/flag references
- Feature comparisons
- Field references with all available options

### Comprehensiveness

- Cover ALL fields, options, and edge cases
- Document default values explicitly
- Note required vs optional fields
- Include deprecated options with migration paths

### Troubleshooting

Each doc should include:
- Common issues and solutions
- Error messages and their meanings
- Debug/diagnostic approaches
- Links to related troubleshooting

### Token Efficiency

This project cares about context window usage:
- Note token costs where relevant
- Document startup vs on-demand loading
- Explain lazy-loading behavior
- Include optimization tips

### Cross-References

- Link to related docs within the collection
- Use relative paths: `./XX-filename.md`
- Don't duplicate content; reference instead
- Note when topics overlap

## Formatting Standards

### Headers

```markdown
# Doc Title (H1 - one per file)

## Major Section (H2)

### Subsection (H3)

#### Detail (H4 - use sparingly)
```

### Code Blocks

Always specify language:
```yaml
---
field: value
---
```

```bash
# Command example
command --flag value
```

```python
# Python example
def function():
    pass
```

### Tables

```markdown
| Field | Type | Default | Description |
|-------|------|---------|-------------|
| name | string | required | The name |
```

### Callouts

Use blockquotes for important notes:
```markdown
> **Note:** Important information here.

> **Warning:** Critical warning here.
```

## Structure Template

```markdown
# Topic Name

Brief introduction (1-2 sentences).

## Overview

What this is, when to use it.

## Quick Start

Minimal working example.

## Configuration Reference

| Field | Type | Default | Description |
|-------|------|---------|-------------|

## Examples

### Basic Example

### Advanced Example

## Troubleshooting

### Common Issue 1

**Problem:** Description
**Solution:** Fix

## See Also

- [Related Doc](./XX-related.md)
```

## What NOT to Include

- Marketing language or superlatives
- Speculation about future features
- Content not in official docs (unless clearly marked as project-specific)
- Duplicate content (cross-reference instead)
- Overly verbose explanations (Claude knows common concepts)
