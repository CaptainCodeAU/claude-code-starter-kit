# Function Modification Safety Protocol

**CRITICAL: Before modifying ANY function, you MUST search for all callers first.**

## Required Steps

1. **Search for callers**: `grep -r "function_name(" . --include="*.ext"`
2. **Analyze each call site**: Read context, verify expectations
3. **Impact assessment**: List affected callers, explain impact
4. **Only then propose changes**: If breaking, propose alternatives

## Red Flags (Extra Scrutiny Required)

- Utility/helper functions (many callers)
- Generic names (`create_*`, `setup_*`, `update_*`)
- Functions in shared/common files
- Functions modifying global state or files

## Shell Functions (ESPECIALLY CRITICAL)

For shell functions (`.zsh_*`, `.bashrc`, etc.):
- No type system to catch breaks
- Silent failures common
- Check if sourced elsewhere
- Verify argument patterns match across callers

## Principles

1. **Understand before changing** - Never modify code you don't fully understand
2. **Search before refactoring** - Find all usages first
3. **Preserve behavior** - Maintain existing contracts unless explicitly changing
4. **Create over modify** - When in doubt, create new function
5. **Verify exhaustively** - Check every caller, every time

**When in doubt, ASK before modifying shared functions.**
