#!/usr/bin/env bash
# Exercise project install and safe uninstall in disposable directories.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
command -v shasum >/dev/null || { echo "shasum is required for installer verification" >&2; exit 1; }

mkdir -p "$TMP/minimal"
(
  cd "$TMP/minimal"
  bash "$ROOT/install.sh" --target project --minimal
)
[[ -f "$TMP/minimal/CLAUDE.md" && -f "$TMP/minimal/policies/core.md" ]]
[[ ! -d "$TMP/minimal/.agents/skills" ]]
echo "PASS: minimal installer adds router and policies without specialist skills"
bash "$ROOT/uninstall.sh" --target "$TMP/minimal"
[[ ! -e "$TMP/minimal/CLAUDE.md" && ! -e "$TMP/minimal/.claude-skills-install.manifest" ]]
echo "PASS: uninstall removes unchanged manifest-owned files"

mkdir -p "$TMP/selected"
(
  cd "$TMP/selected"
  bash "$ROOT/install.sh" --target project --platform cursor --skills ui-ux-pro-max
)
[[ -s "$TMP/selected/.cursor/skills/ui-ux-pro-max/SKILL.md" ]]
[[ -s "$TMP/selected/.cursor/skills/ui-ux-pro-max/references/quick-reference.md" ]]
echo "PASS: selected installation copies the complete skill tree to Cursor"
printf '\nuser edit\n' >> "$TMP/selected/.cursor/skills/ui-ux-pro-max/SKILL.md"
bash "$ROOT/uninstall.sh" --target "$TMP/selected"
[[ -s "$TMP/selected/.cursor/skills/ui-ux-pro-max/SKILL.md" ]]
[[ ! -e "$TMP/selected/policies/core.md" ]]
echo "PASS: uninstall preserves files edited after installation"

mkdir -p "$TMP/claude"
(
  cd "$TMP/claude"
  bash "$ROOT/install.sh" --target project --platform claude --skills ui-ux-pro-max
)
[[ -s "$TMP/claude/.claude/skills/ui-ux-pro-max/references/pro-rules.md" ]]
bash "$ROOT/uninstall.sh" --target "$TMP/claude" >/dev/null
echo "PASS: Claude platform destination receives complete skill resources"

mkdir -p "$TMP/home"
(
  cd "$TMP"
  HOME="$TMP/home" bash "$ROOT/install.sh" --target global --platform antigravity --skills ui-ux-pro-max
)
[[ -s "$TMP/home/.gemini/config/skills/ui-ux-pro-max/references/quick-reference.md" ]]
HOME="$TMP/home" bash "$ROOT/uninstall.sh" --target "$TMP/home" >/dev/null
echo "PASS: Antigravity global destination receives complete skill resources"
