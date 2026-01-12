# Statusline Configuration

Create a custom statusline for Claude Code to display contextual information at the bottom of the interface, similar to terminal prompts (PS1) in shells like Oh-my-zsh.

## Creating a Custom Statusline

### Via Command

```bash
# Claude helps set up a statusline (tries to match your terminal prompt)
/statusline

# With specific instructions
/statusline show the model name in orange
```

### Via Settings

Add a `statusLine` command to `.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh",
    "padding": 0
  }
}
```

| Field | Description |
|-------|-------------|
| `type` | Must be `"command"` |
| `command` | Path to your statusline script |
| `padding` | Optional. Set to `0` to let statusline go to edge |

---

## How It Works

- Statusline updates when conversation messages update
- Updates run at most every **300ms**
- First line of stdout from your command becomes the statusline text
- **ANSI color codes** are supported for styling
- Claude Code passes session context as **JSON via stdin**

---

## JSON Input Structure

Your statusline command receives structured data via stdin:

```json
{
  "hook_event_name": "Status",
  "session_id": "abc123...",
  "transcript_path": "/path/to/transcript.json",
  "cwd": "/current/working/directory",
  "model": {
    "id": "claude-opus-4-1",
    "display_name": "Opus"
  },
  "workspace": {
    "current_dir": "/current/working/directory",
    "project_dir": "/original/project/directory"
  },
  "version": "1.0.80",
  "output_style": {
    "name": "default"
  },
  "cost": {
    "total_cost_usd": 0.01234,
    "total_duration_ms": 45000,
    "total_api_duration_ms": 2300,
    "total_lines_added": 156,
    "total_lines_removed": 23
  },
  "context_window": {
    "total_input_tokens": 15234,
    "total_output_tokens": 4521,
    "context_window_size": 200000,
    "current_usage": {
      "input_tokens": 8500,
      "output_tokens": 1200,
      "cache_creation_input_tokens": 5000,
      "cache_read_input_tokens": 2000
    }
  }
}
```

### Available Fields

| Field | Description |
|-------|-------------|
| `model.id` | Full model identifier |
| `model.display_name` | Short display name (e.g., "Opus", "Sonnet") |
| `workspace.current_dir` | Current working directory |
| `workspace.project_dir` | Original project directory |
| `version` | Claude Code version |
| `output_style.name` | Current output style |
| `cost.total_cost_usd` | Session cost in USD |
| `cost.total_duration_ms` | Total session duration |
| `cost.total_lines_added` | Lines added this session |
| `cost.total_lines_removed` | Lines removed this session |
| `context_window.context_window_size` | Max context window |
| `context_window.current_usage` | Current context state (may be null) |

---

## Example Scripts

### Simple Bash

```bash
#!/bin/bash
input=$(cat)

MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

echo "[$MODEL_DISPLAY] $(basename "$CURRENT_DIR")"
```

### Git-Aware Bash

```bash
#!/bin/bash
input=$(cat)

MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# Show git branch if in a git repo
GIT_BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$BRANCH" ]; then
        GIT_BRANCH=" | $BRANCH"
    fi
fi

echo "[$MODEL_DISPLAY] ${CURRENT_DIR##*/}$GIT_BRANCH"
```

### Python

```python
#!/usr/bin/env python3
import json
import sys
import os

data = json.load(sys.stdin)

model = data['model']['display_name']
current_dir = os.path.basename(data['workspace']['current_dir'])

# Check for git branch
git_branch = ""
if os.path.exists('.git'):
    try:
        with open('.git/HEAD', 'r') as f:
            ref = f.read().strip()
            if ref.startswith('ref: refs/heads/'):
                git_branch = f" | {ref.replace('ref: refs/heads/', '')}"
    except:
        pass

print(f"[{model}] {current_dir}{git_branch}")
```

### Node.js

```javascript
#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

let input = '';
process.stdin.on('data', chunk => input += chunk);
process.stdin.on('end', () => {
    const data = JSON.parse(input);

    const model = data.model.display_name;
    const currentDir = path.basename(data.workspace.current_dir);

    // Check for git branch
    let gitBranch = '';
    try {
        const headContent = fs.readFileSync('.git/HEAD', 'utf8').trim();
        if (headContent.startsWith('ref: refs/heads/')) {
            gitBranch = ` | ${headContent.replace('ref: refs/heads/', '')}`;
        }
    } catch (e) {}

    console.log(`[${model}] ${currentDir}${gitBranch}`);
});
```

### Helper Functions Approach

For complex scripts, create helper functions:

```bash
#!/bin/bash
input=$(cat)

# Helper functions
get_model_name() { echo "$input" | jq -r '.model.display_name'; }
get_current_dir() { echo "$input" | jq -r '.workspace.current_dir'; }
get_project_dir() { echo "$input" | jq -r '.workspace.project_dir'; }
get_version() { echo "$input" | jq -r '.version'; }
get_cost() { echo "$input" | jq -r '.cost.total_cost_usd'; }
get_duration() { echo "$input" | jq -r '.cost.total_duration_ms'; }
get_lines_added() { echo "$input" | jq -r '.cost.total_lines_added'; }
get_lines_removed() { echo "$input" | jq -r '.cost.total_lines_removed'; }
get_input_tokens() { echo "$input" | jq -r '.context_window.total_input_tokens'; }
get_output_tokens() { echo "$input" | jq -r '.context_window.total_output_tokens'; }
get_context_size() { echo "$input" | jq -r '.context_window.context_window_size'; }

# Build statusline
MODEL=$(get_model_name)
DIR=$(get_current_dir)
COST=$(get_cost)

echo "[$MODEL] ${DIR##*/} | \$${COST}"
```

---

## Context Window Usage

Display the percentage of context window consumed:

```bash
#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size')
USAGE=$(echo "$input" | jq '.context_window.current_usage')

if [ "$USAGE" != "null" ]; then
    # Calculate from current_usage fields
    CURRENT_TOKENS=$(echo "$USAGE" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    PERCENT_USED=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))
    echo "[$MODEL] Context: ${PERCENT_USED}%"
else
    echo "[$MODEL] Context: 0%"
fi
```

### Context Window Fields

| Field | Description |
|-------|-------------|
| `total_input_tokens` | Cumulative input tokens (entire session) |
| `total_output_tokens` | Cumulative output tokens (entire session) |
| `current_usage.input_tokens` | Input tokens in current context |
| `current_usage.output_tokens` | Output tokens generated |
| `current_usage.cache_creation_input_tokens` | Tokens written to cache |
| `current_usage.cache_read_input_tokens` | Tokens read from cache |

For accurate context percentage, use `current_usage` (reflects actual context window state).

---

## Tips

- **Keep it concise** - Should fit on one line
- **Use emojis and colors** - Make information scannable
- **Use jq for JSON parsing** in Bash
- **Test manually** with mock input:
  ```bash
  echo '{"model":{"display_name":"Test"},"workspace":{"current_dir":"/test"}}' | ./statusline.sh
  ```
- **Cache expensive operations** (like git status) if needed

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Statusline doesn't appear | Check script is executable (`chmod +x`) |
| No output | Ensure script outputs to stdout, not stderr |
| jq not found | Install jq: `brew install jq` (macOS) or `apt install jq` (Linux) |
| Script errors | Test manually with mock JSON input |
| Updates too slow | Check for blocking operations in script |

---

## See Also

- [Settings Reference](./05-settings-reference.md) - Settings.json configuration
- [Model Configuration](./18-model-configuration.md) - Model display and aliases
- [Hooks](./02-hooks.md) - Custom automation and notifications
- [Interactive Mode](./16-interactive-mode.md) - Other customization options
