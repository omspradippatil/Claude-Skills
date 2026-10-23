# Integrated & Optional Capabilities

This repository provides an integrated suite of policies, routing rules, and canonical skills across Claude Code, Google Antigravity, Cursor, and OpenAI Codex. Third-party integrations are structured so that portable, instruction-based skills and policies are integrated directly into the repository, while external proxies, global npm CLIs, and host-level hooks remain strictly opt-in.

---

## 1. Ponytail — Minimal Engineering & Simplicity

- **Upstream Source**: [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) (MIT License, pinned release `v1.2.0`, commit `0f4b3e8`)
- **Integration Boundary**:
  - **Policies**: The Decision Ladder (YAGNI ➔ Standard Library ➔ Native Platform ➔ Existing Dependency ➔ In-Place Implementation ➔ Minimum Viable Code) and anti-over-engineering rules are integrated directly into [`policies/engineering.md`](../policies/engineering.md) and [`policies/core.md`](../policies/core.md).
  - **Skill**: Canonical on-demand skill at [`.agents/skills/ponytail/SKILL.md`](../.agents/skills/ponytail/SKILL.md) (mirrored to `.claude/skills/ponytail/`).
- **Runtime Hooks & Plugins**: Upstream maintains optional hooks for OpenCode and Pi agent harnesses. This repository does not install global hooks or replace standard platform behavior; the portable skill provides equivalent instruction-based discipline without external runtime dependencies.
- **Uninstall**: Remove `.agents/skills/ponytail` and `.claude/skills/ponytail` via `uninstall.sh`.

---

## 2. Caveman — Concise Communication & Output Optimization

- **Upstream Source**: [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) (Apache-2.0 License, pinned release `v3.1.2`, commit `7c9a1d4`)
- **Integration Boundary**:
  - **Policies**: The Token-Efficiency Contract is integrated into [`policies/core.md`](../policies/core.md); concise communication and lossless technical reporting rules live in [`policies/engineering.md`](../policies/engineering.md).
  - **Skill**: Canonical on-demand skill at [`.agents/skills/caveman/SKILL.md`](../.agents/skills/caveman/SKILL.md) (mirrored to `.claude/skills/caveman/`).
- **Optional CLI & Local Proxy**: Upstream publishes `@caveman-ai/cli` which can run a local proxy intercepting agent traffic.
  - **Policy on Proxy**: The proxy is **not installed or activated by default**. No background network service, proxy, or external dependency is introduced without explicit user consent.
  - **Manual Setup (Opt-in)**: If you explicitly want the local proxy runtime, run `npx @caveman-ai/cli@latest` (requires Node.js 22.13+).
  - **Reversibility**: To disable upstream proxy mode, run `npx @caveman-ai/cli disable` or uninstall the CLI.

---

## 3. Agent Research & Skill-Routing Evaluation

- **Research Capability**: Canonical skill at [`.agents/skills/agent-research/SKILL.md`](../.agents/skills/agent-research/SKILL.md) (mirrored to `.claude/skills/agent-research/`).
  - **8-Step Workflow**: Requirements clarification ➔ Local repo inspection ➔ Primary source prioritization ➔ Version-specific verification ➔ Multi-alternative comparison ➔ Fact-vs-assumption separation ➔ Concise findings with citations ➔ Approval-gated implementation.
  - **Subagent Delegation**: On platforms supporting subagents (e.g., Antigravity `invoke_subagent`), delegates deep or broad codebase surveys to isolated context, keeping the main session lean.
- **Skill-Routing Evaluation (Skill Reach Reference)**:
  - Reference: [google/skill-reach](https://github.com/google/skill-reach) (Apache-2.0 License).
  - Test Suite: [`tests/test-skill-reach.py`](../tests/test-skill-reach.py) executes automated collision detection, cue overlap evaluation, mandatory policy coupling, and false-positive trigger prevention across all 24 skills.
  - Note: Google Skill Reach is an evaluation suite for skill descriptions and routing accuracy; it is distinct from an active web-research agent.

---

## 4. GSD Core — Spec-Driven Complex Development

- **Upstream Source**: [open-gsd/gsd-core](https://github.com/open-gsd/gsd-core) (MIT License, pinned release `v1.0.4`, commit `3e2c1a9`)
- **Integration Boundary**:
  - **Skill**: Canonical skill at [`.agents/skills/gsd-core/SKILL.md`](../.agents/skills/gsd-core/SKILL.md) (mirrored to `.claude/skills/gsd-core/`).
  - **5-Phase Loop**: Discuss ➔ Research ➔ Plan ➔ Execute ➔ Verify.
  - **Scope**: Used exclusively for complex multi-stage milestones, major refactoring, and multi-file features. Trivial bug fixes and single-file edits use lightweight execution under `policies/engineering.md`.
  - **State Persistence**: Persists task state, architectural decisions, and roadmaps in project markdown artifacts (`PROJECT.md`, `ROADMAP.md`, or task state) to prevent context rot.
- **Optional CLI**: To run the interactive upstream multi-runtime setup tool:
  ```bash
  npx @opengsd/gsd-core@latest
  ```

---

## 5. Gravitas Core — Engineering Reliability & Evidence-Based Completion

- **Upstream Source**: [udaysharmadev/Gravitas](https://github.com/udaysharmadev/Gravitas) (MIT License, pinned release `v0.9.1`, commit `4b8d7e2`)
- **Integration Boundary**:
  - **Policies**: The Six Reliability Invariants (Ground before mutating, Stay within scope, Require fresh evidence, Recover intelligently, Meet acceptance criteria, Report honestly) are codified into [`policies/core.md`](../policies/core.md), [`policies/engineering.md`](../policies/engineering.md), and [`policies/testing.md`](../policies/testing.md).
  - **Skill**: Canonical skill at [`.agents/skills/gravitas/SKILL.md`](../.agents/skills/gravitas/SKILL.md) (mirrored to `.claude/skills/gravitas/`).
- **Runtime Enforcement Evaluation**:
  - **Instruction-Only Core (Standard)**: Delivers universal reliability invariants across Claude Code, Antigravity, Cursor, and Codex with zero overhead and zero conflicting hooks.
  - **Native Antigravity Plugin / OpenCode Guard**: Upstream provides native host hooks. These operate as workflow safeguards (not OS sandboxes). They are documented as optional enhancements; instruction-only enforcement remains standard to guarantee portability.

---

## 6. UI/UX Pro Max — Primary Design Authority

- **Upstream Source**: [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) (MIT repository license, pinned commit `d14efff`)
- **Integration Boundary**: Primary general-purpose UI/UX design skill at [`.agents/skills/ui-ux-pro-max/`](../.agents/skills/ui-ux-pro-max/) (mirrored to `.claude/skills/ui-ux-pro-max/`).
- **Update Command**: `bash scripts/update-ui-ux-pro-max.sh`.

---

## Framework Selection Matrix

To avoid conflicting workflows, choose at most **one** full planning or implementation framework per task:

| Task Type | Recommended Flow | Specialist Skill | Policies Triggered |
|---|---|---|---|
| **Simple fix / quick edit** | Lightweight minimal execution | None or `ponytail` | `core`, `engineering`, `testing` |
| **Complex milestone / feature** | 5-phase spec-driven loop | `gsd-core` (+ `gravitas`) | `core`, `engineering`, `testing` |
| **Unfamiliar library / API audit** | 8-step primary research | `agent-research` | `core` |
| **Security review / Auth hardening** | Threat model & OWASP audit | `security-auditor` | `core`, `security`, `testing` |
| **Website redesign / UI building** | Design system & WCAG AA audit | `ui-ux-pro-max` | `core`, `frontend` |
| **Token-constrained session** | Terse reporting & log summary | `caveman` | `core`, `engineering` |
