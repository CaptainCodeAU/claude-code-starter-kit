# Inventory Command

Run a stock-take of all Claude Code configuration components in the `templates/` folder.

## Instructions

Scan the `templates/.claude/` folder and report on:

### 1. Hooks
List all files in `templates/.claude/hooks/`. For each file, show:
- Filename
- Status: "Stub" if only contains comments and `exit 0`, otherwise "Implemented"

### 2. Rules
List all `.md` files in `templates/.claude/rules/`. If empty, say "None".

### 3. Skills
List all folders in `templates/.claude/skills/`. For each, check if `SKILL.md` exists. If empty, say "None".

### 4. CLAUDE.md Templates
List all `CLAUDE*.md` files in `templates/.claude/`. Indicate which is the base template vs project-specific.

### 5. Settings Files
List `settings.json` and note if it has actual configuration or just empty arrays.

### 6. Summary
Provide counts:
- Total hooks (implemented vs stub)
- Total rules
- Total skills
- Total CLAUDE.md templates

### 7. Missing (Referenced but not created)
Cross-reference with `README.md` and `TEMPLATE-GUIDE.md` to identify anything mentioned but not yet created.

## Output Format

Use a clean markdown table format for each section. Be concise.
