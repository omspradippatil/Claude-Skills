# Installation Guide

Complete instructions for installing Claude-Skills globally or into a specific project.

---

## Prerequisites

Before installing, ensure the following are available on your system:

| Tool | Required | Purpose |
|---|---|---|
| `git` | ✅ Required | Cloning the repository |
| `bash` | ✅ Required | Running install scripts |
| `node` / `npm` | ⚠️ Optional | Running JavaScript-based tooling |

To check if prerequisites are installed:

```bash
git --version
bash --version
node --version  # optional
```

---

## Quick Start

### macOS / Linux (one-liner)

```bash
curl -fsSL https://raw.githubusercontent.com/om-1960/Claude-Skills/main/install.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/om-1960/Claude-Skills/main/install.ps1 | iex
```

### Windows (CMD / Batch)

```cmd
curl -fsSL https://raw.githubusercontent.com/om-1960/Claude-Skills/main/install.bat -o install.bat && install.bat
```

> [!NOTE]
> The one-liner installs skills **globally** to `~/.gemini/config/skills/` and `~/.claude/skills/`.
> For a project-level install, follow the [Project-Specific Install](#project-specific-install) instructions below.

---

## Global Install

Global install makes skills available in every project on your machine.

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/om-1960/Claude-Skills.git
   cd Claude-Skills
   ```

2. Run the global install script:
   ```bash
   bash scripts/install-global.sh
   ```

3. To overwrite existing files (if re-installing):
   ```bash
   bash scripts/install-global.sh --force
   ```

### What gets installed globally

| Source | Destination |
|---|---|
| `.agents/skills/` | `~/.gemini/config/skills/` |
| `.agents/skills/` | `~/.claude/skills/` |
| `.agents/rules/` | `~/.gemini/config/rules/` _(if `~/.gemini/config/` exists)_ |

> [!IMPORTANT]
> Global install does **not** overwrite existing files by default. Use `--force` to overwrite.

---

## Project-Specific Install

Project install copies skills into the current working directory, making them available only to that project.

### Steps

1. Navigate to your target project:
   ```bash
   cd /path/to/your-project
   ```

2. Run the project install script:
   ```bash
   bash /path/to/Claude-Skills/scripts/install-project.sh
   ```

3. To skip prompts and force overwrite:
   ```bash
   bash /path/to/Claude-Skills/scripts/install-project.sh --force
   ```

4. To skip adding entries to `.gitignore`:
   ```bash
   bash /path/to/Claude-Skills/scripts/install-project.sh --no-gitignore
   ```

### What gets installed per-project

| Source | Destination |
|---|---|
| `.agents/skills/` | `<project>/.agents/skills/` |
| `.claude/skills/` | `<project>/.claude/skills/` |
| `CLAUDE.md` | `<project>/CLAUDE.md` _(prompts before overwrite)_ |
| `AGENTS.md` | `<project>/AGENTS.md` _(prompts before overwrite)_ |
| `GEMINI.md` | `<project>/GEMINI.md` _(prompts before overwrite)_ |

---

## Manual Install

If you prefer not to run the install scripts, follow these steps manually:

### 1. Clone the repository

```bash
git clone https://github.com/om-1960/Claude-Skills.git ~/Claude-Skills
```

### 2. Create destination directories

```bash
mkdir -p ~/.gemini/config/skills
mkdir -p ~/.claude/skills
```

### 3. Copy skills for Antigravity

```bash
cp -rn ~/Claude-Skills/.agents/skills/. ~/.gemini/config/skills/
```

> `-n` = no-clobber (skip existing files). Remove `-n` to overwrite.

### 4. Copy skills for Claude Code

```bash
cp -rn ~/Claude-Skills/.agents/skills/. ~/.claude/skills/
```

### 5. Copy entry point files to your project

```bash
cp ~/Claude-Skills/CLAUDE.md  ./CLAUDE.md
cp ~/Claude-Skills/AGENTS.md  ./AGENTS.md
cp ~/Claude-Skills/GEMINI.md  ./GEMINI.md
```

### 6. Copy Cursor rules

```bash
mkdir -p .cursor/rules
cp ~/Claude-Skills/.cursor/rules/always-on.mdc .cursor/rules/always-on.mdc
```

---

## Verifying the Installation

After installing, run the validation script to confirm everything is set up correctly:

```bash
cd /path/to/Claude-Skills
bash scripts/validate.sh
```

You should see output like:

```
── Policy Files ──────────────────────────────────────────────
  ✓ PASS  policies/core.md exists and is non-empty
  ✓ PASS  policies/security.md exists and is non-empty
  ...
── Entry Point Files ─────────────────────────────────────────
  ✓ PASS  CLAUDE.md exists and is non-empty
  ...
══════════════════════════════════════════════════════════
  Validation Summary
══════════════════════════════════════════════════════════
  ✓ All checks passed!
```

---

## Uninstalling

To remove globally installed files:

```bash
bash scripts/uninstall.sh
```

The uninstall script:
- Only removes files that **match** what this repository installed (by content comparison)
- **Does not** delete files you created or modified yourself
- Prompts for confirmation before deleting anything
- Removes empty directories after cleanup

---

## Updating

To update to the latest version of Claude-Skills:

1. Pull the latest changes:
   ```bash
   cd /path/to/Claude-Skills
   git pull origin main
   ```

2. Re-run the install with `--force`:
   ```bash
   bash scripts/install-global.sh --force
   ```

   Or for a project install:
   ```bash
   bash scripts/install-project.sh --force
   ```

---

## Keeping Skills in Sync

The canonical source for skills is `.agents/skills/`. To sync changes to `.claude/skills/`:

```bash
bash scripts/sync-skills.sh
```

Run this after adding or editing any skill in `.agents/skills/`.

---

## Troubleshooting

### `node not found`

Node.js is **optional** for the core install. If scripts that require Node fail:

```bash
# macOS (Homebrew)
brew install node

# Ubuntu/Debian
sudo apt install nodejs npm

# Via nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install --lts
```

---

### `git not found`

```bash
# macOS
xcode-select --install

# macOS (Homebrew)
brew install git

# Ubuntu/Debian
sudo apt install git
```

---

### `Permission denied` when running scripts

Scripts must be executable. Fix with:

```bash
chmod +x scripts/validate.sh
chmod +x scripts/install-global.sh
chmod +x scripts/install-project.sh
chmod +x scripts/sync-skills.sh
chmod +x scripts/uninstall.sh
chmod +x tests/validate-policies.sh
chmod +x tests/validate-install.sh
chmod +x install.sh
```

---

### Skills not discovered by Claude Code

1. Verify `.claude/skills/` exists in your project root:
   ```bash
   ls .claude/skills/
   ```
2. Ensure each skill has a `SKILL.md` file with valid YAML frontmatter.
3. Restart the Claude Code session.

---

### Skills not discovered by Antigravity

1. Verify `.agents/skills/` exists in your project root:
   ```bash
   ls .agents/skills/
   ```
2. Check that `SKILL.md` has `name:` and `description:` in the frontmatter.
3. For global skills, verify `~/.gemini/config/skills/` contains the skill directories.
4. Reload the Antigravity session.

---

### Files not showing up after global install

Check the destination directories:

```bash
ls ~/.gemini/config/skills/
ls ~/.claude/skills/
```

If empty, re-run with `--force`:

```bash
bash scripts/install-global.sh --force
```

---

### `validate.sh` reports failures for missing policies

Policy files are part of the repository. If they are missing, you may have a partial clone:

```bash
git status
git pull origin main
```

Then re-run validation:

```bash
bash scripts/validate.sh
```
