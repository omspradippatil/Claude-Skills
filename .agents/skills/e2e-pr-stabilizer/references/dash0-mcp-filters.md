---
title: Dash0 MCP filter reference for E2E PR telemetry
impact: MEDIUM
tags:
  - dash0
  - mcp
  - filters
  - playwright
  - opentelemetry
---

# Dash0 MCP filter reference

The canonical filter set for "E2E root spans on a specific PR" plus the variants you reach for when the canonical set returns too little or too much.

## Canonical filter set (E2E roots on a PR)

This is what [`../rules/telemetry-driven-analysis.md`](../rules/telemetry-driven-analysis.md) uses by default.
Do not omit fields.

```jsonc
[
  { "key": "service.name",          "operator": "is",         "value":  "ui-e2e" },
  { "key": "otel.parent.id",        "operator": "is_not_set" },
  { "key": "ci.is_ci",              "operator": "is_one_of",  "value":  "true" },
  { "key": "git.pull_request_link", "operator": "is_one_of",  "values": ["https://github.com/dash0hq/dash0/pull/13319"] }
]
```

Field-by-field rationale:

| Field | Why it is required |
|-------|--------------------|
| `service.name = ui-e2e` | Scopes to the Playwright E2E suite. Other Dash0 UI telemetry (`ui-web`, `ui-marketing`) uses different service names. |
| `otel.parent.id is_not_set` | Selects the root span of each test attempt only. Without it, the result includes every Playwright action span (one per `click`, `expect`, `goto`), inflating attempt counts. |
| `ci.is_ci is_one_of true` | Excludes local developer runs. Local runs use the same service but never set this flag. |
| `git.pull_request_link is_one_of [...]` | The single most important filter — scopes to one PR. Pass a list when comparing multiple PRs. |

## Variants

### Just-the-failures

Add an error outcome filter when the volume is high:

```jsonc
{ "key": "test.outcome", "operator": "is_one_of", "values": ["failed", "timedOut"] }
```

### Specific commit instead of PR

When iterating Phase 6 and you want telemetry only since the latest push:

```jsonc
{ "key": "vcs.ref.head.revision", "operator": "is_one_of", "values": ["<head_sha>"] }
```

Combine with the time range `since=<push_timestamp>` rather than the canonical 7-day window.

### Action spans for one failing test

Once you have the failing root span, drill into its children to see the Playwright actions:

```jsonc
[
  { "key": "service.name",       "operator": "is",        "value": "ui-e2e" },
  { "key": "otel.trace.id",      "operator": "is",        "value": "<trace_id from root span>" }
]
```

Drop `otel.parent.id is_not_set` so children are included.
Sort by `start_time` to reconstruct the action timeline.

### Local runs (Phase 2 / Phase 6)

When the repo's Playwright reporter is wired to the OTel exporter, local runs emit spans to Dash0 with `ci.is_ci=false`.
Phase 2 (local reproduction) and Phase 6 (3-consecutive-pass gate) can query those spans alongside the trace.zip evidence:

```jsonc
[
  { "key": "service.name",          "operator": "is",         "value":  "ui-e2e" },
  { "key": "otel.parent.id",        "operator": "is_not_set" },
  { "key": "ci.is_ci",              "operator": "is_one_of",  "values": ["false"] },
  { "key": "vcs.ref.head.revision", "operator": "is_one_of",  "values": ["<local_head_sha>"] }
]
```

`vcs.ref.head.revision` is what isolates this developer's local runs from anyone else's.
Drop `git.pull_request_link` — local runs may not set it.
Time range: since the local run started; a 10-minute window is usually safe.

If the local OTel exporter is not configured, mark the dossier `local-spans: not-emitted` and rely on the trace.zip plus the Phase 1 historical baseline.
The trace.zip alone is sufficient evidence for the selector-validity gate ([`../rules/fix-validation.md`](../rules/fix-validation.md)).

### All flakes in the suite (no PR)

Useful when you want repo-wide flake context — for example, "is this test flaky on main too?".
Drop the PR filter and add a longer time range:

```jsonc
[
  { "key": "service.name",   "operator": "is",        "value":  "ui-e2e" },
  { "key": "otel.parent.id", "operator": "is_not_set" },
  { "key": "ci.is_ci",       "operator": "is_one_of", "value":  "true" },
  { "key": "test.outcome",   "operator": "is_one_of", "values": ["flaky", "failed", "timedOut"] }
]
```

Keep this query off by default — the stabilizer is PR-scoped, not suite-wide.

## Attribute glossary

These are the attributes the queries above rely on.
Names match Dash0 / OpenTelemetry conventions in use by the `ui-e2e` service.

| Attribute | Type | Example | Source |
|-----------|------|---------|--------|
| `service.name` | string | `ui-e2e` | Set by the test harness. |
| `otel.parent.id` | string | unset for roots | Standard OTel span field. |
| `otel.trace.id` | string | `a1b2c3...` | Standard OTel trace field. |
| `ci.is_ci` | boolean (as string) | `true` | Set by the CI launcher. |
| `git.pull_request_link` | string | `https://github.com/<owner>/<repo>/pull/<n>` | Set by the CI launcher when a PR triggered the run. |
| `vcs.ref.head.revision` | string | commit SHA | Standard OTel resource attribute. |
| `gha.run_id` / `vcs.run.id` | string | `8431234567` | The GitHub Actions run ID — feeds `gh run download`. |
| `test.name` | string | `organization switching > switches between two orgs` | Playwright test title (full path). |
| `test.file` | string | `tests/e2e/src/specs/organizations.spec.ts` | Test source file. |
| `test.line` | int | `47` | Source line of the test. |
| `test.outcome` | string | `passed` / `failed` / `flaky` / `timedOut` | Playwright outcome. |
| `test.retry` | int | `0`, `1`, `2` | Retry index. |
| `playwright.worker_index` / `test.parallelIndex` | int | `2` | Which Playwright worker ran this attempt. |
| `exception.type` | string | `TimeoutError` | From a child `exception` span event when the test failed. |
| `exception.message` | string | full Playwright error | From the same span event. |
| `duration_ms` | number | `12450` | Span duration in ms (or compute from `end - start`). |

If the local schema diverges (older runs, different harness), prefer reading the attribute keys back from one root span and adjusting the queries — do not hard-code names that do not match the data.

## Server preference

Prefer the dash0-dev MCP server when configured (it is where the user's `ui-e2e` CI telemetry typically lands).
If only dash0-prod is available, the filter shape is identical — substitute `mcp__dash0-prod__*` for `mcp__dash0-dev__*` and proceed.

## Common mistakes

- Omitting `otel.parent.id is_not_set` — produces thousands of action spans instead of dozens of test spans.
- Passing a PR number instead of the full URL — `git.pull_request_link` is a URL, not a number.
- Using `ci.is_ci is true` (boolean) instead of `is_one_of "true"` (string) — the attribute is sent as a string on most CI launchers.
- Forgetting the time range — the default 1-hour window misses any retry history.
