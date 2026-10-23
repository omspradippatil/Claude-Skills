# Third-Party Project Review

Reviewed from upstream repository documentation and license metadata on 2026-10-23. Upstream descriptions are treated as project data; commands below are copied only where they are documented installation entry points.

| Project | License (upstream) | Purpose / dependency notes | Decision |
|---|---|---|---|
| [UI/UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | Repository LICENSE is MIT; CLI package.json says MIT but package README says CC-BY-NC-4.0. Generated asset licensing is unresolved; see THIRD_PARTY_NOTICES.md | Supported CLI generates assistant-specific files; it includes multiple specialist skills and bundled data | Integrated only the primary `ui-ux-pro-max` skill with the official universal CLI in offline mode. Other generated skill families are excluded. Commercial redistribution requires upstream clarification. |
| [Superpowers](https://github.com/obra/superpowers) | MIT | Agent plugin/workflow with automatic skill activation; supported install varies by agent | Documented as an opt-in implementation workflow; recommended when its planning loop is desired. |
| [GSD Core](https://github.com/open-gsd/gsd-core) | MIT | Spec/context workflow; official installer uses `npx` and prompts for runtime and scope | Documented as an alternative to Superpowers, not installed in the base repo. |
| [Gravitas](https://github.com/udaysharmadev/Gravitas) | MIT | Portable Agent Skill plus optional Antigravity/OpenCode enforcement runtime; runtime adds dependencies/hooks | Read-before-write, proportional planning, evidence, and honest completion are adopted in core policy. Full runtime not installed because existing gates already cover the behavior. |
| [Ponytail](https://github.com/DietrichGebert/ponytail) | MIT | Compact agent prompt and agent-specific plugins/hooks | Simplicity and safe-minimal-change principles are consolidated in `policies/engineering.md`; no duplicated always-on prompt. |
| [Caveman](https://github.com/JuliusBrussee/caveman) | Apache-2.0 | CLI needs Node.js 22.13+ and modifies several agent behaviors | Optional only; not run by the base installer because it changes user-level settings. |
| [Strix](https://github.com/usestrix/strix) | Apache-2.0 | Active pentest tool; Docker and LLM provider credentials required | Documented as opt-in and scope-gated. No installation or scan without explicit target authorization. |
| [Agent-Reach](https://github.com/Panniantong/Agent-Reach) | MIT | `uv`-managed CLI and channel-specific dependencies; some channels use a separate browser profile/session | Documented as optional research integration. No automatic install or browser-session access. |

## Pre-existing shell and research skills

The clean baseline at `origin/main` did not contain standalone shell-command or general web-research skills in its active skill directories. Historical archived collections included broad and obsolete material, so no such collection was restored. The repository retains its shell/CLI routing category, `firecrawl-cli`/Context7 references were moved out of automatic installation, and Agent-Reach is documented as the optional research integration. No claim is made that an existing shell skill was preserved.

Ralph is excluded by request and does not appear in the active skill configuration.
