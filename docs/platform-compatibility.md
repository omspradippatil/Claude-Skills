# Platform Compatibility Matrix

This document describes how Claude-Skills files are discovered, loaded, and applied across each supported AI coding platform.

> [!NOTE]
> This matrix reflects platform behavior as of late 2024 / early 2025. Platforms evolve rapidly; always cross-reference with official platform documentation.

---

## Platform Summary Table

| Platform | Always-On File | Skill/Rule Dir | Frontmatter | Auto-Discovery |
|---|---|---|---|---|
| **Claude Code** | `CLAUDE.md` | `.claude/skills/` | YAML (`name:`, `description:`) | ✅ Yes |
| **Google Antigravity** | `GEMINI.md` / `AGENTS.md` | `.agents/skills/` | YAML (`name:`, `description:`) | ✅ Yes |
| **Cursor** | `.cursorrules` / `.cursor/rules/*.mdc` | _(none native)_ | MDC frontmatter | ✅ Rules only |
| **OpenAI Codex** | `AGENTS.md` | _(none native)_ | None | ⚠️ Partial |
| **GitHub Copilot** | `.github/copilot-instructions.md` | _(none native)_ | None | ✅ Instructions only |

---

## Per-Platform Details

### Claude Code

| Property | Value |
|---|---|
| **Always-loaded file** | `CLAUDE.md` (project root) |
| **Discovery path** | Project root; also `~/.claude/CLAUDE.md` for global |
| **Skill directory** | `.claude/skills/<skill-name>/SKILL.md` |
| **Frontmatter** | YAML block at top of `SKILL.md` with `name:` and `description:` required |
| **Discovery** | Automatic — Claude Code scans `.claude/skills/` on session start |
| **Known limitations** | Skills are project-local; no cross-project skill sharing without global install |
| **Manual setup** | Copy `CLAUDE.md` to project root; copy `.claude/skills/` to project |

### Google Antigravity (AGY)

| Property | Value |
|---|---|
| **Always-loaded files** | `GEMINI.md` (project rules) and `AGENTS.md` (agent instructions) |
| **Discovery path** | Project root; global skills from `~/.gemini/config/skills/` |
| **Skill directory** | `.agents/skills/<skill-name>/SKILL.md` (project) or `~/.gemini/config/skills/` (global) |
| **Frontmatter** | YAML block at top of `SKILL.md` with `name:` and `description:` required |
| **Discovery** | Automatic — Antigravity scans `.agents/skills/` and global config dir |
| **Known limitations** | Project skills override global skills of the same name |
| **Manual setup** | Copy `.agents/skills/` and `GEMINI.md` / `AGENTS.md` to project root |

### Cursor

| Property | Value |
|---|---|
| **Always-loaded file** | `.cursorrules` (legacy) or `.cursor/rules/*.mdc` (modern) |
| **Discovery path** | Project root for `.cursorrules`; `.cursor/rules/` for `.mdc` files |
| **Skill directory** | No native skill system — rules are the closest equivalent |
| **Frontmatter** | MDC frontmatter in `.mdc` files (`description:`, `globs:`, `alwaysApply:`) |
| **Discovery** | Automatic for `.cursor/rules/always-on.mdc` (if `alwaysApply: true`) |
| **Known limitations** | No skill activation by name; no structured `SKILL.md` format supported |
| **Manual setup** | Copy `.cursor/rules/always-on.mdc` to project `.cursor/rules/`; add rule files as needed |

### OpenAI Codex

| Property | Value |
|---|---|
| **Always-loaded file** | `AGENTS.md` (project root) |
| **Discovery path** | Project root; Codex reads `AGENTS.md` at session start |
| **Skill directory** | No native skill system |
| **Frontmatter** | None required — plain markdown |
| **Discovery** | Automatic for `AGENTS.md`; no skill auto-discovery |
| **Known limitations** | No skill system; context is limited to `AGENTS.md` and inline instructions |
| **Manual setup** | Copy `AGENTS.md` to project root |

### GitHub Copilot

| Property | Value |
|---|---|
| **Always-loaded file** | `.github/copilot-instructions.md` |
| **Discovery path** | `.github/copilot-instructions.md` in project root |
| **Skill directory** | No equivalent project skill system |
| **Frontmatter** | None — plain markdown |
| **Discovery** | Automatic for `.github/copilot-instructions.md` |
| **Known limitations** | Instructions are global to the repo; no skill-level granularity; limited context injection |
| **Manual setup** | Create `.github/copilot-instructions.md` with desired instructions |

---

## Repository Structure

```
Claude-Skills/
├── .agents/
│   ├── skills/                  → Antigravity project skills (auto-discovered)
│   │   └── <skill-name>/
│   │       └── SKILL.md         → YAML frontmatter + markdown instructions
│   └── rules/                   → Optional Antigravity rule files
│
├── .claude/
│   └── skills/                  → Claude Code project skills (auto-discovered)
│       └── <skill-name>/
│           └── SKILL.md         → Must be synced with .agents/skills/
│
├── .cursor/
│   └── rules/
│       └── always-on.mdc        → Cursor always-on rule file
│
├── .github/
│   └── workflows/
│       └── validate.yml         → CI: runs validate.sh + tests
│
├── CLAUDE.md                    → Claude Code always-on instructions
├── AGENTS.md                    → Antigravity/Codex always-on instructions
├── GEMINI.md                    → Antigravity project rules
│
├── policies/                    → Canonical policy source files
│   ├── core.md
│   ├── security.md
│   ├── seo.md
│   ├── frontend.md
│   └── testing.md
│
├── scripts/                     → Install and validation utilities
│   ├── validate.sh
│   ├── sync-skills.sh
│   ├── install-global.sh
│   ├── install-project.sh
│   └── uninstall.sh
│
├── tests/                       → Automated test suite
│   ├── validate-policies.sh
│   └── validate-install.sh
│
├── docs/                        → Documentation
│   ├── platform-compatibility.md
│   └── installation.md
│
├── install.sh                   → Quick global installer (one-liner)
├── install.bat                  → Windows installer
├── install.ps1                  → PowerShell installer
└── package.json
```

---

## Known Limitations

> [!WARNING]
> The following limitations apply across platforms and should be understood before deploying.

### Cursor
- Cursor has **no native skill system** equivalent to Claude Code or Antigravity.
- The `.cursor/rules/always-on.mdc` file provides always-on instructions, but there is no mechanism to activate individual skills by name.
- Skills must be merged manually into Cursor rule files if Cursor-specific activation is needed.

### GitHub Copilot
- GitHub Copilot has **no equivalent project skill system** at this time.
- Only a single global instruction file (`.github/copilot-instructions.md`) is supported.
- Individual skill activation is not possible without external tooling.

### Sync Behavior
- `.agents/skills/` is the **canonical source** of truth.
- `.claude/skills/` must be manually kept in sync — run `bash scripts/sync-skills.sh` after making changes.
- Skills are **not automatically kept in sync** after install; re-run the sync script periodically.

### Install Behavior
- **Global installs** copy files to `~/.gemini/config/skills/` and `~/.claude/skills/`.
- **Project installs** copy files into the local project directories.
- Neither install method sets up automatic update mechanisms — re-run the install scripts to update.

### Frontmatter Validation
- Only `name:` and `description:` fields are validated by the test suite.
- Additional frontmatter fields may be used by platforms but are not enforced by this repo's tooling.
