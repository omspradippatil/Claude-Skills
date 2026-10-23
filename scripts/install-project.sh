#!/usr/bin/env bash
# =============================================================================
# install-project.sh — Install Claude-Skills into the CURRENT working directory
# Usage: cd /your/project && bash /path/to/Claude-Skills/scripts/install-project.sh
# =============================================================================

set -euo pipefail

FORCE=false
SKIP_GITIGNORE=false

for arg in "$@"; do
  case "${arg}" in
    --force|-f)        FORCE=true ;;
    --no-gitignore)    SKIP_GITIGNORE=true ;;
    --help|-h)
      echo "Usage: bash scripts/install-project.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --force, -f       Overwrite existing files without prompting"
      echo "  --no-gitignore    Skip adding skills dirs to .gitignore"
      echo "  --help,  -h       Show this help message"
      echo ""
      echo "Run this script from the TARGET project root."
      exit 0
      ;;
    *)
      echo "Unknown argument: ${arg}" >&2
      exit 1
      ;;
  esac
done

# ── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

pass()  { echo -e "  ${GREEN}✓${RESET}  $1"; }
fail()  { echo -e "  ${RED}✗${RESET}  $1"; }
info()  { echo -e "  ${CYAN}→${RESET}  $1"; }
warn()  { echo -e "  ${YELLOW}⚠${RESET}  $1"; }

# ── Paths ─────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TARGET_DIR="$(pwd)"

if [[ "${TARGET_DIR}" == "${REPO_ROOT}" ]]; then
  warn "You are running this from inside the Claude-Skills repo itself."
  warn "This script is intended to install into a DIFFERENT project directory."
  echo -n "Continue anyway? [y/N] "
  read -r confirm
  [[ "${confirm}" =~ ^[Yy]$ ]] || exit 0
fi

echo ""
echo -e "${BOLD}Claude-Skills — Project Install${RESET}"
echo -e "Source      : ${REPO_ROOT}"
echo -e "Target      : ${TARGET_DIR}"
echo -e "Force mode  : ${FORCE}"
echo ""

# =============================================================================
# Helper: confirm before overwriting
# =============================================================================
confirm_overwrite() {
  local file_path="$1"
  if [[ "${FORCE}" == "true" ]]; then
    return 0  # always proceed
  fi
  echo -n "  ${YELLOW}⚠  ${file_path} already exists. Overwrite? [y/N]${RESET} "
  read -r answer
  [[ "${answer}" =~ ^[Yy]$ ]]
}

# =============================================================================
# Helper: copy a skill directory tree
# =============================================================================
copy_skills() {
  local src_base="$1"
  local dst_base="$2"
  local label="$3"

  if [[ ! -d "${src_base}" ]]; then
    warn "Source ${label} (${src_base}) does not exist — skipping"
    return
  fi

  mkdir -p "${dst_base}"
  local copied=0 skipped=0

  while IFS= read -r -d '' skill_dir; do
    skill_name="$(basename "${skill_dir}")"
    dst_skill="${dst_base}/${skill_name}"
    src_skill_md="${skill_dir}/SKILL.md"

    [[ -f "${src_skill_md}" ]] || continue

    mkdir -p "${dst_skill}"
    dst_skill_md="${dst_skill}/SKILL.md"

    if [[ -f "${dst_skill_md}" && "${FORCE}" == "false" ]]; then
      echo -e "    ${YELLOW}·  SKIP${RESET}  ${label}/${skill_name}/SKILL.md  (exists)"
      skipped=$((skipped + 1))
    else
      cp "${src_skill_md}" "${dst_skill_md}"
      echo -e "    ${GREEN}↓  COPY${RESET}  ${label}/${skill_name}/SKILL.md"
      copied=$((copied + 1))
    fi
  done < <(find "${src_base}" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

  pass "${label}: ${copied} copied, ${skipped} skipped"
}

# =============================================================================
# Step 1: Copy .agents/skills/
# =============================================================================
echo -e "${BOLD}[1/5] Copying .agents/skills/ ...${RESET}"
copy_skills "${REPO_ROOT}/.agents/skills" "${TARGET_DIR}/.agents/skills" ".agents/skills"

# =============================================================================
# Step 2: Copy .claude/skills/
# =============================================================================
echo ""
echo -e "${BOLD}[2/5] Copying .claude/skills/ ...${RESET}"
copy_skills "${REPO_ROOT}/.claude/skills" "${TARGET_DIR}/.claude/skills" ".claude/skills"

# =============================================================================
# Step 3: Copy entry point files (CLAUDE.md, AGENTS.md, GEMINI.md)
# =============================================================================
echo ""
echo -e "${BOLD}[3/5] Copying entry point files ...${RESET}"

ENTRY_FILES=("CLAUDE.md" "AGENTS.md" "GEMINI.md")
for entry in "${ENTRY_FILES[@]}"; do
  src_entry="${REPO_ROOT}/${entry}"
  dst_entry="${TARGET_DIR}/${entry}"

  if [[ ! -f "${src_entry}" ]]; then
    warn "${entry} not found in source — skipping"
    continue
  fi

  if [[ -f "${dst_entry}" ]]; then
    if confirm_overwrite "${entry}"; then
      cp "${src_entry}" "${dst_entry}"
      pass "Overwrote ${entry}"
    else
      info "Skipped ${entry}"
    fi
  else
    cp "${src_entry}" "${dst_entry}"
    pass "Copied ${entry}"
  fi
done

# =============================================================================
# Step 4: Optionally update .gitignore
# =============================================================================
echo ""
echo -e "${BOLD}[4/5] .gitignore ...${RESET}"

if [[ "${SKIP_GITIGNORE}" == "true" ]]; then
  info "Skipping .gitignore update (--no-gitignore)"
else
  GITIGNORE="${TARGET_DIR}/.gitignore"
  ADDED_GITIGNORE=false

  add_gitignore_entry() {
    local entry="$1"
    if [[ -f "${GITIGNORE}" ]] && grep -qF "${entry}" "${GITIGNORE}" 2>/dev/null; then
      info ".gitignore already contains: ${entry}"
    else
      echo "${entry}" >> "${GITIGNORE}"
      pass "Added to .gitignore: ${entry}"
      ADDED_GITIGNORE=true
    fi
  }

  echo -n "  Add .agents/skills/ and .claude/skills/ to .gitignore? [Y/n] "
  read -r gi_answer
  if [[ ! "${gi_answer}" =~ ^[Nn]$ ]]; then
    add_gitignore_entry ".agents/skills/"
    add_gitignore_entry ".claude/skills/"
    [[ "${ADDED_GITIGNORE}" == "false" ]] && info "No new entries needed"
  else
    info ".gitignore not modified"
  fi
fi

# =============================================================================
# Step 5: Summary
# =============================================================================
echo ""
echo -e "${BOLD}[5/5] Done.${RESET}"
echo ""
echo -e "${GREEN}${BOLD}Project install complete!${RESET}"
echo ""
echo -e "Installed into: ${TARGET_DIR}"
echo ""
echo -e "Next steps:"
echo -e "  • Run ${BOLD}bash ${REPO_ROOT}/scripts/validate.sh${RESET} to verify"
echo -e "  • Run ${BOLD}bash ${REPO_ROOT}/scripts/sync-skills.sh${RESET} to keep skills in sync"
echo ""
