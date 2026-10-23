---
name: git-collaboration
description: >-
  Activate this skill for Git branching strategies, resolving merge conflicts,
  conventional commits, pull request workflows, or Git history management.
  Use when coordinating team workflows, crafting clean commits, or untangling complex Git states.
---

# Git Collaboration & Version Control Engineering

> **Scope**: Trunk-based vs GitFlow branching strategies, conventional commits, interactive rebasing, merge conflict resolution, pull request guidelines, Git hooks, and disaster recovery (`git reflog`).

---

## When to Activate

- Defining or refining branching strategies for teams or repositories
- Structuring clean, atomic commit histories with Conventional Commits
- Resolving complex merge or rebase conflicts
- Preparing pull requests and automated review workflows
- Setting up pre-commit hooks (Husky, lint-staged)
- Recovering lost commits, stashes, or detached HEAD states

---

## 1. Branching Strategies & Workflows

### Trunk-Based Development (Recommended for Fast Teams)
- Developers work on short-lived feature branches (`feat/auth-jwt`, `fix/cart-timeout`) that branch off and merge back into `main` within 1-2 days.
- Feature flags decouple deployment from release, enabling frequent merges without exposing incomplete features to users.

### Branch Naming Conventions
Follow standardized branch prefixes:
- `feat/short-description` — New features
- `fix/short-description` — Bug fixes
- `refactor/short-description` — Code improvements without behavioral changes
- `chore/short-description` — Dependency updates, tooling, CI changes
- `docs/short-description` — Documentation improvements

---

## 2. Conventional Commits Standard

Write atomic, descriptive commits following the Conventional Commits specification:
```text
<type>(<optional scope>): <description in imperative mood>

[optional body explaining WHY the change was made]

[optional footer(s), e.g. BREAKING CHANGE: ... or Closes #123]
```

### Commit Types
- `feat`: A new feature for the user
- `fix`: A bug fix for the user
- `docs`: Documentation-only changes
- `style`: Changes that do not affect code logic (formatting, missing semicolons)
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `perf`: Code change that improves performance
- `test`: Adding or correcting tests
- `chore`: Changes to build process, tooling, or package configurations

### Good vs Bad Commits
- ❌ `fixed stuff` / `WIP` / `more changes`
- ✅ `fix(auth): invalidate stale refresh tokens on password change`
- ✅ `feat(checkout): add Apple Pay button using Stripe Elements`

---

## 3. Merge vs Rebase & Conflict Resolution

### When to Rebase vs Merge
- **Feature Branches**: Rebase against `main` before opening or merging a PR to keep commit history linear and eliminate noisy "Merge branch 'main' into feat/..." commits:
  ```bash
  git checkout feat/my-feature
  git fetch origin main
  git rebase origin/main
  ```
- **Shared Branches / Main**: Never force-push (`git push --force`) to shared branches (`main`, `staging`). Use `--force-with-lease` on your own feature branch if you must update history after a rebase.

### Resolving Merge Conflicts Systematically
1. Check conflicting files: `git status`
2. Open conflicting files and search for conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).
3. Carefully review both incoming and current changes. Understand the intent behind both sides.
4. Resolve the conflict, remove all conflict markers, and verify the build and tests pass.
5. Stage the resolved files: `git add <file>`
6. Continue the rebase or merge: `git rebase --continue` (or `git commit` for a merge).

---

## 4. Disaster Recovery with `git reflog`

If you accidentally delete a branch, run an unintended `git reset --hard`, or lose uncommitted work in a detached HEAD, Git records every HEAD movement in the reflog:

```bash
# View recent actions and commit SHAs
git reflog

# Restore branch to state before the destructive reset
git reset --hard HEAD@{1} # or specific commit SHA e.g., git branch recovery-branch 7f3a9b2
```

---

## 5. Clean Pull Request Checklist

Before submitting or approving a Pull Request:
- [ ] Branch is rebased onto the latest `origin/main`.
- [ ] Commit messages follow the Conventional Commits specification.
- [ ] PR description clearly states: **What** changed, **Why**, and **How to test**.
- [ ] No temporary debug code (`console.log`, commented-out code blocks, local config overrides) is present.
- [ ] CI pipeline passes without errors or skipped essential checks.
