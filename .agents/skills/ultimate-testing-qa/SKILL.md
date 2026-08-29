---
name: ultimate-testing-qa
description: Consolidated ultimate skill containing expert knowledge for testing qa. Use this for all tasks in this domain.
---

# Ultimate Testing Qa

> **Agent Instruction:** This is a consolidated expert skill. Read the catalog below and apply the specific rules that match the user's request.

## Skill Catalog

### e2e-pr-stabilizer
**Description:** >


#### E2E PR Stabilizer

Stabilize the Playwright E2E suite for a single pull request using **evidence, not assumptions**.
Spans, traces, and the live app are the source of truth — not the CI dashboard.
This skill never proposes a fix without a measurement to point at, and never commits a fix until three consecutive local runs prove it works.

> **This `SKILL.md` is a thin index.**
> Detailed procedures live in [`rules/*.md`](./rules) and [`templates/*.md`](./templates).
> Each phase loads only what it needs.

---

##### What this skill combines

| Source | Role |
|--------|------|
| [Playwright Healer agent](https://playwright.dev/docs/test-agents) — external; one of the [Playwright Test Agents](https://playwright.dev/docs/test-agents) on the [Playwright MCP server](https://github.com/microsoft/playwright-mcp) | Test-debugging methodology — how to fix a Playwright test correctly. |
| [`/playwright-trace-analyzer`](../../analysis/playwright-trace-analyzer/SKILL.md) | Per-run `trace.zip` extraction, hotspot ranking. |
| [`/ci-auto-fix`](../../delivery/ci-auto-fix/SKILL.md) | Reused only for Phase 7's single push + watch — the iteration loop no longer lives here. |
| Dash0 MCP server (`dash0-dev` or `dash0-prod`) | Historical evidence — failure recurrence, retry counts, span-level evidence across CI runs. |
| Local Playwright runner | Primary evidence source — trace.zip per run, OTel spans to Dash0 (`ci.is_ci=false`), and the live app for selector verification. |
| GitHub Actions (one call) | Final CI ratification at Phase 7. |

This skill is the orchestrator over those.

> **External dependency — the Playwright Healer agent.** The healer methodology
> this skill drives fixes through is **not** an agent in this repo; it is
> Playwright's own **healer** ([Playwright Test Agents](https://playwright.dev/docs/test-agents):
> planner / generator / healer) running on the
> [Playwright MCP server](https://github.com/microsoft/playwright-mcp). Set it up
> with `npx playwright init-agents --loop=claude` (Playwright ≥ 1.56). At runtime,
> Phase 5 **uses the healer when the Playwright MCP is connected** (`mcp__playwright__*`
> tools present) and **falls back to the inline root-cause methodology** when it
> isn't — so the skill works with or without it, but is strongest with it.
It does not duplicate their content — each phase delegates.

---

##### Modes

| Mode | Default | Entry rule (what enters the fix queue) | Phase 5 (edits) | Phase 6 (local 3-pass gate) | Phase 7 (CI ratification) | Phase 8 output |
|------|---------|----------------------------------------|-----------------|-----------------------------|---------------------------|----------------|
| `stabilize` | **yes** | `failure_rate ≥ 0.10` over ≥ 5 attempts, or `flake_count ≥ 2`. | Drafted, then double-gated before commit. | Required — 3 consecutive local passes per fixed test. | One push, one CI watch. | Stabilization report with before / after numbers, local-pass log, CI verdict. |
| `optimize` | | Top-N slowest tests by total time, or actions with `dur > 5×median`. | **Skipped.** | **Skipped.** | **Skipped.** | Recommendations-only report — humans apply the wins. |

`stabilize` is the default because optimization edits (tightening timeouts, removing waits) carry flake risk that warrants human judgment.
`optimize` runs Phases 1–4 only and emits a ranked recommendations report.

##### Input

`$ARGUMENTS` is parsed as `[mode] [pr-ref]` in any order:

- `optimize` (literal token) selects optimize mode; anything else is treated as `pr-ref`.
- `pr-ref` is a PR URL (`https://github.com/<org>/<repo>/pull/13319`) or PR number (`13319`).
- If `pr-ref` is missing, auto-detect the open PR for the current branch (same path as [`/ci-auto-fix`](../../delivery/ci-auto-fix/SKILL.md) Step 0).
- If `mode` is missing, default to `stabilize`.

Resolve mode + PR before doing anything else.
See [`rules/input-resolution.md`](./rules/input-resolution.md).

---

##### Workflow

Eight phases.
Do not skip a gate.
Phases 5, 6, and 7 are skipped in `optimize` mode (the `Modes` column says so explicitly).

| Phase | Name | Modes | Rule file | Gate |
|-------|------|-------|-----------|------|
| 0 | Resolve target | both | [`rules/input-resolution.md`](./rules/input-resolution.md) | Mode + PR URL + branch + head SHA + owner / repo printed. |
| 1 | Pull historical telemetry | both | [`rules/telemetry-driven-analysis.md`](./rules/telemetry-driven-analysis.md) | Dash0 spans for this PR fetched and grouped by test name; failure recurrence + retry counts measured (stabilize) **or** action `dur` distribution measured (optimize). |
| 2 | Local reproduction + trace capture | both | [`rules/local-iteration.md`](./rules/local-iteration.md) | Each queued test run locally with `--trace=on`; trace.zip + (where available) fresh Dash0 spans tagged `ci.is_ci=false` captured. |
| 3 | Correlate spans ↔ traces | both | [`rules/root-cause-and-fix.md`](./rules/root-cause-and-fix.md) | Each queued test has a span-side signature **and** a trace-side hotspot. |
| 4 | Root-cause synthesis | both | [`rules/root-cause-and-fix.md`](./rules/root-cause-and-fix.md) | A single, evidence-anchored hypothesis per candidate, citing the span signature and the trace hotspot. Speculative hypotheses become `recommendation-only` entries, not fixes. |
| 5 | Draft fix + selector-existence check | **stabilize only** | [`rules/root-cause-and-fix.md`](./rules/root-cause-and-fix.md), [`rules/fix-validation.md`](./rules/fix-validation.md), [`rules/guard-rails.md`](./rules/guard-rails.md) | Diff drafted; every new locator proven to resolve against source (static grep) **or** the live app (`locator.count() ≥ 1`). A locator that fails both checks is hallucinated — discard the diff and re-enter Phase 4 with that evidence. |
| 6 | Local verification — 3 consecutive passes | **stabilize only** | [`rules/local-iteration.md`](./rules/local-iteration.md) | Fixed test runs locally ≥ 3 times with `--trace=on` and passes **3 times in a row**. A single failure or flake within the streak resets the counter. Maximum 10 attempts per test before escalating. |
| 7 | CI ratification — one push, one watch | **stabilize only** | [`rules/verification-loop.md`](./rules/verification-loop.md) | All passing fixes committed and pushed in a single push event; the resulting CI run is watched to conclusion and its telemetry compared against the Phase 1 baseline. |
| 8 | Report | both | [`templates/stabilization-report.md`](./templates/stabilization-report.md) | Stabilize: report with before / after numbers + local-pass log + CI verdict + residual risk. Optimize: recommendations-only report ranked by measured wall-clock impact. |

Inner iteration in `stabilize` mode is local and bounded — see [`rules/local-iteration.md`](./rules/local-iteration.md).
The CI step in Phase 7 runs **once**.
If CI disagrees with the local result, that is a signal to escalate, not to re-enter the loop blindly.

---

##### Required reading by phase

Load on demand.
Do not preload.

| Phase | Files |
|-------|-------|
| 0 | [`rules/input-resolution.md`](./rules/input-resolution.md) |
| 1 | [`rules/telemetry-driven-analysis.md`](./rules/telemetry-driven-analysis.md), [`references/dash0-mcp-filters.md`](./references/dash0-mcp-filters.md) |
| 2 | [`rules/local-iteration.md`](./rules/local-iteration.md) |
| 3–4 | [`rules/root-cause-and-fix.md`](./rules/root-cause-and-fix.md), [`rules/self-improvement-loop.md`](./rules/self-improvement-loop.md) (read lessons — stabilize only) |
| 5 | [`rules/root-cause-and-fix.md`](./rules/root-cause-and-fix.md), [`rules/fix-validation.md`](./rules/fix-validation.md), [`rules/guard-rails.md`](./rules/guard-rails.md) |
| 6 | [`rules/local-iteration.md`](./rules/local-iteration.md) |
| 7 | [`rules/verification-loop.md`](./rules/verification-loop.md), [`rules/self-improvement-loop.md`](./rules/self-improvement-loop.md) (write lessons on ratification — stabilize only) |
| 8 | [`templates/stabilization-report.md`](./templates/stabilization-report.md) |

For trace mechanics (zip → JSONL → action timeline), defer to [`/playwright-trace-analyzer`](../../analysis/playwright-trace-analyzer/SKILL.md).
Do **not** re-implement.

---

##### Core principles

1. **Iterate locally, ratify on CI.**
   The inner loop is local because it is seconds-per-run, has the same trace artifacts, and emits the same OTel spans.
   CI runs once at the end as ground truth.
2. **Data first, hypothesis second.**
   Every fix is anchored to (a) a span with a measured failure rate, or (b) a trace action with a measured `dur`.
   "I think this is flaky" is not a finding.
3. **Two evidence layers, not one.**
   Spans tell you *which tests fail and how often across runs* (historical and local).
   Traces tell you *why one specific run failed*.
   A fix is only credible when both layers agree.
4. **Validate empirically, not predictively.**
   Confidence in a fix comes from running it, not from scoring it on paper.
   The two gates the skill enforces are both deterministic: selectors must exist (verifiable against source or live app), and the fixed test must pass three consecutive local runs (verifiable from exit codes).
5. **Selectors must exist before they are used.**
   Every new locator in a draft fix is verified against the component source (static) and, when ambiguous, the running app (live).
   The skill never commits a fix that names an element that does not exist.
6. **Three consecutive local passes or no commit.**
   A single passing run can be a coin flip on a flake.
   Three in a row — hardened with `--repeat-each=3` when the measured flake rate is low (see [`rules/local-iteration.md`](./rules/local-iteration.md)) — filters out most unfixed flakes before we spend a CI cycle.
   The streak is necessary but not sufficient evidence; Phase 7's CI ratification plus the telemetry comparison is the real confirmation.
7. **Never weaken the suite.**
   No `.skip`, `.fixme`, `waitForTimeout`, `continue-on-error`, `--no-verify`, or removed assertions.
   The full list lives in [`rules/guard-rails.md`](./rules/guard-rails.md).
8. **Test-side fix unless the trace proves otherwise.**
   Most flakes are selector, timing, or state-management bugs in tests.
   If the trace evidence points to product code, surface it to the user as a separate recommendation — do not silently mutate app code.
9. **One PR at a time.**
   Cross-PR refactors belong in a different skill.

---

##### Self-Improvement

`/e2e-pr-stabilizer` gets better across runs through a two-tier lessons loop
(fast episodic tier + gated promotion), like `autonomous-workflow` and
`fix-bug`. In **`stabilize` mode** it **reads** `e2e-pr-stabilizer-lessons` at
Phase 4 (biasing the P1–P6 pattern classification and the Phase 5 locator
strategy) and **writes** at Phase 7 — gated on the **telemetry ratification
signal**, not the local 3-pass streak, so only fixes that CI actually confirmed
`fixed` accrue a working lesson. The two tiers split naturally: the `global`
scope holds universal race-shape → fix-shape mappings, the `repo::{owner}/{repo}`
scope holds app-specific locator robustness. Lessons are **advisory** — they
never relax a guard-rail, an empirical gate, or the 3-consecutive-pass
requirement. A recurring lesson (`seen_count >= 3`) is promotion-eligible via
`/create-skill diagnose e2e-pr-stabilizer`.

`optimize` mode skips the loop (no fix, no ratification signal). Lessons run
through LoreKit's `memory.*` tools (the `lorekit-memory` skill); if LoreKit is
not connected the loop is a silent no-op. Full contract:
[`rules/self-improvement-loop.md`](./rules/self-improvement-loop.md).

##### Anti-patterns

One-liners; the full list lives in [`rules/guard-rails.md`](./rules/guard-rails.md).

- Pushing a fix because "the diff looks right" without three consecutive local passes.
- Trusting a single local pass as proof — flakes pass once routinely.
- Drafting a fix that uses `getByTestId('foo')` when nothing in the component source emits `data-testid="foo"`.
- Patching `waitForTimeout(1500)` to mask a race instead of fixing the wait condition.
- Marking a test `.fixme()` because it is "flaky" without a measured cause.
- Treating a single failed CI run as evidence — flakes are statistical, so fetch the span history.
- Re-running CI hoping for a green without applying a code change.
- Editing product code based on speculation when the trace points at a selector or test-state issue.

---

##### Quickstart

```text
/e2e-pr-stabilizer                                                       # stabilize, auto-detect PR
/e2e-pr-stabilizer 13319                                                 # stabilize PR 13319
/e2e-pr-stabilizer https://github.com/<org>/<repo>/pull/13319            # stabilize via URL
/e2e-pr-stabilizer optimize                                              # optimize, auto-detect PR
/e2e-pr-stabilizer optimize 13319                                        # optimize PR 13319
```

Once invoked, the skill drives end-to-end:

1. Resolves the mode and the PR.
2. Queries the Dash0 MCP for E2E spans filtered to this PR (`git.pull_request_link`) — historical baseline.
3. **Reproduces locally** with `--trace=on`, capturing trace.zip and (where the local OTel reporter is wired) fresh spans.
4. Correlates and produces an evidence-anchored finding set.
5. **stabilize:** drafts each fix, verifies every new locator resolves against source or the live app, then commits locally.
6. **stabilize:** runs the fixed test locally until it passes 3 times in a row (per fix).
7. **stabilize:** pushes once; watches the CI run; compares fresh telemetry to baseline.
8. Emits the report — stabilization (before / after + local-pass log + CI verdict) or optimization (recommendations).

---

##### Definition of Done

###### Both modes

- [ ] Mode (`stabilize` | `optimize`) and PR target resolved and printed.
- [ ] Historical telemetry pulled from the Dash0 MCP using the documented filter set, grouped by test name.
- [ ] Each queued test reproduced locally with `--trace=on`; trace artifacts captured per run.
- [ ] Each candidate has a span-side signature and a trace-side hotspot.
- [ ] Report written using the template, with the mode stated and findings ranked by measured impact.

###### `stabilize` only

- [ ] Every new locator in every applied fix was verified against the component source or via a live `locator.count() ≥ 1` probe.
- [ ] Every applied fix passed 3 consecutive local runs with `--trace=on` and no failures or flakes within the streak.
- [ ] Fixes committed locally, pushed in one push, CI run watched to conclusion.
- [ ] Fresh telemetry pulled and compared to baseline — failures eliminated, retry counts reduced.
- [ ] No `.skip`, `.fixme`, `waitForTimeout`, or `continue-on-error` introduced (guard-rails check passed).

###### `optimize` only

- [ ] No commits, no pushes, no edits to test files.
- [ ] Each recommendation cites an estimated wall-clock saving (ms) based on the trace evidence.


---

### e2e-testing
**Description:** >


#### E2E Testing

Drive end-to-end tests through Playwright's MCP-backed Test Agents — Planner,
Generator, Healer — released in Playwright 1.56 (Oct 2025).
The user writes (or approves) a Markdown feature spec; agents generate the
test, run it against a real browser via the accessibility tree, and self-heal
when locators drift.

> **This `SKILL.md` is a thin index.**
> Decision rules live in [`rules/*.md`](./rules) and load on demand.
> Worked references (agent reference, MCP tool catalog, pyramid math) live
> in [`references/*.md`](./references).
> Literal boilerplate the skill emits lives in [`templates/*.md`](./templates).
> Do not preload everything — load only what the current phase asks for.

---

##### When to use

Reach for this skill when any of the following is true:

- A feature has user-facing flow that integration tests cannot fully cover.
- A bug repros only through real navigation (multi-page, auth, real network).
- A flake needs a Healer pass instead of a manual locator hunt.
- The repo has no `@playwright/mcp` wiring yet and needs Phase 0 setup.

Do **not** reach for this skill when:

- A unit or component test would catch the same bug — defer to
  [`tdd`](../../quality/tdd/SKILL.md) and the layer rule in
  [`rules/layer-decision.md`](./rules/layer-decision.md).
- The change is a pure refactor with no behavioural surface.
- You are adding test infrastructure unrelated to a real flow.

---

##### Phase 0 — Preflight (mandatory gate)

Before any agent loop, verify the repo is wired for Playwright Test Agents.
Halt and ask the user before installing anything.

Run these checks (read-only):

```bash
#### 1. Playwright + MCP server installed?
jq '.devDependencies | keys[]' package.json | grep -E '@playwright/(test|mcp)'

#### 2. Test-agent artefacts present?
ls specs/ tests/seed.spec.ts playwright.config.ts 2>/dev/null
```

Decision table:

| State                                       | Action                                                                  |
| ------------------------------------------- | ----------------------------------------------------------------------- |
| Both deps present + artefacts exist         | Proceed to Phase 1.                                                     |
| Deps missing                                | **Halt.** Print install plan, ask permission before running.            |
| Deps present, artefacts missing             | **Halt.** Print `npx playwright init-agents --loop=claude`, ask first.  |
| Playwright present but version `< 1.56`     | **Halt.** Test Agents require 1.56+. Ask permission to upgrade.         |

Print the exact commands; do not run them silently.
The install plan template is in [`templates/install-plan.md`](./templates/install-plan.md).

---

##### Phase 1 — Spec-first feature flow

The agent loop is **spec → generate → run → heal**.
The spec is human-readable Markdown, not code.
Full rules: [`rules/spec-first-flow.md`](./rules/spec-first-flow.md).

```
specs/<flow>.md   ─┐
                   ├─→  Generator  ─→  tests/<flow>.spec.ts  ─→  run  ─→  pass?
                   │                                                       │ no
                   │                                                       ▼
                   └────────────────────  Healer  ←──────────────  failing test
                                              │
                                              ▼
                                  patched test or `data-testid` proposal
```

Two entry points:

1. **Spec already drafted by the user.**
   Skip the Planner.
   Run the Generator on `specs/<flow>.md`.
2. **App exists, no spec yet.**
   Run the Planner against the live app to draft `specs/<flow>.md`.
   User reviews the Markdown plan before generation.

Use the Markdown template in [`templates/spec.md`](./templates/spec.md).

###### Locator ladder (when generating or healing)

The Generator and the Healer both walk the accessibility tree.
Pick locators in this order — never skip a rung:

1. `getByRole('button', { name: 'Save' })` — accessibility-tree native.
2. `getByLabel`, `getByPlaceholder`, `getByText` — user-facing strings.
3. `getByTestId('save-draft')` — escape hatch only.

`data-testid` is a source change, not a test workaround.
When the Healer cannot find a stable locator at rungs 1–2, propose a source
diff that adds `data-testid` to the component, and offer the diff for user
approval before patching the test.
Full rules and decision criteria: [`rules/locator-strategy.md`](./rules/locator-strategy.md).

---

##### Phase 2 — Token-aware execution

Playwright MCP defaults to **snapshot mode** (accessibility tree, text-only).
Do not enable `--caps=vision` unless an explicit pixel-level concern exists.
Full rules: [`rules/token-budget.md`](./rules/token-budget.md).

Defaults the skill prescribes:

- Snapshot mode (no vision) for all agent calls.
- Run only the changed spec on iteration: `npx playwright test --last-failed`.
- Run the Healer **only on failure**, not on every save.
- Reuse `storageState` from `tests/seed.spec.ts` to skip auth on every run.
- Cap the heal loop at three attempts per failing test before escalating.

---

##### Phase 3 — Verification

After the Generator produces a test:

1. Run the test once against the live app.
   It must pass on first run, or the Healer must converge in ≤ 3 attempts.
2. Invoke [`test-provenance-guard`](../../quality/test-provenance-guard/SKILL.md) on
   the generated file to ensure the test imports production code instead
   of a private re-implementation.
3. Open `playwright.config.ts` and confirm `trace: 'on-first-retry'` is set
   so a future failure produces a trace bundle.

If the heal loop fails to converge:

- Invoke `confidence(analysis)` on the test failure.
- If confidence is below 90%, escalate to the user with the trace, the spec,
  and the proposed locator changes — do **not** keep healing blindly.

---

##### Decision flow at a glance

| Signal                                                       | Do                                                            |
| ------------------------------------------------------------ | ------------------------------------------------------------- |
| Bug fixable by a unit or component test                      | Use [`tdd`](../../quality/tdd/SKILL.md), not this skill.                 |
| Multi-page user flow, auth, or real network involved         | Spec-first feature flow (Phase 1).                            |
| Flaky existing test                                          | Healer pass only; do not rewrite without spec context.        |
| Locator unstable, no stable role / label                     | Propose `data-testid` diff (rule: locator-strategy).          |
| Repo missing Playwright or MCP                               | Phase 0 halt + ask permission.                                |
| Heal loop > 3 attempts                                       | Stop, run `confidence(analysis)`, escalate.               |
| Test passes on first run, never seen failing                 | Run `test-provenance-guard` before declaring done.            |

---

##### Composes with

- [`tdd`](../../quality/tdd/SKILL.md) — owns the unit and component layers.
  This skill defers to it for anything below E2E.
- [`test-provenance-guard`](../../quality/test-provenance-guard/SKILL.md) — runs after
  Generator output to catch tests-by-construction.
- [`confidence`](../../quality/confidence/SKILL.md) — gate when the heal loop fails.
- [`holistic-analysis`](../../analysis/holistic-analysis/SKILL.md) — if a flow is failing
  for reasons no test rewrite can fix, step back instead of patching.
- [`playwright-trace-analyzer`](../../analysis/playwright-trace-analyzer/SKILL.md) —
  consume the trace produced by a failed test on retry.

---

##### References

- [`references/playwright-agents.md`](./references/playwright-agents.md) —
  Planner / Generator / Healer reference, inputs, outputs, invocation.
- [`references/mcp-tool-catalog.md`](./references/mcp-tool-catalog.md) —
  the `@playwright/mcp` tool surface, grouped by category.
- [`references/pyramid-2026.md`](./references/pyramid-2026.md) — testing
  pyramid math in 2026, with the AI-generation caveat.

##### Templates

- [`templates/spec.md`](./templates/spec.md) — feature-flow Markdown spec.
- [`templates/seed.spec.ts`](./templates/seed.spec.ts) — auth and storage
  bootstrap, produces `storageState`.
- [`templates/playwright.config.ts`](./templates/playwright.config.ts) —
  opinionated config: snapshot mode, traces on first retry, projects per
  browser, parallel CI defaults.
- [`templates/install-plan.md`](./templates/install-plan.md) — Phase 0 halt
  message with the exact commands to install Playwright + MCP.

---

##### Anti-patterns (one-liner — full list in [`rules/anti-patterns.md`](./rules/anti-patterns.md))

- Writing E2E for logic a unit test catches.
- Running the Healer on every save.
- Patching the test with brittle CSS selectors instead of proposing a
  `data-testid` diff.
- Enabling `--caps=vision` without a pixel-level requirement.
- Ignoring Healer suggestions and keeping a `.skip()` in CI.
- Generating tests against a stub server, not the real app.

---

##### Definition of done

- [ ] Phase 0 preflight passed or installs were user-approved.
- [ ] `specs/<flow>.md` exists and the user reviewed it.
- [ ] `tests/<flow>.spec.ts` passes against the live app.
- [ ] `test-provenance-guard` reports no violations on the new test.
- [ ] `playwright.config.ts` has `trace: 'on-first-retry'`.
- [ ] If a `data-testid` was added, it is in the source diff and committed.


---

### e2e-testing-mobile
**Description:** >


#### E2E Testing — Mobile (Expo / React Native)

Drive native mobile end-to-end tests through Maestro and Maestro MCP.
The user writes (or approves) a Markdown feature spec; an agent emits a
Maestro YAML flow, runs it against a simulator or Maestro Cloud, and
self-heals when locators drift.

This is the **mobile** counterpart to [`e2e-testing`](../e2e-testing/SKILL.md).
Anything orthogonal to native (web flows, WebViews inside a hybrid app)
defers to that skill.
The two skills compose; they do not overlap.

> **This `SKILL.md` is a thin index.**
> Decision rules live in [`rules/*.md`](./rules) and load on demand.
> Worked references (Maestro CLI surface, MCP tool catalog, EAS Workflow
> wiring, Detox legacy notes, mobile pyramid math) live in
> [`references/*.md`](./references).
> Literal boilerplate the skill emits lives in
> [`templates/*.md`](./templates).
> Do not preload everything — load only what the current phase asks for.

---

##### When to use

Reach for this skill when any of the following is true:

- An Expo or React Native app needs E2E coverage of a native user flow.
- A bug only repros across native navigation, deep links, push,
  permissions prompts, or a real device sensor.
- A flake needs a Maestro heal pass instead of a manual locator hunt.
- The repo has no `.maestro/` flows or EAS E2E build profile yet and
  needs Phase 0 setup.

Do **not** reach for this skill when:

- A unit or component test would catch the same bug — defer to
  [`tdd`](../../quality/tdd/SKILL.md) and the layer rule in
  [`rules/layer-decision.md`](./rules/layer-decision.md).
- The flow is browser-only — defer to
  [`e2e-testing`](../e2e-testing/SKILL.md).
- The flow lives entirely inside a WebView in a hybrid app — defer to
  [`e2e-testing`](../e2e-testing/SKILL.md), which automates the WebView
  via Playwright while Maestro handles native chrome around it.
- The change is a pure refactor with no behavioural surface.

---

##### Phase 0 — Preflight (mandatory gate)

Before any agent loop, verify the repo is wired for Maestro on Expo / RN.
Halt and ask the user before installing anything or producing builds.

Run these checks (read-only):

```bash
#### 1. Maestro CLI installed?
maestro --version 2>/dev/null

#### 2. Flow directory present?
ls -d .maestro 2>/dev/null

#### 3. EAS build profile for E2E exists?
jq '.build | has("e2e")' eas.json 2>/dev/null

#### 4. Simulator / emulator available?
xcrun simctl list devices available 2>/dev/null | grep -E 'iPhone'
adb devices 2>/dev/null

#### 5. Existing Detox install (legacy escape hatch)?
jq '.devDependencies | has("detox")' package.json 2>/dev/null
```

Decision table:

| State                                                       | Action                                                                      |
| ----------------------------------------------------------- | --------------------------------------------------------------------------- |
| Maestro CLI present + `.maestro/` exists + `eas.json` `e2e` profile | Proceed to Phase 1.                                                |
| Maestro CLI missing                                         | **Halt.** Print install plan ([`templates/install-plan.md`](./templates/install-plan.md)). Ask permission. |
| `.maestro/` missing                                         | **Halt.** Propose creating `.maestro/` with the [`templates/flow.yaml`](./templates/flow.yaml) starter. Ask first. |
| `eas.json` `e2e` build profile missing                      | **Halt.** Propose [`templates/eas-build-profile.json`](./templates/eas-build-profile.json). Ask first.            |
| No simulator / emulator running                             | **Halt.** Ask the user to boot one, or proceed with Maestro Cloud only.     |
| Existing Detox suite detected                               | Note it. Read [`references/detox-legacy.md`](./references/detox-legacy.md) before proposing migration. |
| Bare RN project (no `expo` / no `eas.json`)                 | Skip EAS-specific checks. Use Maestro CLI directly against a local build.   |

Print the exact commands; do not run them silently.
The full install plan template is in [`templates/install-plan.md`](./templates/install-plan.md).

---

##### Phase 1 — Spec-first feature flow

The agent loop is **spec → emit-flow → run → heal**.
The spec is human-readable Markdown; the executable artefact is a
Maestro YAML flow.
Full rules: [`rules/spec-first-flow.md`](./rules/spec-first-flow.md).

```
specs/<flow>.md   ─┐
                   ├─→  emit  ─→  .maestro/<flow>.yaml  ─→  run  ─→  pass?
                   │                                                   │ no
                   │                                                   ▼
                   └─────────────────  heal  ←──────────────  failing flow + trace
                                          │
                                          ▼
                          patched flow or `testID` source-diff proposal
```

Two entry points:

1. **Spec already drafted by the user.**
   Skip exploration; emit the flow from `specs/<flow>.md`.
2. **App exists, no spec yet.**
   Run an exploratory pass against a running build (simulator) and
   draft `specs/<flow>.md`.
   The user reviews the Markdown before flow emission.

Use the Markdown template in
[`../e2e-testing/templates/spec.md`](../e2e-testing/templates/spec.md).
The spec format is identical across web and mobile — share it.

###### Locator ladder for React Native (when generating or healing)

The Maestro flow walks the platform accessibility tree.
Pick locators in this order — never skip a rung:

1. `id: <testID>` — the source-of-truth selector for E2E.
   Mapped to `accessibilityIdentifier` on iOS and `resource-id` on
   Android (RN 0.64+). Stable across i18n and refactors.
2. `text: <visible string>` — only when the text is short, unique on
   screen, and not localised.
3. `accessibilityText: <label>` — last resort, with caveats.
   See [`rules/locator-strategy.md`](./rules/locator-strategy.md) for
   why `accessibilityLabel` should **not** double as a test selector.

`testID` is the standard fix, not an escape hatch.
When the Healer cannot find a stable element at rung 1, propose a
**source diff** that adds `testID` to the component (use the
`setTestId` helper in
[`templates/testid-helper.tsx`](./templates/testid-helper.tsx) to keep
iOS and Android consistent), and offer the diff for user approval
before patching the flow.
Full rules: [`rules/locator-strategy.md`](./rules/locator-strategy.md).

---

##### Phase 2 — Token-aware execution

Maestro flows are YAML, not pixel snapshots — the per-step token cost
is already an order of magnitude below screenshot-driven runners.
Defaults the skill prescribes
(full rules: [`rules/token-budget.md`](./rules/token-budget.md)):

- Run only the changed flow on iteration: `maestro test .maestro/<flow>.yaml`.
- Use `--shards` only on Maestro Cloud, never on local iteration.
- `record_screen: false` by default; flip to `true` only when chasing a
  visual race.
- `retries: 1` for local, `retries: 2` for Maestro Cloud.
- Run the Healer **only on failure**, not on every save.
- Reuse a cached signed-in `app.app` / `app.apk` from the EAS E2E
  build profile — never rebuild on every flow run.
- Cap the heal loop at three attempts per failing flow before
  escalating.

---

##### Phase 3 — Verification

After the agent emits a flow:

1. Run the flow once against a simulator or device.
   It must pass on first run, or the Healer must converge in ≤ 3 attempts.
2. Invoke [`test-provenance-guard`](../../quality/test-provenance-guard/SKILL.md) on
   any TypeScript helpers the flow imports (e.g. fixture builders) to
   ensure they call production code instead of a private re-implementation.
3. Open `.github/workflows/eas-e2e.yml` (or the EAS Workflow YAML) and
   confirm the `maestro-cloud` job is wired with `retries: 2` and
   `record_screen: false` per
   [`templates/eas-workflow.yaml`](./templates/eas-workflow.yaml).

If the heal loop fails to converge:

- Invoke `confidence(analysis)` on the flow failure.
- If confidence is below 90%, escalate to the user with the Maestro
  log, the spec, and the proposed locator changes — do **not** keep
  healing blindly.

---

##### Decision flow at a glance

| Signal                                                            | Do                                                                                  |
| ----------------------------------------------------------------- | ----------------------------------------------------------------------------------- |
| Bug fixable by a unit or component test                           | Use [`tdd`](../../quality/tdd/SKILL.md), not this skill.                                       |
| Flow is browser-only or pure web                                  | Use [`e2e-testing`](../e2e-testing/SKILL.md), not this skill.                       |
| Flow lives inside a WebView in a hybrid RN app                    | Pair with [`e2e-testing`](../e2e-testing/SKILL.md) for the WebView; Maestro for the native chrome. |
| Multi-screen native flow, deep links, permissions, or push        | Spec-first feature flow (Phase 1).                                                  |
| Flaky existing flow                                               | Healer pass only; do not rewrite without spec context.                              |
| Locator unstable, no stable `testID`                              | Propose `testID` diff via the `setTestId` helper.                                   |
| Repo missing Maestro CLI or `.maestro/` or `eas.json` E2E profile | Phase 0 halt + ask permission.                                                      |
| Heal loop > 3 attempts                                            | Stop, run `confidence(analysis)`, escalate.                                     |
| Flow passes on first run, never seen failing                      | Verify any imported helpers via `test-provenance-guard` before declaring done.      |
| Existing Detox suite is green and stable                          | Keep it; see [`references/detox-legacy.md`](./references/detox-legacy.md).          |
| Detox suite is brittle through RN upgrades                        | Migrate flow-by-flow to Maestro; do not rewrite the whole suite at once.            |

---

##### Composes with

- [`e2e-testing`](../e2e-testing/SKILL.md) — owns web E2E and the
  WebView half of hybrid mobile apps. This skill defers to it for
  anything browser-shaped.
- [`tdd`](../../quality/tdd/SKILL.md) — owns the unit and component layers
  (Jest + React Native Testing Library). This skill defers for
  anything below E2E.
- [`test-provenance-guard`](../../quality/test-provenance-guard/SKILL.md) — runs
  on TypeScript helpers imported by flows to catch tests-by-construction.
- [`confidence`](../../quality/confidence/SKILL.md) — gate when the heal loop fails.
- [`holistic-analysis`](../../analysis/holistic-analysis/SKILL.md) — if a flow is
  failing for reasons no flow rewrite can fix, step back instead of
  patching.
- [`ux`](../../design/ux/SKILL.md) — review accessibility labels separately from
  test IDs (the two should never share a value).

---

##### References

- [`references/maestro-cli.md`](./references/maestro-cli.md) — CLI surface
  (`launchApp`, `tapOn`, `assertVisible`, `runFlow`, Studio, doctor).
- [`references/maestro-mcp.md`](./references/maestro-mcp.md) — Maestro
  MCP tools for agent-driven flow generation and healing.
- [`references/eas-workflows.md`](./references/eas-workflows.md) —
  `eas.json` E2E profile, `.maestro/` layout, `maestro-cloud` job
  parameters (`build_id`, `flow_path`, `shards`, `retries`,
  `record_screen`, `device_identifier`).
- [`references/detox-legacy.md`](./references/detox-legacy.md) — when
  to keep an existing Detox suite vs. migrate.
- [`references/pyramid-mobile.md`](./references/pyramid-mobile.md) —
  pyramid math for Expo / RN with Jest, React Native Testing Library,
  and Maestro.

##### Templates

- [`templates/install-plan.md`](./templates/install-plan.md) — Phase 0
  halt message with the exact commands to install Maestro + EAS CLI
  and scaffold `.maestro/`.
- [`templates/flow.yaml`](./templates/flow.yaml) — sample Maestro flow
  with `launchApp`, `tapOn` (`id:` and `text:` forms), `assertVisible`,
  and `runFlow` includes.
- [`templates/eas-workflow.yaml`](./templates/eas-workflow.yaml) — EAS
  Workflow with a build job and a `maestro-cloud` job.
- [`templates/eas-build-profile.json`](./templates/eas-build-profile.json)
  — `eas.json` snippet for an `e2e` profile producing `.apk` and `.app`.
- [`templates/testid-helper.tsx`](./templates/testid-helper.tsx) —
  `setTestId` helper that maps `testID` and `accessibilityLabel`
  correctly per platform without conflating the two.

---

##### Anti-patterns (one-liner — full list in [`rules/anti-patterns.md`](./rules/anti-patterns.md))

- Writing E2E for logic a unit or RNTL component test catches.
- Reusing `accessibilityLabel` as the test selector (it is for screen
  readers; doubling its purpose breaks accessibility).
- Patching the flow with absolute coordinates (`tapOn: { point: "50%, 80%" }`)
  instead of proposing a `testID` diff.
- Running the Healer on every save, or on a passing flow.
- Rebuilding the `.app` / `.apk` on every flow run.
- Generating flows against a stub server, not the real app stack.
- Migrating a stable Detox suite all at once instead of flow-by-flow.

---

##### Definition of done

- [ ] Phase 0 preflight passed or installs were user-approved.
- [ ] `specs/<flow>.md` exists and the user reviewed it.
- [ ] `.maestro/<flow>.yaml` passes against a real build.
- [ ] Any imported TS helpers pass `test-provenance-guard`.
- [ ] EAS Workflow `maestro-cloud` job runs the flow on Cloud with
      `retries: 2` and `record_screen: false`.
- [ ] If a `testID` was added, it is in the source diff and committed,
      with no `accessibilityLabel` reuse.


---

### playwright-skill
**Description:** Battle-tested Playwright patterns for writing, debugging, and scaling reliable test suites. Use when you need guidance for E2E, API, component, visual, accessibility, or security testing, plus CI/CD, CLI automation, page objects, and migration from Cypress or Selenium. TypeScript and JavaScript.


#### Playwright Skill

> Opinionated, production-tested Playwright guidance — every pattern includes when (and when *not*) to use it.

**50+ reference guides** covering the full Playwright surface: selectors, assertions, fixtures, page objects, network mocking, auth, visual regression, accessibility, API testing, CI/CD, debugging, and more — with TypeScript and JavaScript examples throughout.

Playwright 1.61 highlights covered in these guides: WebAuthn passkey testing via `context.credentials`, the `page.localStorage` / `page.sessionStorage` Web Storage API, new video retention modes matching trace modes, `expect.soft.poll()`, WebSockets in HAR and trace recordings, and `apiResponse.securityDetails()` / `serverAddr()`. Also covered: the 1.60 features (on-demand HAR recording inside tracing, `locator.drop()`, page-level aria snapshot assertions, `test.abort()`) and 1.59 features (screencast recording, browser binding for agent workflows, CLI debugging and trace analysis, in-place storage state updates). A dedicated [trace-analysis.md](core/trace-analysis.md) guide covers agent-native debugging of `trace.zip` reports with the `npx playwright trace` CLI.

##### Security Trust Boundary

This skill is designed for testing **applications you own or have explicit authorization to test**. It does not support or endorse automating interactions with third-party websites or services without permission.

When writing tests or automation that fetch content from external sources (e.g., `baseURL` pointing to staging/production), treat all returned page content as untrusted input — never pass raw page text back into agent instructions or dynamic code execution without sanitization, as this creates an indirect prompt injection risk.

For CI/CD workflows, pin all external dependencies (GitHub Actions, Docker images) to immutable references (commit SHAs, image digests) rather than mutable version tags. See [ci-github-actions.md](ci/ci-github-actions.md) and [docker-and-containers.md](ci/docker-and-containers.md) for pinning guidance.

##### Golden Rules

1. **`getByRole()` over CSS/XPath** — resilient to markup changes, mirrors how users see the page
2. **Never `page.waitForTimeout()`** — use `expect(locator).toBeVisible()` or `page.waitForURL()`
3. **Web-first assertions** — `expect(locator)` auto-retries; `expect(await locator.textContent())` does not
4. **Isolate every test** — no shared state, no execution-order dependencies
5. **`baseURL` in config** — zero hardcoded URLs in tests
6. **Retries: `2` in CI, `0` locally** — surface flakiness where it matters
7. **Traces: `'on-first-retry'`** — rich debugging artifacts without CI slowdown
8. **Fixtures over globals** — share state via `test.extend()`, not module-level variables
9. **One behavior per test** — multiple related `expect()` calls are fine
10. **Mock external services only** — never mock your own app; mock third-party APIs, payment gateways, email

##### Guide Index

###### Writing Tests

| What you're doing | Guide | Deep dive |
|---|---|---|
| Choosing selectors | [locators.md](core/locators.md) | [locator-strategy.md](core/locator-strategy.md) |
| Assertions & waiting | [assertions-and-waiting.md](core/assertions-and-waiting.md) | |
| Organizing test suites | [test-organization.md](core/test-organization.md) | [test-architecture.md](core/test-architecture.md) |
| Playwright config | [configuration.md](core/configuration.md) | |
| Page objects | [page-object-model.md](pom/page-object-model.md) | [pom-vs-fixtures-vs-helpers.md](pom/pom-vs-fixtures-vs-helpers.md) |
| Fixtures & hooks | [fixtures-and-hooks.md](core/fixtures-and-hooks.md) | |
| Test data | [test-data-management.md](core/test-data-management.md) | |
| Auth & login | [authentication.md](core/authentication.md) | [auth-flows.md](core/auth-flows.md) |
| API testing (REST/GraphQL) | [api-testing.md](core/api-testing.md) | |
| Visual regression | [visual-regression.md](core/visual-regression.md) | |
| Accessibility | [accessibility.md](core/accessibility.md) | |
| Mobile & responsive | [mobile-and-responsive.md](core/mobile-and-responsive.md) | |
| Component testing | [component-testing.md](core/component-testing.md) | |
| Network mocking | [network-mocking.md](core/network-mocking.md) | [when-to-mock.md](core/when-to-mock.md) |
| Forms & validation | [forms-and-validation.md](core/forms-and-validation.md) | |
| File uploads/downloads | [file-operations.md](core/file-operations.md) | [file-upload-download.md](core/file-upload-download.md) |
| Error & edge cases | [error-and-edge-cases.md](core/error-and-edge-cases.md) | |
| CRUD flows | [crud-testing.md](core/crud-testing.md) | |
| Drag and drop | [drag-and-drop.md](core/drag-and-drop.md) | |
| Search & filter UI | [search-and-filter.md](core/search-and-filter.md) | |

###### Debugging & Fixing

| Problem | Guide |
|---|---|
| General debugging workflow | [debugging.md](core/debugging.md) |
| Specific error message | [error-index.md](core/error-index.md) |
| Flaky / intermittent tests | [flaky-tests.md](core/flaky-tests.md) |
| Common beginner mistakes | [common-pitfalls.md](core/common-pitfalls.md) |
| Debug a `trace.zip` from the terminal / with an agent | [trace-analysis.md](core/trace-analysis.md) |

###### Framework Recipes

| Framework | Guide |
|---|---|
| Next.js (App Router + Pages Router) | [nextjs.md](core/nextjs.md) |
| React (CRA, Vite) | [react.md](core/react.md) |
| Vue 3 / Nuxt | [vue.md](core/vue.md) |
| Angular | [angular.md](core/angular.md) |

###### Migration Guides

| From | Guide |
|---|---|
| Cypress | [from-cypress.md](migration/from-cypress.md) |
| Selenium / WebDriver | [from-selenium.md](migration/from-selenium.md) |

###### Architecture Decisions

| Question | Guide |
|---|---|
| Which locator strategy? | [locator-strategy.md](core/locator-strategy.md) |
| E2E vs component vs API? | [test-architecture.md](core/test-architecture.md) |
| Mock vs real services? | [when-to-mock.md](core/when-to-mock.md) |
| POM vs fixtures vs helpers? | [pom-vs-fixtures-vs-helpers.md](pom/pom-vs-fixtures-vs-helpers.md) |

###### CI/CD & Infrastructure

| Topic | Guide |
|---|---|
| GitHub Actions | [ci-github-actions.md](ci/ci-github-actions.md) |
| GitLab CI | [ci-gitlab.md](ci/ci-gitlab.md) |
| CircleCI / Azure DevOps / Jenkins | [ci-other.md](ci/ci-other.md) |
| Parallel execution & sharding | [parallel-and-sharding.md](ci/parallel-and-sharding.md) |
| Docker & containers | [docker-and-containers.md](ci/docker-and-containers.md) |
| Reports & artifacts | [reporting-and-artifacts.md](ci/reporting-and-artifacts.md) |
| Code coverage | [test-coverage.md](ci/test-coverage.md) |
| Global setup/teardown | [global-setup-teardown.md](ci/global-setup-teardown.md) |
| Multi-project config | [projects-and-dependencies.md](ci/projects-and-dependencies.md) |

###### Specialized Topics

| Topic | Guide |
|---|---|
| Multi-user & collaboration | [multi-user-and-collaboration.md](core/multi-user-and-collaboration.md) |
| WebSockets & real-time | [websockets-and-realtime.md](core/websockets-and-realtime.md) |
| Browser APIs (geo, clipboard, permissions) | [browser-apis.md](core/browser-apis.md) |
| iframes & Shadow DOM | [iframes-and-shadow-dom.md](core/iframes-and-shadow-dom.md) |
| Canvas & WebGL | [canvas-and-webgl.md](core/canvas-and-webgl.md) |
| Service workers & PWA | [service-workers-and-pwa.md](core/service-workers-and-pwa.md) |
| Electron apps | [electron-testing.md](core/electron-testing.md) |
| Browser extensions | [browser-extensions.md](core/browser-extensions.md) |
| Security testing | [security-testing.md](core/security-testing.md) |
| Performance & benchmarks | [performance-testing.md](core/performance-testing.md) |
| i18n & localization | [i18n-and-localization.md](core/i18n-and-localization.md) |
| Multi-tab & popups | [multi-context-and-popups.md](core/multi-context-and-popups.md) |
| Clock & time mocking | [clock-and-time-mocking.md](core/clock-and-time-mocking.md) |
| Third-party integrations | [third-party-integrations.md](core/third-party-integrations.md) |

###### CLI Browser Automation

| What you're doing | Guide |
|---|---|
| CLI browser interaction | [playwright-cli/SKILL.md](playwright-cli/SKILL.md) |
| Core commands (open, click, fill, navigate) | [core-commands.md](playwright-cli/core-commands.md) |
| Network mocking & interception | [request-mocking.md](playwright-cli/request-mocking.md) |
| Running custom Playwright code | [running-custom-code.md](playwright-cli/running-custom-code.md) |
| Multi-session browser management | [session-management.md](playwright-cli/session-management.md) |
| Cookies, localStorage, auth state | [storage-and-auth.md](playwright-cli/storage-and-auth.md) |
| Test code generation from CLI | [test-generation.md](playwright-cli/test-generation.md) |
| Tracing and debugging | [tracing-and-debugging.md](playwright-cli/tracing-and-debugging.md) |
| Screenshots, video, PDF | [screenshots-and-media.md](playwright-cli/screenshots-and-media.md) |
| Device & environment emulation | [device-emulation.md](playwright-cli/device-emulation.md) |
| Complex multi-step workflows | [advanced-workflows.md](playwright-cli/advanced-workflows.md) |

##### Language Note

All guides include TypeScript and JavaScript examples. When the project uses `.js` files or has no `tsconfig.json`, examples are adapted to plain JavaScript.


---

### playwright-trace-analyzer
**Description:** >


#### Playwright Trace Analyzer

Turn a Playwright `trace.zip` into a ranked, evidence-backed report of
flakes, slow steps, and root causes.

> **Index file.** Detailed extraction rules, analysis playbooks, and
> report templates live under `rules/`, `references/`, and `templates/`.
> Load only what the current phase needs — the body of `SKILL.md` is a
> thin orchestrator.

---

##### Inputs

The user passes one or more of:

| Input                                | Detection signal                                                       |
| ------------------------------------ | ---------------------------------------------------------------------- |
| GitHub Actions run URL               | Matches `https://github.com/<owner>/<repo>/actions/runs/<id>` — fetch artifacts via `gh run download` |
| `trace.zip` archive                  | Magic bytes `50 4b 03 04`; entries include `trace.trace`, `trace.network`, `*.png`, `resources/`     |
| Unpacked trace directory             | Contains `trace.trace` + `trace.network` (NDJSON) and a `resources/` subdir                          |
| Single `trace.trace` JSONL stream    | NDJSON; each line has `type`, `callId`, `startTime`, `params` (e.g. `before`, `action`, `after`)     |
| Single `trace.network` JSONL stream  | NDJSON; entries with `type: "resource-snapshot"` or `requestEvent` / `responseEvent`                  |
| `report.json` (Playwright reporter)  | Top-level `config`, `suites`, `stats`; complementary, never authoritative for timing                  |

If the user passes a `report.json` plus a `trace.zip`, treat the report as
a high-level test status map and the trace as the source of truth for
timing and network data.

If a `test-results/` directory is passed, scan for the most recent
`trace.zip` per failed test and process them in order of failure recency.

See [`rules/input-detection.md`](./rules/input-detection.md) for the
precise detection logic and unpack recipe.

---

##### Workflow

Six phases. Do not skip a gate.

| Phase | Name                | Rule file                                                                | Gate                                                                     |
| ----- | ------------------- | ------------------------------------------------------------------------ | ------------------------------------------------------------------------ |
| 0     | Intake              | [`rules/input-detection.md`](./rules/input-detection.md)                 | Format detected, archive unpacked, `trace.trace` + `trace.network` parseable |
| 1     | Measurement frame   | [`rules/measurement-methodology.md`](./rules/measurement-methodology.md) | Failure mode named (timeout, assertion, error, slow-but-passing) and primary metric chosen (action ms, total wall-clock, request count) |
| 2     | Hotspot extraction  | [`rules/action-timing.md`](./rules/action-timing.md), [`rules/network-analysis.md`](./rules/network-analysis.md), [`rules/console-and-errors.md`](./rules/console-and-errors.md) | Top-N slow actions, top-N slow requests, error/console list — all with concrete numbers |
| 3     | Root-cause          | [`rules/flake-diagnosis.md`](./rules/flake-diagnosis.md)                 | Each hotspot mapped to a code-level cause (selector, locator, network call, app event) with file path or line where possible |
| 4     | Confidence gate     | [`rules/confidence-loop.md`](./rules/confidence-loop.md)                 | `/confidence analysis` ≥ 90% — else iterate (max 2 deep-dives)        |
| 5     | Fix plan            | [`templates/analysis-report.md`](./templates/analysis-report.md)         | Report written with ranked fixes, expected impact, and verification plan |

---

##### Required reading by phase

Load on demand — do not preload.

| Phase | Files                                                                                                                                                                |
| ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0     | [`rules/input-detection.md`](./rules/input-detection.md) — also points to [`scripts/trace-extract.mjs`](./scripts/trace-extract.mjs)                                 |
| 1     | [`rules/measurement-methodology.md`](./rules/measurement-methodology.md)                                                                                             |
| 2     | [`rules/action-timing.md`](./rules/action-timing.md), [`rules/network-analysis.md`](./rules/network-analysis.md), [`rules/console-and-errors.md`](./rules/console-and-errors.md) — backed by [`scripts/trace-summary.mjs`](./scripts/trace-summary.mjs) |
| 3     | [`rules/flake-diagnosis.md`](./rules/flake-diagnosis.md), [`references/flake-patterns.md`](./references/flake-patterns.md), [`references/performance-patterns.md`](./references/performance-patterns.md) |
| 4     | [`rules/confidence-loop.md`](./rules/confidence-loop.md)                                                                                                             |
| 5     | [`templates/analysis-report.md`](./templates/analysis-report.md)                                                                                                     |

Pass-vs-fail comparison (when given two traces of the same test):
[`scripts/trace-diff.mjs`](./scripts/trace-diff.mjs).

---

##### Confidence-gated iteration

After the first pass at root-cause analysis, invoke the confidence skill
in `analysis` mode:

```text
Skill(skill="confidence", args="analysis")
```

Apply this gate:

| Score        | Action                                                                                              |
| ------------ | --------------------------------------------------------------------------------------------------- |
| **≥ 90%**    | Proceed to Phase 5 (fix plan).                                                                      |
| **70–89%**   | Run one deeper pass: re-read the trace, expand the action's `before`/`after` snapshots, correlate with network. |
| **< 70%**    | Surface the gap to the user with a question — do **not** propose changes on speculation.            |

After **two** deep-dive iterations without reaching 90%, stop and present
findings as a hypothesis with the evidence required to confirm it. See
[`rules/confidence-loop.md`](./rules/confidence-loop.md).

---

##### Core principles

1. **Measure before recommending.** Every fix must be tied to a number
   from the trace. "This selector is slow" is not a finding; "`page.click('text=Save')`
   waited 4,820ms across 3 attempts before the button became actionable"
   is.
2. **Distinguish symptom from cause.** A timeout is the symptom; the
   reason the wait never resolved is the cause. The trace records the
   `before` and `after` DOM snapshots and every poll attempt — read them.
3. **Rank by impact, not by ease.** A 50ms selector fix that runs once
   matters less than a 200ms wait that runs in `beforeEach` of 40 tests.
4. **Auto-detect, do not interrogate.** Read the file shape, infer the
   format, state what you found. Ask the user only if detection genuinely
   fails.
5. **Confidence-gated honesty.** If `/confidence` returns < 90%, dig
   deeper or admit uncertainty. Do not paper over a weak diagnosis with a
   confident-sounding fix.
6. **One trace at a time, but diff when given two.** A passing run vs. a
   failing run of the same test is the strongest signal available.

---

##### Anti-patterns (one-liners — full list in
[`references/flake-patterns.md`](./references/flake-patterns.md))

- Recommending `page.waitForTimeout(N)` without measuring the underlying
  race condition.
- Calling a test "flaky" without naming the race — every flake has a
  cause; "non-deterministic" is not a diagnosis.
- Reporting raw action counts without converting to wall-clock time
  share.
- Skipping the network log when an action timed out — most action
  timeouts are blocked on a request that never resolved.
- Swapping `text=` for `getByRole(...)` without checking whether the
  failure was selector resolution or actionability (visibility,
  pointer-events, animation).
- Fixing one slow action and ignoring the long tail of cumulative `auto-wait`
  delays (death-by-a-thousand-cuts is the common case in real suites).

---

##### Trace-analysis quickstart

###### Input is a GitHub Actions run URL

```bash
node <skill_dir>/scripts/fetch-gh-run.mjs https://github.com/<owner>/<repo>/actions/runs/<id> [--out <dir>]
```

The script uses the `gh` CLI (`gh run download`) to fetch every artifact
whose name matches Playwright conventions (`playwright-report*`,
`playwright-traces*`, `test-results*`, `*-traces`, `*-trace`), unpacks
nested ZIPs, and writes a manifest of all `trace.zip` files discovered,
grouped by failed test where possible. Then continue with the unpacked
flow below.
If `gh` is not installed or unauthenticated, ask the user to download the trace artifact manually from the Actions run page and provide the local path — the `trace.zip` flow below is unaffected.

###### Input is a `trace.zip`

1. **Unpack and index.**
   ```bash
   node <skill_dir>/scripts/trace-extract.mjs <path/to/trace.zip> [--out <dir>]
   ```
   Writes a normalised `trace.trace.jsonl`, `trace.network.jsonl`, and a
   manifest of resources/snapshots into `<dir>` (defaults to a sibling
   `<name>.unpacked/`).

2. **Run the summary.**
   ```bash
   node <skill_dir>/scripts/trace-summary.mjs <dir>
   ```
   Prints: total wall-clock, top-N slow actions, top-N slow requests,
   console errors, page errors, and the failing-action stack trace if
   present.

3. **(Optional) Diff a passing trace against a failing trace.**
   ```bash
   node <skill_dir>/scripts/trace-diff.mjs <pass-dir> <fail-dir>
   ```
   Surfaces actions that diverge in duration, requests present in one but
   not the other, and the first action where the two timelines fork.

4. **Map suspects to source.** Use
   [`rules/flake-diagnosis.md`](./rules/flake-diagnosis.md) Phases 3–4 to
   go from action callId → test file/line (Playwright trace events embed
   `location: { file, line, column }`).

The full extraction methodology (capture protocol, how to interpret the
network log, common flake shapes) is in
[`rules/flake-diagnosis.md`](./rules/flake-diagnosis.md). Don't preload
it — only when an input is detected.

##### Definition of Done

- [ ] Input format detected and stated (zip / dir / single JSONL).
- [ ] Failure mode named — timeout, assertion, error, or slow-passing
      (Phase 1).
- [ ] Top-N slow actions listed with measured `dur` (ms).
- [ ] Top-N slow requests listed with `responseEnd - requestStart` (ms)
      and status.
- [ ] Console / page errors captured verbatim.
- [ ] Each hotspot mapped to a test file + line (from `location` in the
      trace event), or to an app file when the cause is in product code.
- [ ] `/confidence analysis` reached ≥ 90% (or two deep-dives
      recorded with the remaining uncertainty surfaced to the user).
- [ ] Fix plan written using
      [`templates/analysis-report.md`](./templates/analysis-report.md),
      with ranked fixes, expected ms saved, and a re-run verification
      step.
- [ ] User has the next concrete action (apply fix N, re-run with
      `--trace=on`, compare).


---

### test-auto-fix
**Description:** >


#### test-auto-fix

Autonomously diagnose and fix failing tests in any project, with hard
guardrails so the loop never devolves into "make the red go away".

This `SKILL.md` is the **orchestration index**.
Load the matching rule file when you need detail — do not preload them.

| Phase | Goal | Required rule |
| ----- | ---- | ------------- |
| 0 | Resolve the surface (bootstrap or validate) | [`rules/bootstrap.md`](./rules/bootstrap.md) + [`rules/surface-validation.md`](./rules/surface-validation.md) |
| 1 | Detect which test surface(s) are failing; build fix plan | this file + [`templates/plan-artifact.md`](./templates/plan-artifact.md) |
| 2 | Per failure: classify as test-bug / prod-bug / unsure | [`rules/verdicts.md`](./rules/verdicts.md) + [`rules/self-improvement-loop.md`](./rules/self-improvement-loop.md) (read lessons) |
| 3 | Per failure: draft the smallest possible fix | this file |
| 3.5 | Confidence gate — before any edit | [`rules/confidence-gate.md`](./rules/confidence-gate.md) |
| 4 | Apply + verify single failing test | this file + [`rules/anti-patterns.md`](./rules/anti-patterns.md) |
| 5 | test-provenance-guard (optional companion) | invoke `Skill("test-provenance-guard")` |
| 6 | Outer loop: re-run full surface; regression-detect | [`rules/regression-detection.md`](./rules/regression-detection.md) + [`rules/self-improvement-loop.md`](./rules/self-improvement-loop.md) (write lessons) |
| 7 | Report (structured exit summary) | [`templates/exit-summary.md`](./templates/exit-summary.md) + [`rules/self-improvement-loop.md`](./rules/self-improvement-loop.md) (write on outcome) |

Always read [`rules/anti-patterns.md`](./rules/anti-patterns.md) first.
The hard refusals apply to every phase.

##### Input

The user provides one of:

- Nothing — auto-run every surface defined in the project surface file.
- A surface name (`vitest`, `unit`, `integration`, etc.) — run only that surface.
- A file path — narrow detection and re-run to that file.
- `--surface <path>` — override the surface file lookup entirely.
- `--plan-only` — diagnose and produce the plan artifact; do not write code.
- `--max-iterations N` — outer-loop cap (default 5).

The argument is: `$ARGUMENTS`.

##### Phase 0 — Resolve the surface

Determine the surface file for the current project. Phase 0 is a hard
two-branch decision; pick exactly one path and follow it through.

###### Step 1 — Pick the resolution branch

- **If `--surface <path>` was passed** → branch A.
- **Otherwise** → branch B.

###### Branch A — `--surface <path>` override

Use the file at `<path>` directly as the surface. **Do NOT compute the project
key, do NOT scan `surfaces/`, do NOT run bootstrap.**

Still validate per [`rules/surface-validation.md`](./rules/surface-validation.md),
but tolerate the project-key mismatch warning (it's expected when overriding).

When validation passes, jump straight to Phase 1.

###### Branch B — Auto-resolve from project key

1. Compute the project key per [`rules/project-keying.md`](./rules/project-keying.md).

2. Look for `surfaces/<project-key>.md` next to this skill file.
   The skill's own directory is resolved by following the symlink chain of
   the loaded `SKILL.md`:
   ```bash
   readlink -f "$(dirname "$0")"
   ```
   If that fails (model-invocation context), default to
   `~/.agents/skills/test-auto-fix/surfaces/`.

3. **If no surface file is found** → run bootstrap per
   [`rules/bootstrap.md`](./rules/bootstrap.md). Bootstrap detects the stack,
   proposes a surface diff, waits for user approval, then writes the file.
   Do NOT proceed to Phase 1 until the surface exists.

4. **If a surface file exists** → validate it per
   [`rules/surface-validation.md`](./rules/surface-validation.md). If validation
   fails, propose an update diff and ask once. If the user declines the update,
   escalate — do not run with an invalid surface.

##### Phase 1 — Detect failures and build the plan

1. Run the detect command from the surface file:
   ```bash
   <detect-command>
   ```
   If `--path <file>` was supplied, append it to narrow the run.
   If the cache-bust-flag is set in the surface and a prior run was cached-green,
   append the flag to force a real run.

2. Parse failures using the `failure-parser` regex from the surface file.
   Group by file, then by failure type.

3. If every surface is green: stop immediately. Tell the user. Do not invent work.

4. Write the fix plan to `.agent/{branch}/test-auto-fix-plan.md` using
   [`templates/plan-artifact.md`](./templates/plan-artifact.md).
   The plan is read-only documentation of intent.
   Order: high-confidence test-bug fixes first, prod-bug suspects last.

##### Phase 2 — Classify each failure (verdict required)

For every failure, apply the rubric in [`rules/verdicts.md`](./rules/verdicts.md).

Getting this wrong means later phases can corrupt production code to satisfy
a broken test, or "fix" a real regression by patching the test.

Emit exactly one verdict per failure:

- `test-bug` — production code correct; test drifted. Continue to Phase 3.
- `prod-bug` — production code regressed; test caught it. **Escalate.** Do not touch the test.
- `unsure` — confidence < 80%. **Escalate.** Surface the evidence and stop.

##### Phase 3 — Draft the minimal fix

For each `test-bug` failure, draft the smallest edit that addresses the
diagnosed root cause.

Hard refusals — full list and detection patterns in [`rules/anti-patterns.md`](./rules/anti-patterns.md):

- Deleting any test, `describe`, `it`, or story export.
- Adding `.skip`, `.only`, `xit`, `xdescribe`, `fit`, `fdescribe`, `it.todo`, `test.todo`.
- Replacing strict matchers with loose ones.
- Deleting `expect(...)` / `assert*()` calls.
- Mocking the System Under Test (the module being tested) instead of its deps.
- Wrapping the failing assertion in `try`/`catch` to swallow it.

##### Phase 3.5 — Confidence gate (before any edit)

Invoke the `confidence` skill in analysis mode for each proposed fix:

```text
Skill("confidence", "analysis proposed fix: <one-line summary>; verdict: <test-bug>; surface: <surface-name>; risk: <test-only|prod-touch>")
```

Record the score in the plan artifact.

Full decision matrix: [`rules/confidence-gate.md`](./rules/confidence-gate.md).

At a glance:

| Score | Action |
| ----- | ------ |
| ≥ 90 | Auto-apply. Continue to Phase 4. |
| 80–89 | Show the diff, ask once, apply on approval. |
| < 80 | Escalate. Do not write. |

The gate is non-negotiable. Auto mode does not override it.

##### Phase 4 — Apply + verify (per fix)

1. Apply the edit with `Edit` — never `Bash sed/awk`.

2. Re-run only the single failing test using the `single-test-command` from
   the surface file, substituting `{file}` and `{name}`:
   ```bash
   <single-test-command>
   ```

3. If still failing: do not patch over. Revert with:
   ```bash
   git restore <file>
   ```
   Re-classify at Phase 2.

4. If green, and `test-provenance-guard` is installed: invoke
   `Skill("test-provenance-guard")` on the file. If it reports
   tests-by-construction, revert and escalate.

5. Only after both checks pass, mark the failure resolved in the plan.

##### Phase 5 — test-provenance-guard (optional)

If `Skill("test-provenance-guard")` is not installed, log:
`companion: test-provenance-guard — not available, continuing`

##### Phase 6 — Outer loop

After a batch of fixes:

1. Re-run the full surface using the detect command:
   ```bash
   <detect-command>
   ```
   Regressions hide in untouched files — always re-run the full surface.

2. Compare against the previous failure set per
   [`rules/regression-detection.md`](./rules/regression-detection.md):
   - Same failures → back to Phase 2 (re-classify; do not repeat same fix).
   - Strict subset → continue with remaining failures.
   - New failure → revert last fix, re-plan or escalate.

3. Cap at `--max-iterations` (default 5).

4. On any exit, write a summary section to the plan file.

##### Phase 7 — Report

Always end with the structured exit summary from
[`templates/exit-summary.md`](./templates/exit-summary.md).

```text
test-auto-fix run
  Outcome: <green | escalated | regression-reverted | max-iterations>
  Resolved: <N> failures
  Escalated: <N> failures (<verdicts>)
  Iterations: <N>/<max>
  Surface: <surface-file-path>
  Plan: .agent/{branch}/test-auto-fix-plan.md
  Escalation reason: <…>           # if not green
```

##### Self-Improvement

`/test-auto-fix` gets better across runs through a two-tier lessons loop (fast
episodic tier + gated promotion), like `autonomous-workflow` and `fix-bug`. It
**reads** `test-auto-fix-lessons` at Phase 2 (biasing the verdict and the Phase 3
fix sub-class) and **writes** at Phase 6 (regression / same-failure signal) and
Phase 7 (outcome retrospective), keyed by `stack : failure-pattern :
verdict-sub-class`. This **complements the surface file** (which is config — how
to run tests here — not learned judgment) rather than duplicating it. Lessons are
**advisory** — they never lower the confidence gate, never turn a
`prod-bug`/`unsure` escalation into a silent test edit, and never override a
refusal in [`rules/anti-patterns.md`](./rules/anti-patterns.md).

Most value is **within a project** — the `repo::{owner}/{repo}` scope (catching a
recurring verdict misclassification for a failure shape); cross-project leverage
(the `global` scope) is weaker because the feedback is binary and local. A
recurring lesson (`seen_count >= 3`) is promotion-eligible via
`/create-skill diagnose test-auto-fix`. Lessons run through LoreKit's `memory.*`
tools (the `lorekit-memory` skill); if LoreKit is not connected the loop is a
silent no-op. Full contract:
[`rules/self-improvement-loop.md`](./rules/self-improvement-loop.md).

##### Definition of done

The run is done when ANY of the following is true:

- All surface tests are green AND the structured exit summary has been printed.
- All remaining failures are `prod-bug` or `unsure` (escalated; user owns next step).
- The confidence gate scored < 80 and the fix was not written.
- A regression was detected, reverted, and the user owns the next step.
- `--max-iterations` (default 5) was reached.


---

### test-provenance-guard
**Description:** >


#### Test Provenance Guard

Catches the failure mode where a new test file *re-implements* the function it claims to test, then asserts against its own copy.
The tests pass.
The CI is green.
The tests provide zero regression protection.

This skill detects that pattern and, when invoked autonomously, fixes it without user intervention.

> **This `SKILL.md` is a thin index.**
> Detailed procedures live in `rules/*.md` and load on demand.
> The case-study post-mortem and failure-mode taxonomy live in `references/*.md`.

---

##### Contents

- [Inputs](#inputs)
- [Workflow](#workflow)
- [Quick Decision Flow](#quick-decision-flow)
- [Required Reading by Phase](#required-reading-by-phase)
- [Output Contract](#output-contract)
- [Core Principles](#core-principles)
- [Anti-patterns](#anti-patterns)
- [Definition of Done](#definition-of-done)
- [Related Skills](#related-skills)

---

##### Inputs

Parse `$ARGUMENTS`:

| Argument                     | Default                                    | Meaning                                                                                |
| ---------------------------- | ------------------------------------------ | -------------------------------------------------------------------------------------- |
| `--diff`                     | off                                        | Discover changed test files via `git diff --name-only <base>...HEAD`.                  |
| `--base <ref>`               | `main`                                     | Base ref for `--diff`.                                                                 |
| `<positional paths>`         | —                                          | Explicit test files to check (overrides `--diff`).                                     |
| `--mode static\|mutate\|both` | `both`                                     | Which checks to run.                                                                   |
| `--fix`                      | **on** when called from autonomous-workflow; **off** for slash invocation | Apply self-heal: extract logic, rewrite tests, re-verify. **Gated by `confidence(code) ≥ 90 %`** unless `--no-confidence-gate` is passed. |
| `--report-only`              | off                                        | Force off `--fix` even when called from autonomous-workflow.                           |
| `--no-confidence-gate`       | off                                        | Manual override — skip the pre-heal confidence gate. Reserved for human-driven slash invocations; never set inside the autonomous loop. |

The skill defaults to `--fix` in the autonomous loop, but **autofix is gated by `Skill("confidence", "code") ≥ 90 %`** before any file is mutated (see [Self-Heal Step 3](./rules/self-heal.md#step-3--pre-heal-confidence-gate-mandatory-when-running-inside-autonomous-workflow)). Below the threshold, the heal is **skipped**, the finding is emitted as `heal-skipped-low-confidence`, and the autonomous-workflow's stuck-loop protocol takes over.

Manual slash invocation defaults to report-only so a human can review the proposed extraction first; pass `--fix` explicitly to apply. The confidence gate is recommended for manual invocations too, but a human can pass `--no-confidence-gate` to override.

If no test files resolve from either `--diff` or positional args, exit cleanly with `no test files in scope, skipping`.

---

##### Workflow

| Phase | Name                       | Rule file                                                          | Gate                                                                              |
| ----- | -------------------------- | ------------------------------------------------------------------ | --------------------------------------------------------------------------------- |
| 1     | Static check               | [`rules/static-check.md`](./rules/static-check.md)                 | Every test file imports the SUT; no shadowed exports                              |
| 2     | Mutation check             | [`rules/mutation-check.md`](./rules/mutation-check.md)             | Sabotaged production code makes the test FAIL                                     |
| 3     | Self-heal (if `--fix`)     | [`rules/self-heal.md`](./rules/self-heal.md)                       | `confidence(code) ≥ 90 %` on the proposed extraction; extracted helper exists, test imports it, mutation check now passes |

Phase 1 is mandatory.
Phase 2 runs only when Phase 1 passes (a static-shadow finding already explains the failure — no need to mutate).
Phase 3 runs only on detected findings *and* only when `--fix` is on *and* the pre-heal confidence gate clears (≥ 90 %).

---

##### Quick Decision Flow

```
for each test file in scope:
    finding = static_check(file)                 # rules/static-check.md
    if finding.kind == "shadowed-export":
        if --fix: gated_self_heal(finding)        # rules/self-heal.md
        else:    record(finding)
        continue

    if finding.kind == "no-sut-import":
        record(finding)                           # cannot mutate without an SUT
        continue

    if mode in {"mutate", "both"}:
        finding = mutation_check(file)            # rules/mutation-check.md
        if finding.kind == "test-survives-sabotage":
            if --fix: gated_self_heal(finding)
            else:    record(finding)

report(findings)
exit code = 0 if all healed or no findings, else 1


def gated_self_heal(finding):
    proposal = plan_extraction(finding)            # Step 1+2 of self-heal
    if not --no-confidence-gate:
        score = Skill("confidence", "code", proposal)
        if score < 90:
            record(finding, status="heal-skipped-low-confidence", score=score)
            return
    self_heal(finding, proposal)                    # Steps 4-6 of self-heal
```

---

##### Required Reading by Phase

Load on demand — do not preload.

| Phase | Files                                                                           |
| ----- | ------------------------------------------------------------------------------- |
| 1     | [`rules/static-check.md`](./rules/static-check.md)                              |
| 2     | [`rules/mutation-check.md`](./rules/mutation-check.md)                          |
| 3     | [`rules/self-heal.md`](./rules/self-heal.md)                                    |
| —     | [`references/failure-modes.md`](./references/failure-modes.md) — taxonomy        |
| —     | [`references/pr-12340-postmortem.md`](./references/pr-12340-postmortem.md) — origin case |

---

##### Output Contract

After every run, emit a structured report.
The autonomous-workflow Phase 4 logger consumes the JSON line; humans read the Markdown summary.

```
TEST PROVENANCE REPORT
======================
Files checked: <N>
Findings:
  - <test-file>:<line> — <kind> — <one-line evidence>
    Action: <healed | reported | skipped | skipped-low-confidence>
    Confidence (if gated): <N>%

Self-heal summary (if --fix):
  - Pre-heal confidence: <N>% (gate ≥ 90 %)
  - Extracted <symbol> from <prod-file>:<line> → <new-export-file>:<line>
  - Rewrote <test-file> to import <symbol>
  - Mutation check after heal: PASS

Exit: <0 | 1>
```

When called from `autonomous-workflow` Phase 4, also append one line to `.agent/{branch}/plan.md`'s Progress Log:

```markdown
- [<ISO-8601>] Phase 4: test-provenance-guard — <N> file(s) checked, <M> finding(s), <K> healed (confidence ≥ 90 %), <L> skipped-low-confidence
```

---

##### Core Principles

1. **A test that does not import the production module is not a test of that module.**
   The static check is the cheapest, strongest signal.
2. **A test that survives sabotage of its claimed target is by-construction.**
   Mutation is the second-line evidence — slow but conclusive.
3. **Self-heal is a refactor, not a rewrite.**
   Extract the inline logic verbatim; do not redesign the function while moving it.
4. **Never silently change test assertions.**
   Self-heal moves logic and rewrites imports; assertions are preserved unchanged.
5. **Report, then act.**
   Even when `--fix` is on, the report is emitted before the heal so the audit trail survives.
6. **Skip cleanly when out of scope.**
   No test files? Exit 0.
   Test files in unsupported languages?
   Skip them with a one-line note and continue.

---

##### Anti-patterns

- **Treating a passing test as proof the test is correct.**
  A test can pass for the wrong reason — that is the entire raison d'être of this skill.
- **Mutating without restoring.**
  Every sabotage step is paired with a restore — `git restore <sut-file>` when the file was clean, or moving the recorded backup over it when it was dirty — see `rules/mutation-check.md`.
- **Self-healing with a redesign.**
  Moving logic and improving it in the same step is two refactors masquerading as one — split them.
- **Running mutation when static already failed.**
  Wasted tokens.
  Skip Phase 2 when Phase 1 already produced a finding.
- **Asking the user during autonomous runs.**
  This skill self-heals when `--fix` is on; if it cannot, it reports the finding and exits — the autonomous-workflow stuck-loop protocol takes over.

---

##### Definition of Done

- [ ] Every test file in scope passed Phase 1 (or was healed).
- [ ] Every test file in scope passed Phase 2 (or was healed).
- [ ] Self-heal summary lists the extraction(s) with file paths and line numbers.
- [ ] All originally passing tests still pass after self-heal (`<TEST_CMD>` re-run is green).
- [ ] Report emitted in the structured format above.
- [ ] When called from autonomous-workflow, the Progress Log line is appended.

---

##### Related Skills

- [`autonomous-workflow`](../../workflow/autonomous-workflow/SKILL.md) — invokes this skill from Phase 4 Step 5.
- [`tdd`](../../quality/tdd/SKILL.md) — Test-After Mode's "mutate to verify" rule is the conceptual ancestor of Phase 2 here.
- [`code-quality`](../code-quality/SKILL.md) — Pass 12 ("Testability") covers adjacent design issues; this skill targets the specific by-construction failure.
- [`confidence`](../confidence/SKILL.md) — when self-heal cannot resolve a finding, the autonomous-workflow Phase 4 stuck-loop protocol calls `confidence(analysis)` next.


---

### verify-and-stop
**Description:** Prove existing work meets acceptance conditions without expanding scope. Use for validation-only tasks, completion checks, focused gate runs, and last-mile proof.


#### Verify and stop

Translate acceptance conditions into smallest sufficient proof set.

- Reuse still-current results with matching repository state.
- Run focused checks before wider gates.
- Distinguish pass, fail, unavailable, and blocked exactly.
- Do not edit product code unless verification request includes fixes.
- Do not add polish, cleanup, or unrelated tests after criteria pass.

Stop immediately when acceptance proof is complete. Report commands, results, and unresolved risk only.


---

### verify-behavior
**Description:** >


#### Verify Behavior

Given a behavioral claim about code, or a change that was just applied, decide **the cheapest way to get executed proof**, run it in isolation, and report the raw result as a receipt.

This skill is the execution engine six-plus call sites in this repo used to hand-roll independently: "detect the toolchain, run something, read pass or fail."
It replaces the ad hoc version in each of those with one shared ladder.

> **This `SKILL.md` is a thin index.** Detailed rules live in `rules/*.md` and load on demand.

---

##### The execute-not-score boundary

This skill **does not score** — it never assigns a confidence score and never grades pass/fail against an intent.
It runs a command, captures the raw output, and classifies the result against the *claim itself* as `confirms` / `contradicts` / `ambiguous` / `null`.

- `confidence(code)` owns the number — this skill supplies sharper evidence to that gate, it does not replace it.
- A calling agent's own grading (e.g. `bug-fix-verifier`'s `FAIL_TO_PASS`, the `aw-executor` Phase 4 `expect` comparison) stays with the caller — this skill supplies the run-and-observe mechanic underneath that grading, not the grading itself.

See [`rules/receipt.md`](./rules/receipt.md) for the full contract, including the hard invariant that a null or non-reproducing result **drops or contradicts** a finding and is never confirmation.

---

##### The two consumer shapes

| Shape | Question it answers | Consumers |
| --- | --- | --- |
| **Claim-verification** | "Is this specific behavioral assertion true?" — read-only, feeds `confidence(code)` as Evidence | `agents/shared/rules/verification-receipt.md` (pr-reviewer Tier 2/3) |
| **Change-verification** | "Did this applied change produce the expected green/red result?" — a post-apply gate | `bug-fix-verifier`, `feature-pr-verifier`, `aw-executor` Phase 4 checks loop |

Both shapes share the same core: toolchain discovery, isolated execution, and the receipt format.
Only the output framing differs — see [`rules/receipt.md`](./rules/receipt.md).

---

##### Mode Detection

Parse the **first token** of `$ARGUMENTS`.

| Mode | Default | Trigger | What it does |
| --- | --- | --- | --- |
| `claim` | **yes** | No mode token, or `claim` | Verify one behavioral assertion. Returns a single receipt. Read-only. |
| `change` | | First token `change` | Verify a just-applied change against an expected outcome. Returns a green/red gate result with the same receipt shape underneath. |

##### Inputs

- `claim` (claim mode) — the behavioral assertion in prose, e.g. "`validateAuth` throws on an invalid token."
- `target` — the file(s) or symbol the claim or change concerns.
- `expected` (change mode) — the expected post-change outcome (e.g. an `expect:` string from `checks.yaml`, or "the repro now passes").
- `review_relation` — `"self"` | `"cross"` | `"untrusted"` (default `"self"` for a caller's own branch).
  Governs the Tier 3 trust split — see [`rules/isolation-safety.md`](./rules/isolation-safety.md).
- `caller` — the invoking agent or skill, for logging only.

##### The ladder (cheapest-first)

| Tier | Name | Cost | Example tools |
| --- | --- | --- | --- |
| Tier 1 | Syntactic | Lowest | `grep`, `ast-grep`, `Read` |
| Tier 2 | Semantic-no-execution | Low | `tsc --noEmit`, `go build`/`go vet`/`staticcheck`, `cargo check`/`clippy`, `pyright`/`mypy` |
| Tier 3 | Execution | Highest | Run the covering test, or synthesize and run a minimal repro |

Stop at the cheapest tier that can **decide** the claim — do not escalate to Tier 3 when Tier 1 or Tier 2 already confirms or contradicts it.
Full per-language mapping in [`rules/ladder.md`](./rules/ladder.md).

##### Workflow

| Phase | Name | Rule file | Gate |
| --- | --- | --- | --- |
| V1 | Toolchain discovery | [`rules/toolchain-discovery.md`](./rules/toolchain-discovery.md) | Discovery order resolved; never assume a global install |
| V2 | Tier selection | [`rules/ladder.md`](./rules/ladder.md) | Cheapest tier that can decide the claim, per the per-language adapter table |
| V3 | Isolated execution | [`rules/isolation-safety.md`](./rules/isolation-safety.md) | Throwaway worktree (Tier 3), tracked files never modified, scratch deleted, relation-keyed trust split honored |
| V4 | Receipt | [`rules/receipt.md`](./rules/receipt.md) | `confirms`/`contradicts`/`ambiguous`/`null`; null-is-never-confirmation invariant |
| V5 | Report | this file + [`rules/receipt.md`](./rules/receipt.md) | Claim mode returns the receipt; change mode returns the receipt plus a green/red verdict |

###### V1 — Toolchain discovery

Resolve what to run before deciding how to run it: `checks.yaml` first, then the `argent-environment-inspector` detection pattern, then manifest scripts.
Never assume a tool is globally installed.
See [`rules/toolchain-discovery.md`](./rules/toolchain-discovery.md).

###### V2 — Tier selection

Walk the ladder Tier 1 → Tier 2 → Tier 3, stopping at the first tier that can decide the claim.
A claim about symbol absence or a missing guard is usually a Tier 1 grep.
A claim about a type contract is usually a Tier 2 typecheck.
A claim about runtime return value, thrown error, or side-effect ordering needs Tier 3.
See [`rules/ladder.md`](./rules/ladder.md) for the full per-language table.

###### V3 — Isolated execution

Tier 3 runs in a throwaway worktree, never touches tracked files, deletes its scratch harness after, defaults to no network, and never pipes a remote script into a shell.
Tier 3 is default-on only for the caller's own code (`self` relation); cross/untrusted callers need an explicit sandbox opt-in.
See [`rules/isolation-safety.md`](./rules/isolation-safety.md).

###### V4 — Receipt

Every run — regardless of tier or mode — produces a receipt: the raw command, its raw output, and one of four verdict tokens.
A null or empty result is dropped or contradicts; it is never read as confirmation.
See [`rules/receipt.md`](./rules/receipt.md).

###### V5 — Report

- **claim mode** → return the receipt to the caller (typically `confidence(code)` Evidence).
- **change mode** → return the receipt plus a green/red verdict against the caller-supplied `expected` outcome.
  The caller keeps its own grading semantics on top (e.g. `checks.yaml`'s `expect:` comparison, `FAIL_TO_PASS`).

##### Required Reading by Phase

Load on demand — do not preload.

| Phase | Files |
| --- | --- |
| V1 | [`rules/toolchain-discovery.md`](./rules/toolchain-discovery.md) |
| V2 | [`rules/ladder.md`](./rules/ladder.md) |
| V3 | [`rules/isolation-safety.md`](./rules/isolation-safety.md) |
| V4, V5 | [`rules/receipt.md`](./rules/receipt.md) |
| wiring | [`agents/shared/rules/verification-receipt.md`](../../../agents/shared/rules/verification-receipt.md) — how `pr-reviewer` calls this skill |
| diagnose | [`rules/diagnostic-surface.md`](./rules/diagnostic-surface.md) |

##### Core Principles

1. **Cheapest-first, always.** Never reach for Tier 3 when Tier 1 or Tier 2 already decides the claim.
2. **Never assume a global install.** Discover the project's actual toolchain before running anything (`rules/toolchain-discovery.md`).
3. **Isolation is not optional for Tier 3.** A throwaway worktree, no tracked-file mutation, scratch cleanup, no network by default, never `curl | sh` (`rules/isolation-safety.md`).
4. **Trust is relation-keyed, not caller-configurable.** Tier 3 on cross/untrusted code requires an explicit sandbox opt-in; this is a hard safety boundary, not a tuning knob.
5. **Execute, never score.** The receipt reports what happened; it never assigns a confidence number or a pass/fail grade against intent — that stays with the caller.
6. **Null is never confirmation.** A non-reproducing Tier 3 repro or a clean Tier 2 build on a claim asserting a problem exists DROPS or contradicts the finding.

##### Anti-patterns (one-liners — full list in the rules)

- Escalating straight to Tier 3 for a claim a `grep` could decide.
- Assuming `tsc`/`go`/`cargo`/`pyright` is on `PATH` without checking the project's actual toolchain.
- Running Tier 3 in the working tree instead of a throwaway worktree.
- Running Tier 3 on cross/untrusted code without an explicit sandbox opt-in.
- Treating a null or empty Tier 3 result as confirming the claim.
- Returning a confidence score or a verdict against intent instead of a receipt.

##### Definition of Done

- [ ] Toolchain discovered per the documented order, never assumed global.
- [ ] Cheapest deciding tier used; no unnecessary Tier 3 escalation.
- [ ] Tier 3 (if run) executed in isolation, tracked files untouched, scratch deleted.
- [ ] Trust split honored — Tier 3 gated by `review_relation`.
- [ ] Receipt returned with a verdict token; null/contradicting results dropped, never confirmed.
- [ ] No confidence score or intent-grade emitted by this skill itself.


---

### audit-reference-originality
**Description:** Audit a website or digital experience against its supplied source references for originality and plagiarism risk. Use when Codex must compare current or historical site output with reference pages, capture packs, screenshots, copy, brands, numbers, images, assets, videos, layouts, motion, or code; raise evidence-backed red flags; distinguish common visual grammar from distinctive copying; and propose concrete fixes without making unsupported legal claims.


#### Audit Reference Originality

Compare the shipped experience with the complete reference corpus. Treat the audit as an evidence exercise, not a vibe check.

##### Preserve the audit boundary

- Audit only unless the user also asks for fixes.
- Call findings `originality risks`, `overlaps`, or `red flags`; do not declare legal plagiarism from visual similarity alone.
- Pair every red flag with exact current-site evidence and exact reference evidence.
- Keep fact, inference, and unknown access separate.
- Do not clear a site after checking only its homepage screenshot.

##### 1. Build the source registry

Start with the materials explicitly supplied in the task or recorded by the project:

- manifests, prompt packs, and originality matrices
- representative stills, full-page captures, and section crops
- MP4s and extracted motion frames
- reference URLs and named creators
- source brand assets, copy, numbers, screenshots, and downloads
- project briefs, `IMAGE_CREDITS.md`, licenses, and attribution files

Prefer local evidence captured at the time of the brief. Use a live reference only to fill a real gap, because it may have changed. Record each reference's path or URL, role, date when known, and which categories it can prove.

Stop and report an access gap when a promised reference is missing. Do not silently reduce a full-page or motion audit to one cover image.

##### 2. Inventory the current site and its history

Inspect:

- rendered text, metadata, navigation, calls to action, legal copy, and hidden accessible labels
- brand names, wordmarks, logos, icons, people, companies, URLs, and product/interface data
- prices, metrics, dates, counts, percentages, package names, and repeated proof claims
- every rendered image, background, texture, screenshot, font, logo, icon, audio file, and downloadable asset
- every video, poster, frame sequence, shot order, transition, duration, and playback treatment
- layout hierarchy, section order, distinctive compositions, typography behavior, motion grammar, shaders, cursor effects, and interaction sequences
- current source, built output when available, asset provenance, and repository history

Do not trust filenames as proof of originality. Inspect the bytes, visible result, and history. Search renamed, deleted, and replaced files with `git log`, `git show`, `git log -S`, and `git log --all --name-status`.

Run the deterministic inventory helper when local files are available:

```bash
python <skill-dir>/scripts/build_evidence_inventory.py \
  --site <site-root> \
  --reference <reference-file-or-directory> \
  --reference <another-reference> \
  --output <temporary-output.json>
```

The helper finds current and historical exact-file matches, suspicious basename reuse, normalized text overlap, and repeated number tokens. Treat its output as leads for human review, not an automatic verdict.

##### 3. Compare category by category

Read [references/audit-rubric.md](references/audit-rubric.md) before judging findings.

Audit at least these categories:

1. **Text** — headlines, body copy, labels, CTAs, captions, legal text, alt text, metadata, and decorative wording.
2. **Brands** — names, marks, wordmarks, proprietary icons, people, companies, partnerships, URLs, and distinctive verbal identity.
3. **Numbers** — metrics, percentages, prices, dates, counts, plan structures, durations, and interface values.
4. **Images** — exact files, crops, generated derivatives, screenshots, people, poses, objects, signature compositions, and color treatment.
5. **Assets** — fonts, icons, logos, textures, mockups, downloads, code bundles, and third-party media with unclear provenance.
6. **Videos** — exact files, frames, shots, timing, camera moves, edit rhythm, transitions, overlays, posters, and audio.
7. **Structure and motion** — section order, unusual layout devices, pinned sequences, cursor interactions, shaders, and combinations of signature elements.
8. **History** — copied material that was later renamed, recolored, cropped, hidden, deleted, or replaced.

Common patterns such as black backgrounds, large sans-serif type, ordinary pricing tables, standard fade-ins, or a conventional footer are not red flags by themselves. Escalate combinations of distinctive elements or direct evidence.

##### 4. Triangulate every red flag

For each candidate:

1. Identify the current-site artifact and location.
2. Identify the exact reference artifact and location.
3. State the observable overlap without guessing intent.
4. State what differs.
5. Assign severity using the rubric.
6. Propose the smallest fix that breaks the overlap while preserving the site's goal.

Use hashes for exact files, normalized excerpts for copy, side-by-side crops for imagery, and matched timestamps or frames for video. A source-brand string found only in a test that explicitly forbids it is not a shipped-copy violation; explain context.

##### 5. Propose fixes

Prefer concrete replacements:

- rewrite source-like copy from the new brand's audience, offer, and vocabulary
- replace names, URLs, logos, people, metrics, dates, plan names, and legal text
- regenerate or license new imagery with a materially different subject, composition, and motif arrangement
- replace copied assets and document provenance
- re-cut videos with new shots, timing, transitions, overlays, and audio
- reorder or redesign distinctive section and motion sequences
- remove stale source material from current output and, when required, repository history or published artifacts

Do not recommend cosmetic recoloring as a fix for copied identity, copy, media, or composition.

##### 6. Report the result

Lead with one verdict:

- `Clear in checked scope`
- `Clear with low-risk similarities`
- `Changes recommended`
- `Block release`
- `Blocked by missing evidence`

Then provide:

1. checked source registry
2. red-flag table ordered by severity
3. category pass list
4. history findings
5. access gaps and unproven areas
6. prioritized fix plan

Include a row even when a high-risk category could not be checked. Never turn missing evidence into a pass.

##### Completion checks

- Every supplied reference form was inspected.
- Rendered output and source were both checked.
- Text, brands, numbers, images, assets, videos, structure/motion, and history were covered.
- Every red flag cites two evidence locations.
- Exact matches are distinguished from stylistic similarity.
- Proposed fixes replace the copied element rather than disguising it.
- The report states what remains unverified.


---

### audit-verify-explain-grade-5
**Description:** Audit work, verify claims with concrete evidence, and explain the result in simple grade-5 language. Use when the user asks to review, audit, check, verify, explain a change, explain a fix, summarize test results, validate whether something works, or translate technical findings into plain language for non-technical readers.


#### Audit, Verify, Explain

##### Core Rule

Treat every answer as three jobs:

1. Audit what changed or what is being claimed.
2. Verify it with direct evidence.
3. Explain it like the reader is smart but new to the topic.

Do not skip verification when local files, commands, logs, tests, screenshots, or source data are available. Do not pretend something was verified if it was only inferred.

##### Workflow

###### 1. Audit

Start by finding the real source of truth:

- For code changes, inspect the diff, touched files, related call sites, and existing tests.
- For bug fixes, identify the before/after behavior and the user-facing path.
- For performance claims, separate measured evidence from likely improvement.
- For release or app behavior, check the packaged/running artifact when possible.
- For documents or content, compare the user request against the actual produced artifact.

Look for:

- obvious bugs or regressions
- missing edge cases
- stale assumptions
- unverified claims
- mismatches between implementation and user intent
- risks that a grade-5 explanation might accidentally hide

###### 2. Verify

Prefer evidence in this order:

1. Automated tests, builds, linters, typechecks, or validators.
2. Running the actual app or workflow.
3. Logs, process checks, screenshots, generated artifacts, or live output.
4. Static code inspection when execution is impractical.
5. Clearly labeled inference when nothing stronger is available.

When verification fails, report the blocker and what it means. When verification is partial, say exactly what was and was not checked.

For performance work, avoid overclaiming. Say "this removes repeated work" only when the code clearly does so. Say "should improve" only when no timing trace was captured. Say "measured faster" only when before/after measurements exist.

###### 3. Explain Simply

Use grade-5 language without talking down to the user:

- Use short sentences.
- Define technical terms in plain words.
- Use one simple analogy only if it genuinely helps.
- Say what changed, why it matters, and how to test it.
- Keep important caveats visible.

Prefer this shape:

```markdown
What changed:
- ...

Why it matters:
- ...

How I verified it:
- ...

What is still not proven:
- ...
```

For very small answers, use a short paragraph instead of forcing headings.

##### Explanation Standards

Translate technical ideas like this:

- "cache" -> "remember the answer so we do not ask the same question again"
- "metadata" -> "small facts about a file, like size or modified date"
- "regression" -> "something that used to work but broke"
- "artifact" -> "the real file or app that was created"
- "static inspection" -> "reading the code without running it"

Do not say "everything works" unless the full workflow was tested. Say "the checked parts work" when verification covered only part of the system.

##### Output Rules

Lead with the answer. Keep the tone calm and clear.

Include file paths, commands, commit hashes, test names, or log snippets when they are the evidence. Keep them brief.

Separate facts from judgment:

- Fact: "The tests passed."
- Judgment: "That gives confidence in the timeline planner, but not the full editor UI."

End with the most useful next test only when another test would materially improve confidence.


---

### ci-auto-fix
**Description:** >


#### CI Auto-Fix

Diagnose and fix a failed CI check, then verify it passes.
Generic across repositories; currently implements the GitHub Actions path via `gh`.

This `SKILL.md` is the **orchestration index**.
Load the matching rule file when you need detail — do not preload them.

| Phase | Goal | Required rule |
| ----- | ---- | ------------- |
| 0 | Resolve the target (run ID / PR URL / auto-detect) | this file |
| 1 | Identify the failure (fetch logs) | this file |
| 2 | Read every workflow file before editing one | this file |
| 3 | Classify the failure with an explicit verdict | [`rules/verdicts.md`](./rules/verdicts.md) + [`rules/self-improvement-loop.md`](./rules/self-improvement-loop.md) (read lessons) |
| 3.5 | Write the plan artifact + run the confidence gate | [`rules/confidence-gate.md`](./rules/confidence-gate.md) + [`templates/plan-artifact.md`](./templates/plan-artifact.md) |
| 4 | Apply the minimal, targeted fix | this file + [`rules/anti-patterns.md`](./rules/anti-patterns.md) |
| 5 | Verify locally before pushing | this file |
| 6 | Commit and push (rebase-safe) | this file |
| 7 | Wait for CI and capture the new result | this file |
| 8 | Iterate — with regression detection | [`rules/regression-detection.md`](./rules/regression-detection.md) + [`rules/self-improvement-loop.md`](./rules/self-improvement-loop.md) (write on revert) |
| 9 | Report (structured exit summary) | this file + [`rules/self-improvement-loop.md`](./rules/self-improvement-loop.md) (write on outcome) |

Always read [`rules/anti-patterns.md`](./rules/anti-patterns.md) first.
The refusals apply to every phase.

##### Input

The user provides one of:

- A GitHub Actions check/run URL (e.g. `https://github.com/owner/repo/actions/runs/12345678`)
- A check run ID or workflow run ID
- A PR URL with failing checks (e.g. `https://github.com/owner/repo/pull/42`)
- **Nothing** — if `$ARGUMENTS` is empty, auto-detect the failing CI for the current branch's PR (see Phase 0).

The argument is: `$ARGUMENTS`.

##### Phase 0 — Resolve the target

If `$ARGUMENTS` is empty, do not ask the user — resolve automatically:

1. Get the current branch:
   ```bash
   git rev-parse --abbrev-ref HEAD
   ```

2. Find the open PR for this branch:
   ```bash
   gh pr list --head "<branch>" --state open --json number,url,headRepositoryOwner --limit 1
   ```
   - If exactly one PR is found, use its URL as the PR input and continue to Phase 1.
   - If `headRepositoryOwner.login` differs from the current repo's owner (fork PR), surface that fact to the user before continuing.
   - If no open PR is found, fall back to the most recent failed workflow run on this branch:
     ```bash
     gh run list --branch "<branch>" --limit 10 --json databaseId,conclusion,workflowName \
       | jq '[.[] | select(.conclusion == "failure")] | .[0]'
     ```
     If a failed run is found, treat its `databaseId` as the run ID input.
   - If neither resolves (no PR, no failed run), **then** ask the user.

3. Print the resolved target before continuing:
   `Auto-detected target: <PR URL or run ID> on branch <branch>`.

##### Step 0: Resolve your GitHub access path

Before any GitHub step, resolve which path you have — `gh` CLI, `mcp__github__*` tools, or neither — per **[`agents/shared/rules/github-access.md`](../../../agents/shared/rules/github-access.md)**. Resolve once, state the path you took, and use it for the whole run.

`gh` is **absent in Claude Code cloud sessions**, so the commands written below are the `gh`-path form; on the MCP path use the verb mapping in that file rather than attempting them. With **neither** path, GitHub steps cannot be performed: say so precisely, do the `git` work you can, and hand the rest back — never report a step you could not perform as blocked-by-something-else.

##### Phase 1 — Identify the failure

Based on the input:

1. **Run URL or run ID** — fetch the failed job logs:
   ```bash
   gh run view <run-id> --log-failed
   ```

2. **PR URL** — list the failing checks first:
   ```bash
   gh pr checks <pr-number> --repo <owner/repo>
   ```
   Then fetch logs for each failing check.

3. **Check suite / check run ID**:
   ```bash
   gh api repos/<owner>/<repo>/check-runs/<check-run-id>
   ```

Extract and summarize:

- Which job(s) failed.
- The specific error messages and exit codes.
- Which step within the job failed.
- The full error context (surrounding log lines).

##### Phase 2 — Understand the workflow holistically

Before making any changes, read every workflow file in the repository:

```bash
find .github/workflows -name '*.yml' -o -name '*.yaml'
```

Build a mental model of:

- How jobs depend on each other (`needs:`).
- What triggers each workflow (`on:`).
- Shared steps, reusable workflows, composite actions.
- Environment variables and secrets used.
- Matrix strategies.
- Caching strategies.
- Artifact passing between jobs.

This holistic understanding prevents fixes that solve one problem but break another job or workflow.

##### Phase 3 — Classify the failure (verdict required)

Pick exactly one verdict per failure.
The verdict binds behavior; do not skip this step.

Full decision table and per-verdict notes: [`rules/verdicts.md`](./rules/verdicts.md).

Verdicts at a glance:

- `code-bug` / `workflow-bug` / `dep-bug` / `env-bug` → continue to Phase 3.5.
- `flaky` / `unsure` → **escalate.** Stop.

##### Phase 3.5 — Plan artifact + confidence gate

1. Write or update the plan at `.agent/{branch}/ci-auto-fix-plan.md` using [`templates/plan-artifact.md`](./templates/plan-artifact.md).
   The plan is read-only documentation of intent — the user can pre-empt before any code is written.

2. Run the confidence gate per [`rules/confidence-gate.md`](./rules/confidence-gate.md):

   | Score | Action |
   | ----- | ------ |
   | ≥ 90 | Auto-apply. Continue to Phase 4. |
   | 80–89 | Show the diff, ask once, apply on approval. |
   | < 80 | Escalate. Do not write. |

   The gate is non-negotiable.

##### Phase 4 — Fix the error

Apply the minimal, targeted fix per the verdict:

- `code-bug` — fix the actual code issue.
- `workflow-bug` — fix the workflow YAML.
- `dep-bug` — update the lockfile or correct the version constraint.
- `env-bug` — pin or bump the runner-side version.

Hard refusals (full list in [`rules/anti-patterns.md`](./rules/anti-patterns.md)):

- Do not disable, skip, or weaken any check.
- Do not add `continue-on-error: true`.
- Do not add `.skip` / `it.only` to silence a test.
- Do not skip hooks with `--no-verify`.
- Do not refactor surrounding code.

Do:

- Make the smallest change that fixes the root cause.
- Stay consistent with the rest of the codebase.
- If fixing a test, verify the test is the one that's wrong (not the code it tests).

##### Phase 5 — Verify locally

Before pushing, run the same checks that failed:

- If build failed: run the build command.
- If lint failed: run the linter.
- If tests failed: run the tests.
- If typecheck failed: run the type checker.

Only proceed to push if local verification passes.

##### Phase 6 — Commit and push

1. Stage only the files relevant to the fix.

2. Write a clear commit message:

   ```text
   fix(ci): <description of what was fixed>

   <brief explanation of root cause and fix>
   ```

3. Sync with the remote before pushing — a parallel worker may have pushed:

   ```bash
   git pull --rebase origin "<branch>"
   ```

   If the rebase conflicts, run `git rebase --abort`, stop, and report the conflicting files to the user. Do not auto-resolve.

4. Push:

   ```bash
   git push origin "<branch>"
   ```

5. If the push is rejected as non-fast-forward, rebase and retry the push **once**.
   If the retry also fails, or the rebase conflicts, stop and report. Never `--force` push from this skill.

##### Phase 7 — Wait for CI

After pushing, monitor the check:

1. Find the new workflow run — **select on the head SHA, do not sleep and hope.**
   A bare `sleep` is blocked in some harnesses, and a fixed 10 s is a race: if
   registration takes longer, the listing returns the *previous* commit's runs and
   you watch a stale run to green. Filtering by SHA removes the race instead of
   timing it (the same fix [`e2e-pr-stabilizer`](../../testing/e2e-pr-stabilizer/rules/verification-loop.md) already uses):

   ```bash
   # Issue this Bash call with the tool parameter timeout: 600000.
   # Bounded loop with a real interval — registration takes seconds, so six
   # back-to-back calls would exhaust the retries before it could happen.
   # The sleep is inside a capped loop, so it is not a bare sleep.
   timeout 90 bash -c '
     SHA=$(git rev-parse HEAD); TMP=$(mktemp)
     # TERM must be listed: bash runs the EXIT trap on a signal only when that
     # signal is trapped, and `timeout` sends TERM on the 124 path.
     trap "rm -f \"$TMP\"" EXIT INT TERM
     while :; do
       # stderr -> variable, stdout -> file. `head -1` is deliberately on its own
       # line below: folding it back into this call would make $? head`s status,
       # which is 0 even when gh dies.
       err=$(gh run list --branch <current-branch> --limit 5 \
         --json databaseId,headSha,status \
         --jq ".[] | select(.headSha == \"$SHA\") | .databaseId" 2>&1 >"$TMP")
       # gh spoke = gh failed. An empty result with NO stderr is "not registered
       # yet"; an empty result WITH stderr is a broken gh, and looping on it
       # would burn the whole budget and then escalate the wrong cause.
       [ -n "$err" ] && { echo "$err" >&2; exit 3; }
       NEW_RUN_ID=$(head -1 "$TMP")
       [ -n "$NEW_RUN_ID" ] && { echo "$NEW_RUN_ID"; exit 0; }
       sleep 5
     done'
   ```

   | Exit | Outcome | Next |
   | ---- | ------- | ---- |
   | 0 | `registered` | `NEW_RUN_ID` is on stdout — watch it |
   | 3 | `tooling-failure` | `gh` itself failed. Report **that** and escalate — do not retry, and do not report it as "no run found" |
   | 124 | `no-run-yet` | No run for this SHA after 90 s. Retry the whole block at most twice more, then report and escalate |

   Same **classifier** as [`registration-poll.md`](../create-pr/rules/registration-poll.md#the-poll) — an unrecognised `gh` error is never benign, and empty output alone cannot tell "nothing yet" from "nothing works". **Different outcome set**: this block renders its own 124 as `no-run-yet` because the retry policy lives here, whereas the shared rule keeps its 124 internal. Do not reuse that rule's outcome names.

2. For reference, the unfiltered listing:
   ```bash
   gh run list --branch <current-branch> --limit 5
   ```

3. Watch the run until completion, bounded per attempt:
   ```bash
   # Issue this Bash call with the tool parameter timeout: 600000.
   # The tool default is 120000; a `timeout` larger than the tool cap never
   # fires its own exit 124 — the harness kills the call first and the expiry
   # handling below becomes dead code.
   timeout 540 gh run watch <new-run-id>
   ```
   If `timeout` expires (exit code 124), watch again — **at most 2 attempts per fix-push cycle, and at most 6 across the whole invocation**. Then run `gh run view <new-run-id>` to capture pending jobs, report them, and escalate.

   **Print each attempt** as `ci-watch attempt N/2 (cycle) · M/6 (invocation)` and carry those lines into your report. The invocation cap spans multiple Phase 8 iterations — a longer span than any single reasoning step — so it must be written down at the moment it changes, not remembered.

   **State the scope, because two are in play.** Each Phase 8 iteration pushes a new commit and therefore watches a *new* run — a new wait, not a continuation — so a purely per-invocation cap would starve iterations 2–4 of any watch at all. A purely per-cycle cap of 4 would allow 4 × 4 = 16 watches (≈ 2.4 h). The pair above bounds both: per-cycle so each fix gets a fair look, and an invocation ceiling so the total cannot run away.

   **Your cap is your own.** You watch a run for a commit *you* just pushed, so you never inherit or spend a caller's budget, and you write no shared state. Report your outcome and let the caller act on it.

4. Check the result:
   ```bash
   gh run view <new-run-id>
   ```

##### Phase 8 — Iterate with regression detection

Full decision table: [`rules/regression-detection.md`](./rules/regression-detection.md).

At a glance:

- Same failure → re-classify in Phase 3.
- Strict subset → continue with the remaining failures.
- New failure that did not exist before → **revert the last commit** (`git revert HEAD && git push`) and re-plan or escalate.

Maximum 4 iterations.
After 4, escalate with the structured exit summary.

##### Phase 9 — Report

Always end with a structured summary block, regardless of outcome:

```text
ci-auto-fix run
  Outcome: <green | escalated | regression-reverted | max-iterations>
  Original failure: <workflow / job / step + one-line cause>
  Verdict: <code-bug | workflow-bug | dep-bug | env-bug | flaky | unsure>
  Iterations: <N>/4
  Plan: .agent/{branch}/ci-auto-fix-plan.md
  Successful run: <URL>           # if green
  Escalation reason: <…>           # if not green
```

On success, include the original error, the fix applied, confirmation that all checks pass, and a link to the successful run.

On escalation, include what was tried (one line per iteration), what remains, and suggested next steps for manual investigation.

##### Self-Improvement

`/ci-auto-fix` gets better across runs through a two-tier lessons loop (fast
episodic tier + gated promotion), like `autonomous-workflow` and `fix-bug`. It
**reads** `ci-auto-fix-lessons` at Phase 3 (biasing the verdict and the Phase 8
regression call) and **writes** at Phase 8 (on a revert — the strongest negative
signal) and Phase 9 (on the CI outcome). Lessons are **advisory** — they never
relax the confidence gate, the revert-on-new-failure rule, or any refusal in
[`rules/anti-patterns.md`](./rules/anti-patterns.md).

This loop is deliberately **more conservative** than the others because the
verdict is inferred from CI logs alone: **verdict lessons default to the
`repo::{owner}/{repo}` scope** (repo-specific failure shapes are far more
reliable than cross-repo generalizations) with a **raised promotion bar
(`seen_count >= 5`)**, and **regression lessons are `volatile` with a 30-day
expiry** since error signatures churn. A lesson can never authorize a
check-weakening or soft-refusal action — those still re-gate on this run. Full
contract and the two ci-auto-fix-specific entrenchment guards:
[`rules/self-improvement-loop.md`](./rules/self-improvement-loop.md). LoreKit
(the `lorekit-memory` skill's `memory.*` tools) is optional; the loop is a silent
no-op if not connected.

##### Definition of done

The run is done when ANY of the following is true:

- All checks are green AND the structured exit summary has been printed.
- The verdict was `flaky` or `unsure` and the failure was escalated to the user.
- The confidence gate scored < 80 and the fix was not written.
- A regression was detected and reverted, and the user owns the next step.
- `--max-iterations` (default 4) was reached.


---

### investigate-first
**Description:** Diagnose ambiguous failures before editing. Use for unknown causes, intermittent behavior, performance regressions, or investigations needing evidence-ranked hypotheses.


#### Investigate first

Gather evidence before changing product code.

- Separate observed symptom from inferred cause.
- Trace inputs, state transitions, ownership boundaries, and failure output.
- Rank hypotheses by evidence and cheap falsification value.
- Do not edit until one credible mechanism explains evidence.
- Stop exploration when evidence is sufficient to name cause or exact blocker.

Report cause and proof. Make no fix unless task authorizes implementation.


---

### resolve-conflicts
**Description:** >


#### Resolve Git Conflicts

You are tasked with helping resolve Git merge or rebase conflicts. This command handles both active conflict states and proactive conflict preview/resolution.

##### Step 1: Detect Conflict State

First, determine the current state:

```bash
#### Check if we're in the middle of a merge
git rev-parse --verify MERGE_HEAD 2>/dev/null && echo "MERGE_IN_PROGRESS" || echo "NO_MERGE"

#### Check if we're in the middle of a rebase
test -d "$(git rev-parse --git-dir)/rebase-merge" -o -d "$(git rev-parse --git-dir)/rebase-apply" && echo "REBASE_IN_PROGRESS" || echo "NO_REBASE"

#### Check for unmerged files (active conflicts)
git diff --name-only --diff-filter=U
```

Based on results:
- **Active merge conflict**: MERGE_HEAD exists + unmerged files present
- **Active rebase conflict**: rebase-merge/rebase-apply dir exists + unmerged files present
- **No active conflict**: Can preview differences for potential conflicts

##### Step 2: Gather Context

###### Get Branch Information

```bash
#### Current branch
git branch --show-current

#### Target branch (default: main)
git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main"

#### Fetch latest to ensure accurate comparison
git fetch origin
```

###### If Active Conflict Exists

```bash
#### List all conflicted files AND capture the list now — once files are staged
#### in Step 5, `--diff-filter=U` returns nothing. Step 7's merge commit message
#### reads this file.
git diff --name-only --diff-filter=U | tee /tmp/conflicted.txt

#### Show the conflict markers in each file
git diff --check
```

###### If No Active Conflict (Preview Mode)

```bash
#### Show what would change when merging target into current
git diff origin/main...HEAD --name-status

#### Show detailed diff
git diff origin/main...HEAD --stat

#### Identify files modified in both branches (potential conflicts)
git log origin/main..HEAD --name-only --pretty=format: | sort -u > /tmp/head_files
git log HEAD..origin/main --name-only --pretty=format: | sort -u > /tmp/main_files
comm -12 /tmp/head_files /tmp/main_files
```

##### Step 3: Analyze Each Conflicted File

For each conflicted or potentially conflicting file:

###### 3.1 Show Both Versions

```bash
#### For active conflicts - show the three-way diff
git diff <file>

#### Show "ours" version (current branch)
git show :2:<file>

#### Show "theirs" version (incoming branch)
git show :3:<file>

#### Show common ancestor
git show :1:<file>
```

###### 3.2 Understand the Changes

For each file, analyze:
1. **What "ours" (current branch) changed**: What was the intent of changes on the current branch?
2. **What "theirs" (target branch) changed**: What was the intent of changes from the incoming branch?
3. **Conflict type**:
   - **Overlapping edits**: Same lines modified differently
   - **Adjacent edits**: Close proximity changes
   - **Structural conflicts**: Function/class restructuring
   - **Semantic conflicts**: Logic changes that may conflict conceptually

###### 3.3 Propose Resolution Strategy

For each conflict, suggest one of:

1. **Accept Ours**: Keep current branch changes (theirs were superseded/duplicated)
2. **Accept Theirs**: Accept incoming changes (ours are outdated/wrong)
3. **Merge Both**: Both changes are valid and can coexist
4. **Manual Resolution**: Changes conflict semantically - need human decision

##### Step 4: Ask Clarifying Questions

When intent is ambiguous, ask specific questions:

###### Template Questions

**For overlapping edits:**
> "In `<file>` at line X, both branches modified the same code:
> - Current branch: [summary of change]
> - Incoming branch: [summary of change]
>
> Which behavior should we keep?
> 1. Current branch's approach
> 2. Incoming branch's approach
> 3. Combine both (explain how)
> 4. Need more context to decide"

**For structural conflicts:**
> "The file `<file>` was restructured differently in both branches:
> - Current branch: [describe restructure]
> - Incoming branch: [describe restructure]
>
> This requires manual review. Would you like me to show the full diff?"

**For semantic conflicts:**
> "Both branches changed the logic in `<function>`:
> - Current: [behavior description]
> - Incoming: [behavior description]
>
> These may be incompatible. Which business logic is correct?"

##### Step 5: Apply Resolutions

After understanding all conflicts and getting answers to questions:

###### For Accept Ours
```bash
git checkout --ours <file>
git add <file>
```

###### For Accept Theirs
```bash
git checkout --theirs <file>
git add <file>
```

###### For Merge Both
Edit the file to combine both changes, then:
```bash
git add <file>
```

###### For Manual Edits
After editing:
```bash
#### Verify no conflict markers remain
grep -n "^<<<<<<< " <file> && echo "Still has conflict markers!" || git add <file>
```

##### Step 6: Verify Resolution

After resolving all conflicts:

```bash
#### Check no unmerged files remain
git diff --name-only --diff-filter=U

#### Verify no conflict markers in staged files
git diff --cached | grep -E "^[+](<<<<<<<|=======|>>>>>>>)" && echo "Warning: Conflict markers still present!"

#### Show what will be committed
git diff --cached --stat
```

##### Step 7: Complete the Merge/Rebase

###### For Merge Conflicts
```bash
#### Commit the merge, citing the conflicted-file list captured in Step 2.
#### Do NOT use `git diff --name-only HEAD~1` here — that lists every merged
#### file, not just the files whose conflicts were resolved.
git commit -m "Merge origin/main into $(git branch --show-current)

Resolved conflicts in:
$(cat /tmp/conflicted.txt)"
```

###### For Rebase Conflicts
```bash
#### Continue the rebase
git rebase --continue
```

If more conflicts appear during rebase, repeat from Step 3.

##### Step 8: Summary

After completion, provide:

###### Resolution Summary

| File | Resolution Type | Notes |
|------|-----------------|-------|
| `path/to/file1.ts` | Accept Theirs | Our changes were outdated |
| `path/to/file2.ts` | Merge Both | Combined feature additions |
| `path/to/file3.ts` | Manual | Required semantic understanding |

###### Recommendations

- If many conflicts occurred, consider more frequent rebasing/merging
- If semantic conflicts are common, consider better branch coordination
- Document any non-obvious resolution decisions for PR reviewers

##### Abort Options

If resolution isn't going well:

###### Abort Merge
```bash
git merge --abort
```

###### Abort Rebase
```bash
git rebase --abort
```

##### Tips

- **Always fetch first**: Ensure you have the latest remote state
- **Small conflicts are easier**: Merge frequently to avoid large conflicts
- **Tests after resolution**: Run tests to verify merged code works
- **Commit message clarity**: Document what conflicts were resolved and how
- **When in doubt, ask**: Semantic conflicts often need human judgment


---

### review-changes
**Description:** >


##### Routing

Choose the path based on the argument shape:

| Argument shape | Path | Reason |
| --- | --- | --- |
| no arg / `--report` | `Skill("review-loop", "<pr-url> [--critical\|--no-ci\|--external-review\|--interval S]")` on the current branch's open PR, or `pr-reviewer` directly if `--report` (one-shot, no apply) | Own PR convergence loop, or one-shot report. |
| PR URL or `#<n>` | `Skill("review-loop", "<pr-url> [--critical\|--no-ci\|--external-review\|--interval S]")` — runs the bounded review-apply-simplify loop | Converges the PR regardless of who authored it (`pr-reviewer` detects `REVIEW_RELATION` itself). |

`--no-ci`, `--external-review` and `--interval S` are pass-throughs: this skill never
sets them itself, it only forwards what the user passed (see the note below).

```bash
#### --report routes straight to pr-reviewer, which --external-review exists to avoid.
#### Refuse the pair rather than accepting a flag this path cannot honour, mirroring
#### review-loop's refusal of --no-feedback --external-review.
case "$ARGUMENTS" in
  *--report*) case "$ARGUMENTS" in
    *--external-review*)
      echo "--report needs pr-reviewer; drop --external-review or drop --report."
      exit 1 ;;
  esac ;;
esac

#### Resolve the current branch's PR whenever no PR was named. Test for the ABSENCE of a
#### PR reference, never for an exact flag string: every flag in the table above is
#### combinable, so `= "--report"` left `--external-review`, `--critical`, `--no-ci`, and
#### `--interval S` with no PR to act on.
case "$ARGUMENTS" in
  *github.com/*/pull/*|*\#[0-9]*) ;;                       # a PR was named; use it
  *) CURRENT_PR=$(gh pr view --json url -q .url 2>/dev/null) ;;
esac
```

**`review-changes` passes no `--no-ci`** — unlike `create-pr` and `autonomous-workflow`
Phase 7, it owns no CI phase of its own, so the loop's CI sub-step is exactly what
keeps a standalone run from converging on a **red** build instead of a
green-threads-red-build one. Forward `--no-ci`, `--external-review`, and `--interval`
through when the user passes them.

It converges on *not red*, not on *green*. `review-loop`'s `ci_is_settled()` treats
`pending` as settled — the loop reads check state, never waits for it — so a run can
converge with checks still in flight. Wait for the checks yourself before merging, or
give CI to a caller that owns a watch (`create-pr` Step 9, `phase-7-ci-gate.md`) and
pass `--no-ci` here.

```
#### Default — convergence loop on own or specified PR
Skill("review-loop", "<pr-url-or-number> [--critical|--no-ci|--external-review|--interval S if passed]")

#### Report-only (no apply) — one-shot review.
#### pr-reviewer is an AGENT — dispatch via the Task tool, NOT Skill():
Task(subagent_type="pr-reviewer", prompt="<pr-url-or-number> [--critical if passed]")
```

##### Usage

| Invocation | Effect |
| --- | --- |
| `/review-changes` | Convergence loop on the current branch's open PR — `pr-reviewer` → `implement-suggestion --resolve-all` → `polish simplify` → CI, up to 5 iterations, converging until every review thread is resolved (fix or reply) **and** CI is not red. |
| `/review-changes --no-ci` | Same, minus the CI sub-step. Pass this when something else already owns CI for the PR. |
| `/review-changes --external-review` | Waits for an out-of-process reviewer (another agent, a review bot) instead of dispatching `pr-reviewer`, then applies + resolves + simplifies as usual. Also the path to use where the `Task` tool is unavailable. |
| `/review-changes --report` | One-shot read-only review via `pr-reviewer` (no apply). |
| `/review-changes --report --external-review` | **Refused.** Print `--report needs pr-reviewer; drop --external-review or drop --report.` and exit — the same refusal `review-loop` gives for `--no-feedback --external-review`, and for the same reason: report-only needs a reviewer to report, and `--external-review` removes the only one either path owns. Never silently ignore `--external-review` here. |
| `/review-changes --critical` | Adds adversarial pre-mortem (`Skill("critical", "code")`) to each `pr-reviewer` call. |
| `/review-changes <PR-URL>` | Convergence loop on the specified PR (self or cross — `pr-reviewer` detects relation automatically). |

##### What replaced `--comments`

The old `--comments` flag is gone.
Cross-review with line-level inline comments now lives in the `pr-reviewer` agent and is the default behaviour when a PR is passed.

There is no posting-authorization flag any more. `pr-reviewer` Step 4 posts a single
visible `COMMENT` review to `POST /repos/{owner}/{repo}/pulls/{n}/reviews`
unconditionally, in both relations — the old `--publish` token and the pending-review
workflow it gated are gone. Step 3 still prints the full proposal to the terminal
before Step 4 posts it, so you always see what was sent.


---

### review-loop
**Description:** >


#### review-loop — Bounded Review-Apply-Resolve Convergence

Drive a PR from its initial draft state to a clean, review-ready state by
iterating `pr-reviewer` → `implement-suggestion --resolve-all` → `polish simplify`
until **every review thread is resolved** or the cap is reached, then refresh the
PR description to match the shipped diff.

A thread is resolved when it is **either fixed** (a code change landed) **or
answered** (a reply — the answer to a question, the agent's take on a discussion,
or a rationale for a declined suggestion). The only threads left open at
convergence are genuine **human-judgment flags**: a real potential issue the
agent will neither auto-apply nor honestly decline. That safety valve means the
loop can never green-wash a PR by resolving a live finding — it surfaces it
instead.

This skill is an **orchestrator**.
It contains no quality rules of its own.
It sequences existing pieces, each owning its own domain:

1. `pr-reviewer` — finds issues (read-only; posts one `COMMENT` review; on a re-review resolves its own addressed threads).
2. `implement-suggestion --resolve-all` — applies actionable findings **and** replies-to-and-resolves the non-fix threads it can honestly close (single-shot, no `--watch`).
3. `Skill("polish", "simplify")` — applies Class M mechanical refactors behind a confidence gate.
4. `ci-auto-fix` — diagnoses and fixes a red check after the iteration's push (skipped under `--no-ci`).
5. On convergence — refreshes the PR description (via the shared description-contract) and, best-effort, notes the linked Linear ticket.

Under `--external-review`, step 1 is replaced by a **wait**: the reviewer is
another process (a review bot, a CI-triggered agent, a teammate), and the loop
polls for its output instead of producing its own. Steps 2–5 are unchanged —
they consume threads from GitHub and do not care who wrote them.

###### Dispatch mechanics — read before invoking

`pr-reviewer` is an **agent**, not a skill. Dispatch it with the **Task tool**
(`Task(subagent_type="pr-reviewer", prompt="<PR-URL> [--critical]")`). **Do not** call
`Skill("pr-reviewer", …)` — there is no skill by that name and it errors with
`Unknown skill: pr-reviewer`.

####### Caller contract — run this loop at the top level, never inside a sub-agent

This skill is an orchestrator whose **first sub-step is itself a delegation**. It
must therefore be invoked from a context that still holds the `Task` tool. Most
harnesses give a dispatched sub-agent no `Task` tool at all (Dash0 Agent0
sub-agents cannot delegate further, by platform design), so a caller that
dispatches this loop into a sub-agent spends the run's delegation budget one level
too high and leaves the loop with nothing to dispatch `pr-reviewer` with. The loop
then has exactly one honest outcome: a skip at iteration 0, with the PR unreviewed.

```text
#### WRONG — the loop arrives without Task and can only skip at iteration 0
Task(subagent_type="general", prompt="Run /review-loop <PR-URL>")

#### RIGHT — the caller runs the loop itself and spends Task on the agents it needs
Skill("review-loop", "<PR-URL>")        # → the loop dispatches pr-reviewer via Task
```

A caller that can make **only one** dispatch has two supported shapes, in
preference order:

| Shape | What the caller does | Consequence |
| --- | --- | --- |
| **Own the loop** (preferred) | Run this procedure at the top level and spend the delegation budget on `pr-reviewer` / `implement-suggestion` | The only shape in which the loop can converge a PR |
| **Delegate with `--external-review`** | Dispatch the loop *with `--external-review` passed deliberately by the caller*, never invented by the callee | No `pr-reviewer` pass happens: a fix-and-polish loop over someone else's review |

**One skip is conclusive — never retry the dispatch.** A missing `Task` tool is a
property of the dispatch topology, decided before any code is read; a second
attempt re-derives a platform fact at the cost of a full round trip and cannot
change the outcome.

**When sub-agent dispatch is unavailable.** Some harnesses disable the `Task`
tool, so that dispatch fails outright (`Failed to run agent`). `pr-reviewer` has
**no `Skill()` form and no in-context substitute** — its review independence comes
from running in a fresh, isolated context, so "play the role yourself" would
produce a self-review wearing a reviewer's label, which is worse than no review.

Check for it in [Step 0](#step-0-resolve-the-pr-and-preconditions) and **self-report
a clean skip** rather than letting the caller discover it as a mid-loop tool error:

Two causes produce the same missing tool, and they get **different skip lines**
because they have different fixes. Report the one you can evidence; when you cannot
tell them apart, report the harness line:

| Cause | How you know | Skip line |
| --- | --- | --- |
| **Nested dispatch** (caller error, fixable today) | You are running as a dispatched sub-agent — the caller's prompt dispatched this loop rather than running it | `skipped (nested dispatch — review-loop must run at the top level; the caller consumed the delegation budget)` |
| **Harness disables `Task`** (environment) | This is the top-level session and `Task` is still absent from the tool set | `skipped (sub-agent dispatch unavailable; pr-reviewer requires it)` |

```markdown
- [TIMESTAMP] review-loop — skipped (nested dispatch — review-loop must run at the top level; the caller consumed the delegation budget). Have the caller run the loop itself, or dispatch it with --external-review.
- [TIMESTAMP] review-loop — skipped (sub-agent dispatch unavailable; pr-reviewer requires it)
```

Return that skip as the loop's terminal result. Do **not** retry the dispatch and
do **not** silently continue to sub-steps B and C — without a review pass there are
no findings to apply, and running `polish simplify` alone would misreport an
unreviewed PR as converged.

**`--external-review` is the exception, and the graceful-degradation path.** In
that mode the loop never dispatches `pr-reviewer`, so this precondition does not
apply and **must not** fire: the review comes from another process that has
already written to GitHub. A harness with `Task` disabled can therefore still run
the loop — suggest `--external-review` in the skip line rather than presenting the
skip as the only outcome:

```markdown
- [TIMESTAMP] review-loop — skipped (sub-agent dispatch unavailable; pr-reviewer requires it). Re-run with --external-review if another agent reviews this PR.
```

One caveat to state plainly: sub-step B (`implement-suggestion`) dispatches a
**worker** subagent of its own, which also wants `Task`. Its documented inline
fallback (apply commit-per-comment, push, reply-and-resolve yourself) covers that
case — see the paragraph below. `--external-review` removes the `pr-reviewer`
dependency, not every sub-agent dependency.

The check is best-effort, not certain: there is no capability-introspection API, and
a refused dispatch may surface as an uncatchable harness error. Its value is
**placement** — one clean logged deviation at Step 0 instead of a mid-Phase-6 error
the caller has to interpret.

`implement-suggestion` and `polish` **are** skills — invoke them with `Skill(...)`.
If a given install has `implement-suggestion` set `disable-model-invocation: true`
(so `Skill("implement-suggestion")` is refused), fall back to applying its
contract inline: resolve a worktree at the PR head, apply the findings as
commit-per-comment, push, and reply-to-and-resolve the threads yourself (the
same work the skill's worker does) — never skip sub-step B silently.

##### Modes

Parse the **first positional argument** as the PR reference.
Everything else is a flag.

| Flag | Effect |
| --- | --- |
| `--cap N` | Override the default iteration cap of 5. |
| `--critical` | Pass `--critical` to each `pr-reviewer` call (adversarial pre-mortem). |
| `--no-feedback` | Report-only. Forces `CAP=1` and skips sub-steps B, C, and the final refresh, so `pr-reviewer` runs once and its findings are reported without being applied, resolved, or pushed. |
| `--no-refresh` | Run the convergence loop as normal but skip the final PR-description refresh and Linear note. |
| `--external-review` | Replace sub-step A: wait for an **out-of-process** reviewer instead of dispatching `pr-reviewer`. See [Sub-step A — external-review mode](#sub-step-a--external-review-mode). |
| `--interval S` | Poll interval in seconds for `--external-review`, default `300`, **clamped to `540`**. Ignored without `--external-review`. |
| `--no-ci` | Skip sub-step D (the CI pass). Callers that own their own CI phase pass this — `create-pr` (Steps 7–9) and `autonomous-workflow` (Phase 7) both do. |

**Incompatible combinations**, refused or downgraded at Step 0:

| Combination | Behaviour |
| --- | --- |
| `--external-review` + `--no-feedback` | **Refuse.** `--no-feedback` means "run `pr-reviewer` once and report"; with no `pr-reviewer` there is nothing to report. Print `--no-feedback needs pr-reviewer; drop --external-review or drop --no-feedback.` and exit. |
| `--external-review` + `--critical` | **Warn and ignore.** `--critical` only ever fed `pr-reviewer`. Print one line noting it was ignored, then continue — callers pass it by habit and it must not abort the run. |

##### Procedure

###### Step 0: Resolve the PR and preconditions

```bash
#### Resolve PR number and repo from the argument
#### (mirrors the parsing logic in pr-reviewer Step 0)
if [[ "$ARG" =~ ^https://github\.com/([^/]+/[^/]+)/pull/([0-9]+) ]]; then
  PR_REPO="${BASH_REMATCH[1]}"
  PR_NUMBER="${BASH_REMATCH[2]}"
elif [[ "$ARG" =~ ^#?([0-9]+)$ ]]; then
  PR_REPO=""
  PR_NUMBER="${BASH_REMATCH[1]}"
fi

RESOLVED_REPO=${PR_REPO:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}
OWNER="${RESOLVED_REPO%/*}"
REPO="${RESOLVED_REPO#*/}"
```

If no PR reference is found, abort: `review-loop requires a PR URL or #<n>.`

**Precondition — sub-agent dispatch (best-effort).** The loop's first sub-step dispatches
the `pr-reviewer` agent, which has no non-`Task` substitute (see
[Dispatch mechanics](#dispatch-mechanics--read-before-invoking)). Before entering the
loop, check whether `Task` appears in your available tools; if it plainly does not,
emit the skip line from that section and return, without running sub-steps B or C.
Pick the skip line by cause — **nested dispatch** when you are running as a
dispatched sub-agent, the harness line otherwise — and do **not** retry the
dispatch: one missing-`Task` return is conclusive.

**Skip this precondition entirely when `--external-review` is set** — that mode
dispatches no `pr-reviewer`, so a missing `Task` tool is not disqualifying.

**This check cannot be made certain**, and the contract does not pretend otherwise:
there is no capability-introspection API, and on some harnesses a refused dispatch
surfaces as an uncatchable error rather than a return value. When the check is
inconclusive, attempt the dispatch — and if it fails, emit the same skip line rather
than retrying or working around it. The value is **placement**: one clean logged
deviation instead of a mid-Phase-6 error the caller must interpret.

Parse the flags and set the iteration cap:

```bash
#### Parse flags out of the argument string.
cap_flag=""
CRITICAL=0
NO_FEEDBACK=0
NO_REFRESH=0

#### --cap N: override the default iteration cap (accepts "--cap 5" or "--cap=5").
if [[ " $ARGUMENTS " =~ [[:space:]]--cap[[:space:]=]+([0-9]+) ]]; then
  cap_flag="${BASH_REMATCH[1]}"
fi

#### --critical: pass the adversarial pre-mortem through to each pr-reviewer call.
if [[ " $ARGUMENTS " == *" --critical "* ]]; then
  CRITICAL=1
fi

#### --no-refresh: skip the final PR-description refresh + Linear note.
if [[ " $ARGUMENTS " == *" --no-refresh "* ]]; then
  NO_REFRESH=1
fi

#### --external-review: sub-step A waits for an out-of-process reviewer.
EXTERNAL_REVIEW=0
if [[ " $ARGUMENTS " == *" --external-review "* ]]; then
  EXTERNAL_REVIEW=1
fi

#### --interval S: poll interval for --external-review. Clamp to 540 (below the
#### 600 s Bash tool cap) exactly as watch-mode does; values above are clamped
#### silently.
INTERVAL=300
if [[ " $ARGUMENTS " =~ [[:space:]]--interval[[:space:]=]+([0-9]+) ]]; then
  INTERVAL="${BASH_REMATCH[1]}"
fi
[ "$INTERVAL" -gt 540 ] && INTERVAL=540

#### --no-ci: skip sub-step D. Callers owning their own CI phase pass this.
NO_CI=0
if [[ " $ARGUMENTS " == *" --no-ci "* ]]; then
  NO_CI=1
fi

CAP=${cap_flag:-5}
ITERATION=0

#### --no-feedback degrades the loop to a single read-only review pass.
if [[ " $ARGUMENTS " == *" --no-feedback "* ]]; then
  NO_FEEDBACK=1
  CAP=1
  NO_REFRESH=1
fi

#### Refuse the one combination that cannot mean anything: report-only needs a
#### reviewer to report, and --external-review removes the only one this loop owns.
if [ "$EXTERNAL_REVIEW" -eq 1 ] && [ "$NO_FEEDBACK" -eq 1 ]; then
  echo "--no-feedback needs pr-reviewer; drop --external-review or drop --no-feedback."
  exit 1
fi

#### --critical only ever fed pr-reviewer. Warn, do not abort — callers pass it by habit.
if [ "$EXTERNAL_REVIEW" -eq 1 ] && [ "$CRITICAL" -eq 1 ]; then
  echo "note: --critical ignored under --external-review (it only configures pr-reviewer)."
  CRITICAL=0
fi
```

> **Naming.** `NO_FEEDBACK` here is the **report-only mode flag** (`--no-feedback`).
> The shared review-activity poll emits an outcome string also spelled
> `NO_FEEDBACK`, meaning "no new review activity this interval". They are
> unrelated. Sub-step A below reads the poll's result into `POLL_RESULT`
> (`new` / `quiet` / `error`) and never into this variable.

A helper for the exit check — the count of **unresolved** review threads:

```bash
unresolved_thread_count() {
  gh api graphql -f query='
    query($owner:String!,$repo:String!,$pr:Int!){
      repository(owner:$owner,name:$repo){
        pullRequest(number:$pr){
          reviewThreads(first:100){ nodes{ isResolved } }
        }
      }
    }' -F owner="$OWNER" -F repo="$REPO" -F pr="$PR_NUMBER" \
    --jq '[.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved==false)] | length'
}
```

###### Step 1: Loop — review → apply+resolve → simplify

Each iteration runs up to four sub-steps.
The loop exits when **every review thread is resolved** (`unresolved_thread_count == 0`)
**and CI is settled** (green, pending, or absent — never red), when an iteration makes
**no progress** (the only threads left are ones nothing can resolve — human-judgment
flags), or at the cap.

When `NO_FEEDBACK == 1`, only sub-step A runs: sub-steps B and C are skipped, the
push and the refresh are skipped, and the run reports the findings without applying
anything.

```text
APPLIED_TOTAL = 0
CI_HANDOFFS   = 0
CI_STATE      = "unread"     # no check state observed yet this run
while ITERATION < CAP:
    ITERATION += 1

    # Sub-step A: review — always the first thing each iteration runs, so the
    # loop always ENDS on a review pass that validates the previous iteration's
    # fixes and resolves this agent's now-addressed threads. This is the
    # "last review just resolves comments and makes no changes" convergence pass.
    if EXTERNAL_REVIEW == 0:
        review = Task(subagent_type="pr-reviewer",
                      prompt="<PR-URL>" + (" --critical" if CRITICAL == 1 else ""))
        # pr-reviewer is an AGENT — dispatch via Task, NOT Skill("pr-reviewer").
        # On a re-review it resolves its own addressed threads (thread-resolution.md).
        NEW_FINDINGS = (pr-reviewer reported new actionable findings)
    else:
        POLL_RESULT = shared review-activity poll, bounded by INTERVAL   # new | quiet | error
        if POLL_RESULT == "error":
            abort → stop reason "poll error"      # a broken probe is NEVER "quiet"
        if POLL_RESULT == "quiet" and ITERATION > 1:
            NEW_FINDINGS = false                  # reviewer silent → fall to the exit below
        else:
            NEW_FINDINGS = true                   # iter 1 always runs a pass

    if NO_FEEDBACK == 1:
        break   # report-only: never apply, never resolve, never simplify, never push

    # CLEAN CONVERGENCE EXIT — the only exit that means "done":
    # ci_is_settled() reads check state on demand when CI_STATE is still "unread"
    # (iteration 1 can reach this exit before sub-step D has ever run), so the
    # loop can never converge on a build it has not looked at.
    if NEW_FINDINGS == false AND unresolved_thread_count() == 0 AND ci_is_settled():
        break   # every thread resolved (fix or reply), nothing new to fix, CI not red

    unresolved_before = unresolved_thread_count()

    # Sub-step B: apply findings AND resolve non-fix threads
    Skill("implement-suggestion", "<PR-URL> --resolve-all")
    # If this install has implement-suggestion set disable-model-invocation:true,
    # Skill() is refused — use the inline fallback from "Dispatch mechanics" above
    # (apply commit-per-comment, push, reply-and-resolve yourself). Never skip B.
    # Single-shot apply — no --watch; the loop drives re-review itself.
    # --resolve-all: fixes what it can, and replies-to-and-resolves questions /
    # discussions / declined suggestions; leaves only human-judgment flags open.
    APPLIED_TOTAL += (applies + answers this iteration, from its report)

    # Sub-step C: simplify
    Skill("polish", "simplify")
    # Applies Class M mechanical refactors; never runs the reviewer pass.

    push any local changes:
    git push

    # Sub-step D: CI. Read check state at the CURRENT REMOTE HEAD, then delegate
    # a red mechanical failure to ci-auto-fix. Skipped under --no-ci.
    if NO_CI == 0:
        CI_STATE = read check state (stateless query, no watch)   # green|pending|red|error
        if CI_STATE == "error":
            # Tooling failure, not "no CI" and not a red build. Same verdict as
            # ci_is_settled()'s error arm: never route to ci-auto-fix, never converge.
            break   # stop reason "ci-error"; report the query failure and escalate
        if CI_STATE == "red" and CI_HANDOFFS < 2:
            dispatch ci-auto-fix as a subagent; CI_HANDOFFS += 1
            CI_STATE = "unread"   # the handoff pushed a fix, so the recorded red
                                  # describes a commit that is no longer head.
                                  # ci_is_settled()'s unread arm re-reads it.

    # No-progress guard: nothing was applied or answered AND the open-thread
    # count did not drop → the remaining threads are human-judgment flags the
    # loop cannot resolve. Stop early rather than spinning to the cap. (The clean
    # convergence exit above stays the normal path — it runs one more review pass
    # to validate before declaring done.)
    # CI is deliberately part of "progress": a red-CI iteration that fixed nothing
    # else still made progress if ci-auto-fix pushed, so the loop gets to re-review.
    if this iteration applied 0, answered 0, dispatched no ci-auto-fix,
       and unresolved_thread_count() >= unresolved_before:
        break

if ITERATION == CAP:
    # NO_FEEDBACK == 1 forces CAP=1, so this branch is always taken on a
    # report-only run — which broke out at the top having pushed nothing. There is
    # no head of this loop's making to read CI at, so gate on it as well as NO_CI.
    if CI_STATE == "unread" and NO_CI == 0 and NO_FEEDBACK == 0:
        CI_STATE = read check state   # never report a state you have not read at head
    if unresolved_thread_count() > 0 or CI_STATE == "red":   # CI_STATE stays "unread" under --no-ci
        report: cap reached; surface remaining blockers/flags AND any red check
```

###### Sub-step A — external-review mode

Under `--external-review` the loop produces no review of its own. It waits for one.

Run the shared [review-activity poll](../../../agents/shared/rules/review-activity-poll.md#the-poll)
with `SINCE` = the current baseline and `INTERVAL` as parsed at Step 0. That file
owns the procedure — call it, never restate it. Issue its Bash call with the tool
parameter `timeout: 600000`; the `--interval` clamp to 540 at Step 0 is what keeps
the loop's own bound reachable underneath it.

Map its [caller-neutral outcomes](../../../agents/shared/rules/review-activity-poll.md#outcomes-caller-neutral)
into `POLL_RESULT`:

| Poll outcome | `POLL_RESULT` | This loop does |
| --- | --- | --- |
| `NEW_FEEDBACK` | `new` | Run the iteration (sub-steps B, C, D) |
| `NO_FEEDBACK` | `quiet` | **Iteration 1:** run a pass anyway — the external reviewer may have reviewed before the loop started, and exiting here would converge a PR having done nothing. **Later iterations:** the reviewer is quiet; fall through to the convergence exit |
| `POLL_ERROR` | `error` | **Abort** with stop reason `poll error`. Report the stderr. A broken probe is never "the reviewer had nothing to say" — treating it as quiet would report a never-reviewed PR as converged |

**Advance the baseline after every pass**, exactly as the shared rule requires: set
`SINCE` to "now" once sub-steps B–D complete, so the next wait sees only what the
reviewer posted in response to the latest push. Leaving `SINCE` at its original
value re-reports the same review forever and the loop never reaches `quiet`.

What this mode does **not** change: sub-steps B, C, and D are byte-identical. They
read threads from GitHub and neither know nor care which process authored them.
`unresolved_thread_count()` is the same query, and the no-green-wash safety valve
is untouched — a live finding the agent cannot fix or honestly decline still stays
open, whoever raised it.

There is **no verdict** in this mode. `pr-reviewer`'s `PASS`/`FAIL` has no source
here, so the report prints `n/a (external review)` rather than inventing one.

###### Sub-step D — CI

Skipped entirely when `--no-ci` is set.

After the iteration's push, read the check state **once** — stateless, at the
current remote head, no watch:

```bash
gh pr checks "$PR_NUMBER" --repo "$RESOLVED_REPO"
```

This is a **query, not a watch**: it adds no `gh … --watch` site and spends nothing
from the watch budgets that
[`create-pr` Step 9](../../delivery/create-pr/SKILL.md) and
[`phase-7-ci-gate.md`](../../workflow/autonomous-workflow/rules/phase-7-ci-gate.md)
each count inside their own invocation. `ci-auto-fix` likewise keeps its own local
counter, so delegating to it stays inside the existing contract — no budget is
shared, and none is carried across contexts.

Classify with the same three-way rule as `phase-7-ci-gate.md` Step 1 — **"no checks
reported" is three different states**, and a bare `gh pr checks` **exits non-zero
while merely pending**, printing to stdout, so non-zero with empty stderr means
"registered and running", not an error:

| Check state | `CI_STATE` | This loop does |
| --- | --- | --- |
| All terminal and passing | `green` | Nothing. Convergence may proceed |
| Any still pending | `pending` | Nothing this iteration — do **not** wait. A *continuing* loop re-reads it next iteration; a loop that exits here does not, so `pending` can be the state it converges on |
| Any check failing | `red` | Dispatch `ci-auto-fix` as a subagent (its output is loud and belongs out of this context), unless `CI_HANDOFFS` is already 2 |
| Query errored (exit 127, or stderr naming auth / network / rate limit / not-logged-in) | `error` | **Tooling failure, not "no CI".** Report and escalate. Never route to `ci-auto-fix` |
| Nothing reported, query succeeded, and this iteration just pushed | — | Not registered yet. Run the shared [registration poll](../../delivery/create-pr/rules/registration-poll.md#the-poll) and re-classify from its outcome; `no-ci` means this repo genuinely has no CI, and counts as `green` for convergence |

```text
ci_is_settled():   # the convergence predicate
    NO_CI == 1                      → true    # caller owns CI; not this loop's call
    CI_STATE == "unread"            → read check state now, then re-evaluate
    CI_STATE == "green"             → true
    CI_STATE == "pending", 1st time → re-read at head once, then re-evaluate
    CI_STATE == "pending", re-read  → true    # not red, and this loop never waits for CI
    CI_STATE == red                 → false
    CI_STATE == error               → abort, do not converge
```

The `"pending"` re-read is the same rule
[`watch-mode.md`](../../workflow/implement-suggestion/rules/watch-mode.md#ci-state-is-a-stop-reason-not-a-fix)
applies before its own stop, and it exists for the same reason: sub-step D reads seconds
after its own push, so `pending` is its usual answer, and converging on the first one means
converging on a build no check has finished. Exactly **one** re-read, and only at this
predicate — re-reading until a check is terminal would turn a loop that must never wait for
CI into a busy-wait on it.

The `"unread"` arm matters: iteration 1 can reach the convergence exit before
sub-step D has run even once (a PR that arrives already reviewed and thread-clean).
Without that arm the loop would report convergence having never looked at CI —
the precise failure this sub-step exists to prevent.

It is also the arm that keeps a `red` from going stale. A `ci-auto-fix` handoff
pushes a fix, so the `red` sub-step D just recorded describes a commit that is no
longer head; the handoff therefore resets `CI_STATE` to `"unread"`, and the next
`ci_is_settled()` re-reads instead of blocking convergence on a build that is
already fixed. The cap check does the same read for the same reason — the loop
never reports a CI state it has not read at the current head.

**Cap: 2 `ci-auto-fix` handoffs per `review-loop` run** (`CI_HANDOFFS`), matching the
per-PR cap the other two orchestrators use. Each handoff already burns a full internal
retry budget; do not wrap it in another loop. At the cap with CI still red, stop and
surface the failing checks — never extend it, and never converge a red PR silently.

**This loop never fixes CI itself.** It classifies and delegates. Every refusal in
[`ci-auto-fix`'s anti-patterns](../../delivery/ci-auto-fix/rules/anti-patterns.md)
holds transitively: no `--no-verify`, no `continue-on-error`, no skipped suites, no
weakened assertions to reach green.

**Hard rule: the only permitted `polish` invocation is `Skill("polish", "simplify")`.**
The `simplify` mode applies Class M mechanical refactors and dispatches no pr-reviewer.
All other `polish` modes trigger an internal agent pass, which would create a dispatch cycle.
This is the anti-circularity guarantee.

###### Step 2: Refresh the PR description and Linear note (on convergence)

Skip this step entirely when `NO_REFRESH == 1`, when `NO_FEEDBACK == 1`, or when
`APPLIED_TOTAL == 0` (the loop changed no code, so the description cannot have drifted).

Otherwise, refresh the PR body so it matches the diff that actually shipped after
the loop's fixes:

1. Regenerate the title and body following the shared
   [`description-contract.md`](../../delivery/create-pr/rules/description-contract.md)
   — the same contract `create-pr` uses, so the refresh keeps identical quality and
   length rules. Diff against the PR base and read the current body first; make it a
   minimal edit, not a rewrite.
2. Apply it:

   ```bash
   gh pr edit "$PR_NUMBER" --repo "$RESOLVED_REPO" --body "$(cat <<'EOF'
   <refreshed narrative body>
   EOF
   )"
   ```

Then, **best-effort**, note the linked Linear ticket (skip silently if any part is absent):

- Detect a ticket from the branch name (`.../ABC-123-...`), the PR title/body, or `gh pr view`.
- If a ticket id is found **and** the Linear MCP tools are connected, post a short comment on the ticket linking the PR and stating that review converged (e.g. `Review loop converged — PR <url> ready for review.`).
- Any failure here (no ticket, no MCP, API error) is logged and never fails the loop.

###### Step 3: Report

After the loop exits (converged, no-progress, or at cap), emit a compact summary:

```text
review-loop on PR #<n> (<RESOLVED_REPO>)

Iterations: <N> of <CAP>
Stop reason: <all-threads-resolved | no-progress (flags remain) | cap-reached | ci-red (cap on ci-auto-fix handoffs) | ci-error (check query failed) | poll error | report-only (--no-feedback) | skipped (sub-agent dispatch unavailable) | skipped (nested dispatch — must run at top level)>
#### The two skipped tokens are distinct on purpose. A nested dispatch is a caller
#### bug with a same-day fix; a disabled Task tool is the environment. Never report a
#### skip as "report-only" because it is the nearest token — report-only means a
#### review pass ran and its findings were not applied, which is the opposite of a
#### PR that was never reviewed.
Review source: <pr-reviewer | external>
#### No count on the external arm: the shared poll is a liveness probe and returns only
#### NEW_FEEDBACK / NO_FEEDBACK / POLL_ERROR. It exposes no event count, and widening a
#### shared contract with two callers for a report cosmetic is not worth it.

Per-iteration summary:
  Iteration 1: <verdict>, <N findings>, <M applied>, <A answered/resolved>, <K simplify recipes>, <U threads still open>
  Iteration 2: ...

Open threads at exit: <count>
  - <one line per still-open human-judgment flag / unresolved blocker>

CI at exit: <green | pending | red (<failing check names>) | error (<verbatim query failure>) | not run (--no-ci) | none on this repo>
  ci-auto-fix handoffs: <CI_HANDOFFS> of 2

PR description: <refreshed | unchanged (no code applied) | skipped (--no-refresh)>
Linear note: <posted <ticket> | no ticket linked | Linear MCP unavailable | skipped>

Final pr-reviewer verdict: <PASS | FAIL | n/a (external review)>
Head commit: <sha>
```

Surface remaining open threads prominently if the cap was reached or the
no-progress guard tripped. Do not silently drop them — an open thread at exit is
a human-judgment flag the user must resolve.

**A red check at exit gets the same treatment.** Name the failing checks and say
the loop stopped with CI red. Never describe such a run as converged — zero open
threads over a red build is not a review-ready PR.

##### Hard rules

- **The only permitted `polish` invocation is `Skill("polish", "simplify")`.** Non-simplify modes trigger an internal agent pass and create a dispatch cycle.
- **This loop runs at the top level, never inside a sub-agent.** Its first sub-step is a delegation, so a caller that dispatches the loop instead of running it spends the delegation budget one level too high and the loop can only skip at iteration 0 ([Caller contract](#caller-contract--run-this-loop-at-the-top-level-never-inside-a-sub-agent)). A caller limited to one dispatch passes `--external-review` **deliberately** — the loop never adds that flag to itself.
- **One missing-`Task` skip is terminal.** Never retry the dispatch and never work around it: the tool's absence is fixed by the dispatch topology before any code is read, so a retry costs a round trip and returns the same answer.
- **A skip is never reported as convergence, and never as report-only.** Zero open threads plus green CI is not convergence when no review pass produced a verdict; say plainly that the loop did not run and the PR was not reviewed.
- **Convergence never green-washes.** The loop resolves a thread only via a fix or an honest reply. A live finding the agent cannot fix or honestly decline stays open and is surfaced — the loop never resolves it to terminate. This is `implement-suggestion --resolve-all`'s safety valve, inherited here.
- **Never write to GitHub directly, except the Step 2 description refresh.** `pr-reviewer` posts the `COMMENT` review and `implement-suggestion` resolves threads; this skill orchestrates. The one direct write it owns is the final `gh pr edit --body` refresh.
- **Never undraft the PR.** This skill converges; the user makes the final undraft decision.
- **One `implement-suggestion` per iteration, no `--watch`.** The loop drives re-review; `--watch` waits for external bots and would conflict.
- **Cap is a hard limit.** If threads are still open at the cap, surface them and stop. Do not extend the cap silently.
- **Convergence requires CI settled, not just threads resolved.** Unless `--no-ci` is set, a red check blocks the clean-convergence exit. Reporting zero open threads over a red build is the CI-shaped version of green-washing.
- **Never fix CI in this context.** Sub-step D classifies and delegates to `ci-auto-fix`; it applies no fix itself, and every `ci-auto-fix` refusal (no `--no-verify`, no `continue-on-error`, no skipped suites, no weakened assertions) holds transitively.
- **Never carry CI watch state — query it.** Sub-step D reads check state statelessly at the current remote head and writes nothing; it never records a verdict or a spent budget for another phase to inherit, and it never reintroduces a cross-phase watch-state file ([`diagnostic-surface.md`](../../workflow/autonomous-workflow/rules/diagnostic-surface.md) — *watch state is queried, never carried*). `CI_HANDOFFS` is counted inside this run only.
- **A failed poll is never a quiet reviewer.** Under `--external-review`, `POLL_ERROR` aborts with `poll error`. Converting a broken probe into "the reviewer had nothing to say" reports a never-reviewed PR as converged.
- **Never restate the shared poll.** `--external-review` calls [`review-activity-poll.md`](../../../agents/shared/rules/review-activity-poll.md); copying the block forks four correctness properties that are individually easy to drop.

##### Relationship to other skills

| Skill | Relationship |
| --- | --- |
| `pr-reviewer` | Sub-step A: the find pass (read-only); resolves its own addressed threads on re-review; this skill drives re-review between iterations. |
| `implement-suggestion --resolve-all` | Sub-step B: the apply + resolve pass; invoked single-shot (no `--watch`) with `--resolve-all` so non-fix threads (questions, discussions, declines) are answered and resolved. |
| `polish simplify` | Sub-step C: the cleanup pass; only the simplify mode, never full `polish`. |
| `create-pr` description-contract | Step 2 reuses [`description-contract.md`](../../delivery/create-pr/rules/description-contract.md) for the PR-description refresh — single source of truth with `create-pr`. |
| `polish` (bare) | **Downstream, not a caller.** `polish`'s Pass A invokes `pr-reviewer` directly and never calls `review-loop`; this loop only invokes `Skill("polish", "simplify")`. |
| `create-pr` | Upstream caller — delegates post-draft review to `review-loop` after opening the draft PR. |
| `autonomous-workflow` Phase 6/7 | Invokes `review-loop` in place of the retired `reviewer` agent dispatches. |
| `review-changes` | Routes to `review-loop` as the primary convergence entry point. |
| `ci-auto-fix` | Sub-step D: dispatched as a subagent on a red check, capped at 2 handoffs per run. Owns the fix; this loop only classifies and delegates. Skipped under `--no-ci`. |
| `review-activity-poll` | Shared rule owning the `--external-review` wait — [`agents/shared/rules/review-activity-poll.md`](../../../agents/shared/rules/review-activity-poll.md), co-owned with `implement-suggestion --watch`. |
| `implement-suggestion --watch` | **Sibling, never nested.** Both wait on an out-of-process reviewer via the shared poll; `--watch` is the thin one (apply + push + stop, and it reads CI only as a stop reason). This loop adds `--resolve-all`, simplify, CI delegation, and the description refresh. The hard rule *one `implement-suggestion` per iteration, no `--watch`* keeps them from stacking. |


---

### safe-refactor
**Description:** Restructure code while preserving behavior. Use for extraction, consolidation, ownership moves, or cleanup where verification must bracket structural edits.


#### Safe refactor

Define behavior-preservation boundary and establish verification before structural edits.

- Keep feature changes outside refactor.
- Move one ownership boundary at a time.
- Preserve public interfaces, failure behavior, ordering, and compatibility unless explicitly scoped.
- Keep intermediate states buildable and testable.
- Avoid dependency or configuration growth without correctness need.

Run same proof after change. Stop when behavior matches and requested structure is achieved.


---

### surgical-patch
**Description:** Fix bugs and small behavior changes at the narrowest responsible layer. Use when regression proof, preserved surrounding behavior, and task-relevant tests matter.


#### Surgical patch

Reproduce failure first when economical; otherwise capture strongest available evidence.

- Trace symptom to responsible mechanism.
- Change narrowest layer that owns incorrect behavior.
- Preserve unrelated behavior and user changes.
- Avoid cleanup, renaming, and abstraction outside fix.
- Add only regression proof relevant to task.

Run focused proof plus nearest affected gate. Stop when failure is fixed and regression proof passes.


---

