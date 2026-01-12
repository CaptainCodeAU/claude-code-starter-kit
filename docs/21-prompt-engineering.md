# Prompt Engineering for Claude Code

Prompt engineering is the practice of crafting effective instructions to get optimal results from Claude. These techniques apply across all Claude Code components: CLAUDE.md files, skills, slash commands, and subagent definitions.

This guide covers core techniques from Anthropic's official documentation, adapted specifically for Claude Code workflows.

**Token note:** This reference documentation has zero runtime cost—it lives in `docs/`, not in your project's `.claude/` folder. For token-efficient prompts in your actual configuration, see [Token Management](./04-token-management.md).

---

## 1. Be Clear and Direct

When interacting with Claude, think of it as a brilliant but new employee who needs explicit instructions. The more precisely you explain what you want, the better Claude's response will be.

### The Golden Rule

> Show your prompt to a colleague with minimal context on the task. If they're confused, Claude will likely be too.

### Provide Contextual Information

Give Claude the context it needs to perform well:

| Context Type | Example | Why It Helps |
|--------------|---------|--------------|
| Purpose | "This will be shown to customers" | Adjusts tone and detail level |
| Audience | "The reader is a senior developer" | Calibrates technical depth |
| Workflow | "This is step 2 of a 3-step process" | Understands dependencies |
| Success criteria | "A good response includes X, Y, Z" | Clarifies expectations |

### Be Specific

Vague instructions lead to inconsistent results:

| Vague | Specific |
|-------|----------|
| "Summarize this" | "Summarize in 3 bullet points, max 20 words each" |
| "Fix the code" | "Fix the type error on line 15 without changing the function signature" |
| "Make it better" | "Improve readability by extracting the nested conditionals into named functions" |

### Use Sequential Steps

For multi-step tasks, use numbered instructions:

```
Your task is to process the customer feedback.

Instructions:
1. Identify all mentioned product names
2. Categorize each mention as positive, negative, or neutral
3. Output as a markdown table with columns: Product, Sentiment, Quote
4. Sort by sentiment (negative first)
```

### Claude Code Application

**In CLAUDE.md:**
```markdown
## Commands
- Dev: `npm run dev`
- Test: `npm test`
- Build: `npm run build`

## Conventions
- Use TypeScript strict mode
- Components in PascalCase
- Hooks prefixed with "use"
```

**In skill descriptions:**
```yaml
description: Analyze test failures and suggest fixes. Use when tests fail or coverage drops.
```

The "Use when..." pattern tells Claude exactly when to invoke the skill.

---

## 2. Multishot Prompting (Examples)

Examples are your shortcut for getting Claude to generate exactly what you need. By providing well-crafted examples, you dramatically improve accuracy, consistency, and output quality.

### Why Use Examples

- **Accuracy**: Reduces misinterpretation of instructions
- **Consistency**: Enforces uniform structure and style
- **Performance**: Boosts Claude's ability to handle complex tasks

### Effective Example Characteristics

| Characteristic | Description |
|----------------|-------------|
| **Relevant** | Mirror your actual use case |
| **Diverse** | Cover edge cases and variations |
| **Clear** | Wrapped in `<example>` tags for structure |

### Example Format

Use `<example>` tags with clear input/output structure:

```xml
<examples>
  <example>
    <input>The app crashes when I click submit</input>
    <output>
Category: Bug Report
Severity: High
Component: Form Submission
    </output>
  </example>
  <example>
    <input>Would be nice to have dark mode</input>
    <output>
Category: Feature Request
Severity: Low
Component: UI/Theming
    </output>
  </example>
</examples>

Now categorize this feedback: {{FEEDBACK}}
```

### Include 3-5 Diverse Examples

More examples generally improve performance, especially for complex tasks. Include:
- Common cases (what you'll see most often)
- Edge cases (unusual inputs)
- Boundary cases (limits of acceptable input)

### Claude Code Application

**Skills with examples (EXAMPLES.md pattern):**

Create a skill folder structure:
```
skills/
└── code-review/
    ├── SKILL.md          # Main instructions
    └── EXAMPLES.md       # Detailed examples (lazy-loaded)
```

In SKILL.md:
```markdown
When reviewing code, check for:
- Security vulnerabilities
- Performance issues
- Code style violations

For detailed examples, see EXAMPLES.md in this folder.
```

**Slash commands with examples:**
```markdown
---
name: categorize
description: Categorize issues by type and priority
---

Categorize the following issue. Use these examples as reference:

<example>
Input: "Login button doesn't work on Safari"
Output: { "type": "bug", "priority": "high", "component": "auth" }
</example>

<example>
Input: "Add export to PDF feature"
Output: { "type": "feature", "priority": "medium", "component": "export" }
</example>

Issue to categorize: $ARGUMENTS
```

---

## 3. Chain of Thought (Let Claude Think)

Chain of thought (CoT) prompting encourages Claude to break down problems step-by-step, leading to more accurate and nuanced outputs.

### When to Use CoT

| Good for CoT | Skip CoT |
|--------------|----------|
| Complex math or logic | Simple factual questions |
| Multi-step analysis | Direct lookups |
| Decisions with many factors | Formatting tasks |
| Debugging complex issues | Straightforward transformations |

### CoT Approaches

**Basic CoT** - Simple instruction:
```
Think step-by-step before answering.
```

**Guided CoT** - Specific thinking steps:
```
Before answering, think through:
1. What are the key requirements?
2. What constraints exist?
3. What approaches might work?
4. Which approach best fits the constraints?
```

**Structured CoT** - Separate thinking from answer:
```
Think through this problem in <thinking> tags, then provide your answer in <answer> tags.

<thinking>
[Your reasoning here]
</thinking>

<answer>
[Final answer here]
</answer>
```

### Example: Financial Analysis with CoT

Without CoT:
```
Which investment option is better: 12% volatile stock or 6% guaranteed bond for a 5-year goal?
→ "I recommend the bond for stability."
```

With structured CoT:
```
<thinking>
1. Goal: Down payment in 5 years (fixed timeline, can't delay)
2. Stock analysis:
   - Best case: $10,000 × 1.12^5 = $17,623
   - Risk: Could lose 50% in crash = $5,000
3. Bond analysis:
   - Guaranteed: $10,000 × 1.06^5 = $13,382
4. Risk tolerance: Essential goal, short timeline, can't recover from loss
5. Conclusion: Certainty more valuable than potential gains
</thinking>

<answer>
I recommend the bond. While the stock could yield $17,623 vs the bond's $13,382, the 5-year timeline and essential nature of your goal make the guaranteed return more appropriate. A market downturn close to your deadline could jeopardize your down payment.
</answer>
```

### Claude Code Application

**Complex slash commands:**
```markdown
---
name: debug
description: Debug an error with structured analysis
---

Debug the following error using this process:

<instructions>
1. In <analysis> tags, identify:
   - Error type and message
   - Stack trace key points
   - Likely root causes (list 2-3)

2. In <investigation> tags, describe:
   - What you would check first
   - What evidence would confirm each hypothesis

3. In <solution> tags, provide:
   - The most likely fix
   - How to verify the fix worked
</instructions>

Error to debug:
$ARGUMENTS
```

**Subagent reasoning:**
```yaml
---
name: architecture-reviewer
description: Reviews architectural decisions with structured analysis
model: opus
---

When reviewing architecture decisions:

1. First, understand the context (what problem is being solved)
2. Then, evaluate against principles (SOLID, separation of concerns)
3. Consider alternatives (what else could work)
4. Finally, provide recommendation with tradeoffs

Think through each step explicitly before giving your final assessment.
```

---

## 4. XML Tags

XML tags help Claude parse prompts accurately by clearly separating different components. They improve clarity, reduce errors, and make outputs easier to process.

### Benefits of XML Tags

| Benefit | Description |
|---------|-------------|
| **Clarity** | Visually separates prompt sections |
| **Accuracy** | Reduces Claude mixing up instructions with content |
| **Flexibility** | Easy to add, remove, or modify sections |
| **Parseability** | Structured output is easier to extract programmatically |

### Common Tag Patterns

| Tag | Purpose | Example |
|-----|---------|---------|
| `<context>` | Background information | `<context>{{PROJECT_README}}</context>` |
| `<instructions>` | Task directives | `<instructions>Summarize in 3 points</instructions>` |
| `<example>` | Demonstrations | `<example>Input: X → Output: Y</example>` |
| `<format>` | Output requirements | `<format>JSON with keys: name, type</format>` |
| `<constraints>` | Limitations | `<constraints>Max 100 words</constraints>` |
| `<thinking>` | Reasoning space | `<thinking>Let me analyze...</thinking>` |
| `<output>` | Final response | `<output>The answer is...</output>` |

### Nesting Tags

Use hierarchical tags for complex structures:

```xml
<documents>
  <document index="1">
    <source>requirements.md</source>
    <content>{{REQUIREMENTS}}</content>
  </document>
  <document index="2">
    <source>design.md</source>
    <content>{{DESIGN}}</content>
  </document>
</documents>

<instructions>
Compare the requirements against the design and identify gaps.
</instructions>
```

### Reference Tags in Instructions

Be explicit about which tags contain what:

```
Using the code in <code> tags and the error in <error> tags,
identify the bug and suggest a fix.

<code>
{{SOURCE_CODE}}
</code>

<error>
{{ERROR_MESSAGE}}
</error>
```

### Claude Code Application

**CLAUDE.md structure:**
```markdown
# Project Name

## Context
React application with TypeScript and Tailwind CSS.

## Commands
- `npm run dev` - Start development server
- `npm test` - Run tests

## Conventions
- Functional components only
- Props interfaces named `{Component}Props`
```

While not XML, this markdown structure serves a similar purpose—clear sections that Claude can reference.

**Skill organization:**
```markdown
# Code Review Skill

<checklist>
- [ ] No console.log statements
- [ ] Error handling present
- [ ] Types are explicit (no `any`)
- [ ] Tests cover new code
</checklist>

<severity_levels>
- Critical: Security issues, data loss risks
- Major: Bugs, missing error handling
- Minor: Style issues, naming
</severity_levels>

Review the code and categorize issues by severity level.
```

---

## 5. System Prompts (Role Prompting)

System prompts set Claude's role and persona. The right role can dramatically improve performance in domain-specific tasks.

### Why Use Roles

| Benefit | Description |
|---------|-------------|
| **Enhanced accuracy** | Domain expertise framing improves responses |
| **Tailored tone** | CFO brevity vs. teacher thoroughness |
| **Improved focus** | Stays within task-specific boundaries |

### Effective Role Patterns

| Role Type | Example | Best For |
|-----------|---------|----------|
| **Expert** | "You are a senior security engineer" | Technical analysis |
| **Reviewer** | "You are a code reviewer at a Fortune 500 company" | Quality assessment |
| **Teacher** | "You are a patient programming tutor" | Explanations |
| **Analyst** | "You are a data analyst specializing in e-commerce" | Data interpretation |

### Role Prompting Example

Without role:
```
Analyze this contract for risks.
→ Generic summary of clauses
```

With role:
```
You are the General Counsel of a Fortune 500 tech company reviewing
a software licensing agreement for core infrastructure.

Analyze for risks focusing on indemnification, liability, and IP ownership.
Give your professional opinion.
→ Detailed risk analysis with specific legal concerns and recommendations
```

### Keep Roles Concise

A role prompt doesn't need to be lengthy:

```
# Good (concise)
You are a senior Python developer who values clean, readable code.

# Too long (wastes tokens)
You are a senior Python developer with 15 years of experience who has
worked at Google, Facebook, and several startups. You value clean code,
follow PEP 8, prefer functional approaches, and always write comprehensive
tests. You mentor junior developers and have spoken at PyCon...
```

### Claude Code Application

**CLAUDE.md as system prompt:**
```markdown
# Project Context

You are working on a healthcare data platform. Patient privacy is paramount.

## Security Requirements
- Never log PII
- All data access must be audited
- Use parameterized queries only
```

**Subagent personas:**
```yaml
---
name: security-auditor
description: Reviews code for security vulnerabilities
model: sonnet
---

You are a security engineer specializing in web application security.
Focus on OWASP Top 10 vulnerabilities.

When reviewing code:
1. Identify potential vulnerabilities
2. Rate severity (Critical/High/Medium/Low)
3. Provide specific remediation steps
```

---

## 6. Prefill Claude's Response

Prefilling lets you start Claude's response with specific text, giving you control over output format and structure.

### Use Cases

| Use Case | Prefill | Effect |
|----------|---------|--------|
| Force JSON | `{` | Skips preamble, outputs JSON directly |
| Start list | `1.` | Begins with numbered list |
| Set structure | `## Analysis\n` | Starts with specific heading |
| Maintain persona | `[Detective]:` | Keeps character consistent |

### JSON Output Control

Without prefill:
```
Extract name and age as JSON.
→ "Here's the extracted information in JSON format:\n```json\n{..."
```

With prefill (assistant message starts with `{`):
```
Extract name and age as JSON.
→ {"name": "John", "age": 30}
```

### Skipping Preambles

Prefill eliminates "Here's what I found:" introductions:

```python
messages = [
    {"role": "user", "content": "List the top 3 issues."},
    {"role": "assistant", "content": "1."}  # Prefill
]
# Response continues: "1. Missing error handling\n2. No input validation..."
```

### Character Maintenance

For long conversations with personas:

```python
messages = [
    {"role": "user", "content": "What do you think of this code?"},
    {"role": "assistant", "content": "[Code Reviewer]:"}  # Prefill
]
# Response: "[Code Reviewer]: This implementation has several concerns..."
```

### Important Limitations

- **No trailing whitespace**: Prefill `"{ "` (with space) will error
- **Not available with extended thinking**: Use structured CoT instead
- **Don't overuse**: Sometimes preambles provide useful context

### Claude Code Application

**Slash commands with structured output:**
```markdown
---
name: extract-api
description: Extract API endpoints from code
---

Find all API endpoints in the provided code and return as JSON.

The response should be a JSON array. Start your response with: [
```

**Structured extraction in skills:**
```markdown
# Data Extraction Skill

When extracting data, output ONLY valid JSON with no additional text.

Format:
{
  "extracted": [...],
  "confidence": "high|medium|low",
  "notes": "..."
}

Begin your response with the opening brace.
```

---

## 7. Chain Complex Prompts

For complex tasks, break them into smaller subtasks connected in a chain. Each step gets Claude's full attention, reducing errors.

### Why Chain Prompts

| Benefit | Description |
|---------|-------------|
| **Accuracy** | Each subtask gets focused attention |
| **Clarity** | Simpler instructions per step |
| **Traceability** | Easy to pinpoint and fix issues |
| **Debuggability** | Isolate problematic steps |

### When to Chain

- Research synthesis (gather → analyze → synthesize)
- Document analysis (extract → categorize → summarize)
- Content creation (outline → draft → edit → format)
- Decision making (gather info → list options → analyze → recommend)

### Self-Correction Chains

Have Claude review its own work:

**Step 1: Generate**
```
Summarize this research paper focusing on methodology and findings.
```

**Step 2: Critique**
```
Review this summary for accuracy and completeness:
<summary>{{STEP1_OUTPUT}}</summary>

Grade on:
- Accuracy (A-F)
- Clarity (A-F)
- Completeness (A-F)
```

**Step 3: Refine**
```
Improve this summary based on the feedback:
<summary>{{STEP1_OUTPUT}}</summary>
<feedback>{{STEP2_OUTPUT}}</feedback>
```

### Chain Workflow Patterns

| Pattern | Steps | Use For |
|---------|-------|---------|
| **Linear** | A → B → C | Sequential dependencies |
| **Fan-out** | A → [B, C, D] → E | Parallel analysis, then merge |
| **Iterative** | A → B → A' → B' | Refinement loops |
| **Verification** | A → Check → A (if fail) | Quality gates |

### Claude Code Application

**Multi-step skills:**
```markdown
# Migration Skill

This skill performs database migrations in phases.

## Phase 1: Analysis
Analyze the current schema and target schema.
Output differences in <analysis> tags.

## Phase 2: Plan
Create a migration plan with rollback steps.
Output in <plan> tags.

## Phase 3: Generate
Generate migration scripts.
Output in <scripts> tags.

## Phase 4: Verify
Review scripts for data safety.
Output verification in <verification> tags.
```

**Subagent workflows:**

Define subagents that call each other:
```yaml
# agents/code-improver.yml
---
name: code-improver
description: Improves code through analysis and refactoring
---

1. First, analyze the code for issues (call code-analyzer if available)
2. Then, propose improvements
3. Finally, generate the improved code

If the improvement is significant, explain the before/after difference.
```

---

## 8. Long Context Tips

Claude's extended context window (200K tokens) enables handling complex, data-rich tasks. Use these strategies to maximize effectiveness.

### Document Placement

**Put long content at the TOP of your prompt**, above instructions:

```xml
<documents>
  {{LONG_DOCUMENT_1}}
  {{LONG_DOCUMENT_2}}
</documents>

<instructions>
Based on the documents above, identify the key risks.
</instructions>
```

Queries at the end can improve response quality by up to 30% with complex inputs.

### Structure Multi-Document Input

```xml
<documents>
  <document index="1">
    <source>annual_report_2024.pdf</source>
    <document_content>
      {{ANNUAL_REPORT}}
    </document_content>
  </document>
  <document index="2">
    <source>competitor_analysis.xlsx</source>
    <document_content>
      {{COMPETITOR_DATA}}
    </document_content>
  </document>
</documents>

Analyze the annual report and competitor analysis.
Identify strategic advantages and recommend Q3 focus areas.
```

### Ground Responses in Quotes

For long documents, ask Claude to cite sources:

```xml
<documents>
  {{PATIENT_RECORDS}}
  {{APPOINTMENT_HISTORY}}
</documents>

First, find relevant quotes from the documents and place them in <quotes> tags.
Then, based on these quotes, provide your analysis in <analysis> tags.
```

This helps Claude "cut through the noise" of long documents.

### Claude Code Application

**Large codebase skills:**
```markdown
# Codebase Analysis Skill

When analyzing large codebases:

1. Start by examining the entry points (main files, index files)
2. Trace the execution path relevant to the question
3. Quote specific code sections that support your analysis
4. Reference file paths for all code mentions

Format: `path/to/file.ts:lineNumber`
```

**Reference file organization:**
```
skills/
└── api-design/
    ├── SKILL.md
    ├── REFERENCE.md        # Long-form patterns (lazy-loaded)
    └── EXAMPLES.md         # Detailed examples (lazy-loaded)
```

Keep main skill files concise; put long content in reference files that load on demand.

---

## 9. Extended Thinking Tips

Extended thinking allows Claude to work through complex problems step-by-step with dedicated "thinking time." This improves performance on difficult tasks.

### When to Use Extended Thinking

| Task Type | Example | Why Extended Thinking Helps |
|-----------|---------|----------------------------|
| **Complex STEM** | Physics simulations, algorithm design | Requires building mental models |
| **Constraint optimization** | Trip planning with 8+ constraints | Must balance competing requirements |
| **Thinking frameworks** | Porter's Five Forces analysis | Methodical framework application |
| **Multi-step reasoning** | Legal contract analysis | Sequential logical dependencies |

### General Instructions Over Step-by-Step

Claude often performs better with high-level instructions than prescriptive steps:

**Instead of:**
```
Think through this step by step:
1. First identify the variables
2. Then set up the equation
3. Next solve for x...
```

**Use:**
```
Please think about this problem thoroughly and in great detail.
Consider multiple approaches and show your complete reasoning.
Try different methods if your first approach doesn't work.
```

### Multishot with Extended Thinking

You can include thinking examples:

```
I'll show you how to solve a problem, then you solve a similar one.

Problem 1: What is 15% of 80?

<thinking>
To find 15% of 80:
1. Convert 15% to decimal: 15% = 0.15
2. Multiply: 0.15 × 80 = 12
</thinking>

Answer: 12

Now solve: What is 35% of 240?
```

### Reflection and Verification

Ask Claude to check its work:

```
Write a function to calculate factorial.

Before you finish, verify your solution with test cases:
- n=0 (should return 1)
- n=1 (should return 1)
- n=5 (should return 120)

Fix any issues you find.
```

### Claude Code Application

**Opus model for complex analysis:**
```yaml
---
name: architecture-planner
description: Plans complex system architectures
model: opus
---

When designing architecture:
- Think deeply about scalability requirements
- Consider multiple approaches before recommending
- Verify your design against common failure modes
- If uncertain, explore alternatives in your reasoning
```

**Planning subagents:**

The built-in `Plan` subagent uses extended thinking patterns:
```yaml
---
name: implementation-planner
model: opus
skills:
  - architecture-patterns
---

Design a detailed implementation plan for the requested feature.
Consider edge cases, dependencies, and testing strategy.
Take time to think through potential issues before finalizing.
```

---

## 10. Prompt Generator Tool

Anthropic provides a prompt generator tool in the Console that helps create effective prompts.

### What It Does

The prompt generator:
- Solves the "blank page problem"
- Creates structured prompt templates
- Follows prompt engineering best practices
- Generates prompts tailored to your specific task

### How to Use

1. Go to the [Anthropic Console](https://console.anthropic.com)
2. Describe your task in plain language
3. The generator creates a structured prompt template
4. Refine and iterate on the generated prompt

### When to Use

- Starting a new project and need a prompt foundation
- Unsure how to structure a complex prompt
- Want to quickly test different prompt approaches
- Learning prompt engineering patterns

### Claude Code Application

Use generated prompts as starting points for:
- Skill instructions
- Slash command prompts
- CLAUDE.md sections
- Subagent system prompts

The generator is particularly useful for creating initial drafts of complex skill prompts that you then refine.

---

## Applying Techniques to Claude Code

### CLAUDE.md Optimization

| Technique | Application in CLAUDE.md | Token Impact |
|-----------|-------------------------|--------------|
| Be Direct | Concise conventions, no fluff | Reduces tokens |
| XML/Structure | Clear markdown sections | Neutral |
| Role Prompt | Brief project context opener | +10-20 tokens |
| Examples | Avoid—put in skills instead | Saves tokens |
| CoT Instructions | Avoid—put in skills instead | Saves tokens |

**Keep CLAUDE.md lean (50-150 tokens)**. Move detailed content to skills.

### Skill Description Patterns

| Pattern | Example | Effect |
|---------|---------|--------|
| WHAT + WHEN | "Generates migration scripts. Use when changing DB schema." | Reliable triggering |
| Third person | "Analyzes code" not "I analyze code" | Consistent discovery |
| Key terms | Include domain vocabulary ("API", "REST", "endpoint") | Better semantic matching |
| Specific scope | "for React components" not "for code" | Focused invocation |

### Where to Put Prompt Content

| Content Type | Best Location | Token Cost at Startup |
|--------------|---------------|----------------------|
| Project role/persona | CLAUDE.md | ~20 tokens |
| Quick conventions | CLAUDE.md | ~50-100 tokens |
| Detailed examples | Skills (EXAMPLES.md) | 0 |
| Chain of thought scaffolds | Skills or Commands | 0 |
| Output templates | Slash commands | 0 |
| Reference documentation | Skills (REFERENCE.md) | 0 |

**Rule of thumb:** If it's more than 2-3 sentences, it belongs in a skill, not CLAUDE.md.

### Slash Command Structure

```markdown
---
name: command-name
description: Brief description for discovery
allowed-tools: [Edit, Write, Bash]
---

<context>
Background information about what this command does
</context>

<instructions>
1. First step
2. Second step
3. Output format requirements
</instructions>

<constraints>
- Limitation 1
- Limitation 2
</constraints>

Input: $ARGUMENTS
```

### Subagent System Prompts

```yaml
---
name: specialized-agent
description: What this agent does and when to use it
model: sonnet  # or opus for complex reasoning
allowed-tools:
  - Read
  - Grep
  - Glob
disallowed-tools:
  - Write
  - Edit
---

You are a [role] specializing in [domain].

When given a task:
1. [First action]
2. [Second action]
3. [Output format]

Constraints:
- [Limitation relevant to this agent's scope]
- [Safety consideration]
```

---

## Anti-Patterns and Troubleshooting

### Common Mistakes

| Anti-Pattern | Problem | Solution |
|--------------|---------|----------|
| Vague instructions | Misinterpretation, inconsistent results | Be specific, add context |
| No examples | Claude guesses format/style | Add 3-5 diverse examples |
| Long CLAUDE.md | Token waste, buried information | Move details to skills |
| Missing output format | Wrong structure | Specify format explicitly or use prefill |
| Over-constraining | Stilted, unhelpful responses | Balance constraints with flexibility |
| Assuming context | Claude doesn't know project history | Provide relevant background |

### Troubleshooting Guide

**Skill not triggering:**
- Add "Use when..." to description
- Include key domain terms in description
- Make description more specific

**Output format wrong:**
- Add explicit format instructions
- Use XML tags for structure
- Consider prefilling the response start

**Claude ignores CLAUDE.md instructions:**
- CLAUDE.md may be too long (buried content)
- Move critical instructions to top
- Split into sections with clear headers

**Subagent goes off-task:**
- System prompt too broad
- Add explicit constraints
- Limit available tools with `allowed-tools`

**Inconsistent behavior:**
- Add examples (multishot prompting)
- Be more specific about edge cases
- Use structured output requirements

**Response too verbose:**
- Add word/sentence limits
- Use "Be concise" or "Brief response only"
- Specify "No preamble" or prefill to skip intro

---

## Quick Reference

### Technique Selection Guide

| Task Type | Primary Technique | Secondary Technique |
|-----------|-------------------|---------------------|
| Data extraction | XML tags + Prefill | Examples |
| Analysis tasks | Chain of thought | Role prompting |
| Code review | Role prompting | Examples |
| Format conversion | Examples | XML structure |
| Complex reasoning | Extended thinking | Chain prompts |
| Long document work | Document structure | Quote extraction |
| Creative writing | Role prompting | Clear constraints |
| Multi-step workflow | Chain prompts | Verification loops |

### Claude Code Component Mapping

| Component | Key Techniques | Notes |
|-----------|---------------|-------|
| CLAUDE.md | Be direct, Light role prompt | Keep minimal |
| Skills | All techniques | Heavy content here |
| Slash commands | Prefill, Examples, XML | Loaded on demand |
| Subagents | Role prompt, CoT, Constraints | Isolated context |
| Hooks | Clear conditions | Executed, not prompted |

---

## Resources

### Official Tutorials

- [GitHub Prompting Tutorial](https://github.com/anthropics/prompt-eng-interactive-tutorial) - Interactive examples
- [Google Sheets Tutorial](https://docs.google.com/spreadsheets/d/19jzLgRruG9kjUQNKtCg1ZjdD6l6weA6qRXG5zLIAhC8) - Lightweight version
- [Prompt Library](https://docs.anthropic.com/en/prompt-library) - Curated prompt examples
- [Anthropic Console](https://console.anthropic.com) - Prompt generator tool

### Related Documentation

- [03-skills.md](./03-skills.md) - Creating effective skills
- [04-token-management.md](./04-token-management.md) - Context optimization
- [07-claude-md-best-practices.md](./07-claude-md-best-practices.md) - Memory file patterns
- [09-subagents.md](./09-subagents.md) - Subagent configuration
- [10-slash-commands.md](./10-slash-commands.md) - Command creation
