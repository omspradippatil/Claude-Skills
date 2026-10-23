# Optional Integrations

The repository's own policies and focused skills work without these tools. Third-party integrations are opt-in and must be installed through their maintainers' supported methods. Never install every workflow together: choose at most one full planning/implementation framework for a task.

## UI/UX Pro Max — primary design skill

Integrated from [`nextlevelbuilder/ui-ux-pro-max-skill`](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) using its supported `uipro init --ai universal --offline` generation path. Only the `ui-ux-pro-max` skill is included; the CLI's separate brand, slides, graphic-design, and styling skills are excluded to keep one general UI/UX authority. The other local skills `ux-research`, `web-animation`, and `assets-media` remain focused on separate disciplines.

To refresh from the upstream CLI, run `bash scripts/update-ui-ux-pro-max.sh`. Review the diff before committing. The generated skill is MIT-licensed by the upstream repository; see [THIRD_PARTY_NOTICES.md](../THIRD_PARTY_NOTICES.md).

## Superpowers — optional implementation workflow

Reviewed as the candidate for disciplined implementation, TDD, and debugging. It is a complete workflow and automatically activates its own skills, so install it only when you want that workflow for a project. Do not simultaneously use GSD Core as the planning workflow for the same task.

- Claude Code: `/plugin install superpowers@claude-plugins-official`
- Antigravity: `agy plugin install https://github.com/obra/superpowers`
- Codex: use the official plugin marketplace in the Codex app or CLI.
- Cursor: install Superpowers from Cursor's plugin marketplace.

Upstream: [obra/superpowers](https://github.com/obra/superpowers) · MIT · no repository runtime dependency when installed as a plugin.

## GSD Core — alternative planning/context workflow

Use this instead of Superpowers when a project needs milestone-based planning and persistent project artifacts. Its installer supports multiple runtimes and uses Node.js via `npx`; follow its interactive official installer rather than copying its internal files.

```bash
npx @opengsd/gsd-core@latest
```

Do not run GSD and Superpowers together as competing full planning loops. Upstream: [open-gsd/gsd-core](https://github.com/open-gsd/gsd-core) · MIT.

## Gravitas — verification principles adopted

The core router and verification policy already require reading before editing, proportionate planning, executed checks, evidence-based completion claims, and recording unverified work. These capture the distinct value of Gravitas without installing another policy/hook runtime over the existing release gates. Reconsider its official Antigravity skill/plugin only if mechanical enforcement beyond repository instructions is needed.

Upstream: [udaysharmadev/Gravitas](https://github.com/udaysharmadev/Gravitas) · MIT · its documented portable skill install requires the Skills CLI; its enforcement runtime adds extra machinery.

## Ponytail and Karpathy-inspired simplicity — consolidated policy

The non-overlapping principles are consolidated in [`policies/engineering.md`](../policies/engineering.md): inspect before editing, minimize scope, prefer simple existing patterns, preserve behavior, and verify the final change. We do not vendor Ponytail or duplicate its always-on agent prompt. Its plugin remains an optional choice when you want its additional review commands/hooks.

Upstream: [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) · MIT · plugin install instructions are maintained upstream and differ by agent.

## Caveman — optional token-efficiency tooling

Not installed by default. Its current CLI requires Node.js 22.13+ and can change several global agent behaviors. Review its scope and use the upstream installer only if you explicitly want those changes:

```bash
npx @caveman-ai/cli@latest
```

Upstream: [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) · Apache-2.0.

## Strix — explicitly authorized security testing only

Not installed or run automatically. It requires Docker and an LLM provider key and performs active testing against a target. Before a scan, obtain written authorization, define exact in-scope targets and test limits, and use a safe environment. Follow the [official installation guide](https://github.com/usestrix/strix#quick-start) only after those conditions are met.

Upstream: [usestrix/strix](https://github.com/usestrix/strix) · Apache-2.0.

## Agent-Reach — optional web research integration

Not installed by default. It requires `uv` and channel-specific tools; some channels use a dedicated browser profile and may copy an existing browser session. Review its security and channel setup docs before opting in. Follow [the official installation guide](https://github.com/Panniantong/Agent-Reach/blob/main/docs/install.md); do not install the unrelated PyPI package with the same name.

Upstream: [Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach) · MIT.

## Compatibility and support boundary

These are upstream integrations, not bundled dependencies. Their availability and commands can change. This repository validates its own routes and install copies; it does not claim to have installed or runtime-tested every third-party plugin in every supported agent.
