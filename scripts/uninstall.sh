#!/usr/bin/env bash
# =============================================================================
# uninstall.sh — Remove Claude-Skills globally installed files
# Usage: bash scripts/uninstall.sh
# Only removes files that were installed by THIS repository.
# User files not belonging to this repo are never touched.
# =============================================================================

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()  { echo -e "  ${CYAN}→${RESET}  $1"; }
warn()  { echo -e "  ${YELLOW}⚠${RESET}  $1"; }
removed_msg() { echo -e "  ${RED}✗  REMOVED${RESET}  $1"; }
kept_msg()    { echo -e "  ${GREEN}·  KEPT${RESET}     $1  (not from this repo)"; }
missing_msg() { echo -e "       NOT FOUND  $1"; }

# ── Resolve repo root ─────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

GEMINI_SKILLS_DIR="${HOME}/.gemini/config/skills"
CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"
GEMINI_RULES_DIR="${HOME}/.gemini/config/rules"

SRC_AGENTS_SKILLS="${REPO_ROOT}/.agents/skills"
SRC_RULES="${REPO_ROOT}/.agents/rules"

echo ""
echo -e "${BOLD}Claude-Skills — Global Uninstall${RESET}"
echo -e "Repository : ${REPO_ROOT}"
echo ""
echo -e "${YELLOW}This will remove skill files that were installed by this repository.${RESET}"
echo -e "${YELLOW}Files not originating from this repo will NOT be touched.${RESET}"
echo ""

# =============================================================================
# Build list of what would be removed
# =============================================================================
declare -a TO_REMOVE=()

collect_removable_skills() {
  local src_base="$1"
  local dst_base="$2"

  [[ -d "${src_base}" ]] || return

  while IFS= read -r -d '' skill_dir; do
    skill_name="$(basename "${skill_dir}")"
    src_skill_md="${skill_dir}/SKILL.md"
    dst_skill_md="${dst_base}/${skill_name}/SKILL.md"
    dst_skill_dir="${dst_base}/${skill_name}"

    [[ -f "${src_skill_md}" ]] || continue

    if [[ -f "${dst_skill_md}" ]]; then
      # Only mark for removal if the content matches (belongs to this repo)
      if diff -q "${src_skill_md}" "${dst_skill_md}" > /dev/null 2>&1; then
        TO_REMOVE+=("${dst_skill_dir}")
      fi
    fi
  done < <(find "${src_base}" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
}

collect_removable_rules() {
  local src_base="$1"
  local dst_base="$2"

  [[ -d "${src_base}" && -d "${dst_base}" ]] || return

  while IFS= read -r -d '' rule_file; do
    rule_name="$(basename "${rule_file}")"
    dst_rule="${dst_base}/${rule_name}"
    if [[ -f "${dst_rule}" ]]; then
      if diff -q "${rule_file}" "${dst_rule}" > /dev/null 2>&1; then
        TO_REMOVE+=("${dst_rule}")
      fi
    fi
  done < <(find "${src_base}" -maxdepth 1 -type f -print0 | sort -z)
}

echo -e "${BOLD}Scanning for installed files ...${RESET}"
echo ""

collect_removable_skills "${SRC_AGENTS_SKILLS}" "${GEMINI_SKILLS_DIR}"
collect_removable_skills "${SRC_AGENTS_SKILLS}" "${CLAUDE_SKILLS_DIR}"
collect_removable_rules  "${SRC_RULES}"         "${GEMINI_RULES_DIR}"

if [[ "${#TO_REMOVE[@]}" -eq 0 ]]; then
  echo -e "${GREEN}Nothing to remove — no installed files found matching this repository.${RESET}"
  echo ""
  exit 0
fi

echo -e "The following will be removed:"
echo ""
for item in "${TO_REMOVE[@]}"; do
  echo -e "  ${RED}✗${RESET}  ${item}"
done
echo ""

# =============================================================================
# Confirm before deleting
# =============================================================================
echo -n "Proceed with removal of ${#TO_REMOVE[@]} item(s)? [y/N] "
read -r confirm
if [[ ! "${confirm}" =~ ^[Yy]$ ]]; then
  echo ""
  warn "Aborted. No files were removed."
  echo ""
  exit 0
fi

echo ""
echo -e "${BOLD}Removing files ...${RESET}"
echo ""

REMOVE_COUNT=0
for item in "${TO_REMOVE[@]}"; do
  if [[ -d "${item}" ]]; then
    rm -rf "${item}"
    removed_msg "${item}"
    REMOVE_COUNT=$((REMOVE_COUNT + 1))
  elif [[ -f "${item}" ]]; then
    rm -f "${item}"
    removed_msg "${item}"
    REMOVE_COUNT=$((REMOVE_COUNT + 1))
  else
    missing_msg "${item}"
  fi
done

# ── Clean up empty parent directories ────────────────────────────────────────
for parent_dir in "${GEMINI_SKILLS_DIR}" "${CLAUDE_SKILLS_DIR}" "${GEMINI_RULES_DIR}"; do
  if [[ -d "${parent_dir}" ]]; then
    remaining=$(find "${parent_dir}" -mindepth 1 -maxdepth 1 | wc -l | tr -d ' ')
    if [[ "${remaining}" -eq 0 ]]; then
      rmdir "${parent_dir}" 2>/dev/null || true
      info "Removed empty directory: ${parent_dir}"
    fi
  fi
done

# =============================================================================
# Summary
# =============================================================================
echo ""
echo -e "${BOLD}Uninstall complete.${RESET}"
echo -e "  Removed: ${REMOVE_COUNT} item(s)"
echo ""
echo -e "To reinstall: ${BOLD}bash ${REPO_ROOT}/scripts/install-global.sh${RESET}"
echo ""
