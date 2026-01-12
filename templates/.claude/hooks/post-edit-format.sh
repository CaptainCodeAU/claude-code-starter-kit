#!/usr/bin/env bash
# Post-edit formatting hook - auto-formats files after Claude edits

FILE="$1"
[[ -z "$FILE" || ! -f "$FILE" ]] && exit 0

EXT="${FILE##*.}"

case "$EXT" in
    py)
        # Python - use ruff (preferred) or black
        if command -v ruff &>/dev/null; then
            ruff format "$FILE" 2>/dev/null
            ruff check --fix "$FILE" 2>/dev/null
        elif command -v black &>/dev/null; then
            black "$FILE" 2>/dev/null
        fi
        ;;
    js|jsx|ts|tsx)
        # JavaScript/TypeScript - use prettier
        if command -v prettier &>/dev/null; then
            prettier --write "$FILE" 2>/dev/null
        fi
        ;;
    json)
        # JSON - use prettier
        if command -v prettier &>/dev/null; then
            prettier --write "$FILE" 2>/dev/null
        fi
        ;;
    md)
        # Markdown - use prettier
        if command -v prettier &>/dev/null; then
            prettier --write "$FILE" 2>/dev/null
        fi
        ;;
    sh|bash|zsh)
        # Shell scripts - use shfmt
        if command -v shfmt &>/dev/null; then
            shfmt -w -i 4 "$FILE" 2>/dev/null
        fi
        ;;
    yaml|yml)
        # YAML - use prettier
        if command -v prettier &>/dev/null; then
            prettier --write "$FILE" 2>/dev/null
        fi
        ;;
esac

exit 0
