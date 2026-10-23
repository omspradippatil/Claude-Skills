#!/usr/bin/env bash
# =============================================================================
# validate.sh — Repository structure validation script
# Usage: bash scripts/validate.sh
# Make executable: chmod +x scripts/validate.sh
# =============================================================================

set -euo pipefail

# ── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Counters ─────────────────────────────────────────────────────────────────
PASS_COUNT=0
FAIL_COUNT=0

# ── Helpers ───────────────────────────────────────────────────────────────────
pass() {
  echo -e "  ${GREEN}✓ PASS${RESET}  $1"
  PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
  echo -e "  ${RED}✗ FAIL${RESET}  $1"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

section() {
  echo ""
  echo -e "${CYAN}${BOLD}── $1 ──────────────────────────────────────────────${RESET}"
}

# ── Resolve repo root ─────────────────────────────────────────────────────────
# Support running from any directory by resolving relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

echo ""
echo -e "${BOLD}Claude-Skills Repository Validator${RESET}"
echo -e "Checking: ${REPO_ROOT}"
echo -e "$(date '+%Y-%m-%d %H:%M:%S')"

# =============================================================================
# 1. Required Policy Files
# =============================================================================
section "Policy Files"

POLICY_FILES=(
  "policies/core.md"
  "policies/security.md"
  "policies/seo.md"
  "policies/frontend.md"
  "policies/testing.md"
)

for pf in "${POLICY_FILES[@]}"; do
  if [[ -f "${REPO_ROOT}/${pf}" && -s "${REPO_ROOT}/${pf}" ]]; then
    pass "${pf} exists and is non-empty"
  elif [[ -f "${REPO_ROOT}/${pf}" ]]; then
    fail "${pf} exists but is empty"
  else
    fail "${pf} is MISSING"
  fi
done

# =============================================================================
# 2. Required Entry Point Files
# =============================================================================
section "Entry Point Files"

ENTRY_POINTS=(
  "CLAUDE.md"
  "AGENTS.md"
  "GEMINI.md"
)

for ep in "${ENTRY_POINTS[@]}"; do
  if [[ -f "${REPO_ROOT}/${ep}" && -s "${REPO_ROOT}/${ep}" ]]; then
    pass "${ep} exists and is non-empty"
  elif [[ -f "${REPO_ROOT}/${ep}" ]]; then
    fail "${ep} exists but is empty"
  else
    fail "${ep} is MISSING"
  fi
done

# =============================================================================
# 3. Skills Directories
# =============================================================================
section "Skills Directories"

# .agents/skills/ — must exist and contain at least one SKILL.md
if [[ -d "${REPO_ROOT}/.agents/skills" ]]; then
  pass ".agents/skills/ directory exists"
  AGENTS_SKILL_COUNT=$(find "${REPO_ROOT}/.agents/skills" -name "SKILL.md" | wc -l | tr -d ' ')
  if [[ "${AGENTS_SKILL_COUNT}" -ge 1 ]]; then
    pass ".agents/skills/ contains ${AGENTS_SKILL_COUNT} SKILL.md file(s)"
  else
    fail ".agents/skills/ has no SKILL.md files"
  fi
else
  fail ".agents/skills/ directory is MISSING"
fi

# .claude/skills/ — must exist and contain at least one SKILL.md
if [[ -d "${REPO_ROOT}/.claude/skills" ]]; then
  pass ".claude/skills/ directory exists"
  CLAUDE_SKILL_COUNT=$(find "${REPO_ROOT}/.claude/skills" -name "SKILL.md" | wc -l | tr -d ' ')
  if [[ "${CLAUDE_SKILL_COUNT}" -ge 1 ]]; then
    pass ".claude/skills/ contains ${CLAUDE_SKILL_COUNT} SKILL.md file(s)"
  else
    fail ".claude/skills/ has no SKILL.md files"
  fi
else
  fail ".claude/skills/ directory is MISSING"
fi

# =============================================================================
# 4. Cursor Rules
# =============================================================================
section "Cursor Rules"

if [[ -f "${REPO_ROOT}/.cursor/rules/always-on.mdc" ]]; then
  pass ".cursor/rules/always-on.mdc exists"
else
  fail ".cursor/rules/always-on.mdc is MISSING"
fi

# =============================================================================
# 5. install.sh Executable
# =============================================================================
section "install.sh Permissions"

if [[ -f "${REPO_ROOT}/install.sh" ]]; then
  if [[ -x "${REPO_ROOT}/install.sh" ]]; then
    pass "install.sh is executable"
  else
    fail "install.sh exists but is NOT executable (run: chmod +x install.sh)"
  fi
else
  fail "install.sh is MISSING"
fi

# =============================================================================
# 6. No Skill Directory Missing SKILL.md
# =============================================================================
section "Skill Completeness"

SKILL_MISSING=0

check_skill_dirs() {
  local base_dir="$1"
  if [[ ! -d "${base_dir}" ]]; then
    return
  fi
  while IFS= read -r -d '' skill_dir; do
    skill_name="$(basename "${skill_dir}")"
    skill_md="${skill_dir}/SKILL.md"
    if [[ ! -f "${skill_md}" ]]; then
      fail "${base_dir#${REPO_ROOT}/}/${skill_name}/ is missing SKILL.md"
      SKILL_MISSING=$((SKILL_MISSING + 1))
    fi
  done < <(find "${base_dir}" -mindepth 1 -maxdepth 1 -type d -print0)
}

check_skill_dirs "${REPO_ROOT}/.agents/skills"
check_skill_dirs "${REPO_ROOT}/.claude/skills"

if [[ "${SKILL_MISSING}" -eq 0 ]]; then
  pass "All skill directories contain SKILL.md"
fi

# =============================================================================
# 7. package.json
# =============================================================================
section "Project Files"

if [[ -f "${REPO_ROOT}/package.json" ]]; then
  pass "package.json exists"
else
  fail "package.json is MISSING"
fi

# =============================================================================
# Summary
# =============================================================================
TOTAL=$((PASS_COUNT + FAIL_COUNT))
echo ""
echo -e "${BOLD}══════════════════════════════════════════════════════════${RESET}"
echo -e "${BOLD}  Validation Summary${RESET}"
echo -e "${BOLD}══════════════════════════════════════════════════════════${RESET}"
echo -e "  Total checks : ${TOTAL}"
echo -e "  ${GREEN}Passed${RESET}        : ${PASS_COUNT}"
echo -e "  ${RED}Failed${RESET}        : ${FAIL_COUNT}"
echo ""

if [[ "${FAIL_COUNT}" -eq 0 ]]; then
  echo -e "  ${GREEN}${BOLD}✓ All checks passed!${RESET}"
  echo ""
  exit 0
else
  echo -e "  ${RED}${BOLD}✗ ${FAIL_COUNT} check(s) failed. Please fix the issues above.${RESET}"
  echo ""
  exit 1
fi
