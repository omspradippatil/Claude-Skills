# Claude-Skills

A small, cross-agent collection of engineering policies and task-specific skills. The repository keeps its own policy source in `policies/`, uses focused skills under `.agents/skills/`, and provides lightweight adapters for Claude Code, Antigravity, Codex, and Cursor.

The repo contains **19 active skills**. Third-party plugins and tools are optional; the installer does not install global npm packages or active security/research tools.

## Start here

1. Read [`CLAUDE.md`](CLAUDE.md), the canonical task router.
2. Read [`policies/core.md`](policies/core.md) for every task.
3. Use [`skills-lock.json`](skills-lock.json) to select only relevant skills and policies.
4. Read each selected `SKILL.md` in full and its required references before acting.
5. Run the task-relevant checks and report evidence and limitations.

## Skill catalog

| Skill | Purpose |
|---|---|
| `ui-ux-pro-max` | Primary UI/UX skill, integrated from the official upstream project |
| `ux-research` | User research, usability heuristics, UX writing |
| `web-animation` | Purposeful, performant, accessible motion |
| `assets-media` | Media, fonts, and web asset performance |
| `api-architecture` | REST/GraphQL API contracts and backend patterns |
| `postgres-ecosystem` | PostgreSQL, Supabase, Neon, SQL and RLS |
| `firebase-expert` | Firebase, Firestore, Auth, rules and functions |
| `cloudflare-expert` | Workers, D1, R2, KV and Wrangler |
| `devops-cicd` | CI/CD, containers and deployment practices |
| `testing-qa` | Unit, integration, E2E and test-quality guidance |
| `security-auditor` | OWASP-focused security review and threat modeling |
| `seo-marketing` | Technical SEO, metadata, indexing and migrations |
| `mobile-engineering` | Native and cross-platform mobile engineering |
| `llm-optimization` | Prompt, agent and context design |
| `state-management` | Client-side state and data-fetching patterns |
| `3d-visuals` | Three.js, WebGL and spatial visuals |
| `web-gamedev` | Canvas game loops and browser game systems |
| `git-collaboration` | Branching, merges and pull-request workflows |
| `sentry-expert` | Error monitoring and telemetry |

Shell/CLI requests route through the core and engineering policies. The previous baseline did not contain a standalone shell skill or general web-research skill. See [`integrations/audit.md`](integrations/audit.md) for what was found and why optional tools are not installed automatically.

## Policies

- [`core.md`](policies/core.md): routing, conflicts, untrusted content, evidence-based completion
- [`engineering.md`](policies/engineering.md): simple, scoped, maintainable changes
- [`security.md`](policies/security.md): security requirements and release checks
- [`seo.md`](policies/seo.md): discoverability, indexing, metadata and migrations
- [`frontend.md`](policies/frontend.md): UI quality, accessibility and responsive behavior
- [`release.md`](policies/release.md): production-only launch gates
- [`testing.md`](policies/testing.md): verification and test practices

## Install

Requirements: Git and Bash for the POSIX installer. It installs project instructions, policies, and the selected skill profile into your agent folders.

### One-line remote install (interactive)

Run directly in terminal to download from GitHub and choose what to install:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.sh)"
```

### Direct terminal execution from clone

```bash
# Interactive setup menu (asks scope, platform, and what all to install)
./install.sh

# Non-interactive: minimal project install (router and policies only)
bash install.sh --target project --minimal

# Non-interactive: install all 19 domain skills
bash install.sh --target project --platform claude --all

# Non-interactive: select exact skills
bash install.sh --target project --platform agents --skills ui-ux-pro-max,security-auditor,seo-marketing

# Uninstall matching files recorded by manifest
bash uninstall.sh
```

### Windows (PowerShell & CMD)

```powershell
# PowerShell One-liner:
irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.ps1 | iex

# Local PowerShell execution:
.\install.ps1 -Scope project -Platform claude -All

# PowerShell Uninstall:
.\uninstall.ps1
```

```cmd
:: Command Prompt (CMD)
install.bat
uninstall.bat
```

The default install contains policies, adapters, and the router; it adds no specialist skills until selected with `--skills`. Existing files are preserved. Use `--force` only after reviewing the affected targets. Windows users can use `install.ps1`; see [`docs/installation.md`](docs/installation.md).

## Optional integrations

Third-party integrations are not bundled or installed silently. The review records upstream purpose, license, requirements, and the chosen integration boundary. Select at most one full planning workflow per task.

See [`integrations/README.md`](integrations/README.md) for UI/UX Pro Max updates and official setup paths for Superpowers, GSD Core, Gravitas, Ponytail, Caveman, Strix, and Agent-Reach. Active security testing requires written authorization and a defined scope.

## Platform support

This repo includes instruction adapters for Claude Code (`CLAUDE.md`), Antigravity (`AGENTS.md`/`GEMINI.md`), Codex (`AGENTS.md`), and Cursor (`.cursor/rules/always-on.mdc`). Skills are stored in `.agents/skills/` and mirrored to `.claude/skills/` for Claude Code.

The automated checks validate repository structure and route coverage. They do not prove that each product version automatically discovers skills or follows instructions. Read [`docs/platform-compatibility.md`](docs/platform-compatibility.md) before advertising or relying on native behavior.

## Verify

```bash
npm run validate
npm test
npm run test:install
```

The install test runs project and global destination simulations in temporary folders. These commands do not validate Windows PowerShell execution, native agent discovery, third-party plugin installation, or production behavior.

## Security and license

See [`SECURITY.md`](SECURITY.md) for reporting guidance and safe use. Repository-authored files are MIT-licensed; see [`LICENSE`](LICENSE) and [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md) for the integrated upstream skill attribution.
