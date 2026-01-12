# Model Configuration

Learn about Claude Code model configuration, including model aliases, selection methods, and prompt caching.

## Available Models

For the `model` setting, you can use:
- A **model alias** (convenient shorthand)
- A **model name** (full identifier)
  - Anthropic API: Full model name (e.g., `claude-sonnet-4-5-20250929`)
  - AWS Bedrock: Inference profile ARN
  - Google Vertex: Version name
  - Foundry: Deployment name

---

## Model Aliases

| Alias | Behavior |
|-------|----------|
| `default` | Recommended model, depends on account type |
| `sonnet` | Latest Sonnet model (currently Sonnet 4.5) for daily coding |
| `opus` | Opus model (currently Opus 4.5) for complex reasoning |
| `haiku` | Fast and efficient Haiku model for simple tasks |
| `sonnet[1m]` | Sonnet with 1 million token context window |
| `opusplan` | Uses Opus in plan mode, Sonnet for execution |

### The `opusplan` Alias

An automated hybrid approach:
- **In plan mode**: Uses Opus for complex reasoning and architecture decisions
- **In execution mode**: Automatically switches to Sonnet for code generation

This gives you Opus's superior reasoning for planning and Sonnet's efficiency for execution.

---

## Setting Your Model

Methods listed in order of priority (highest first):

### 1. During Session

```bash
# Switch models mid-session
/model opus
/model sonnet
/model haiku
```

### 2. At Startup

```bash
claude --model opus
claude --model claude-sonnet-4-5-20250929
```

### 3. Environment Variable

```bash
export ANTHROPIC_MODEL=opus
```

### 4. Settings File

```json
{
  "permissions": { ... },
  "model": "opus"
}
```

---

## Special Model Behavior

### Default Model

The behavior of `default` depends on your account type.

For certain Max users, Claude Code automatically falls back to Sonnet if you hit a usage threshold with Opus.

### Extended Context with [1m]

For Console/API users, add `[1m]` suffix to enable 1 million token context window:

```bash
/model anthropic.claude-sonnet-4-5-20250929-v1:0[1m]
```

Note: Extended context models have [different pricing](https://docs.claude.com/en/docs/about-claude/pricing#long-context-pricing).

---

## Checking Current Model

See your current model:
- In [statusline](./19-statusline.md) (if configured)
- Run `/status` (also shows account information)

---

## Environment Variables

### Model Override Variables

Control which models the aliases map to (must be full model names):

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Model for `opus` alias, or `opusplan` in Plan Mode |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Model for `sonnet` alias, or `opusplan` outside Plan Mode |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Model for `haiku` alias and background tasks |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Model used for [subagents](./09-subagents.md) |

Note: `ANTHROPIC_SMALL_FAST_MODEL` is deprecated in favor of `ANTHROPIC_DEFAULT_HAIKU_MODEL`.

### Example

```bash
# Use specific model versions
export ANTHROPIC_DEFAULT_OPUS_MODEL=claude-opus-4-1-20250918
export ANTHROPIC_DEFAULT_SONNET_MODEL=claude-sonnet-4-5-20250929

# Use different model for subagents
export CLAUDE_CODE_SUBAGENT_MODEL=claude-sonnet-4-5-20250929
```

---

## Prompt Caching Configuration

Claude Code automatically uses [prompt caching](https://docs.claude.com/en/docs/build-with-claude/prompt-caching) to optimize performance and reduce costs.

### Disabling Prompt Caching

| Variable | Description |
|----------|-------------|
| `DISABLE_PROMPT_CACHING` | Set to `1` to disable for all models (takes precedence) |
| `DISABLE_PROMPT_CACHING_HAIKU` | Set to `1` to disable for Haiku only |
| `DISABLE_PROMPT_CACHING_SONNET` | Set to `1` to disable for Sonnet only |
| `DISABLE_PROMPT_CACHING_OPUS` | Set to `1` to disable for Opus only |

### When to Disable Caching

- Debugging specific models
- Working with cloud providers with different caching implementations
- Testing cache-miss scenarios

### Example

```bash
# Disable caching globally
export DISABLE_PROMPT_CACHING=1

# Disable only for Opus
export DISABLE_PROMPT_CACHING_OPUS=1
```

---

## Model Selection Guidelines

| Use Case | Recommended Model |
|----------|-------------------|
| Daily coding tasks | `sonnet` (default) |
| Complex architecture decisions | `opus` |
| Quick edits, simple tasks | `haiku` |
| Long sessions with large context | `sonnet[1m]` |
| Planning + execution workflow | `opusplan` |
| Background subagents | `haiku` (automatic) |

---

## Cost Considerations

| Model | Relative Cost | Best For |
|-------|---------------|----------|
| Haiku | Lowest | Simple tasks, high volume |
| Sonnet | Medium | General development |
| Opus | Highest | Complex reasoning |
| Extended context | Premium pricing | Large codebases |

For detailed pricing, see [Claude pricing documentation](https://docs.claude.com/en/docs/about-claude/pricing).

---

## See Also

- [Subagents](./09-subagents.md) - Model configuration for subagents
- [Statusline](./19-statusline.md) - Display current model in statusline
- [Settings Reference](./05-settings-reference.md) - Complete settings documentation
- [CLI Reference](./12-cli-reference.md) - `--model` flag and other options
