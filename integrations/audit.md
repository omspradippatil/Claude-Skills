# Third-Party Project Review & Architecture Audit

Reviewed from upstream repository documentation, source code, and license metadata on 2026-10-23. Upstream descriptions are treated as project data; commands below are documented installation and verification entry points.

| Project | License (upstream) | Upstream Ref / Version | Purpose / Architecture Notes | Integration Decision |
|---|---|---|---|---|
| [UI/UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | MIT (repo) / CC-BY-NC-4.0 (CLI readme) | Commit `d14efff` | Comprehensive design intelligence (palettes, fonts, UX guidelines, components, styles) | Integrated primary `ui-ux-pro-max` skill with bundled offline data. Retained as sole general-purpose UI/UX authority. |
| [Ponytail](https://github.com/DietrichGebert/ponytail) | MIT | `v1.2.0` (`0f4b3e8`) | "Lazy senior developer" minimalism, The Decision Ladder, eliminating unnecessary code and abstractions | Integrated The Decision Ladder into `policies/engineering.md` and `policies/core.md`. Added canonical on-demand skill at `.agents/skills/ponytail/SKILL.md`. Host hooks kept optional. |
| [Caveman](https://github.com/JuliusBrussee/caveman) | Apache-2.0 | `v3.1.2` (`7c9a1d4`) | Concise communication, token-efficient summaries, stripping pleasantries while preserving code/errors | Token-Efficiency Contract added to `policies/core.md`; concise communication rules in `policies/engineering.md`. Added canonical skill at `.agents/skills/caveman/SKILL.md`. Optional proxy is strictly opt-in. |
| [GSD Core](https://github.com/open-gsd/gsd-core) | MIT | `v1.0.4` (`3e2c1a9`) | Spec-driven phased development (Discuss ➔ Research ➔ Plan ➔ Execute ➔ Verify) and durable context state | Canonical skill added at `.agents/skills/gsd-core/SKILL.md`. Used for complex milestones and multi-file refactoring. State persistence in markdown artifacts. |
| [Gravitas](https://github.com/udaysharmadev/Gravitas) | MIT | `v0.9.1` (`4b8d7e2`) | Six engineering reliability invariants (read-before-write, scope control, fresh evidence, intelligent recovery, acceptance criteria, honest reporting) | Codified the Six Invariants directly into `policies/core.md`, `policies/engineering.md`, and `policies/testing.md`. Added canonical skill at `.agents/skills/gravitas/SKILL.md`. Standardized on portable instruction-only core. |
| [Skill Reach](https://github.com/google/skill-reach) | Apache-2.0 | Main | Evaluation framework for skill description routing, collision detection, and trigger specificity | Adopted evaluation methodology in `tests/test-skill-reach.py` to continuously verify collision-free routing, mandatory policy inclusion, and false-positive prevention across all 24 skills. |
| [Agent Research](https://github.com/omspradippatil/Claude-Skills) | MIT | Native | Systematic 8-step primary-source documentation and codebase investigation with citations | Added dedicated canonical research skill at `.agents/skills/agent-research/SKILL.md`. Incorporates subagent delegation for large repository surveys. |
| [Superpowers](https://github.com/obra/superpowers) | MIT | Latest plugin | Alternative TDD / planning workflow plugin | Maintained as an opt-in alternative plugin; never run simultaneously with GSD Core to avoid competing loops. |
| [Strix](https://github.com/usestrix/strix) | Apache-2.0 | Quick start | Active penetration testing tool requiring Docker and LLM credentials | Scope-gated and strictly opt-in with explicit authorization. Never run or installed automatically. |

---

## Pre-existing Research and Shell Baseline

The previous baseline did not contain dedicated agent-research or shell skills in its active directories. 
- General shell requests route cleanly through `policies/core.md` and `policies/engineering.md`.
- A dedicated, evidence-based research capability is now provided by `.agents/skills/agent-research/SKILL.md`.
- Routing collision testing is handled by `tests/test-skill-reach.py`.
- Ralph remains excluded by request and does not appear in the active skill configuration.
