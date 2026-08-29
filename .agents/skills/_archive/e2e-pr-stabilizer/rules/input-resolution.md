---
title: Phase 0 — Resolve the PR target
impact: HIGH
tags:
  - input
  - pr-resolution
  - github
---

# Phase 0 — Resolve the PR target

Print the resolved target before any other work.
Do not ask the user if resolution succeeds.

## Inputs

`$ARGUMENTS` is parsed as up to two whitespace-separated tokens, in either order: a mode and a PR reference.

| Token shape | Detection | Maps to |
|-------------|-----------|---------|
| `optimize` (literal) | Case-insensitive exact match | `MODE=optimize` |
| `stabilize` (literal) | Case-insensitive exact match | `MODE=stabilize` (explicit) |
| `^https?://github\.com/[^/]+/[^/]+/pull/[0-9]+$` | URL regex | `PR_URL` |
| `^[0-9]+$` | All-digit | `PR_NUMBER` |
| _missing_ | Token absent | Defaults: `MODE=stabilize`, PR auto-detected from current branch. |

Anything that matches neither shape: print an error and stop.

## Resolution procedure

Parse `$ARGUMENTS` first, then resolve the PR.
Always finish with the same seven fields printed: `mode`, `pr_url`, `pr_number`, `repo_owner`, `repo_name`, `branch`, `head_sha`.

### 0. Parse mode + PR reference

```bash
MODE="stabilize"
PR_REF=""
for tok in $ARGUMENTS; do
  case "$(echo "$tok" | tr '[:upper:]' '[:lower:]')" in
    optimize)  MODE="optimize" ;;
    stabilize) MODE="stabilize" ;;
    *)         PR_REF="$tok" ;;
  esac
done
```

Continue with PR resolution below, using `PR_REF` in place of `$ARGUMENTS` for the URL / number paths.
When `PR_REF` is empty, use the auto-detect path (case 3).

### 1. PR URL given

```bash
PR_URL="$PR_REF"
PR_NUMBER=$(echo "$PR_URL" | sed -E 's|.*/pull/([0-9]+).*|\1|')
REPO_PATH=$(echo "$PR_URL" | sed -E 's|https?://github\.com/([^/]+/[^/]+)/.*|\1|')

gh pr view "$PR_NUMBER" --repo "$REPO_PATH" \
  --json number,url,headRefName,headRefOid,headRepositoryOwner,headRepository
```

### 2. PR number given

```bash
PR_NUMBER="$PR_REF"
REPO_PATH=$(gh repo view --json owner,name -q '"\(.owner.login)/\(.name)"')

gh pr view "$PR_NUMBER" --repo "$REPO_PATH" \
  --json number,url,headRefName,headRefOid,headRepositoryOwner,headRepository
```

### 3. Empty — auto-detect

```bash
BRANCH=$(git rev-parse --abbrev-ref HEAD)

gh pr list --head "$BRANCH" --state open --limit 1 \
  --json number,url,headRefName,headRefOid,headRepositoryOwner,headRepository
```

- If exactly one PR is returned, use it.
- If the `headRepositoryOwner.login` differs from the current repo owner (the PR is from a fork), print a warning before continuing.
- If no open PR is found, print: `No open PR for branch <branch>. Re-run with an explicit PR URL or number.` and stop — do **not** fall back to "latest failed run", because this skill needs a PR target for the `git.pull_request_link` telemetry filter.

## Output contract

After resolution, print exactly:

```text
Mode:      <mode>
PR:        <pr_url>
Number:    <pr_number>
Repo:      <repo_owner>/<repo_name>
Branch:    <branch>
Head SHA:  <head_sha>
```

These seven values feed every downstream phase.
Store them as shell variables — do not re-resolve.

## Fork PRs

Forks complicate two things:

1. `gh run download` still works against the upstream repo's runs.
2. `git push` requires write access to the fork — if the user is not a maintainer, push will fail. Print a clear message in that case and emit the fix plan without pushing.

If the PR is from a fork, set `IS_FORK=true` and mention it in the report.

## Failure modes

| Symptom | Cause | Action |
|---------|-------|--------|
| `gh` not installed | Missing CLI | Print install hint; stop. |
| `gh auth status` fails | Not logged in | Print `gh auth login` hint; stop. |
| PR not found | Wrong number or repo | Print `gh pr view` error; stop. |
| Multiple PRs for branch | Rare; usually a fork mismatch | Print all candidates; ask the user which one. |
