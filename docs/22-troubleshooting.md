# Troubleshooting

Solutions to common Claude Code issues including installation problems, authentication, performance, and IDE integration.

---

## Installation Issues

### Windows/WSL Installation

#### OS/Platform Detection Errors

If you receive errors during installation, WSL may be using Windows `npm`:

```bash
# Fix 1: Set OS explicitly
npm config set os linux

# Fix 2: Force install
npm install -g @anthropic-ai/claude-code --force --no-os-check
```

**Important:** Do NOT use `sudo` for npm installations.

#### Node Not Found Errors

If you see `exec: node: not found`, WSL may be using a Windows Node.js installation.

**Diagnose:**
```bash
which npm   # Should show /usr/... not /mnt/c/...
which node  # Should show /usr/... not /mnt/c/...
```

**Fix:** Install Node via your Linux distribution's package manager or [nvm](https://github.com/nvm-sh/nvm).

#### NVM Version Conflicts

WSL imports Windows PATH by default, causing Windows nvm/npm to take priority.

**Primary solution - Ensure nvm loads in your shell:**

Add to `~/.bashrc` or `~/.zshrc`:
```bash
# Load nvm if it exists
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

**Alternative - Adjust PATH order:**
```bash
export PATH="$HOME/.nvm/versions/node/$(node -v)/bin:$PATH"
```

> **Warning:** Avoid disabling Windows PATH importing (`appendWindowsPath = false`) as this breaks calling Windows executables from WSL.

---

### Linux/Mac Installation

#### Permission or Command Not Found Errors

PATH problems may prevent access to `claude`, or npm global prefix may not be user-writable.

**Recommended solution - Native installation:**

```bash
# macOS, Linux, WSL - Install stable version
curl -fsSL https://claude.ai/install.sh | bash

# Install latest version
curl -fsSL https://claude.ai/install.sh | bash -s latest

# Install specific version
curl -fsSL https://claude.ai/install.sh | bash -s 1.0.58
```

This installs Claude Code and adds a symlink at `~/.local/bin/claude`.

> **Tip:** Ensure `~/.local/bin` is in your system PATH.

---

### Windows Native Installation

#### "Claude Code on Windows requires git-bash"

Claude Code on native Windows requires [Git for Windows](https://git-scm.com/downloads/win).

If Git is installed but not detected:

```powershell
# Set path explicitly before running Claude
$env:CLAUDE_CODE_GIT_BASH_PATH="C:\Program Files\Git\bin\bash.exe"
```

Or add to system environment variables permanently via System Properties → Environment Variables.

#### "installMethod is native, but claude command not found"

The `claude` command isn't in your PATH.

1. Press `Win + R`, type `sysdm.cpl`, press Enter
2. Click **Advanced** → **Environment Variables**
3. Under "User variables", select **Path** → **Edit**
4. Click **New** and add: `%USERPROFILE%\.local\bin`
5. Restart your terminal

**Verify:**
```bash
claude doctor  # Check installation health
```

---

## Permissions and Authentication

### Repeated Permission Prompts

If you're repeatedly approving the same commands, allow specific tools to run without approval:

```
/permissions
```

See [05-settings-reference.md](./05-settings-reference.md) for permission configuration details.

### Authentication Issues

If experiencing authentication problems:

1. Run `/logout` to sign out completely
2. Close Claude Code
3. Restart with `claude` and complete authentication again

**Force clean login:**
```bash
rm -rf ~/.config/claude-code/auth.json
claude
```

This removes stored authentication and forces a fresh login.

---

## Configuration File Locations

| File | Purpose |
|------|---------|
| `~/.claude/settings.json` | User settings (permissions, hooks, model overrides) |
| `.claude/settings.json` | Project settings (checked into source control) |
| `.claude/settings.local.json` | Local project settings (not committed) |
| `~/.claude.json` | Global state (theme, OAuth, MCP servers, allowed tools) |
| `.mcp.json` | Project MCP servers (checked into source control) |
| `managed-settings.json` | Managed settings (enterprise) |
| `managed-mcp.json` | Managed MCP servers (enterprise) |

On Windows, `~` refers to your user home directory (e.g., `C:\Users\YourName`).

### Managed File Locations

| Platform | Path |
|----------|------|
| macOS | `/Library/Application Support/ClaudeCode/` |
| Linux/WSL | `/etc/claude-code/` |
| Windows | `C:\Program Files\ClaudeCode\` |

### Resetting Configuration

```bash
# Reset all user settings and state
rm ~/.claude.json
rm -rf ~/.claude/

# Reset project-specific settings
rm -rf .claude/
rm .mcp.json
```

> **Warning:** This removes all settings, allowed tools, MCP server configurations, and session history.

---

## Performance and Stability

### High CPU or Memory Usage

Claude Code may consume significant resources when processing large codebases.

**Mitigations:**
1. Use `/compact` regularly to reduce context size
2. Close and restart Claude Code between major tasks
3. Add large build directories to `.gitignore`

### Command Hangs or Freezes

If Claude Code seems unresponsive:

1. Press `Ctrl+C` to attempt to cancel the current operation
2. If still unresponsive, close the terminal and restart

### Search and Discovery Issues

If Search tool, `@file` mentions, custom agents, and custom slash commands aren't working, install system `ripgrep`:

```bash
# macOS (Homebrew)
brew install ripgrep

# Windows (winget)
winget install BurntSushi.ripgrep.MSVC

# Ubuntu/Debian
sudo apt install ripgrep

# Alpine Linux
apk add ripgrep

# Arch Linux
pacman -S ripgrep
```

Then set in your environment:
```bash
export USE_BUILTIN_RIPGREP=0
```

### Slow or Incomplete Search Results on WSL

Disk read performance penalties when working across file systems on WSL may result in fewer-than-expected matches.

> **Note:** `/doctor` will show Search as OK in this case.

**Solutions:**

1. **Submit more specific searches**: Reduce files searched by specifying directories or file types: "Search for JWT validation logic in the auth-service package"

2. **Move project to Linux filesystem**: Ensure your project is on the Linux filesystem (`/home/`) rather than Windows filesystem (`/mnt/c/`)

3. **Use native Windows**: Consider running Claude Code natively on Windows for better file system performance

---

## IDE Integration Issues

### JetBrains IDE Not Detected on WSL2

WSL2 uses NAT networking by default, which can prevent IDE detection.

#### Option 1: Configure Windows Firewall (Recommended)

1. Find your WSL2 IP address:
   ```bash
   wsl hostname -I
   # Example: 172.21.123.456
   ```

2. Open PowerShell as Administrator and create a firewall rule:
   ```powershell
   New-NetFirewallRule -DisplayName "Allow WSL2 Internal Traffic" -Direction Inbound -Protocol TCP -Action Allow -RemoteAddress 172.21.0.0/16 -LocalAddress 172.21.0.0/16
   ```
   (Adjust IP range based on your WSL2 subnet)

3. Restart both your IDE and Claude Code

#### Option 2: Switch to Mirrored Networking

Add to `.wslconfig` in your Windows user directory:
```ini
[wsl2]
networkingMode=mirrored
```

Then restart WSL:
```powershell
wsl --shutdown
```

> **Note:** These networking issues only affect WSL2. WSL1 uses the host's network directly.

### Escape Key Not Working in JetBrains Terminals

If `Esc` doesn't interrupt Claude Code in JetBrains terminals (IntelliJ, PyCharm, etc.):

1. Go to **Settings** → **Tools** → **Terminal**
2. Either:
   - Uncheck "Move focus to the editor with Escape", or
   - Click "Configure terminal keybindings" and delete the "Switch focus to Editor" shortcut
3. Apply changes

### Reporting IDE Integration Issues

When creating an issue for Windows IDE problems, include:
- Environment type: native Windows (Git Bash) or WSL1/WSL2
- WSL networking mode (if applicable): NAT or mirrored
- IDE name and version
- Claude Code extension/plugin version
- Shell type: Bash, Zsh, PowerShell, etc.

---

## Markdown Formatting Issues

### Missing Language Tags in Code Blocks

Claude Code sometimes generates markdown without language tags:

````markdown
# Missing tag (bad)
```
function example() {
  return "hello";
}
```

# With tag (good)
```javascript
function example() {
  return "hello";
}
```
````

**Solutions:**

1. **Ask Claude to fix**: "Add appropriate language tags to all code blocks in this markdown file"

2. **Use post-processing hooks**: Set up automatic formatting hooks. See [02-hooks.md](./02-hooks.md) for hook examples.

3. **Manual verification**: Review generated markdown files and request corrections

### Inconsistent Spacing and Formatting

**Solutions:**

1. **Request corrections**: "Fix spacing and formatting issues in this markdown file"

2. **Use formatting tools**: Set up hooks to run `prettier` or custom formatters

3. **Specify preferences**: Include formatting requirements in your CLAUDE.md

### Best Practices for Markdown Generation

- **Be explicit**: Ask for "properly formatted markdown with language-tagged code blocks"
- **Use project conventions**: Document preferred markdown style in [CLAUDE.md](./07-claude-md-best-practices.md)
- **Set up validation hooks**: Use post-processing hooks to verify and fix common issues

---

## Diagnostic Commands

| Command | Purpose |
|---------|---------|
| `/doctor` | Check installation health and diagnose issues |
| `/bug` | Report problems directly to Anthropic |
| `/compact` | Reduce context size for performance |
| `/logout` | Sign out for authentication reset |

---

## Getting Help

1. **Built-in diagnostics**: Run `/doctor` to check Claude Code installation health

2. **Report bugs**: Use `/bug` within Claude Code to report problems directly to Anthropic

3. **GitHub issues**: Check the [GitHub repository](https://github.com/anthropics/claude-code) for known issues

4. **Ask Claude**: Claude has built-in access to its documentation - ask directly about capabilities and features

---

## See Also

- [05-settings-reference.md](./05-settings-reference.md) - Configuration options and permissions
- [02-hooks.md](./02-hooks.md) - Post-processing hooks for formatting
- [11-mcp.md](./11-mcp.md) - MCP server configuration
- [16-interactive-mode.md](./16-interactive-mode.md) - Terminal and keyboard shortcuts
