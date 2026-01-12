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

## UV/NVM Integration Patterns

### Python Version Helper

```bash
# Get path to UV-managed Python
get_uv_python_path() {
    local version_prefix=$1
    uv python list 2>/dev/null | \
        awk -v prefix="cpython-${version_prefix}." -v home="$HOME" \
            '$1 ~ "^" prefix && $2 ~ /^[\/\.]/ {
                path = $2
                if (substr(path, 1, 1) == ".") { path = home "/" path }
                print path
            }' | sort -V | tail -n 1
}

# Usage
local python_path=$(get_uv_python_path 3.13)
if [[ -z "$python_path" ]]; then
    echo "Python 3.13 not installed via uv" >&2
    return 1
fi
```

### NVM Auto-Switch

```bash
# Automatically switch Node version based on .nvmrc
load-nvmrc() {
    local nvmrc_path="$(nvm_find_nvmrc)"
    if [ -n "$nvmrc_path" ]; then
        local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")
        if [ "$nvmrc_node_version" != "$(nvm version)" ]; then
            nvm use --silent
        fi
    elif [ "$(nvm version)" != "$(nvm version default)" ]; then
        nvm use default --silent
    fi
}
# Hook into directory change
add-zsh-hook chpwd load-nvmrc
```

### Cross-Platform Considerations

```bash
# Detect OS for conditional logic
case "$(uname -s)" in
    Darwin)
        IS_MAC=true
        # macOS-specific paths
        HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-/opt/homebrew}"
        ;;
    Linux)
        if [[ "$(uname -r)" =~ [Ww][Ss][Ll] ]]; then
            IS_WSL=true
            # WSL-specific: NTFS doesn't support symlinks well
            export UV_LINK_MODE=copy
        else
            IS_LINUX=true
        fi
        ;;
esac
```

### direnv Integration

```bash
# Create .envrc for automatic venv activation
create_envrc() {
    if [[ -f ".envrc" ]]; then
        echo ".envrc already exists. (Skipping)"
        return
    fi

    cat <<'EOF' > .envrc
if [[ -d ".venv" ]]; then
    export VIRTUAL_ENV_PROMPT="($(basename "$PWD"))"
    source .venv/bin/activate
fi
EOF
    direnv allow .
    echo "Created .envrc with venv activation"
}
```

### Venv Creation Pattern

```bash
# Create venv with UV using specific Python version
create_venv() {
    local python_version=${1:-"3.13"}
    local python_path=$(get_uv_python_path "$python_version")

    if [[ -z "$python_path" ]]; then
        echo "Installing Python $python_version via uv..."
        uv python install "python@$python_version"
        python_path=$(get_uv_python_path "$python_version")
    fi

    echo "Creating .venv with Python $python_version..."
    uv venv --prompt "$(basename "$PWD")" -p "$python_path"
}
```

### Project Setup Wrapper

```bash
# Full Python project setup
python_setup() {
    local python_version=${1:-"3.13"}
    local extras=${2:-""}  # e.g., "dev" or "dev,cli"

    # Validate we're in a project directory
    if [[ ! -f "pyproject.toml" ]]; then
        echo "No pyproject.toml found" >&2
        return 1
    fi

    # Create venv if missing
    if [[ ! -d ".venv" ]]; then
        create_venv "$python_version"
    fi

    # Install dependencies
    if [[ -n "$extras" ]]; then
        uv pip install --prerelease=allow -e ".[$extras]"
    else
        uv pip install --prerelease=allow -e .
    fi

    # Setup direnv
    create_envrc

    echo "Project setup complete"
}
