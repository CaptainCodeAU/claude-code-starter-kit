# Getting Started with Your .claude/ Folder

You've copied the `CLAUDE.md`, `DECISIONS.md`, and `.claude/` folder into your project. Here's a hands-on tour of everything you now have access to.

**Time to complete:** 15-20 minutes

---

## Step 1: Customize Your CLAUDE.md Files

**What:** You have TWO CLAUDE.md files that Claude reads every session:

| File | Purpose |
|------|---------|
| `CLAUDE.md` (root) | Project context - WHAT your project is |
| `.claude/CLAUDE.md` | Claude behavior - HOW Claude should work |

**Do this:**
1. Open `CLAUDE.md` (root) - fill in your stack, commands, structure
2. Open `.claude/CLAUDE.md` - review the behavior settings (critical thinking partner, memory awareness, session workflow)
3. Delete the template instruction comments when done

**Why it matters:** Root file gives Claude project context. The `.claude/` file ensures Claude works the way you need (commits after tasks, reads DECISIONS.md, documents everything).

**Also:** You have `DECISIONS.md` for tracking decisions, rejections, and experiments. Claude will read this at the start of each session.

---

## Step 2: Try Your First Slash Command

**What:** Slash commands are pre-built prompts you invoke with `/command-name`.

**Try this:**
```
/audit
```

**What happens:** Claude performs a comprehensive quality audit of your code (accessibility, performance, theming).

**Other commands to try:**
| Command | What it does |
|---------|--------------|
| `/polish` | Final quality pass before shipping |
| `/simplify` | Strip designs to their essence |
| `/critique` | Get honest UX feedback |
| `/clarify` | Improve unclear copy and labels |

**See all commands:** Type `/` and browse, or check `.claude/commands/`

---

## Step 3: Use the Code Reviewer Agent

**What:** Agents are specialized assistants that run in isolated contexts with specific tools.

**Try this:**
```
Review the code in src/main.py for security and performance issues
```

Claude will automatically delegate to the `code-reviewer` agent, which focuses on:
- Correctness and edge cases
- Security vulnerabilities
- Performance issues
- Maintainability

**See the agent config:** `.claude/agents/code-reviewer.md`

---

## Step 4: Experience the Notification Hook

**What:** Hooks run automatically when certain events happen.

**Try this:**
1. Ask Claude to do something that takes a few seconds (e.g., "search for all TODO comments")
2. When it finishes, you'll hear an audio notification and see a macOS notification

**What's happening:** The `Stop` hook triggers `.claude/hooks/agent-notify.sh` when Claude finishes a task.

**Customize it:** Edit `.claude/hooks/agent-notify.sh` to change the notification style.

**Note:** This works on macOS only. On other platforms, delete or modify the hook.

---

## Step 5: Invoke a Skill

**What:** Skills are detailed instruction sets that Claude loads on-demand (saving tokens).

**Try this:**
```
Use the frontend-design skill to create a login form
```

**What happens:** Claude loads the frontend-design skill which includes:
- Typography guidelines
- Color and contrast rules
- Interaction design patterns
- Anti-AI-slop aesthetics

**Available skills:**
| Skill | When to use |
|-------|-------------|
| `frontend-design` | Building UI components, pages, web apps |
| `shell-functions` | Writing .zshrc/.bashrc functions |
| `testing-python` | Python test isolation and best practices |

**See all skills:** Check `.claude/skills/`

---

## Step 6: See Rules in Action

**What:** Rules are always-on constraints that Claude follows automatically.

**Try this:**
```
Modify the helper function in utils.py
```

**What happens:** Before modifying, Claude will search for all callers of that function (per `function-safety.md` rule).

**Active rules:**
| Rule | What it enforces |
|------|------------------|
| `function-safety.md` | Search for callers before modifying shared functions |
| `uv-commands.md` | Use `uv run python` instead of `python` directly |

**Note:** Delete `uv-commands.md` if you're not using uv for Python.

---

## Step 7: Explore Hook Events

**What:** Your `settings.json` has hooks configured for various events.

**Available events:**
| Event | When it fires |
|-------|---------------|
| `PreToolUse` | Before Claude uses a tool (validate, block) |
| `PostToolUse` | After a tool completes (format, log) |
| `SessionStart` | When Claude Code starts |
| `Stop` | When Claude finishes (notifications) |
| `UserPromptSubmit` | When you submit a prompt |

**Try adding a hook:**
Edit `.claude/settings.json` and add to `SessionStart`:
```json
"SessionStart": [
  {
    "hooks": [
      {
        "type": "command",
        "command": "echo 'Welcome to your project!'",
        "timeout": 5
      }
    ]
  }
]
```

Restart Claude Code to see it in action.

---

## Quick Reference

### What you copied to your project

```
your-project/
├── CLAUDE.md              # Project context (WHAT your project is)
├── DECISIONS.md           # Decision journal (tracks choices, rejections, experiments)
└── .claude/
    ├── CLAUDE.md          # Claude behavior (HOW Claude works)
    ├── settings.json      # Hooks and permissions
    ├── hooks/             # Scripts that run on events
    │   └── agent-notify.sh
    ├── skills/            # Detailed instruction sets
    │   ├── frontend-design/
    │   ├── shell-functions/
    │   └── testing-practices/
    ├── commands/          # Slash commands (/polish, /audit, etc.)
    ├── agents/            # Specialized assistants
    │   └── code-reviewer.md
    └── rules/             # Always-on constraints
        ├── function-safety.md
        └── uv-commands.md
```

### Token costs

| Component | Cost | Notes |
|-----------|------|-------|
| CLAUDE.md | ~50-150 tokens | Loaded every session |
| rules/ | Full content | Loaded every session |
| skills/ | ~20 tokens each | Metadata only until invoked |
| commands/ | Zero | Loaded when you use them |
| agents/ | ~50 tokens each | Metadata only until delegated |
| hooks/ | Zero | Executed, not in context |

### Delete what you don't need

- **Not doing frontend?** Delete `skills/frontend-design/` and the frontend commands
- **Not using Python?** Delete `skills/testing-practices/` and `rules/uv-commands.md`
- **Not on macOS?** Delete or modify `hooks/agent-notify.sh`
- **Not writing shell scripts?** Delete `skills/shell-functions/`

---

## Next Steps

1. **Customize CLAUDE.md** for your specific project
2. **Delete unused components** to keep things clean
3. **Add your own commands** in `.claude/commands/`
4. **Create project-specific agents** in `.claude/agents/`
5. **Read the full docs** in the `docs/` folder of the starter kit

---

## Troubleshooting

**Commands not showing up?**
- Type `/` and wait for the list to load
- Check that command files have valid YAML frontmatter

**Agent not being used?**
- Make sure your request matches the agent's description
- You can explicitly ask: "Use the code-reviewer agent to..."

**Hooks not running?**
- Check `settings.json` syntax (valid JSON?)
- Ensure hook scripts are executable: `chmod +x .claude/hooks/*.sh`
- Check hook timeout isn't too short

**Need more help?**
- Run `/doctor` to check Claude Code health
- See `docs/22-troubleshooting.md` for common issues
