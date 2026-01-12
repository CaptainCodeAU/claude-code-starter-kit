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

## Advanced Patterns

### Virtual Environment Creation

```bash
# Create venv with specific Python version
uv venv --prompt "$(basename "$PWD")" -p "$(get_uv_python_path 3.13)"

# Create venv with default Python
uv venv
```

### Editable Install with Extras

```bash
# Install project with dev dependencies
uv pip install --prerelease=allow -e '.[dev]'

# Install with multiple extras
uv pip install --prerelease=allow -e '.[dev,cli]'
```

### Python Version Management

```bash
# List installed Python versions
uv python list

# Install a specific Python version
uv python install python@3.13

# Find path to UV-managed Python
get_uv_python_path 3.13  # Shell function from .zsh_python_functions
```

### Sync Dependencies

```bash
# Sync from lock file
uv sync

# Sync with dev dependencies
uv sync --dev
```

### Adding Dependencies

```bash
# Add runtime dependency
uv add <package>

# Add dev dependency
uv add --dev <package>
```
