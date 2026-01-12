#!/usr/bin/env bash
# Session start hook - environment checks

# Detect project type
PROJECT_TYPE="unknown"
[[ -f "pyproject.toml" ]] && PROJECT_TYPE="python"
[[ -f "package.json" ]] && PROJECT_TYPE="node"
[[ -f "pyproject.toml" && -f "package.json" ]] && PROJECT_TYPE="fullstack"

# Python checks
if [[ "$PROJECT_TYPE" == "python" || "$PROJECT_TYPE" == "fullstack" ]]; then
    if [[ -d ".venv" ]]; then
        echo "✓ .venv exists"
    else
        echo "⚠ No .venv directory. Run: python_setup <version>"
    fi
    [[ -f "uv.lock" ]] && echo "✓ uv.lock present"
    [[ -f ".python-version" ]] && echo "✓ Python version: $(cat .python-version)"
fi

# Node checks
if [[ "$PROJECT_TYPE" == "node" || "$PROJECT_TYPE" == "fullstack" ]]; then
    if [[ -f ".nvmrc" ]]; then
        echo "✓ .nvmrc: $(cat .nvmrc)"
    else
        echo "⚠ No .nvmrc file for Node version pinning"
    fi
    if [[ -d "node_modules" ]]; then
        echo "✓ node_modules exists"
    else
        echo "⚠ No node_modules. Run: pnpm install"
    fi
fi

# Git status
if [[ -d ".git" ]]; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    CHANGES=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    echo "✓ Git branch: $BRANCH ($CHANGES uncommitted changes)"
fi

exit 0
