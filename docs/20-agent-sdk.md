# Claude Agent SDK

Build production AI agents programmatically with the Claude Agent SDK in TypeScript and Python.

---

## Overview

The Claude Agent SDK gives you the same tools, agent loop, and context management that power Claude Code, programmable in Python and TypeScript. Build AI agents that autonomously read files, run commands, search the web, edit code, and more.

> **Note:** The Claude Code SDK has been renamed to the Claude Agent SDK. See the [Migration Guide](#migration-guide) if you're migrating from the old SDK.

### SDK vs CLI Comparison

| Use Case | Best Choice |
|----------|-------------|
| Interactive development | CLI |
| CI/CD pipelines | SDK |
| Custom applications | SDK |
| One-off tasks | CLI |
| Production automation | SDK |
| Building multi-agent systems | SDK |

Many teams use both: CLI for daily development, SDK for production. Workflows translate directly between them.

### Capabilities

Everything that makes Claude Code powerful is available in the SDK:

| Capability | Description |
|------------|-------------|
| **Built-in Tools** | Read, Write, Edit, Bash, Glob, Grep, WebSearch, WebFetch, Task |
| **Hooks** | Run custom code before/after tool calls for logging, validation, transformation |
| **Subagents** | Spawn specialized agents for focused subtasks |
| **MCP Integration** | Connect to databases, browsers, APIs via Model Context Protocol |
| **Permissions** | Control which tools your agent can use, with approval workflows |
| **Sessions** | Maintain context across multiple exchanges, resume later |

---

## Installation & Setup

### Prerequisites

The SDK uses Claude Code as its runtime. Install it first:

```bash
# macOS/Linux/WSL
curl -fsSL https://claude.ai/install.sh | bash

# Homebrew
brew install --cask claude-code

# npm
npm install -g @anthropic-ai/claude-code
```

### Install the SDK

**TypeScript:**
```bash
npm install @anthropic-ai/claude-agent-sdk
```

**Python:**
```bash
pip install claude-agent-sdk
```

### API Key Configuration

Set your Anthropic API key:

```bash
export ANTHROPIC_API_KEY=your-api-key
```

Get your key from the [Console](https://platform.claude.com/).

**Third-party API providers:**

| Provider | Environment Variable |
|----------|---------------------|
| Amazon Bedrock | `CLAUDE_CODE_USE_BEDROCK=1` + AWS credentials |
| Google Vertex AI | `CLAUDE_CODE_USE_VERTEX=1` + Google Cloud credentials |
| Microsoft Foundry | `CLAUDE_CODE_USE_FOUNDRY=1` + Azure credentials |

---

## Quick Start

### Basic Example

**TypeScript:**
```typescript
import { query } from "@anthropic-ai/claude-agent-sdk";

for await (const message of query({
  prompt: "Find and fix the bug in auth.py",
  options: { allowedTools: ["Read", "Edit", "Bash"] }
})) {
  console.log(message);
}
```

**Python:**
```python
import asyncio
from claude_agent_sdk import query, ClaudeAgentOptions

async def main():
    async for message in query(
        prompt="Find and fix the bug in auth.py",
        options=ClaudeAgentOptions(allowed_tools=["Read", "Edit", "Bash"])
    ):
        print(message)

asyncio.run(main())
```

### Understanding Message Types

The `query()` function returns an async iterator that yields messages as Claude works:

| Message Type | Description |
|--------------|-------------|
| `system` | Session initialization with tools, model, permissions |
| `assistant` | Claude's responses with text and tool calls |
| `user` | User messages (in multi-turn conversations) |
| `result` | Final result with cost, usage, and outcome |

**Filtering for readable output:**

```typescript
// TypeScript
for await (const message of query({ prompt: "Hello", options })) {
  if (message.type === "assistant" && message.message?.content) {
    for (const block of message.message.content) {
      if ("text" in block) console.log(block.text);
      else if ("name" in block) console.log(`Tool: ${block.name}`);
    }
  } else if (message.type === "result") {
    console.log(`Done: ${message.subtype}`);
  }
}
```

```python
# Python
from claude_agent_sdk import AssistantMessage, TextBlock, ToolUseBlock, ResultMessage

async for message in query(prompt="Hello", options=options):
    if isinstance(message, AssistantMessage):
        for block in message.content:
            if isinstance(block, TextBlock):
                print(block.text)
            elif isinstance(block, ToolUseBlock):
                print(f"Tool: {block.name}")
    elif isinstance(message, ResultMessage):
        print(f"Done: {message.subtype}")
```

---

## TypeScript SDK Reference

### `query()` Function

The primary function for interacting with Claude Code. Creates an async generator that streams messages.

```typescript
function query({
  prompt,
  options
}: {
  prompt: string | AsyncIterable<SDKUserMessage>;
  options?: Options;
}): Query
```

### Options

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `allowedTools` | `string[]` | All tools | List of allowed tool names |
| `disallowedTools` | `string[]` | `[]` | List of disallowed tool names |
| `permissionMode` | `PermissionMode` | `'default'` | Permission mode for the session |
| `systemPrompt` | `string \| { type: 'preset', preset: 'claude_code', append?: string }` | `undefined` | System prompt configuration |
| `model` | `string` | Default | Claude model to use |
| `maxTurns` | `number` | `undefined` | Maximum conversation turns |
| `maxBudgetUsd` | `number` | `undefined` | Maximum budget in USD |
| `cwd` | `string` | `process.cwd()` | Working directory |
| `additionalDirectories` | `string[]` | `[]` | Additional directories Claude can access |
| `env` | `Dict<string>` | `process.env` | Environment variables |
| `mcpServers` | `Record<string, McpServerConfig>` | `{}` | MCP server configurations |
| `hooks` | `Record<HookEvent, HookCallbackMatcher[]>` | `{}` | Hook callbacks for events |
| `agents` | `Record<string, AgentDefinition>` | `undefined` | Custom subagent definitions |
| `resume` | `string` | `undefined` | Session ID to resume |
| `continue` | `boolean` | `false` | Continue the most recent conversation |
| `forkSession` | `boolean` | `false` | Fork to new session when resuming |
| `canUseTool` | `CanUseTool` | `undefined` | Custom permission function |
| `settingSources` | `SettingSource[]` | `[]` | Which filesystem settings to load |
| `plugins` | `SdkPluginConfig[]` | `[]` | Local plugins to load |
| `sandbox` | `SandboxSettings` | `undefined` | Sandbox configuration |
| `outputFormat` | `{ type: 'json_schema', schema: JSONSchema }` | `undefined` | Structured output format |
| `includePartialMessages` | `boolean` | `false` | Include partial message events |
| `enableFileCheckpointing` | `boolean` | `false` | Enable file change tracking |

### Query Interface Methods

```typescript
interface Query extends AsyncGenerator<SDKMessage, void> {
  interrupt(): Promise<void>;
  rewindFiles(userMessageUuid: string): Promise<void>;
  setPermissionMode(mode: PermissionMode): Promise<void>;
  setModel(model?: string): Promise<void>;
  supportedCommands(): Promise<SlashCommand[]>;
  supportedModels(): Promise<ModelInfo[]>;
  mcpServerStatus(): Promise<McpServerStatus[]>;
  accountInfo(): Promise<AccountInfo>;
}
```

### Permission Modes

```typescript
type PermissionMode =
  | 'default'           // Standard permission behavior
  | 'acceptEdits'       // Auto-accept file edits
  | 'bypassPermissions' // Bypass all permission checks
  | 'plan'              // Planning mode - no execution
```

### Message Types

```typescript
type SDKMessage =
  | SDKAssistantMessage    // Claude's responses
  | SDKUserMessage         // User input
  | SDKResultMessage       // Final result with cost/usage
  | SDKSystemMessage       // System initialization
  | SDKPartialAssistantMessage  // Streaming partial (if enabled)
  | SDKCompactBoundaryMessage   // Conversation compaction marker
```

### AgentDefinition

```typescript
type AgentDefinition = {
  description: string;      // When to use this agent
  prompt: string;           // Agent's system prompt
  tools?: string[];         // Allowed tools (inherits if omitted)
  model?: 'sonnet' | 'opus' | 'haiku' | 'inherit';
}
```

---

## Python SDK Reference

### Choosing Between `query()` and `ClaudeSDKClient`

| Feature | `query()` | `ClaudeSDKClient` |
|---------|-----------|-------------------|
| **Session** | Creates new each time | Reuses same session |
| **Conversation** | Single exchange | Multiple exchanges |
| **Interrupts** | Not supported | Supported |
| **Hooks** | Not supported | Supported |
| **Custom Tools** | Not supported | Supported |
| **Use Case** | One-off tasks | Continuous conversations |

### `query()` Function

Creates a new session for each interaction. Returns an async iterator.

```python
async def query(
    *,
    prompt: str | AsyncIterable[dict[str, Any]],
    options: ClaudeAgentOptions | None = None
) -> AsyncIterator[Message]
```

### `ClaudeSDKClient`

Maintains a conversation session across multiple exchanges.

```python
class ClaudeSDKClient:
    def __init__(self, options: ClaudeAgentOptions | None = None)
    async def connect(self, prompt: str | AsyncIterable[dict] | None = None) -> None
    async def query(self, prompt: str | AsyncIterable[dict], session_id: str = "default") -> None
    async def receive_messages(self) -> AsyncIterator[Message]
    async def receive_response(self) -> AsyncIterator[Message]
    async def interrupt(self) -> None
    async def rewind_files(self, user_message_uuid: str) -> None
    async def disconnect(self) -> None
```

**Context manager usage:**
```python
async with ClaudeSDKClient(options) as client:
    await client.query("Hello Claude")
    async for message in client.receive_response():
        print(message)

    # Follow-up in same session - Claude remembers context
    await client.query("What did I just say?")
    async for message in client.receive_response():
        print(message)
```

### ClaudeAgentOptions

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `allowed_tools` | `list[str]` | `[]` | Allowed tool names |
| `disallowed_tools` | `list[str]` | `[]` | Disallowed tool names |
| `permission_mode` | `PermissionMode` | `None` | Permission mode |
| `system_prompt` | `str \| SystemPromptPreset` | `None` | System prompt |
| `model` | `str` | `None` | Claude model |
| `max_turns` | `int` | `None` | Max conversation turns |
| `cwd` | `str \| Path` | `None` | Working directory |
| `add_dirs` | `list[str \| Path]` | `[]` | Additional directories |
| `env` | `dict[str, str]` | `{}` | Environment variables |
| `mcp_servers` | `dict[str, McpServerConfig]` | `{}` | MCP servers |
| `hooks` | `dict[HookEvent, list[HookMatcher]]` | `None` | Hook configurations |
| `agents` | `dict[str, AgentDefinition]` | `None` | Custom subagents |
| `resume` | `str` | `None` | Session ID to resume |
| `continue_conversation` | `bool` | `False` | Continue most recent |
| `fork_session` | `bool` | `False` | Fork when resuming |
| `can_use_tool` | `CanUseTool` | `None` | Permission callback |
| `setting_sources` | `list[SettingSource]` | `None` | Filesystem settings to load |
| `plugins` | `list[SdkPluginConfig]` | `[]` | Local plugins |
| `sandbox` | `SandboxSettings` | `None` | Sandbox config |
| `output_format` | `OutputFormat` | `None` | Structured output |
| `enable_file_checkpointing` | `bool` | `False` | File change tracking |

### Message Types

```python
Message = UserMessage | AssistantMessage | SystemMessage | ResultMessage

@dataclass
class AssistantMessage:
    content: list[ContentBlock]  # TextBlock, ToolUseBlock, etc.
    model: str

@dataclass
class ResultMessage:
    subtype: str          # 'success', 'error_max_turns', etc.
    duration_ms: int
    is_error: bool
    num_turns: int
    session_id: str
    total_cost_usd: float | None
    result: str | None
```

### Error Types

| Error | Description |
|-------|-------------|
| `ClaudeSDKError` | Base exception for all SDK errors |
| `CLINotFoundError` | Claude Code CLI not installed |
| `CLIConnectionError` | Connection to Claude Code failed |
| `ProcessError` | Claude Code process failed |
| `CLIJSONDecodeError` | JSON parsing failed |

---

## Built-in Tools Reference

| Tool | Description | Key Input Fields |
|------|-------------|------------------|
| `Read` | Read files (text, images, PDFs, notebooks) | `file_path`, `offset`, `limit` |
| `Write` | Create/overwrite files | `file_path`, `content` |
| `Edit` | Precise string replacements | `file_path`, `old_string`, `new_string`, `replace_all` |
| `Bash` | Execute terminal commands | `command`, `timeout`, `run_in_background` |
| `Glob` | Find files by pattern | `pattern`, `path` |
| `Grep` | Search file contents with regex | `pattern`, `path`, `output_mode` |
| `WebSearch` | Search the web | `query`, `allowed_domains`, `blocked_domains` |
| `WebFetch` | Fetch and analyze web pages | `url`, `prompt` |
| `Task` | Launch subagents | `description`, `prompt`, `subagent_type` |
| `AskUserQuestion` | Ask user clarifying questions | `questions` array with options |
| `TodoWrite` | Manage task lists | `todos` array |
| `NotebookEdit` | Edit Jupyter notebooks | `notebook_path`, `cell_id`, `new_source` |

### Tool Permission Control

Restrict tools by specifying `allowedTools` or `disallowedTools`:

```typescript
// TypeScript - Read-only agent
options: {
  allowedTools: ["Read", "Glob", "Grep"],
  permissionMode: "bypassPermissions"
}
```

```python
# Python - Full automation
options = ClaudeAgentOptions(
    allowed_tools=["Read", "Edit", "Write", "Bash", "Glob", "Grep"],
    permission_mode="acceptEdits"
)
```

---

## Custom Tools & MCP

### Creating Custom Tools

**TypeScript:**
```typescript
import { tool, createSdkMcpServer } from "@anthropic-ai/claude-agent-sdk";
import { z } from "zod";

const addTool = tool(
  "add",
  "Add two numbers",
  { a: z.number(), b: z.number() },
  async (args) => ({
    content: [{ type: "text", text: `Sum: ${args.a + args.b}` }]
  })
);

const calculator = createSdkMcpServer({
  name: "calculator",
  version: "1.0.0",
  tools: [addTool]
});

// Use with query
for await (const msg of query({
  prompt: "What is 5 + 3?",
  options: {
    mcpServers: { calc: calculator },
    allowedTools: ["mcp__calc__add"]
  }
})) {
  console.log(msg);
}
```

**Python:**
```python
from claude_agent_sdk import tool, create_sdk_mcp_server, query, ClaudeAgentOptions

@tool("add", "Add two numbers", {"a": float, "b": float})
async def add(args):
    return {
        "content": [{"type": "text", "text": f"Sum: {args['a'] + args['b']}"}]
    }

calculator = create_sdk_mcp_server(
    name="calculator",
    version="1.0.0",
    tools=[add]
)

async for msg in query(
    prompt="What is 5 + 3?",
    options=ClaudeAgentOptions(
        mcp_servers={"calc": calculator},
        allowed_tools=["mcp__calc__add"]
    )
):
    print(msg)
```

### External MCP Servers

Configure external MCP servers (stdio, HTTP, SSE):

```typescript
// TypeScript
options: {
  mcpServers: {
    playwright: { command: "npx", args: ["@playwright/mcp@latest"] },
    remote: { type: "http", url: "https://api.example.com/mcp" }
  }
}
```

```python
# Python
options = ClaudeAgentOptions(
    mcp_servers={
        "playwright": {"command": "npx", "args": ["@playwright/mcp@latest"]},
        "remote": {"type": "http", "url": "https://api.example.com/mcp"}
    }
)
```

---

## Hooks in SDK

SDK hooks use callback functions to validate, log, block, or transform agent behavior.

### Available Hook Events

| Event | Description |
|-------|-------------|
| `PreToolUse` | Before tool execution |
| `PostToolUse` | After successful tool execution |
| `PostToolUseFailure` | After tool execution fails |
| `Stop` | When agent stops |
| `SubagentStart` | When subagent starts |
| `SubagentStop` | When subagent stops |
| `UserPromptSubmit` | When user submits prompt |
| `SessionStart` | Session initialization |
| `SessionEnd` | Session termination |
| `PreCompact` | Before conversation compaction |
| `PermissionRequest` | Permission request from tool |

### Hook Example

**TypeScript:**
```typescript
import { query, HookCallback } from "@anthropic-ai/claude-agent-sdk";
import { appendFileSync } from "fs";

const logFileChange: HookCallback = async (input) => {
  const filePath = (input as any).tool_input?.file_path ?? "unknown";
  appendFileSync("audit.log", `${new Date().toISOString()}: ${filePath}\n`);
  return {};
};

for await (const msg of query({
  prompt: "Refactor utils.py",
  options: {
    permissionMode: "acceptEdits",
    hooks: {
      PostToolUse: [{ matcher: "Edit|Write", hooks: [logFileChange] }]
    }
  }
})) {
  console.log(msg);
}
```

**Python:**
```python
from claude_agent_sdk import query, ClaudeAgentOptions, HookMatcher

async def validate_bash(input_data, tool_use_id, context):
    if input_data['tool_name'] == 'Bash':
        cmd = input_data['tool_input'].get('command', '')
        if 'rm -rf /' in cmd:
            return {
                'hookSpecificOutput': {
                    'hookEventName': 'PreToolUse',
                    'permissionDecision': 'deny',
                    'permissionDecisionReason': 'Dangerous command blocked'
                }
            }
    return {}

options = ClaudeAgentOptions(
    hooks={
        'PreToolUse': [HookMatcher(matcher='Bash', hooks=[validate_bash])]
    }
)
```

### Hook Return Values

```typescript
type HookJSONOutput = {
  continue?: boolean;           // Continue execution
  decision?: 'approve' | 'block';  // Block the action
  systemMessage?: string;       // Add to transcript
  hookSpecificOutput?: {
    hookEventName: 'PreToolUse';
    permissionDecision?: 'allow' | 'deny' | 'ask';
    permissionDecisionReason?: string;
    updatedInput?: Record<string, unknown>;
  } | {
    hookEventName: 'UserPromptSubmit' | 'PostToolUse' | 'SessionStart';
    additionalContext?: string;
  };
}
```

---

## Subagents

Define custom subagents programmatically that Claude can delegate tasks to.

**TypeScript:**
```typescript
for await (const msg of query({
  prompt: "Use the code-reviewer agent to review this codebase",
  options: {
    allowedTools: ["Read", "Glob", "Grep", "Task"],
    agents: {
      "code-reviewer": {
        description: "Expert code reviewer for quality and security reviews",
        prompt: "Analyze code quality and suggest improvements. Focus on security, performance, and maintainability.",
        tools: ["Read", "Glob", "Grep"]
      }
    }
  }
})) {
  console.log(msg);
}
```

**Python:**
```python
from claude_agent_sdk import query, ClaudeAgentOptions, AgentDefinition

options = ClaudeAgentOptions(
    allowed_tools=["Read", "Glob", "Grep", "Task"],
    agents={
        "code-reviewer": AgentDefinition(
            description="Expert code reviewer",
            prompt="Analyze code quality and suggest improvements.",
            tools=["Read", "Glob", "Grep"]
        )
    }
)
```

> **Important:** Include `Task` in `allowedTools` since subagents are invoked via the Task tool.

Messages from within a subagent's context include a `parent_tool_use_id` field for tracking.

---

## Sessions & Continuity

### Session IDs

Every query returns messages with a `session_id`. Capture it to resume later:

**TypeScript:**
```typescript
let sessionId: string | undefined;

for await (const msg of query({ prompt: "Read auth.py", options })) {
  if (msg.type === "system" && msg.subtype === "init") {
    sessionId = msg.session_id;
  }
}

// Resume later with full context
for await (const msg of query({
  prompt: "Now find all places that call it",
  options: { resume: sessionId }
})) {
  console.log(msg);
}
```

**Python (with ClaudeSDKClient):**
```python
async with ClaudeSDKClient(options) as client:
    await client.query("Read auth.py")
    async for msg in client.receive_response():
        pass  # Process first response

    # Follow-up with full context
    await client.query("Find all places that call it")
    async for msg in client.receive_response():
        print(msg)
```

### Fork Session

Create a branch from an existing session without modifying the original:

```typescript
options: { resume: sessionId, forkSession: true }
```

---

## Permissions & Security

### Custom Permission Handler

**TypeScript:**
```typescript
const canUseTool: CanUseTool = async (toolName, input, { signal, suggestions }) => {
  if (toolName === "Bash" && input.command?.includes("rm -rf")) {
    return { behavior: 'deny', message: 'Dangerous command blocked' };
  }
  return { behavior: 'allow', updatedInput: input };
};

for await (const msg of query({
  prompt: "Clean up temp files",
  options: { canUseTool, permissionMode: "default" }
})) {
  console.log(msg);
}
```

**Python:**
```python
from claude_agent_sdk.types import PermissionResultAllow, PermissionResultDeny

async def can_use_tool(tool_name, input_data, context):
    if tool_name == "Write" and "/system/" in input_data.get("file_path", ""):
        return PermissionResultDeny(
            message="System directory write blocked",
            interrupt=True
        )
    return PermissionResultAllow(updated_input=input_data)
```

### Sandbox Settings

Configure command sandboxing programmatically:

```typescript
options: {
  sandbox: {
    enabled: true,
    autoAllowBashIfSandboxed: true,
    excludedCommands: ["docker"],
    network: {
      allowLocalBinding: true,
      allowUnixSockets: ["/var/run/docker.sock"]
    }
  }
}
```

---

## Hosting & Deployment

### System Requirements

Each SDK instance requires:
- **Runtime:** Python 3.10+ or Node.js 18+
- **Claude Code CLI:** Required as the SDK runtime
- **Resources:** ~1GiB RAM, 5GiB disk, 1 CPU (adjust based on task)
- **Network:** Outbound HTTPS to `api.anthropic.com`

### Deployment Patterns

| Pattern | Description | Best For |
|---------|-------------|----------|
| **Ephemeral** | New container per task, destroy on complete | Bug fixes, processing jobs |
| **Long-Running** | Persistent containers, multiple Claude processes | Chat bots, proactive agents |
| **Hybrid** | Ephemeral with state hydration from database | Project managers, research agents |

### Sandbox Providers

- [Modal Sandbox](https://modal.com/docs/guide/sandbox)
- [Cloudflare Sandboxes](https://github.com/cloudflare/sandbox-sdk)
- [Daytona](https://www.daytona.io/)
- [E2B](https://e2b.dev/)
- [Fly Machines](https://fly.io/docs/machines/)
- [Vercel Sandbox](https://vercel.com/docs/functions/sandbox)

---

## TypeScript V2 Preview

> **Warning:** The V2 interface is an unstable preview. APIs may change before becoming stable.

The V2 interface simplifies multi-turn conversations with `send()` and `stream()` patterns instead of async generators.

### Quick Start

**One-shot prompt:**
```typescript
import { unstable_v2_prompt } from '@anthropic-ai/claude-agent-sdk';

const result = await unstable_v2_prompt('What is 2 + 2?', {
  model: 'claude-sonnet-4-5-20250929'
});
console.log(result.result);
```

**Multi-turn session:**
```typescript
import { unstable_v2_createSession } from '@anthropic-ai/claude-agent-sdk';

await using session = unstable_v2_createSession({
  model: 'claude-sonnet-4-5-20250929'
});

// Turn 1
await session.send('What is 5 + 3?');
for await (const msg of session.stream()) {
  if (msg.type === 'assistant') {
    const text = msg.message.content
      .filter(block => block.type === 'text')
      .map(block => block.text)
      .join('');
    console.log(text);
  }
}

// Turn 2 - Claude remembers context
await session.send('Multiply that by 2');
for await (const msg of session.stream()) {
  // Process response...
}
```

### V2 API

| Function | Description |
|----------|-------------|
| `unstable_v2_prompt(prompt, options)` | One-shot queries |
| `unstable_v2_createSession(options)` | Create new session |
| `unstable_v2_resumeSession(id, options)` | Resume existing session |

| Session Method | Description |
|----------------|-------------|
| `send(message)` | Send a message |
| `stream()` | Get response stream |
| `close()` | Close session |

### Feature Availability

Some V1 features are not yet available in V2:
- Session forking (`forkSession` option)
- Some advanced streaming input patterns

---

## Migration Guide

### Package Rename

The Claude Code SDK has been renamed to Claude Agent SDK.

**TypeScript:**
```bash
npm uninstall @anthropic-ai/claude-code
npm install @anthropic-ai/claude-agent-sdk
```

```typescript
// Before
import { query } from "@anthropic-ai/claude-code";

// After
import { query } from "@anthropic-ai/claude-agent-sdk";
```

**Python:**
```bash
pip uninstall claude-code-sdk
pip install claude-agent-sdk
```

```python
# Before
from claude_code_sdk import query, ClaudeCodeOptions

# After
from claude_agent_sdk import query, ClaudeAgentOptions
```

### Breaking Changes (v0.1.0)

**1. System prompt no longer default**

The SDK no longer uses Claude Code's system prompt by default.

```typescript
// Before (v0.0.x) - Claude Code system prompt by default
const result = query({ prompt: "Hello" });

// After (v0.1.0) - Empty system prompt by default
// To get old behavior:
const result = query({
  prompt: "Hello",
  options: {
    systemPrompt: { type: "preset", preset: "claude_code" }
  }
});
```

**2. Settings sources not loaded by default**

The SDK no longer reads from filesystem settings (CLAUDE.md, settings.json) by default.

```typescript
// Before (v0.0.x) - Loaded all settings automatically
const result = query({ prompt: "Hello" });

// After (v0.1.0) - No settings loaded by default
// To get old behavior:
const result = query({
  prompt: "Hello",
  options: {
    settingSources: ["user", "project", "local"]
  }
});
```

**3. Python type rename**

`ClaudeCodeOptions` is now `ClaudeAgentOptions`.

---

## Best Practices

### When to Use SDK vs CLI

| Scenario | Recommendation |
|----------|----------------|
| Interactive development | CLI |
| Automated pipelines | SDK |
| Custom UI/applications | SDK |
| Testing and experimentation | CLI |
| Production services | SDK |

### Cost Considerations

- Use `maxBudgetUsd` to cap spending per query
- Use `maxTurns` to limit conversation length
- Monitor costs via `ResultMessage.total_cost_usd`
- Consider `haiku` model for simple subagent tasks

### Token Efficiency

- System prompt is NOT included by default - add only what you need
- Settings sources are NOT loaded by default - include explicitly
- Use focused `allowedTools` to reduce tool descriptions in context

---

## Related Documentation

- [02-hooks.md](./02-hooks.md) - Hooks reference for CLI (same concepts apply to SDK)
- [09-subagents.md](./09-subagents.md) - Subagent concepts and patterns
- [11-mcp.md](./11-mcp.md) - MCP server configuration
- [13-headless-mode.md](./13-headless-mode.md) - CLI automation (SDK alternative)

---

## Resources

- **TypeScript SDK:** [npm package](https://www.npmjs.com/package/@anthropic-ai/claude-agent-sdk)
- **Python SDK:** [PyPI package](https://pypi.org/project/claude-agent-sdk/)
- **Example agents:** [GitHub demos](https://github.com/anthropics/claude-agent-sdk-demos)
- **TypeScript changelog:** [GitHub](https://github.com/anthropics/claude-agent-sdk-typescript/blob/main/CHANGELOG.md)
- **Python changelog:** [GitHub](https://github.com/anthropics/claude-agent-sdk-python/blob/main/CHANGELOG.md)
- **Bug reports:** [TypeScript](https://github.com/anthropics/claude-agent-sdk-typescript/issues) | [Python](https://github.com/anthropics/claude-agent-sdk-python/issues)
