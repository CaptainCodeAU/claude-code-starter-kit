---
name: developing-shell-functions
description: Best practices for shell function development in .zsh_*, .bashrc, and similar files. Use when writing, modifying, or debugging shell functions, aliases, or scripts.
---

# Shell Function Development Best Practices

## When to Use

Apply this skill when working with:
- `.zsh_*` files (e.g., `.zsh_functions`, `.zsh_aliases`)
- `.bashrc`, `.bash_profile`, `.bash_aliases`
- Any shell script with reusable functions

## Comment Style

### Section markers
```bash
# --- Section Name ---
```

### Inline clarification
```bash
local var=$1  # e.g., 3.13
```

### Explain "why" not "what"
```bash
# BAD - explains what (obvious)
local project_name=$(basename "$PWD")  # Get basename of current directory

# GOOD - self-explanatory, no comment needed
local project_name=$(basename "$PWD")
```

## Variable Scope

### Always use `local` for function variables
```bash
my_function() {
    local req_python_version=$1  # e.g., 3.13
    local project_name=$(basename "$PWD")
    local python_interpreter_path=""
}
```

### Validate inputs
```bash
if [[ -z "$req_python_version" ]]; then
    echo "Error: Python version is required." >&2
    return 1
fi
```

## Error Handling

### Check if commands exist
```bash
if ! command -v uv &> /dev/null; then
    echo "Error: 'uv' command not found." >&2
    echo "Please install uv first: https://github.com/astral-sh/uv" >&2
    return 1
fi
```

### Provide helpful error messages
```bash
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to create virtual environment." >&2
    echo "Try running: uv python install ${req_python_version}" >&2
    return 1
fi
```

### Return appropriate exit codes
```bash
return 0  # Success
return 1  # Failure
```

## File Operations

### Check before creating
```bash
if [[ ! -f ".envrc" ]]; then
    echo "Creating .envrc..."
else
    echo ".envrc already exists. (Skipping)"
    return
fi
```

### Use heredocs for multi-line content
```bash
cat << EOF > filename
Line 1
Line 2
EOF
```

### Consider operation order
Some tools create files automatically. Create your files first if needed:
```bash
# Create .gitignore BEFORE uv init (which would create its own)
create_gitignore
uv init --no-readme --python "${req_python_version}"
```

## Function Header Format

```bash
# Function to do something with description
# Usage: function_name <arg1> <arg2> [optional_arg]
# Creates/modifies/manages something specific
function_name() {
    local arg1=$1  # e.g., 3.13
    local arg2=${2:-"default"}  # Optional with default

    # Function body
}
```

## Common Pitfalls

1. **Assuming file doesn't exist** - Always check before creating
2. **Wrong venv detection** - Verify which Python/venv is actually being used
3. **Skipping caller analysis** - NEVER modify shared functions without checking callers
4. **Inconsistent command usage** - Always use `uv` commands
5. **File creation order matters** - Create files in correct sequence
