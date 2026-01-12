#!/usr/bin/env bash
# Pre-commit validation hook - runs checks before git commits

ERRORS=0

# Python checks
if [[ -f "pyproject.toml" ]]; then
    echo "Checking Python..."
    if command -v ruff &>/dev/null; then
        if ! ruff check . --quiet; then
            echo "⚠ Ruff found issues. Run: uv run ruff check --fix ."
            ERRORS=$((ERRORS + 1))
        fi
    fi
    if command -v mypy &>/dev/null && [[ -d "src" ]]; then
        if ! mypy src --quiet 2>/dev/null; then
            echo "⚠ Mypy found type errors"
            ERRORS=$((ERRORS + 1))
        fi
    fi
fi

# Node checks
if [[ -f "package.json" ]]; then
    echo "Checking Node.js..."
    if [[ -f "tsconfig.json" ]]; then
        if command -v pnpm &>/dev/null; then
            if ! pnpm tsc --noEmit 2>/dev/null; then
                echo "⚠ TypeScript found errors"
                ERRORS=$((ERRORS + 1))
            fi
        fi
    fi
    # ESLint check
    if [[ -f ".eslintrc.json" || -f ".eslintrc.js" || -f "eslint.config.js" ]]; then
        if command -v pnpm &>/dev/null; then
            if ! pnpm eslint . --quiet 2>/dev/null; then
                echo "⚠ ESLint found issues"
                ERRORS=$((ERRORS + 1))
            fi
        fi
    fi
fi

if [[ $ERRORS -gt 0 ]]; then
    echo "Pre-commit: $ERRORS issue(s) found"
fi

exit 0
