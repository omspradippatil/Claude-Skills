# Installation

The installer defaults to a minimal router-and-policy setup. It does not install
specialist skills, npm packages, plugins, browser tools, or security scanners
unless you select a skill explicitly. Third-party integrations have their own
opt-in instructions in [integrations/README.md](../integrations/README.md).

## Prerequisites

- Bash and `shasum` for POSIX installs.
- Git only when running the installer outside a local clone.
- Python 3 when using the route helper.
- Windows: PowerShell 5.1 or later.

## POSIX: macOS and Linux

From a clone, install the minimal project adapter and policies:

```bash
bash install.sh --target project --minimal
```

Select only the skills needed:

```bash
bash install.sh --target project --platform agents --skills api-architecture,postgres-ecosystem
bash install.sh --target project --platform claude --skills ui-ux-pro-max
bash install.sh --target project --platform cursor --skills ui-ux-pro-max
bash install.sh --target global --platform antigravity --skills ui-ux-pro-max
```

For user-wide setup, use `--target global`. The `agents` platform uses
`~/.agents/skills/`; `claude` uses `~/.claude/skills/`; `cursor` uses
`~/.cursor/skills/`; and `antigravity` uses
`~/.gemini/config/skills/` for the Antigravity app/IDE. Antigravity CLI has a
different global path, so its CLI users should use a project install or copy
the skill to the CLI-specific location in its current docs. Project installs
use the corresponding project-native folder; Antigravity uses `.agents/skills/`.
Skill folders are copied in full, including references, scripts, and data.

Existing files cause the install to stop. Review the destinations before
re-running with `--force`. Each install writes a SHA-256 manifest at the
installation root. Uninstall removes only files that still match its manifest:

```bash
bash uninstall.sh --target /path/to/project
bash uninstall.sh --target "$HOME"  # global install
```

Files edited after installation are kept. Do not delete the manifest manually
until uninstall is complete.

The one-line remote setup is available after cloning from the official
repository. Review the script before piping remote code into a shell.

## Windows PowerShell

Run from a local clone:

```powershell
.\install.ps1 -Scope project -Platform agents -Skills ui-ux-pro-max,security-auditor
.\install.ps1 -Scope global -Platform claude -Skills ui-ux-pro-max
```

Omitting `-Skills` creates the minimal router-and-policy setup. Use
`-Force` only after reviewing existing files. Remove unchanged installed
files with:

```powershell
.\uninstall.ps1 -Target (Get-Location).Path
```

Global installs target the current user's profile. The Windows manifest uses a
separate filename from the POSIX manifest. The scripts do not require
administrator access and do not call npm or install external integrations.

## Verify task routing

```bash
python3 scripts/route-task.py --task "secure the authentication endpoint against injection"
```

The helper reports keyword-matched candidate skills and policies. It is a
transparent aid, not proof that an agent automatically loads skills or a
replacement for semantic selection.

## Verify repository and install behavior

```bash
bash scripts/validate.sh
npm test
npm run test:install
```

The repository checks validate files, registry routes, mirror completeness, and
a local copy simulation. They do not prove native skill discovery in every
product version or install third-party tools.
