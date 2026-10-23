---
name: ponytail
description: >-
  Activate this skill for minimal engineering, code simplification, refactoring to reduce
  complexity, eliminating unnecessary abstractions, wrappers, or dead dependencies, and enforcing
  the "lazy senior developer" philosophy (YAGNI, standard library and native platform preference).
---

# Ponytail — Minimal Engineering Skill

Official upstream: [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) (MIT License)

---

## Philosophy & Core Objective

The best code is the code you never wrote. Every line of added code is a liability to be read, tested, debugged, and maintained. 

The goal of Ponytail is to enforce disciplined minimalism: eliminate premature abstractions, avoid speculative complexity, reject unnecessary third-party dependencies, and prefer native platform capabilities.

---

## When to Activate

- Refactoring code to simplify architecture and eliminate bloat.
- Reviewing PRs or proposed designs for over-engineering.
- Implementing features where minimal footprint and maximum maintainability are priorities.
- Evaluating whether to add a new third-party dependency versus using existing libraries or native APIs.
- Removing dead code, redundant wrappers, and speculative configuration layers.

---

## The Decision Ladder

Before writing any new code, evaluate solutions in this strict order:

```
1. YAGNI (Does this problem need code at all?)
   └── If no: Stop. Do not build it.
2. Standard Library (Can Python / Node.js / Go / Rust stdlib solve it?)
   └── If yes: Use stdlib. Add zero dependencies.
3. Native Platform Feature (HTML5, modern CSS, Web APIs, shell builtins)
   └── If yes: Use the platform primitive directly.
4. Already-Installed Dependency (Can existing packages in package.json/pyproject.toml do it?)
   └── If yes: Reuse the established tool.
5. In-Place Idiomatic Code (Can it be solved in 5-15 readable lines?)
   └── If yes: Implement directly without creating a new class/module.
6. Minimum Viable Code (Write only what satisfies the acceptance criteria)
   └── Implement cleanly with no speculative generality.
```

---

## Implementation Rules

### 1. Reject Premature Abstractions
- **No wrapper components without clear value**: Avoid creating single-use wrappers around standard components or libraries.
- **No multi-layered architectures for simple tasks**: Avoid creating a repository, service, interface, DTO, and controller for a simple 10-line database query.
- **Flatten unnecessary indirection**: If a helper function is only called once and adds no semantic clarity, inline it.
- **Avoid speculative configuration**: Do not add dynamic config switches, feature flags, or factory patterns for variations that do not currently exist.

### 2. Native-First Choices
- **Frontend**: Prefer HTML5 semantic elements (`<dialog>`, `<details>`, `<input type="date">`), CSS Grid/Flexbox, native CSS variables, and modern Web APIs (`fetch`, `Intl`, `URLSearchParams`) over heavy utility packages.
- **Node.js**: Prefer built-in `node:fs/promises`, `node:path`, `node:crypto`, `node:test`, `fetch` over external packages like `lodash`, `rimraf`, `uuid`, `axios` unless project requirements dictate otherwise.
- **Python**: Prefer `pathlib`, `dataclasses`, `functools`, `typing`, `json`, `sqlite3` over redundant external packages.

### 3. Reuse Established Project Patterns
- Inspect existing codebase conventions first.
- If the project already uses a specific validation library (e.g., Zod), do not introduce a second one (e.g., Joi or Yup).
- Match the established project architecture rather than inventing a competing paradigm.

### 4. Non-Negotiable Safeguards
Minimal code does **not** mean cutting corners on safety:
- **Retain full input validation and sanitization**: Never bypass security controls to reduce lines of code.
- **Retain necessary error handling**: Handle known error modes gracefully.
- **Preserve type safety and tests**: Maintain complete type annotations and unit test coverage.
- **Preserve accessibility (a11y)**: Never remove ARIA attributes, semantic tags, or focus outlines.
- **Do not write unreadable one-liners**: Clean, readable code over clever, unmaintainable code golf.

---

## Practical Examples

### Example 1: Date & Time Manipulation
- **Over-engineered**: Installing `moment.js` (large legacy bundle) just to format a date string.
- **Ponytail approach**: Use native `Intl.DateTimeFormat` or standard library methods.

### Example 2: Deep Clone
- **Over-engineered**: Importing `lodash.clonedeep` for JSON-serializable state cloning.
- **Ponytail approach**: Use native `structuredClone()` (standard in modern browsers and Node.js 17+).

### Example 3: Modal Dialog
- **Over-engineered**: Pulling in a 20KB third-party modal library with 10 props and portal wrappers.
- **Ponytail approach**: Use standard HTML5 `<dialog>` element with `.showModal()` and native CSS backdrop styling.

---

## Architectural Rationale

When you make an intentional design trade-off (e.g., inlining code or choosing stdlib over a library), leave a brief 1-line code comment or report summary so future developers understand the reasoning.
