# GitHub Actions

Claude Code GitHub Actions brings AI-powered automation to your GitHub workflow. With a simple `@claude` mention in any PR or issue, Claude can analyze code, create pull requests, implement features, and fix bugs.

## Overview

Claude Code GitHub Actions is built on the [Agent SDK](./13-headless-mode.md), enabling programmatic integration of Claude Code into CI/CD workflows.

### What Claude Can Do

- **Instant PR creation**: Describe what you need, Claude creates a complete PR
- **Automated implementation**: Turn issues into working code with `@claude implement this`
- **Code reviews**: `@claude review PR #456 for security issues`
- **Bug fixes**: `@claude fix the TypeError in the dashboard component`
- **Custom automation**: Scheduled reports, release notes, dependency updates

## Quick Setup

The easiest setup uses Claude Code's built-in installer:

```bash
claude
> /install-github-app
```

This guides you through:
1. Installing the GitHub app
2. Setting up required secrets

**Requirements:**
- Repository admin access
- Permissions: Contents, Issues, Pull Requests (read & write)

**Note:** Quick setup is for direct Claude API users. For AWS Bedrock or Google Vertex AI, see [Cloud Provider Setup](#aws-bedrock--google-vertex-ai).

## Manual Setup

If `/install-github-app` fails or you prefer manual configuration:

### 1. Install the GitHub App

Install from: https://github.com/apps/claude

**Required permissions:**
- **Contents**: Read & write (modify files)
- **Issues**: Read & write (respond to issues)
- **Pull requests**: Read & write (create PRs, push changes)

### 2. Add API Key Secret

Add `ANTHROPIC_API_KEY` to your repository secrets:

1. Go to Settings → Secrets and variables → Actions
2. Create new secret: `ANTHROPIC_API_KEY`
3. Paste your API key

### 3. Create Workflow File

Copy to `.github/workflows/claude.yml`:

```yaml
name: Claude Code
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]

jobs:
  claude:
    if: contains(github.event.comment.body, '@claude')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

### 4. Test

Tag `@claude` in an issue or PR comment to verify the setup.

## Basic Workflow

Minimal workflow responding to `@claude` mentions:

```yaml
name: Claude Code
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]

jobs:
  claude:
    runs-on: ubuntu-latest
    steps:
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          # Responds to @claude mentions in comments
```

## Configuration

### Action Parameters

| Parameter | Description | Required |
|-----------|-------------|----------|
| `anthropic_api_key` | Claude API key | Yes* |
| `prompt` | Instructions for Claude (text or slash command) | No |
| `claude_args` | CLI arguments passed to Claude Code | No |
| `github_token` | GitHub token for API access | No |
| `trigger_phrase` | Custom trigger (default: `@claude`) | No |
| `use_bedrock` | Use AWS Bedrock instead of Claude API | No |
| `use_vertex` | Use Google Vertex AI instead of Claude API | No |

*Required for direct Claude API, not for Bedrock/Vertex.

### Using Prompts

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    prompt: "Review this PR for security issues"
```

### Using Slash Commands

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    prompt: "/review"
    claude_args: "--max-turns 5"
```

### CLI Arguments

Pass any Claude Code CLI argument via `claude_args`:

```yaml
claude_args: "--max-turns 5 --model claude-sonnet-4-5-20250929"
```

Common arguments:
- `--max-turns`: Maximum conversation turns (default: 10)
- `--model`: Model to use
- `--mcp-config`: Path to MCP configuration
- `--allowed-tools`: Comma-separated allowed tools
- `--debug`: Enable debug output

## Workflow Examples

### Code Review on PR Open

```yaml
name: Code Review
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: "/review"
          claude_args: "--max-turns 5"
```

### Daily Summary Report

```yaml
name: Daily Report
on:
  schedule:
    - cron: "0 9 * * *"

jobs:
  report:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          prompt: "Generate a summary of yesterday's commits and open issues"
          claude_args: "--model claude-opus-4-5-20251101"
```

### Issue and PR Comments

```yaml
name: Claude Assistant
on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
  issues:
    types: [opened, assigned]

jobs:
  claude:
    if: |
      (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'issues' && contains(github.event.issue.body, '@claude'))
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: anthropics/claude-code-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

## Common Use Cases

In issue or PR comments:

```
@claude implement this feature based on the issue description
@claude how should I implement user authentication for this endpoint?
@claude fix the TypeError in the user dashboard component
@claude review this PR for security vulnerabilities
@claude create unit tests for the auth module
```

## AWS Bedrock & Google Vertex AI

For enterprise environments using cloud infrastructure.

### Prerequisites

**For AWS Bedrock:**
1. AWS account with Amazon Bedrock enabled
2. Claude models access requested in Bedrock
3. GitHub OIDC Identity Provider in AWS
4. IAM role with Bedrock permissions

**For Google Vertex AI:**
1. GCP project with Vertex AI API enabled
2. Workload Identity Federation for GitHub
3. Service account with Vertex AI permissions

### Creating a Custom GitHub App

For cloud providers, create your own GitHub App:

1. Go to https://github.com/settings/apps/new
2. Configure:
   - **Name**: "YourOrg Claude Assistant"
   - **Webhooks**: Uncheck "Active"
3. Set permissions:
   - Contents: Read & Write
   - Issues: Read & Write
   - Pull requests: Read & Write
4. Create and generate private key
5. Note your App ID
6. Install to your repository
7. Add secrets:
   - `APP_PRIVATE_KEY`: Contents of `.pem` file
   - `APP_ID`: Your GitHub App ID

### AWS Bedrock Workflow

**Required secrets:**

| Secret | Description |
|--------|-------------|
| `AWS_ROLE_TO_ASSUME` | IAM role ARN for Bedrock access |
| `APP_ID` | GitHub App ID |
| `APP_PRIVATE_KEY` | GitHub App private key |

```yaml
name: Claude PR Action

permissions:
  contents: write
  pull-requests: write
  issues: write
  id-token: write

on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
  issues:
    types: [opened, assigned]

jobs:
  claude-pr:
    if: |
      (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'issues' && contains(github.event.issue.body, '@claude'))
    runs-on: ubuntu-latest
    env:
      AWS_REGION: us-west-2
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Generate GitHub App token
        id: app-token
        uses: actions/create-github-app-token@v2
        with:
          app-id: ${{ secrets.APP_ID }}
          private-key: ${{ secrets.APP_PRIVATE_KEY }}

      - name: Configure AWS Credentials (OIDC)
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_TO_ASSUME }}
          aws-region: us-west-2

      - uses: anthropics/claude-code-action@v1
        with:
          github_token: ${{ steps.app-token.outputs.token }}
          use_bedrock: "true"
          claude_args: '--model us.anthropic.claude-sonnet-4-5-20250929-v1:0 --max-turns 10'
```

**Note:** Bedrock model IDs include region prefix and version suffix.

### Google Vertex AI Workflow

**Required secrets:**

| Secret | Description |
|--------|-------------|
| `GCP_WORKLOAD_IDENTITY_PROVIDER` | Workload identity provider resource name |
| `GCP_SERVICE_ACCOUNT` | Service account email with Vertex AI access |
| `APP_ID` | GitHub App ID |
| `APP_PRIVATE_KEY` | GitHub App private key |

```yaml
name: Claude PR Action

permissions:
  contents: write
  pull-requests: write
  issues: write
  id-token: write

on:
  issue_comment:
    types: [created]
  pull_request_review_comment:
    types: [created]
  issues:
    types: [opened, assigned]

jobs:
  claude-pr:
    if: |
      (github.event_name == 'issue_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'pull_request_review_comment' && contains(github.event.comment.body, '@claude')) ||
      (github.event_name == 'issues' && contains(github.event.issue.body, '@claude'))
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Generate GitHub App token
        id: app-token
        uses: actions/create-github-app-token@v2
        with:
          app-id: ${{ secrets.APP_ID }}
          private-key: ${{ secrets.APP_PRIVATE_KEY }}

      - name: Authenticate to Google Cloud
        id: auth
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: ${{ secrets.GCP_WORKLOAD_IDENTITY_PROVIDER }}
          service_account: ${{ secrets.GCP_SERVICE_ACCOUNT }}

      - uses: anthropics/claude-code-action@v1
        with:
          github_token: ${{ steps.app-token.outputs.token }}
          trigger_phrase: "@claude"
          use_vertex: "true"
          claude_args: '--model claude-sonnet-4@20250514 --max-turns 10'
        env:
          ANTHROPIC_VERTEX_PROJECT_ID: ${{ steps.auth.outputs.project_id }}
          CLOUD_ML_REGION: us-east5
```

## Best Practices

### CLAUDE.md Configuration

Create `CLAUDE.md` in your repository root to guide Claude:

```markdown
# Project Guidelines

## Code Style
- Use TypeScript strict mode
- Follow ESLint rules
- Write tests for new features

## Review Criteria
- Check for security vulnerabilities
- Ensure error handling
- Verify edge cases
```

Claude follows these guidelines when creating PRs and responding to requests.

### Security

**Never commit API keys.** Always use GitHub Secrets:

```yaml
# Correct
anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}

# Wrong - never do this
anthropic_api_key: "sk-ant-..."
```

**Limit permissions:**
- Use minimum required permissions
- Review Claude's suggestions before merging
- Consider branch protection rules

### Performance Optimization

- Use issue templates to provide context
- Keep `CLAUDE.md` concise and focused
- Configure appropriate `--max-turns`
- Set workflow timeouts

### Cost Considerations

**GitHub Actions costs:**
- Claude Code runs on GitHub-hosted runners
- Consumes GitHub Actions minutes
- See [GitHub billing](https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-actions/about-billing-for-github-actions)

**API costs:**
- Each interaction consumes API tokens
- Usage varies by task complexity and codebase size
- See [Claude pricing](https://claude.com/platform/api)

**Optimization tips:**
- Use specific `@claude` commands to reduce API calls
- Configure appropriate `--max-turns`
- Set workflow timeouts to avoid runaway jobs
- Use GitHub concurrency controls

## Migrating from Beta

If upgrading from beta version to v1.0:

### Required Changes

1. Update action version: `@beta` → `@v1`
2. Remove `mode` configuration (now auto-detected)
3. Replace `direct_prompt` with `prompt`
4. Move CLI options to `claude_args`

### Breaking Changes Reference

| Beta Input | v1.0 Input |
|------------|------------|
| `mode` | *(Removed - auto-detected)* |
| `direct_prompt` | `prompt` |
| `override_prompt` | `prompt` with GitHub variables |
| `custom_instructions` | `claude_args: --system-prompt` |
| `max_turns` | `claude_args: --max-turns` |
| `model` | `claude_args: --model` |
| `allowed_tools` | `claude_args: --allowedTools` |
| `disallowed_tools` | `claude_args: --disallowedTools` |
| `claude_env` | `settings` JSON format |

### Before/After Example

**Beta:**
```yaml
- uses: anthropics/claude-code-action@beta
  with:
    mode: "tag"
    direct_prompt: "Review this PR for security issues"
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    custom_instructions: "Follow our coding standards"
    max_turns: "10"
    model: "claude-sonnet-4-5-20250929"
```

**v1.0:**
```yaml
- uses: anthropics/claude-code-action@v1
  with:
    prompt: "Review this PR for security issues"
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    claude_args: |
      --system-prompt "Follow our coding standards"
      --max-turns 10
      --model claude-sonnet-4-5-20250929
```

## Troubleshooting

### Claude Not Responding

| Check | Solution |
|-------|----------|
| GitHub App installed? | Verify at Settings → GitHub Apps |
| Workflows enabled? | Check Actions tab is enabled |
| API key set? | Verify `ANTHROPIC_API_KEY` in secrets |
| Correct trigger? | Use `@claude` not `/claude` |

### CI Not Running on Claude's Commits

- Ensure using GitHub App (not Actions user)
- Check workflow triggers include necessary events
- Verify app permissions include CI triggers

### Authentication Errors

- Confirm API key is valid with sufficient permissions
- For Bedrock/Vertex: check IAM roles and OIDC config
- Verify secrets are named correctly in workflows

## Token Impact

| Component | Cost |
|-----------|------|
| Workflow files | ZERO (not in Claude context) |
| API usage | Per-token based on model |
| GitHub Actions | Minutes-based on runner time |

## See Also

- [Headless Mode](./13-headless-mode.md) - CLI automation underlying GitHub Actions
- [MCP](./11-mcp.md) - Connect to external tools in workflows
- [claude-code-action repo](https://github.com/anthropics/claude-code-action) - Official action source
