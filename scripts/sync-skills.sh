#!/usr/bin/env bash
# Mirror complete skill trees from the canonical .agents location.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/.agents/skills"
DST="$ROOT/.claude/skills"
[[ -d "$SRC" ]] || { echo "Missing canonical skills: $SRC" >&2; exit 1; }
mkdir -p "$DST"
for skill in "$SRC"/*; do
  [[ -d "$skill" && -f "$skill/SKILL.md" ]] || continue
  name="$(basename "$skill")"
  mkdir -p "$DST/$name"
  cp -R "$skill/." "$DST/$name/"
done
echo "Copied complete skill folders. Existing extra files in the mirror were left intact; review them manually if a source file was removed."
