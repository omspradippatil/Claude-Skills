---
name: gsd-core
description: >-
  Activate this skill for complex features, multi-stage milestones, major refactoring, and
  long-running development tasks requiring disciplined phase loops (Discuss, Research, Plan, Execute, Verify)
  and persistent project state artifacts. Do not use for simple bug fixes or routine edits.
---

# GSD Core — Spec-Driven Complex Development Skill

Official upstream: [open-gsd/gsd-core](https://github.com/open-gsd/gsd-core) (MIT License)

---

## Philosophy & Core Objective

"Git. Ship. Done."

Complex engineering tasks fail when agents lose context ("context rot"), attempt to solve too many things in a single turn, skip architectural alignment, or claim completion without verification.

GSD Core enforces a structured, phase-bounded development lifecycle designed to keep context focused, code thoroughly grounded, and progress auditable across sessions.

---

## When to Activate

- Building non-trivial multi-file features or services.
- Major system refactoring or architectural migrations.
- Greenfield project initialization or multi-milestone roadmaps.
- Tasks spanning multiple engineering domains (e.g., fullstack API + UI + Database + Security).

### When NOT to Activate
- Single-line edits, typo fixes, or small bug fixes (use lightweight execution under `policies/engineering.md`).
- Simple documentation edits or routine shell commands.
- Standalone research questions.

---

## The 5-Phase Lifecycle

```
┌───────────┐     ┌───────────┐     ┌───────────┐     ┌───────────┐     ┌───────────┐
│  Discuss  │ ──► │ Research  │ ──► │   Plan    │ ──► │  Execute  │ ──► │  Verify   │
└───────────┘     └───────────┘     └───────────┘     └───────────┘     └───────────┘
```

### Phase 1: Discuss
- Align on the user's core intent, functional requirements, and constraints.
- Define explicit acceptance criteria before touching code.
- Clarify edge cases, performance targets, and security expectations.
- Agree on what is in scope and what is explicitly out of scope.

### Phase 2: Research
- Inspect the codebase to understand existing conventions, data flows, and callers.
- Identify external dependencies, APIs, and potential breaking changes.
- If subagents are supported, delegate deep codebase scans to isolated subagent contexts.
- Resolve technical unknowns before writing implementation plans.

### Phase 3: Plan
- Break the milestone into small, sequential, testable tasks.
- Establish dependency order: database ➔ backend API ➔ frontend UI ➔ integration tests.
- Define the exact write scope for each task.
- Persist plan and decisions in durable project artifacts (`PROJECT.md`, `ROADMAP.md`, or task state) so work survives context resets.

### Phase 4: Execute
- Implement one bounded task at a time.
- Ground before mutating: read existing files and tests before modifying.
- Adhere strictly to the declared write scope; do not wander into unrelated files.
- Apply Ponytail minimal engineering: write the smallest correct solution.

### Phase 5: Verify
- Require fresh evidence: run validators, type checks, unit tests, and integration tests *after* final mutations.
- Check actual task acceptance criteria directly.
- Report honest findings: distinguish executed evidence from assumptions or suggestions.

---

## State Persistence & Context Management

To prevent context rot during large tasks:
1. **Durable Milestones**: Write architectural decisions, active phase, and completed checklist items to a tracking markdown file in the project (e.g., `.claude-skills/state/task-plan.md` or `ROADMAP.md`).
2. **Context Resets**: When conversation history becomes large, summarize progress into the persistent state file so a fresh turn can resume cleanly.
3. **Subagent Delegation**: Where supported (e.g. Antigravity subagents), offload parallel investigations or bounded implementation tasks to child agents. Retain the main session for orchestration, dependency tracking, and final verification.

---

## Integration with Repository Policies

GSD Core orchestrates the workflow lifecycle, while repository policies govern technical rules:
- **Gravitas Core**: Supplies the six reliability invariants and completion evidence requirements.
- **Policies (Security, SEO, Frontend, Testing)**: Authoritative rules for each specific domain.
- **Ponytail**: Guides minimal, unbloated code implementation within Phase 4.
- **Caveman**: Keeps progress reports and execution logs concise and focused.
