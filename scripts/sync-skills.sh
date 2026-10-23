#!/usr/bin/env bash
# =============================================================================
# sync-skills.sh — Sync .agents/skills/ → .claude/skills/
# Usage: bash scripts/sync-skills.sh
# Run from the project root.
# =============================================================================

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Resolve repo root ─────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

SRC="${REPO_ROOT}/.agents/skills"
DST="${REPO_ROOT}/.claude/skills"

echo ""
echo -e "${BOLD}Claude-Skills: Sync Skills${RESET}"
echo -e "  Source : ${SRC}"
echo -e "  Target : ${DST}"
echo ""

# Guard: source must exist
if [[ ! -d "${SRC}" ]]; then
  echo -e "${YELLOW}⚠  Source directory ${SRC} does not exist. Nothing to sync.${RESET}"
  exit 1
fi

# Ensure destination exists
mkdir -p "${DST}"

SYNCED=0
SKIPPED=0
CREATED=0

# ── Iterate over each skill directory in .agents/skills/ ─────────────────────
while IFS= read -r -d '' skill_dir; do
  skill_name="$(basename "${skill_dir}")"
  src_skill_md="${skill_dir}/SKILL.md"
  dst_skill_dir="${DST}/${skill_name}"
  dst_skill_md="${dst_skill_dir}/SKILL.md"

  # Skip if source has no SKILL.md
  if [[ ! -f "${src_skill_md}" ]]; then
    echo -e "  ${YELLOW}⚠  SKIP${RESET}  ${skill_name}/ — no SKILL.md in source"
    continue
  fi

  # Create destination directory if needed
  if [[ ! -d "${dst_skill_dir}" ]]; then
    mkdir -p "${dst_skill_dir}"
    echo -e "  ${CYAN}+  MKDIR${RESET} .claude/skills/${skill_name}/"
    CREATED=$((CREATED + 1))
  fi

  # Compare source and destination SKILL.md
  if [[ ! -f "${dst_skill_md}" ]]; then
    cp "${src_skill_md}" "${dst_skill_md}"
    echo -e "  ${GREEN}↓  COPY${RESET}  .claude/skills/${skill_name}/SKILL.md  (new file)"
    SYNCED=$((SYNCED + 1))
  elif ! diff -q "${src_skill_md}" "${dst_skill_md}" > /dev/null 2>&1; then
    cp "${src_skill_md}" "${dst_skill_md}"
    echo -e "  ${GREEN}↺  UPDATE${RESET} .claude/skills/${skill_name}/SKILL.md  (content changed)"
    SYNCED=$((SYNCED + 1))
  else
    echo -e "  ·  SAME  .claude/skills/${skill_name}/SKILL.md"
    SKIPPED=$((SKIPPED + 1))
  fi

done < <(find "${SRC}" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

# ── Also check for stale dirs in .claude/skills/ not present in .agents/skills/
echo ""
echo -e "${CYAN}Checking for orphaned directories in .claude/skills/ ...${RESET}"
ORPHAN=0
while IFS= read -r -d '' dst_dir; do
  dir_name="$(basename "${dst_dir}")"
  if [[ ! -d "${SRC}/${dir_name}" ]]; then
    echo -e "  ${YELLOW}⚠  ORPHAN${RESET} .claude/skills/${dir_name}/  (not in .agents/skills/)"
    ORPHAN=$((ORPHAN + 1))
  fi
done < <(find "${DST}" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

if [[ "${ORPHAN}" -eq 0 ]]; then
  echo -e "  No orphaned directories found."
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Sync complete.${RESET}"
echo -e "  Directories created : ${CREATED}"
echo -e "  Files synced        : ${SYNCED}"
echo -e "  Files unchanged     : ${SKIPPED}"
[[ "${ORPHAN}" -gt 0 ]] && echo -e "  ${YELLOW}Orphaned dirs       : ${ORPHAN}${RESET} (manual cleanup may be needed)"
echo ""
