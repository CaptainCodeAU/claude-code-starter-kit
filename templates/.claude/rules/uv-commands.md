# UV Command Policy

**ALWAYS use `uv` commands instead of direct Python/pip commands.**

## Command Replacements

| Wrong | Correct |
|-------|---------|
| `python script.py` | `uv run python script.py` |
| `pip install pkg` | `uv pip install pkg` |
| `python -m pytest` | `uv run pytest` |
| `python -c "..."` | `uv run python -c "..."` |
| `pip freeze` | `uv pip freeze` |

## Rationale

- Direct `python` may use wrong interpreter or venv
- `uv` ensures correct Python version and virtual environment
- Consistent across all projects and machines

## This Applies To

- All Python script execution
- All package installations
- All test running
- All Python one-liners (`-c` flag)
- All module execution (`-m` flag)

**No exceptions. Always use `uv`.**
