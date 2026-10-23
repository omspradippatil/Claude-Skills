---
name: gravitas
description: >-
  Activate this skill for engineering reliability, strict read-before-write grounding, write-scope
  enforcement, fresh evidence verification gates, intelligent failure diagnosis, and honest evidence reporting.
---

# Gravitas — Engineering Reliability & Evidence-Based Completion Skill

Official upstream: [udaysharmadev/Gravitas](https://github.com/udaysharmadev/Gravitas) (MIT License)

---

## Purpose & Architecture

Gravitas is a reliability framework that eliminates common agent failure modes: mutating unread files, wandering outside task scope, assuming stale test runs prove new code, repeating failed commands blindly, and declaring completion without evidence.

This skill provides **instruction-only Gravitas Core**, delivering portable, zero-overhead behavioral enforcement across Claude Code, Antigravity, Codex, and Cursor without external daemon dependencies or fragile monkey-patching.

---

## The Six Reliability Invariants

Every code modification must strictly uphold these six invariants:

### 1. Ground Before Mutating
- **Rule**: Inspect target files, relevant callers, and existing tests before editing.
- **Why**: Editing based on memory, hallucinated symbol names, or outdated assumptions introduces instant syntax or logic breakage.
- **Evidence**: The file must be read in the current conversation turn prior to applying edits.

### 2. Stay Within Declared Scope
- **Rule**: Define the bounded write scope (files intended for modification) before starting nontrivial tasks.
- **Why**: Scope creep breaks unrelated modules and creates bloated PR diffs.
- **Protocol**: If solving the task legitimately requires editing files outside the initial scope, explicitly declare the expanded scope and justify it.

### 3. Require Fresh Evidence
- **Rule**: Run relevant validators, tests, or lint checks *after the final code mutation*.
- **Why**: Earlier passing tests are stale evidence. An edit made after running tests invalidates prior test passes.
- **Protocol**: The final action before reporting completion must be fresh verification.

### 4. Recover Intelligently
- **Rule**: When a command, test, or approach fails, diagnose the root cause and alter the strategy before retrying.
- **Why**: Repeating an identical failed tool call or command without changing inputs or fixing errors wastes tokens and gets stuck in loops.
- **Protocol**: State the error diagnosis, the corrective action taken, and then re-execute. Maximum 3 bounded attempts before escalating to the user.

### 5. Meet Acceptance Criteria
- **Rule**: Verify the concrete functional and edge-case requirements of the active task directly.
- **Why**: Relying on 50 unrelated unit tests passing while the new feature code remains untested provides a false sense of security.
- **Protocol**: Formulate checks specifically targeting the new code paths, error states, and user requirements.

### 6. Report Honestly
- **Rule**: Never fabricate, exaggerate, or assume outcomes.
- **Why**: Trust requires absolute precision in status reporting.
- **Protocol**: Clearly distinguish between:
  - **Executed checks** (with exact command, exit code, and output snippet).
  - **Suggested manual checks** for the operator.
  - **Verified facts** versus **assumptions**.
  - **Completed work** versus **outstanding or unverified limitations**.

---

## Integration with GSD Core and Platform Adapters

- **GSD Core**: Manages the multi-phase macro lifecycle (Discuss ➔ Research ➔ Plan ➔ Execute ➔ Verify).
- **Gravitas Core**: Enforces the micro-level reliability invariants and completion evidence within every phase.
- **Optional Native Hooks**: Host platforms with native hook support (e.g., Antigravity `PreToolUse` / `PostToolUse` plugins) can provide mechanical pre-execution warnings. In this repository, instruction-based enforcement is standard, ensuring full cross-platform compatibility across all agents without conflicting hook execution order or fail-closed brittleness.
