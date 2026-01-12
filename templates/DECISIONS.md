# Decision Journal

Tracks decisions, rejections, and experiments for this project. This file serves as external memory - preserving the "why" behind choices.

**Structure:** Reference sections at top, append-only Decisions Log at bottom.

---

## How to Use This File

### When making decisions:
1. Log the decision with context (append to bottom)
2. List options that were considered
3. Note which options were rejected and WHY
4. If experimenting, mark current approach and alternatives

### When pivoting:
1. Update the original entry with outcome
2. Document: what we tried → why it failed → what we're trying now

---

## Example Entries

These examples show the expected tone and level of detail.

### Example: Decision Entry

> ### 2026-01-15: API Authentication Method
>
> **Context:** Need to secure the API endpoints. Choosing between session-based auth and JWT tokens.
>
> **Options considered:**
> 1. Session-based authentication (cookies)
> 2. JWT tokens (stateless)
> 3. API keys (simple but limited)
>
> **Decision:** Option 2 - JWT tokens
>
> **Rejected:**
> - Option 1: Requires session storage, complicates horizontal scaling
> - Option 3: No user-level permissions, harder to revoke
>
> **Rationale:** JWT allows stateless auth, works well with mobile clients, and supports role-based claims.
>
> **Outcome:** Working well. Added refresh token rotation for security.

### Example: Rejection Entry

> ### Microservices Architecture
>
> **Proposed:** Split the monolith into microservices for better scaling.
>
> **Rejected because:**
> - Team of 2 doesn't need the operational overhead
> - Current traffic doesn't justify the complexity
> - Can revisit when we hit actual scaling issues
>
> **Date:** 2026-01-10

### Example: Experiment Entry

> ### 2026-01-12: Trying Tailwind CSS
>
> **Trying:** Tailwind CSS for styling instead of styled-components
>
> **Shortlisted alternatives:**
> 1. styled-components (current)
> 2. CSS Modules
>
> **Rollback point:** Git commit abc123 has the styled-components version
>
> **Status:** In Progress
>
> **Outcome:** [To be filled in]

---

## Rejected Ideas Archive

Ideas that were considered but rejected. Kept here so they're not re-proposed.

<!--
### [Feature/Idea Name]

**Proposed:** [What was suggested]

**Rejected because:** [Why it was rejected]

**Date:** [When]
-->

---

## Active Experiments

*None currently active.*

<!-- Template for experiments:
### [Date]: [Experiment Name]

**Trying:** [Current approach]

**Shortlisted alternatives:**
1. [Alternative 1]
2. [Alternative 2]

**Rollback point:** [How to revert if this doesn't work]

**Status:** In Progress / Succeeded / Failed

**Outcome:** [What happened, learnings]
-->

---

## Decisions Log

*Append new entries below. Most recent at bottom.*

---

<!-- Template for new entries:

### [Date]: [Decision Title]

**Context:** [What problem or question prompted this]

**Options considered:**
1. [Option 1]
2. [Option 2]

**Decision:** [Which option was chosen]

**Rejected:**
- [Option X]: [Why it was rejected]

**Rationale:** [Deeper explanation if needed]

**Outcome:** [Fill in later - what happened]

-->
