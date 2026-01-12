# Interactive Mode

Complete reference for keyboard shortcuts, input modes, terminal configuration, and interactive features in Claude Code sessions.

## Keyboard Shortcuts

> Keyboard shortcuts may vary by platform and terminal. Press `?` to see available shortcuts for your environment.

### macOS Option Key Setup

Option/Alt key shortcuts (`Alt+B`, `Alt+F`, `Alt+Y`, `Alt+M`, `Alt+P`) require configuring Option as Meta:

| Terminal | Setup |
|----------|-------|
| **iTerm2** | Settings → Profiles → Keys → Set Left/Right Option key to "Esc+" |
| **Terminal.app** | Settings → Profiles → Keyboard → Check "Use Option as Meta Key" |
| **VS Code** | Settings → Profiles → Keys → Set Left/Right Option key to "Esc+" |

---

### General Controls

| Shortcut | Description | Notes |
|----------|-------------|-------|
| `Ctrl+C` | Cancel current input or generation | Standard interrupt |
| `Ctrl+D` | Exit Claude Code session | EOF signal |
| `Ctrl+L` | Clear terminal screen | Keeps conversation history |
| `Ctrl+O` | Toggle verbose output | Shows detailed tool usage |
| `Ctrl+R` | Reverse search command history | Interactive search |
| `Ctrl+V` / `Cmd+V` (iTerm2) / `Alt+V` (Windows) | Paste image from clipboard | Pastes image or path |
| `Ctrl+B` | Background running tasks | Tmux users press twice |
| `Left/Right arrows` | Cycle through dialog tabs | Permission dialogs, menus |
| `Up/Down arrows` | Navigate command history | Recall previous inputs |
| `Esc` + `Esc` | Rewind code/conversation | Restore to previous point |
| `Shift+Tab` or `Alt+M` | Toggle permission modes | Auto-Accept, Plan, normal |
| `Alt+P` (Option+P on macOS) | Switch model | Change without clearing prompt |
| `Alt+T` (Option+T on macOS) | Toggle extended thinking | Run `/terminal-setup` first |

### Text Editing

| Shortcut | Description | Notes |
|----------|-------------|-------|
| `Ctrl+K` | Delete to end of line | Stores deleted text |
| `Ctrl+U` | Delete entire line | Stores deleted text |
| `Ctrl+Y` | Paste deleted text | From `Ctrl+K` or `Ctrl+U` |
| `Alt+Y` (after `Ctrl+Y`) | Cycle paste history | Requires Option as Meta |
| `Alt+B` | Move cursor back one word | Requires Option as Meta |
| `Alt+F` | Move cursor forward one word | Requires Option as Meta |

### Theme and Display

| Shortcut | Description | Notes |
|----------|-------------|-------|
| `Ctrl+T` | Toggle syntax highlighting | Only works in `/theme` picker menu |

Syntax highlighting is only available in the native build of Claude Code.

---

## Multiline Input

| Method | Shortcut | Notes |
|--------|----------|-------|
| Quick escape | `\` + `Enter` | Works in all terminals |
| macOS default | `Option+Enter` | Default on macOS |
| Shift+Enter | `Shift+Enter` | Works in iTerm2, WezTerm, Ghostty, Kitty |
| Control sequence | `Ctrl+J` | Line feed character |
| Paste mode | Paste directly | For code blocks, logs |

**Shift+Enter works without configuration** in iTerm2, WezTerm, Ghostty, and Kitty. For other terminals (VS Code, Alacritty, Zed, Warp), run `/terminal-setup` to install the binding.

---

## Quick Commands

| Prefix | Description | Example |
|--------|-------------|---------|
| `/` at start | Slash command | `/help`, `/status`, `/model opus` |
| `!` at start | Bash mode | `! npm test`, `! git status` |
| `@` | File path mention | `@src/main.ts` for autocomplete |

---

## Vim Editor Mode

Enable vim-style editing with `/vim` command or configure permanently via `/config`.

### Mode Switching

| Command | Action | From Mode |
|---------|--------|-----------|
| `Esc` | Enter NORMAL mode | INSERT |
| `i` | Insert before cursor | NORMAL |
| `I` | Insert at beginning of line | NORMAL |
| `a` | Insert after cursor | NORMAL |
| `A` | Insert at end of line | NORMAL |
| `o` | Open line below | NORMAL |
| `O` | Open line above | NORMAL |

### Navigation (NORMAL Mode)

| Command | Action |
|---------|--------|
| `h`/`j`/`k`/`l` | Move left/down/up/right |
| `w` | Next word |
| `e` | End of word |
| `b` | Previous word |
| `0` | Beginning of line |
| `$` | End of line |
| `^` | First non-blank character |
| `gg` | Beginning of input |
| `G` | End of input |
| `f{char}` | Jump to next occurrence of character |
| `F{char}` | Jump to previous occurrence of character |
| `t{char}` | Jump to just before next occurrence |
| `T{char}` | Jump to just after previous occurrence |
| `;` | Repeat last f/F/t/T motion |
| `,` | Repeat last f/F/t/T in reverse |

### Editing (NORMAL Mode)

| Command | Action |
|---------|--------|
| `x` | Delete character |
| `dd` | Delete line |
| `D` | Delete to end of line |
| `dw`/`de`/`db` | Delete word/to end/back |
| `cc` | Change line |
| `C` | Change to end of line |
| `cw`/`ce`/`cb` | Change word/to end/back |
| `yy`/`Y` | Yank (copy) line |
| `yw`/`ye`/`yb` | Yank word/to end/back |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `>>` | Indent line |
| `<<` | Dedent line |
| `J` | Join lines |
| `.` | Repeat last change |

### Text Objects (NORMAL Mode)

Text objects work with operators like `d`, `c`, and `y`:

| Command | Action |
|---------|--------|
| `iw`/`aw` | Inner/around word |
| `iW`/`aW` | Inner/around WORD (whitespace-delimited) |
| `i"`/`a"` | Inner/around double quotes |
| `i'`/`a'` | Inner/around single quotes |
| `i(`/`a(` | Inner/around parentheses |
| `i[`/`a[` | Inner/around brackets |
| `i{`/`a{` | Inner/around braces |

---

## Command History

Claude Code maintains command history for the current session:

- History is stored per working directory
- Cleared with `/clear` command
- Use Up/Down arrows to navigate
- History expansion (`!`) is disabled by default

### Reverse Search with Ctrl+R

1. **Start search**: Press `Ctrl+R` to activate
2. **Type query**: Enter text to search - matches are highlighted
3. **Navigate matches**: Press `Ctrl+R` again for older matches
4. **Accept match**:
   - `Tab` or `Esc` - Accept and continue editing
   - `Enter` - Accept and execute immediately
5. **Cancel search**:
   - `Ctrl+C` - Cancel and restore original input
   - `Backspace` on empty search - Cancel

---

## Background Bash Commands

Claude Code supports running bash commands in the background while you continue working.

### How Backgrounding Works

When a command runs in the background:
- Runs asynchronously with a unique task ID
- Claude can respond to new prompts immediately
- Output is buffered (retrieve with BashOutput tool)
- Tasks are cleaned up when Claude Code exits

### Starting Background Tasks

- **Prompt Claude** to run a command in the background
- **Press `Ctrl+B`** to move a running Bash command to background (Tmux users press twice)

### Common Backgrounded Commands

- Build tools (webpack, vite, make)
- Package managers (npm, yarn, pnpm)
- Test runners (jest, pytest)
- Development servers
- Long-running processes (docker, terraform)

### Disabling Background Tasks

Set `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS=1` to disable all background functionality.

---

## Bash Mode with `!` Prefix

Run bash commands directly without Claude interpretation:

```bash
! npm test
! git status
! ls -la
```

Bash mode:
- Adds command and output to conversation context
- Shows real-time progress and output
- Supports `Ctrl+B` backgrounding
- Does not require Claude approval

Useful for quick shell operations while maintaining conversation context.

---

## Terminal Configuration

### Themes and Appearance

Claude cannot control terminal theme (handled by your terminal app). Match Claude Code's theme to your terminal via `/config`.

For interface customization, configure a [custom statusline](./19-statusline.md) to display contextual information.

### Line Break Setup

**Option+Enter (macOS Terminal.app, iTerm2, VS Code):**

| Terminal | Setup |
|----------|-------|
| Terminal.app | Settings → Profiles → Keyboard → Check "Use Option as Meta Key" |
| iTerm2 / VS Code | Settings → Profiles → Keys → Set Left/Right Option key to "Esc+" |

### Notification Setup

#### iTerm2 System Notifications

1. Open iTerm2 Preferences
2. Navigate to Profiles → Terminal
3. Enable "Silence bell" and Filter Alerts → "Send escape sequence-generated alerts"
4. Set preferred notification delay

Note: These are iTerm2-specific, not available in default macOS Terminal.

#### Custom Notification Hooks

Create [notification hooks](./02-hooks.md#notification) for advanced handling.

### Handling Large Inputs

- **Avoid direct pasting**: Claude Code may struggle with very long pasted content
- **Use file-based workflows**: Write content to a file and ask Claude to read it
- **VS Code limitation**: VS Code terminal is particularly prone to truncating long pastes

---

## See Also

- [CLI Reference](./12-cli-reference.md) - Command-line flags and options
- [Slash Commands](./10-slash-commands.md) - Interactive session commands
- [Checkpointing](./15-checkpointing.md) - Rewind edits and restore states
- [Statusline](./19-statusline.md) - Custom statusline configuration
- [Settings](./05-settings-reference.md) - Configuration options
