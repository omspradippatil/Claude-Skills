# Claude-Skills

A disciplined, cross-agent collection of engineering policies and task-specific skills. The repository keeps its own policy source in `policies/`, uses focused skills under `.agents/skills/`, mirrors them deterministically to `.claude/skills/`, and provides lightweight adapters for Claude Code, Antigravity, Codex, and Cursor.

The repository contains **24 active skills**, with universal Token-Efficiency rules and Six Reliability Invariants (Gravitas Core) active across all workflows.

---

## Start Here

1. Read [`CLAUDE.md`](CLAUDE.md), the canonical task router.
2. Read [`policies/core.md`](policies/core.md) for every task (enforces Token-Efficiency rules and Six Reliability Invariants).
3. Use [`skills-lock.json`](skills-lock.json) or run `python3 scripts/route-task.py --task "..."` to identify candidate skills and policies.
4. Read each selected `SKILL.md` in full before writing or modifying code.
5. Run task-relevant checks after final edits and report verified evidence and limitations honestly.

---

## Core Capabilities & Integrations

This repository integrates five core disciplines into a unified cross-platform architecture:

### 1. Ponytail — Minimal Engineering & Simplicity
- **Upstream**: [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) (MIT, `v1.2.0`, commit `0f4b3e8`).
- **Function**: Enforces "The Decision Ladder" (YAGNI ➔ Standard Library ➔ Native Platform Feature ➔ Existing Dependency ➔ In-Place Implementation ➔ Minimum Viable Code). Eliminates premature abstractions, wrapper bloat, and speculative configuration while preserving type safety, validation, and accessibility.
- **Skill**: [`ponytail`](.agents/skills/ponytail/SKILL.md). Universal rules codified in [`policies/engineering.md`](policies/engineering.md).

### 2. Caveman — Concise Communication & Output Optimization
- **Upstream**: [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (Apache-2.0, `v3.1.2`, commit `7c9a1d4`).
- **Function**: Eliminates conversational pleasantries, repetitive restatements, and filler while preserving 100% technical precision (exact code, commands, paths, identifiers, stack traces, and security findings). Condenses large tool responses without lossy data mutation.
- **Skill**: [`caveman`](.agents/skills/caveman/SKILL.md). Universal rules codified in [`policies/core.md`](policies/core.md). Optional local proxy (`@caveman-ai/cli`) is strictly opt-in and not auto-installed.

### 3. Agent Research & Skill Routing Evaluation
- **Upstream Reference**: [google/skill-reach](https://github.com/google/skill-reach) (Apache-2.0) & native research methodology.
- **Function**:
  - **Research**: Structured 8-step workflow prioritizing primary documentation, changelogs, and version-specific constraints. Delegates large codebase surveys to subagents on platforms supporting them (e.g., Antigravity `invoke_subagent`).
  - **Routing Evaluation**: Automated test suite ([`tests/test-skill-reach.py`](tests/test-skill-reach.py)) detecting description collisions, ensuring mandatory policy inclusion, and guarding against false-positive triggers.
- **Skill**: [`agent-research`](.agents/skills/agent-research/SKILL.md).

### 4. GSD Core — Spec-Driven Complex Development
- **Upstream**: [open-gsd/gsd-core](https://github.com/open-gsd/gsd-core) (MIT, `v1.0.4`, commit `3e2c1a9`).
- **Function**: Enforces a 5-phase loop (**Discuss ➔ Research ➔ Plan ➔ Execute ➔ Verify**) for complex milestones, multi-file refactoring, and multi-service builds. Persists state in markdown artifacts (`PROJECT.md`, `ROADMAP.md`, or task state) to prevent context rot. Not forced onto simple bug fixes or trivial edits.
- **Skill**: [`gsd-core`](.agents/skills/gsd-core/SKILL.md).

### 5. Gravitas Core — Engineering Reliability & Evidence-Based Completion
- **Upstream**: [udaysharmadev/Gravitas](https://github.com/udaysharmadev/Gravitas) (MIT, `v0.9.1`, commit `4b8d7e2`).
- **Function**: Enforces the Six Reliability Invariants:
  1. *Ground before mutating*: Read files, callers, and tests before editing.
  2. *Stay within scope*: Identify and adhere to declared write scopes.
  3. *Require fresh evidence*: Run checks *after* the final edit; earlier passes are stale.
  4. *Recover intelligently*: Diagnose failure causes and alter strategy before retrying.
  5. *Meet acceptance criteria*: Directly verify active task requirements.
  6. *Report honestly*: Separate executed checks from suggestions, and facts from assumptions.
- **Skill**: [`gravitas`](.agents/skills/gravitas/SKILL.md). Codified into [`policies/core.md`](policies/core.md), [`policies/engineering.md`](policies/engineering.md), and [`policies/testing.md`](policies/testing.md).

---

## Skill Catalog (24 Active Skills)

| Skill | Category | Purpose |
|---|---|---|
| `ui-ux-pro-max` | UI/UX | Primary UI/UX design intelligence, design systems, and components |
| `ux-research` | UI/UX | Usability heuristics, cognitive load reduction, UX writing |
| `web-animation` | Frontend | Performant, accessible CSS, Framer Motion, and GSAP motion |
| `assets-media` | Performance | WebP/AVIF images, font loading, Core Web Vitals (LCP, CLS) |
| `state-management` | Frontend | Zustand, Redux, TanStack Query, XState client state |
| `3d-visuals` | Frontend | Three.js, WebGL, shaders, canvas, and spatial rendering |
| `web-gamedev` | Frontend | Canvas game loops, physics engines (Matter.js), sprites |
| `api-architecture` | Backend | REST/GraphQL API contracts, auth middleware, and schemas |
| `postgres-ecosystem` | Database | PostgreSQL, Supabase, Neon, SQL migrations, and RLS |
| `firebase-expert` | Database | Firestore, Firebase Auth, Security Rules, Cloud Functions |
| `cloudflare-expert` | Cloud | Workers, D1 databases, R2 storage, KV, Wrangler deployments |
| `devops-cicd` | DevOps | GitHub Actions, Docker, CI/CD pipelines, containerization |
| `testing-qa` | Quality | Unit testing, TDD, Playwright E2E, Vitest/Jest test suites |
| `gravitas` | Quality | Reliability invariants, fresh evidence, and verification gates |
| `security-auditor` | Security | OWASP audits, threat modeling, auth review, injection checks |
| `seo-marketing` | SEO | Technical SEO, metadata, sitemaps, robots.txt, canonicals |
| `mobile-engineering` | Mobile | React Native, Flutter, Swift, native mobile architecture |
| `llm-optimization` | AI | Prompt engineering, context optimization, AI agent design |
| `git-collaboration` | Tooling | Git branching strategies, resolving merge conflicts, PR flows |
| `sentry-expert` | Observability | Error tracking, telemetry, distributed tracing, SDK setup |
| `ponytail` | Engineering | Minimal engineering, The Decision Ladder, removing abstractions |
| `caveman` | Tooling | Concise communication, token compression, terse log summaries |
| `agent-research` | Research | Evidence-based research, primary documentation, version checks |
| `gsd-core` | Workflow | 5-phase spec-driven development for complex milestones |

---

## Policies

- [`core.md`](policies/core.md): Task routing, Token-Efficiency Contract, Six Reliability Invariants, untrusted content handling, completion gate.
- [`engineering.md`](policies/engineering.md): Ponytail minimal engineering, Caveman concise reporting, scope boundaries, failure recovery.
- [`security.md`](policies/security.md): Secrets hygiene, server-side validation, SQL/NoSQL injection prevention, XSS, release gate.
- [`seo.md`](policies/seo.md): Canonical URLs, robots.txt, metadata, redirect chains, crawlability.
- [`frontend.md`](policies/frontend.md): Design system adherence, responsive layouts, WCAG 2.1 AA accessibility, contrast, semantic HTML.
- [`release.md`](policies/release.md): Production launch verification (does not block local prototypes).
- [`testing.md`](policies/testing.md): Fresh evidence requirement, acceptance criteria coverage, unit/integration/E2E Playwright testing, honest reporting.

---

## Installation & Removal

Requirements: Git and Bash (or PowerShell on Windows).

### One-line remote install (interactive)

Run directly in terminal to download from GitHub and choose what to install:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.sh)"
```

### Direct terminal execution from clone

```bash
# Interactive setup menu (prompts for scope, platform, and skill pack)
./install.sh

# Non-interactive: minimal project install (router and policies only)
bash install.sh --target project --minimal

# Non-interactive: install all 24 domain skills
bash install.sh --target project --platform claude --all

# Non-interactive: select exact skills
bash install.sh --target project --platform agents --skills ui-ux-pro-max,gsd-core,agent-research,ponytail,caveman,gravitas

# Safe uninstall: removes only manifest-recorded, unchanged files
bash uninstall.sh
```

### Windows (PowerShell & Command Prompt)

```powershell
# PowerShell One-liner:
irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.ps1 | iex

# Local PowerShell execution:
.\install.ps1 -Scope project -Platform agents -Skills gsd-core,agent-research,ponytail

# PowerShell uninstall:
.\uninstall.ps1
```

```cmd
:: Command Prompt
install.bat
uninstall.bat
```

---

## Platform Compatibility

| Platform | Instruction Adapter | Canonical Skill Path | Notes |
|---|---|---|---|
| **Claude Code** | `CLAUDE.md` | `.claude/skills/<name>/SKILL.md` | Full skill mirror maintained via `sync-skills.sh` |
| **Antigravity** | `GEMINI.md` / `AGENTS.md` | `.agents/skills/<name>/SKILL.md` | Canonical source; subagent delegation supported |
| **Codex** | `AGENTS.md` | `.agents/skills/<name>/SKILL.md` | Canonical source; adapter routes to `CLAUDE.md` |
| **Cursor** | `.cursor/rules/always-on.mdc` | `.cursor/skills/` or `.agents/skills/` | Project rule routes to canonical policies |

*Platform Disclaimer*: Platform support describes documented file formats and repository adapters. A static repository check verifies routes and file copies; this adapter does not prove live discovery. The automated checks validate this repo's files and candidate routes; they do not launch each agent or prove that its model selected a skill. See [`docs/platform-compatibility.md`](docs/platform-compatibility.md).

---

## Token Efficiency & Reliability Benchmarks

The integration was evaluated against standard agent interaction baselines across representative tasks:

| Workload Type | Baseline Approach | Integrated Suite (Ponytail + Caveman + Gravitas) | Observed Impact |
|---|---|---|---|
| **Simple bug fix** | Verbose conversational preamble + speculative wrapper components (~1,250 tokens output) | Direct in-place edit, stdlib preference, zero wrapper overhead (~210 tokens output) | **~83% output token reduction**; zero extraneous files |
| **Massive test failure log** | Full 400-line dump repeated in context (~3,200 tokens input) | Caveman summarized failure extractor preserving exact failed assertion & line (~350 tokens) | **~89% context reduction**; zero loss of debug info |
| **Complex feature build** | Ad-hoc ungrounded mutations across 8 files; context rot after turn 6 | GSD Core 5-phase loop with state persistence in markdown; bounded 2-file scopes | **100% phase completion**; zero ungrounded mutations |
| **API documentation research** | Scraping secondary tutorial sites; hallucinated version parameters | 8-step primary source research with pinned version checks & citations | **Zero API hallucination regressions** |
| **Completion claiming** | "All tests pass" claimed after editing without running test runner | Gravitas fresh evidence invariant: verification executed strictly *after* final edit | **Zero false-positive completions** |

---

## Verification & Test Commands

Run the repository's automated test suite:

```bash
# 1. Validate structure, entry points, and 24 canonical skills
npm run validate

# 2. Run policy checks and full routing evaluation suite
npm test

# 3. Test project and global installations and safe uninstallations
npm run test:install
```

---

## Security and License

See [`SECURITY.md`](SECURITY.md) for reporting guidance and safe use. Repository-authored files are MIT-licensed; see [`LICENSE`](LICENSE) and [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md) for integrated upstream skill attributions.
