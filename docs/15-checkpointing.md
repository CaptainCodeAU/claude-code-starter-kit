# Checkpointing

Claude Code automatically tracks file edits as you work, allowing you to quickly undo changes and rewind to previous states.

## How Checkpoints Work

As you work with Claude, checkpointing captures the state of your code before each edit.

### Automatic Tracking

- **Every user prompt** creates a new checkpoint
- **Persistence**: Checkpoints persist across sessions (available in resumed conversations)
- **Cleanup**: Automatically deleted after 30 days (configurable via `cleanupPeriodDays`)

### What Gets Tracked

Claude Code tracks changes made by its file editing tools:

| Tool | Tracked |
|------|---------|
| Edit | Yes |
| Write | Yes |
| NotebookEdit | Yes |
| Bash commands | **No** |

## Rewinding Changes

Access the rewind menu with:

- **Keyboard**: Press `Esc` twice (`Esc` + `Esc`)
- **Command**: `/rewind`

### Rewind Options

| Option | Effect |
|--------|--------|
| **Conversation only** | Rewind to a message, keep code changes |
| **Code only** | Revert file changes, keep conversation |
| **Both** | Restore both code and conversation to a prior point |

## Use Cases

### Exploring Alternatives

Try different implementation approaches without losing your starting point:

```
> Implement feature X using approach A
> [review results]
> /rewind
> Implement feature X using approach B
> [compare and decide]
```

### Recovering from Mistakes

Quickly undo changes that introduced bugs:

```
> Refactor the authentication module
> [tests fail]
> /rewind (code only)
> [back to working state]
```

### Iterating on Features

Experiment with variations knowing you can revert:

```
> Add a caching layer to the API
> [performance not improved]
> /rewind
> Try a different caching strategy
```

## Limitations

### Bash Command Changes Not Tracked

File modifications via bash commands **cannot** be undone through rewind:

```bash
# These changes are NOT tracked
rm file.txt
mv old.txt new.txt
cp source.txt dest.txt
echo "content" > file.txt
```

If Claude uses bash to modify files, those changes won't be in checkpoints.

### External Changes Not Tracked

Checkpointing only tracks files edited within the current session:

- Manual edits outside Claude Code: **Not captured**
- Edits from other concurrent sessions: **Not captured**
- Exception: If external changes affect files already in the session

### Not a Replacement for Version Control

Checkpoints are for quick, session-level recovery:

| Checkpoints | Git |
|-------------|-----|
| Session-level undo | Permanent history |
| Local only | Shareable |
| Auto-cleanup | Persistent |
| Quick revert | Branching, merging |

Continue using Git for:
- Commits and branches
- Long-term history
- Collaboration

Think of checkpoints as "local undo" and Git as "permanent history."

## Configuration

### Cleanup Period

Control how long inactive sessions (and their checkpoints) are retained:

```json
{
  "cleanupPeriodDays": 30
}
```

Set to `0` for immediate cleanup after session ends.

## Token Impact

**ZERO** - Checkpoints are internal to Claude Code and don't consume context tokens.

## See Also

- [Slash Commands](./10-slash-commands.md) - `/rewind` command
- [Settings Reference](./05-settings-reference.md) - `cleanupPeriodDays` setting
