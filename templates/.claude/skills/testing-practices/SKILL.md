---
name: testing-python
description: Test isolation, venv verification, and proper uv command usage for Python testing. Use when writing, running, or debugging Python tests.
---

# Python Testing Best Practices

## When to Use

Apply this skill when:
- Writing or running Python tests
- Debugging test failures
- Setting up test environments
- Verifying test isolation

## Test Isolation

### 1. Verify Active Environment

```bash
# Check which Python is being used
which python

# Verify correct venv is active
echo $VIRTUAL_ENV

# Be aware of direnv auto-activation
```

### 2. Use Isolated Test Directories

- Test outside of direnv-managed directories when needed
- Clean test directory before starting
- Use `/tmp/` for truly isolated tests
- Avoid testing in directories with existing `.envrc` files

### 3. Consistent Command Usage

```bash
# WRONG - May use wrong venv
python -m pytest

# CORRECT - Ensures project venv
uv run pytest
```

### 4. Verification Steps

- Actually import and run generated code
- Don't just check if tests pass
- Verify the correct modules are being imported
- Check which venv was actually used

## File Naming Conventions

### Test Files

- `test_main.py` - Acceptable for comprehensive test suite
- Not required to match module names exactly
- Focus on what's being tested, not internal structure

### Why test_main.py is acceptable

- Tests the "main" functionality of the project
- Common convention in Python projects
- Groups related tests logically
- More important what's tested than filename matching

## Common Pitfalls

### 1. Wrong venv detection

Test output may show package installed but in wrong location if direnv activated parent project's venv.

**Solution:** Test in `/tmp/` or disable direnv:
```bash
DIRENV_LOG_FORMAT="" direnv deny . && test_command && direnv allow .
```

### 2. Direnv interference

```bash
# Test in isolated location
cd /tmp
mkdir test_project && cd test_project
# Run tests here
```

### 3. Assuming tests passed correctly

Just because pytest exits 0 doesn't mean it tested the right code.

**Always verify:**
- Which Python was used
- Where modules were imported from
- Coverage report shows expected files

## Test Execution Checklist

Before declaring tests successful:

- [ ] Verified correct venv active (`which python`)
- [ ] Tests import from correct location
- [ ] Coverage report shows project files
- [ ] Used `uv run` for all Python commands
- [ ] Tested in isolated directory if needed

## Running Tests

```bash
# Run all tests
uv run pytest

# Verbose output
uv run pytest -v

# With coverage
uv run pytest --cov

# Specific test file
uv run pytest tests/test_main.py

# Specific test function
uv run pytest tests/test_main.py::test_function_name
```
