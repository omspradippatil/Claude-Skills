# Engineering Policy

Use this policy for general implementation, refactoring, and code-quality work. It consolidates minimal-engineering principles inspired by Ponytail, concise communication principles inspired by Caveman, and reliability invariants from Gravitas Core.

---

## 1. Minimal Engineering & Simplicity (Ponytail Principles)

The primary goal is the smallest, most maintainable solution that meets requirements:

### The Decision Ladder
Before writing new code or introducing abstractions, evaluate in order:
1. **YAGNI**: Does this feature or abstraction actually need to exist right now?
2. **Standard Library**: Does the platform's standard library already provide this functionality?
3. **Native Platform Features**: Can a native language, browser (e.g., HTML5 controls, CSS), or OS feature handle it?
4. **Existing Dependencies**: Does an already-installed dependency solve it before adding a new package?
5. **Simple In-Place Implementation**: Can it be written clearly in a few idiomatic lines without extra indirection?
6. **Minimum Viable Code**: If new code must be written, write only the code required to solve the immediate problem.

### Anti-Over-Engineering Safeguards
- **Eliminate unnecessary abstractions**: Avoid speculative wrapper classes, multi-tiered architectures for simple lookups, premature plugin systems, or redundant configuration files.
- **Reuse existing patterns**: Conform to established project conventions, file structure, and idioms before introducing competing paradigms.
- **Preserve safeguards**: Never sacrifice input validation, security controls, error handling, type safety, test coverage, or accessibility to save lines of code or tokens. Do not compress code into unreadable one-liners.
- **Explain architectural choices briefly**: Document non-obvious trade-offs only when necessary for future maintainers.

---

## 2. Concise Communication & Output Optimization (Caveman Principles)

Optimize agent communication and token efficiency without loss of critical technical detail:

- **Direct and factual responses**: Keep ordinary status updates and explanations concise and direct. Omit boilerplate pleasantries, repetitive apologies, and conversational fluff.
- **Summarize large outputs**: Condense extensive command output, compiler warnings, test runners, and search results into focused summaries.
- **Preserve critical technical precision**: Always preserve exact source code, shell commands, error messages, stack traces, file paths, symbol names, API fields, and security findings.
- **Context-appropriate depth**: When the user explicitly requests an in-depth tutorial, architectural report, exam answer, or comprehensive walkthrough, provide full detailed explanations.
- **Lossless representation**: Never rewrite source code, JSON payloads, schema definitions, or configuration files in a way that alters syntax or runtime semantics. Treat compressed summaries as lossy and inspect original tool output whenever ambiguity exists.
- **Strictly opt-in proxies and services**: Any runtime proxy, token compression daemon, or network middleware is strictly opt-in, documented, and requires explicit user consent.

---

## 3. Reliability & Scope Enforcement (Gravitas Core)

- **Ground before mutating**: Inspect target files, callers, and tests before modifying code. Never edit based on memory or assumptions.
- **Stay within scope**: Identify the files required for the task. If expanding beyond the initial scope is necessary, state the reason clearly.
- **Require fresh evidence**: Always run tests or validation after the final edit before reporting completion.
- **Recover intelligently**: When a command, test, or tool call fails, diagnose the error and adjust the approach. Never retry the exact same failing action blindly.
- **Meet acceptance criteria**: Verify the active task requirements directly rather than relying on unrelated passing tests.
- **Report honestly**: Distinguish between executed tests and suggested tests, verified facts and assumptions.

