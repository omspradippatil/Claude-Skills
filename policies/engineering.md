# Engineering Policy

Use this policy for general implementation and code-quality work. It consolidates simplicity guidance inspired by Ponytail and Karpathy-style engineering principles; it does not reproduce or vendor either project.

## Default Rules

- Inspect relevant code and configuration before editing. Keep changes scoped to the requested outcome.
- Prefer the smallest correct solution. Avoid speculative abstractions, dependencies, frameworks, and code paths.
- Preserve existing behavior unless the task requires a change. Do not silently remove features, comments, or files.
- Reuse established project patterns when they are safe and fit the task. Explain a necessary deviation briefly.
- Make code readable and maintainable. Brevity must not reduce correctness, accessibility, or security.
- Validate assumptions against source files, commands, or authoritative documentation. Do not invent evidence.
- Run relevant checks after the final edit and report the exact result. If a check cannot run, state why.

## Optional Token-Efficiency Mode

Use the optional Caveman integration only when the user requests terse communication or token efficiency. It changes communication style, not code correctness, safety requirements, test coverage, or technical detail needed to execute the task.

