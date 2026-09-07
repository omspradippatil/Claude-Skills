---
name: ultimate-git-collaboration
description: Activate this skill for Git branching strategies, resolving merge conflicts, conventional commits, or PR creation.
---

# Ultimate Git Collaboration

### 1. Safe AI Refactoring
- Never perform massive, sweeping changes on the `main` branch. Always checkout a new feature branch (e.g., `git checkout -b refactor/auth`).
- Make atomic, granular commits. Do not bundle a CSS fix and a database migration into the same commit.

### 2. Conventional Commits
- Use semantic commit prefixes: `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`.
- Include context (e.g., `fix(auth): prevent token undefined crash`).

### 3. Conflict Resolution
- When stuck in a rebase or merge conflict, explicitly list the conflicting files, explain the diverging paths, and ask the user how they want to resolve business logic discrepancies.
