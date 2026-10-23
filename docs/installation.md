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

### One-line remote install (interactive)

Download from Git and run the interactive setup menu in your terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.sh)"
```

### Direct terminal execution from a local clone

Run directly in terminal to interactively choose your scope, platform, and what to install:

```bash
./install.sh
```

Or pass non-interactive flags:

```bash
# Minimal project adapter and policies:
bash install.sh --target project --minimal

# All 19 domain skills:
bash install.sh --target project --platform claude --all

# Select specific skills:
bash install.sh --target project --platform agents --skills api-architecture,postgres-ecosystem
bash install.sh --target project --platform claude --skills ui-ux-pro-max
bash install.sh --target project --platform cursor --skills ui-ux-pro-max
bash install.sh --target global --platform antigravity --skills ui-ux-pro-max
```

### Uninstall (macOS and Linux)

Remove only unchanged files recorded by the installation manifest:

```bash
# Remote one-liner:
bash -c "$(curl -fsSL https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/uninstall.sh)"

# From local clone or installed directory:
./uninstall.sh

# Or specify an explicit target directory:
bash uninstall.sh --target /path/to/project
bash uninstall.sh --target "$HOME"  # global install
```

## Windows PowerShell

### One-line remote install

```powershell
irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.ps1 | iex
```

### Direct execution from a local clone

```powershell
# Interactive / default:
.\install.ps1

# All 19 domain skills:
.\install.ps1 -Scope project -Platform claude -All

# Specific skills:
.\install.ps1 -Scope project -Platform agents -Skills ui-ux-pro-max,security-auditor
.\install.ps1 -Scope global -Platform claude -Skills ui-ux-pro-max
```

### Uninstall (Windows PowerShell)

```powershell
# Remote one-liner:
irm https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/uninstall.ps1 | iex

# From local clone:
.\uninstall.ps1

# Or specify target:
.\uninstall.ps1 -Target (Get-Location).Path
```

## Windows Command Prompt (CMD)

```cmd
:: Install
install.bat

:: Uninstall
uninstall.bat
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
