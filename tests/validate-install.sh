#!/usr/bin/env bash
# =============================================================================
# tests/validate-install.sh — Install dry-run verification test
# Usage: bash tests/validate-install.sh
# Simulates install to a temp directory. Does NOT make any real changes.
# Exit code: 0 if all checks pass, 1 if any fail.
# =============================================================================

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

PASS_COUNT=0
FAIL_COUNT=0
NOTRUN_COUNT=0

pass()    { echo -e "  ${GREEN}✓ PASS${RESET}     $1"; PASS_COUNT=$((PASS_COUNT + 1)); }
fail()    { echo -e "  ${RED}✗ FAIL${RESET}     $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }
not_run() { echo -e "  ${YELLOW}· NOT RUN${RESET}  $1"; NOTRUN_COUNT=$((NOTRUN_COUNT + 1)); }
info()    { echo -e "  ${CYAN}→${RESET}          $1"; }

section() {
  echo ""
  echo -e "${CYAN}${BOLD}── $1 ──────────────────────────────────────────────${RESET}"
}

# ── Resolve repo root ─────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo ""
echo -e "${BOLD}Claude-Skills: Install Dry-Run Tests${RESET}"
echo -e "Repo: ${REPO_ROOT}"
echo -e "$(date '+%Y-%m-%d %H:%M:%S')"
echo ""
echo -e "${YELLOW}NOTE: This test does NOT make any real changes to your system.${RESET}"

# =============================================================================
# Test 1: git availability
# =============================================================================
section "Prerequisite: git"

if command -v git &> /dev/null; then
  GIT_VERSION="$(git --version)"
  pass "git is available: ${GIT_VERSION}"
else
  fail "git is NOT available — install.sh will fail without it"
fi

# =============================================================================
# Test 2: Repo URL reachability (dry-run, no clone)
# =============================================================================
section "Repository Reachability (Dry Run)"

REPO_URL="https://github.com/omspradippatil/Claude-Skills.git"

# Detect offline state using a simple ping or skip entirely
if ! command -v git &> /dev/null; then
  not_run "Cannot check repo URL — git not available"
else
  # Use git ls-remote with a short timeout — pure metadata check, no clone
  echo ""
  info "Checking: git ls-remote --exit-code ${REPO_URL}"
  info "(This is a dry-run metadata check — no clone performed)"
  echo ""

  if git ls-remote --exit-code --heads "${REPO_URL}" > /dev/null 2>&1; then
    pass "Repository is reachable: ${REPO_URL}"
  else
    not_run "Repository not reachable (offline environment or URL may differ) — SKIPPED"
    echo -e "         ${YELLOW}URL checked: ${REPO_URL}${RESET}"
    echo -e "         ${YELLOW}Update REPO_URL in this script if your remote differs.${RESET}"
  fi
fi

# =============================================================================
# Test 3: Install source directories exist in repo
# =============================================================================
section "Source Directory Checks"

SRC_PATHS=(
  ".agents/skills"
  ".claude/skills"
)

for sp in "${SRC_PATHS[@]}"; do
  full_path="${REPO_ROOT}/${sp}"
  if [[ -d "${full_path}" ]]; then
    count=$(find "${full_path}" -name "SKILL.md" | wc -l | tr -d ' ')
    pass "${sp}/ exists — contains ${count} SKILL.md file(s)"
  else
    fail "${sp}/ NOT found in repo (install would fail)"
  fi
done

RULES_PATH="${REPO_ROOT}/.agents/rules"
if [[ -d "${RULES_PATH}" ]]; then
  count=$(find "${RULES_PATH}" -maxdepth 1 -type f | wc -l | tr -d ' ')
  pass ".agents/rules/ exists — contains ${count} rule file(s)"
else
  info ".agents/rules/ not found (optional — rules install will be skipped)"
fi

# =============================================================================
# Test 4: Verify expected installation targets (accessibility check)
# =============================================================================
section "Installation Target Paths"

echo ""
info "Expected global installation targets:"
echo ""

TARGET_PATHS=(
  "${HOME}/.gemini/config/skills    ← .agents/skills/"
  "${HOME}/.claude/skills           ← .agents/skills/"
  "${HOME}/.gemini/config/rules     ← .agents/rules/ (optional)"
)

for target_desc in "${TARGET_PATHS[@]}"; do
  target_path="${target_desc%%[ ←]*}"
  target_path="${target_path%"${target_path##*[![:space:]]}"}"  # trim trailing space

  if [[ -d "${target_path}" ]]; then
    echo -e "  ${GREEN}✓  ACCESSIBLE${RESET}  ${target_desc}"
    PASS_COUNT=$((PASS_COUNT + 1))
  else
    echo -e "  ${YELLOW}·  NOT EXISTS${RESET}  ${target_desc}  (will be created on install)"
    NOTRUN_COUNT=$((NOTRUN_COUNT + 1))
  fi
done

# =============================================================================
# Test 5: Simulate copy (temp dir dry run)
# =============================================================================
section "Dry-Run Copy Simulation"

SRC_AGENTS="${REPO_ROOT}/.agents/skills"

if [[ ! -d "${SRC_AGENTS}" ]]; then
  not_run "Source .agents/skills/ not found — cannot simulate copy"
else
  TMP_SIM="$(mktemp -d)"
  trap 'rm -rf "${TMP_SIM}"' EXIT

  info "Simulating copy to temp dir: ${TMP_SIM}"

  SIM_SUCCESS=true
  SKILL_DIRS=()

  while IFS= read -r -d '' skill_dir; do
    skill_name="$(basename "${skill_dir}")"
    src_skill_md="${skill_dir}/SKILL.md"
    dst_dir="${TMP_SIM}/skills/${skill_name}"

    [[ -f "${src_skill_md}" ]] || continue

    mkdir -p "${dst_dir}"
    if cp "${src_skill_md}" "${dst_dir}/SKILL.md" 2>/dev/null; then
      SKILL_DIRS+=("${skill_name}")
    else
      fail "Could not simulate copy for ${skill_name}/SKILL.md"
      SIM_SUCCESS=false
    fi
  done < <(find "${SRC_AGENTS}" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

  if [[ "${SIM_SUCCESS}" == "true" ]]; then
    pass "Dry-run copy succeeded for ${#SKILL_DIRS[@]} skill(s): ${SKILL_DIRS[*]:-none}"
  fi

  info "Cleaning up temp dir: ${TMP_SIM}"
fi

# =============================================================================
# Test 6: install.sh script is executable
# =============================================================================
section "install.sh Executable"

if [[ -f "${REPO_ROOT}/install.sh" ]]; then
  if [[ -x "${REPO_ROOT}/install.sh" ]]; then
    pass "install.sh is executable"
  else
    fail "install.sh is NOT executable — run: chmod +x install.sh"
  fi
else
  fail "install.sh not found"
fi

# =============================================================================
# Summary
# =============================================================================
TOTAL=$((PASS_COUNT + FAIL_COUNT + NOTRUN_COUNT))
echo ""
echo -e "${BOLD}══════════════════════════════════════════════════════════${RESET}"
echo -e "${BOLD}  Test Summary${RESET}"
echo -e "${BOLD}══════════════════════════════════════════════════════════${RESET}"
echo -e "  Total checks : ${TOTAL}"
echo -e "  ${GREEN}Passed${RESET}       : ${PASS_COUNT}"
echo -e "  ${RED}Failed${RESET}       : ${FAIL_COUNT}"
echo -e "  ${YELLOW}Not Run${RESET}      : ${NOTRUN_COUNT}  (network-dependent or non-existent paths)"
echo ""

if [[ "${FAIL_COUNT}" -eq 0 ]]; then
  echo -e "  ${GREEN}${BOLD}✓ All runnable tests passed!${RESET}"
  echo ""
  exit 0
else
  echo -e "  ${RED}${BOLD}✗ ${FAIL_COUNT} test(s) failed.${RESET}"
  echo ""
  exit 1
fi
