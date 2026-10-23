#!/usr/bin/env bash
# =============================================================================
# install-global.sh — Install Claude-Skills globally to user config dirs
# Usage: bash scripts/install-global.sh [--force]
# Does NOT require elevated (sudo) permissions.
# =============================================================================

set -euo pipefail

FORCE=false
for arg in "$@"; do
  case "${arg}" in
    --force|-f) FORCE=true ;;
    --help|-h)
      echo "Usage: bash scripts/install-global.sh [--force]"
      echo ""
      echo "Options:"
      echo "  --force, -f   Overwrite existing files in destination dirs"
      echo "  --help,  -h   Show this help message"
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

# ── Resolve repo root ─────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ── Temp dir with guaranteed cleanup ─────────────────────────────────────────
TMPDIR_WORK=""
cleanup() {
  if [[ -n "${TMPDIR_WORK}" && -d "${TMPDIR_WORK}" ]]; then
    rm -rf "${TMPDIR_WORK}"
    info "Cleaned up temp directory."
  fi
}
trap cleanup EXIT

echo ""
echo -e "${BOLD}Claude-Skills — Global Install${RESET}"
echo -e "Repository : ${REPO_ROOT}"
echo -e "Force mode : ${FORCE}"
echo ""

# =============================================================================
# Step 1: Prerequisites
# =============================================================================
echo -e "${BOLD}[1/4] Checking prerequisites ...${RESET}"

PREREQS_OK=true

if command -v git &> /dev/null; then
  pass "git found: $(git --version)"
else
  fail "git not found — please install git and re-run"
  PREREQS_OK=false
fi

if command -v node &> /dev/null; then
  pass "node found: $(node --version)  (optional)"
else
  warn "node not found — some features may be unavailable (optional)"
fi

if [[ "${PREREQS_OK}" == "false" ]]; then
  echo ""
  echo -e "${RED}Prerequisites check failed. Aborting.${RESET}"
  exit 1
fi

# =============================================================================
# Step 2: Prepare temp dir (simulates a fresh clone for path safety)
# =============================================================================
echo ""
echo -e "${BOLD}[2/4] Preparing source ...${RESET}"

TMPDIR_WORK="$(mktemp -d)"
info "Temp dir: ${TMPDIR_WORK}"

# We are already inside the repo, so we copy from REPO_ROOT directly.
# This avoids a network clone when running from the source repo itself.
info "Using local repo as source (no network required)"
pass "Source ready: ${REPO_ROOT}"

# =============================================================================
# Step 3: Define destination paths
# =============================================================================
echo ""
echo -e "${BOLD}[3/4] Installing files ...${RESET}"

GEMINI_SKILLS_DIR="${HOME}/.gemini/config/skills"
CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"
GEMINI_RULES_DIR="${HOME}/.gemini/config/rules"

SRC_AGENTS_SKILLS="${REPO_ROOT}/.agents/skills"
SRC_CLAUDE_SKILLS="${REPO_ROOT}/.claude/skills"
SRC_RULES="${REPO_ROOT}/.agents/rules"

# ── Helper: copy a skill directory ───────────────────────────────────────────
copy_skill_dir() {
  local src_base="$1"
  local dst_base="$2"
  local label="$3"

  if [[ ! -d "${src_base}" ]]; then
    warn "Source ${src_base} does not exist — skipping ${label}"
    return
  fi

  mkdir -p "${dst_base}"
  local copied=0
  local skipped=0

  while IFS= read -r -d '' skill_dir; do
    skill_name="$(basename "${skill_dir}")"
    dst_skill="${dst_base}/${skill_name}"
    src_skill_md="${skill_dir}/SKILL.md"

    if [[ ! -f "${src_skill_md}" ]]; then
      warn "  ${skill_name}/SKILL.md missing in source — skipping"
      continue
    fi

    mkdir -p "${dst_skill}"
    dst_skill_md="${dst_skill}/SKILL.md"

    if [[ -f "${dst_skill_md}" && "${FORCE}" == "false" ]]; then
      echo -e "    ${YELLOW}·  SKIP${RESET}  ${label}/${skill_name}/SKILL.md  (already exists; use --force to overwrite)"
      skipped=$((skipped + 1))
    else
      cp "${src_skill_md}" "${dst_skill_md}"
      echo -e "    ${GREEN}↓  COPY${RESET}  ${label}/${skill_name}/SKILL.md"
      copied=$((copied + 1))
    fi
  done < <(find "${src_base}" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

  pass "  ${label}: ${copied} copied, ${skipped} skipped"
}

# ── Copy .agents/skills/ → ~/.gemini/config/skills/ ─────────────────────────
echo ""
info "Installing Antigravity skills → ${GEMINI_SKILLS_DIR}"
copy_skill_dir "${SRC_AGENTS_SKILLS}" "${GEMINI_SKILLS_DIR}" "~/.gemini/config/skills"

# ── Copy .agents/skills/ → ~/.claude/skills/ ────────────────────────────────
echo ""
info "Installing Claude Code skills → ${CLAUDE_SKILLS_DIR}"
copy_skill_dir "${SRC_AGENTS_SKILLS}" "${CLAUDE_SKILLS_DIR}" "~/.claude/skills"

# ── Copy .agents/rules/ → ~/.gemini/config/rules/ (if exists) ───────────────
echo ""
if [[ -d "${SRC_RULES}" && -d "${HOME}/.gemini/config" ]]; then
  info "Installing rules → ${GEMINI_RULES_DIR}"
  mkdir -p "${GEMINI_RULES_DIR}"
  local_rule_copied=0
  local_rule_skipped=0
  while IFS= read -r -d '' rule_file; do
    rule_name="$(basename "${rule_file}")"
    dst_rule="${GEMINI_RULES_DIR}/${rule_name}"
    if [[ -f "${dst_rule}" && "${FORCE}" == "false" ]]; then
      echo -e "    ${YELLOW}·  SKIP${RESET}  ~/.gemini/config/rules/${rule_name}  (exists; use --force)"
      local_rule_skipped=$((local_rule_skipped + 1))
    else
      cp "${rule_file}" "${dst_rule}"
      echo -e "    ${GREEN}↓  COPY${RESET}  ~/.gemini/config/rules/${rule_name}"
      local_rule_copied=$((local_rule_copied + 1))
    fi
  done < <(find "${SRC_RULES}" -maxdepth 1 -type f -print0 | sort -z)
  pass "  ~/.gemini/config/rules: ${local_rule_copied} copied, ${local_rule_skipped} skipped"
else
  warn "~/.gemini/config/rules not installed (source missing or ~/.gemini/config absent)"
fi

# =============================================================================
# Step 4: Summary
# =============================================================================
echo ""
echo -e "${BOLD}[4/4] Done.${RESET}"
echo ""
echo -e "${GREEN}${BOLD}Global install complete!${RESET}"
echo ""
echo -e "Skills installed to:"
echo -e "  • ${GEMINI_SKILLS_DIR}"
echo -e "  • ${CLAUDE_SKILLS_DIR}"
echo ""
echo -e "To verify: ${BOLD}bash ${REPO_ROOT}/scripts/validate.sh${RESET}"
echo ""
