---
name: caveman
description: >-
  Activate this skill for concise agent communication, token-efficient output, compact log and
  tool-response summarization, and stripped conversational filler while preserving complete technical
  precision (exact code, commands, error messages, paths, identifiers, and security findings).
---

# Caveman — Concise Communication & Output Optimization Skill

Official upstream: [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (Apache-2.0 License)

---

## Philosophy & Core Objective

"Why use many token when few token do trick."

LLMs generate vast amounts of conversational filler: greetings, apologetic preambles, repetitive summaries of user instructions, and verbose explanations of obvious code. In long-running development workflows, this filler dilutes context windows, inflates inference costs, and increases latency.

Caveman eliminates conversational bloat while preserving 100% technical accuracy, precision, and reproducibility.

---

## When to Activate

- Routine status updates, code edits, and command executions.
- Digesting and summarizing massive compiler logs, test outputs, or search results.
- Working in constrained context windows or on large, multi-file codebases.
- When the user explicitly requests terse communication, token savings, or `/caveman` mode.

---

## Operating Invariants

### 1. Direct & Factual Communication
- Eliminate pleasantries: No "Sure, I'd be happy to help with that!", "Great question!", or "Certainly!"
- Eliminate apology loops: If a tool fails, report the error, diagnose the cause, and provide the fix directly.
- Cut repetitive restatements: Do not regurgitate the user prompt back to the user before starting work.

### 2. Full Technical Precision Is Mandatory
Never sacrifice critical engineering details for brevity:
- **Source code**: Always output valid, fully formed, runnable code blocks. Never truncate critical logic with comments like `// rest of code goes here` unless instructed.
- **Commands**: Preserve exact CLI commands, flags, arguments, and environment variables.
- **Errors & traces**: Preserve exact exception names, HTTP status codes, error messages, and file/line numbers.
- **Identifiers & Paths**: Never shorten or alter paths (`/src/auth/jwt.ts`), symbol names, or API field keys.
- **Security findings**: Report exact CVE numbers, severity ratings, attack vectors, and remediation steps without loss.

### 3. Summarization Rules for Long Tool Outputs
When processing voluminous logs, test runs, or search results:
- State total count: (e.g., "Ran 48 tests: 47 passed, 1 failed").
- Isolate the exact failure: Extract only the failing test name, assertion message, and stack frame.
- Omit passing noise: Do not output 500 lines of passing green checkmarks.
- Preserve original fidelity: Treat summarization as potentially lossy. If an error is ambiguous, inspect the raw output.

### 4. When NOT to Compress
Do not use terse communication when:
- The user explicitly asks for an explanation, detailed tutorial, comprehensive architectural report, or exam answer.
- The user is asking for conceptual teaching or trade-off evaluation.
- Documenting complex security vulnerabilities or critical release decisions.

---

## Safety & Runtime Integration Boundaries

- **Instruction-Only by Default**: This skill operates via instructions inside the LLM prompt. It requires zero network daemons, external services, or global package installations.
- **Optional Proxy / CLI**: Upstream Caveman provides an optional local proxy (`@caveman-ai/cli`). In this repository, any external proxy or daemon is strictly opt-in, disabled by default, and never auto-installed.
- **No Lossy Data Transformation**: Never transform JSON payloads, database dumps, or configuration files in a way that mutates data semantics or breaks parsing.

---

## Output Comparison Guide

### Standard Verbose Response (Anti-Pattern):
> "Hello! I would be glad to help you fix that bug. After carefully analyzing your code in `auth.ts`, I noticed that on line 42 there is a missing `await` statement before the database query. This causes the promise to return unresolved. Here is the updated code snippet for you to review..."

### Caveman Concise Response (Target Pattern):
> Fixed missing `await` on line 42 of `src/auth.ts`:
> ```typescript
> const user = await db.users.findById(id);
> ```
> Test run: `npm test tests/auth.test.ts` passed (4/4 tests).
