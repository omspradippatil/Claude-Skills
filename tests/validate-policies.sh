#!/usr/bin/env bash
# =============================================================================
# tests/validate-policies.sh — Policy and skill correctness tests
# Usage: bash tests/validate-policies.sh
# Exit code: 0 if all tests pass, 1 if any fail.
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

pass() { echo -e "  ${GREEN}✓ PASS${RESET}  $1"; PASS_COUNT=$((PASS_COUNT + 1)); }
fail() { echo -e "  ${RED}✗ FAIL${RESET}  $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

section() {
  echo ""
  echo -e "${CYAN}${BOLD}── $1 ──────────────────────────────────────────────${RESET}"
}

# ── Resolve repo root ─────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

echo ""
echo -e "${BOLD}Claude-Skills: Policy & Skill Validation Tests${RESET}"
echo -e "Repo: ${REPO_ROOT}"
echo -e "$(date '+%Y-%m-%d %H:%M:%S')"

# =============================================================================
# Test Group 1: Policy files have non-empty # headings
# =============================================================================
section "Policy File Headings"

POLICY_FILES=(
  "policies/core.md"
  "policies/security.md"
  "policies/seo.md"
  "policies/frontend.md"
  "policies/testing.md"
)

for pf in "${POLICY_FILES[@]}"; do
  if [[ ! -f "${REPO_ROOT}/${pf}" ]]; then
    fail "${pf}: file not found"
    continue
  fi

  # Check that the file has at least one "# Heading" line (not just ##)
  if grep -qE '^# .+' "${REPO_ROOT}/${pf}"; then
    heading="$(grep -m1 -E '^# .+' "${REPO_ROOT}/${pf}")"
    pass "${pf}: has heading → \"${heading}\""
  else
    fail "${pf}: no top-level '# Heading' found"
  fi
done

# =============================================================================
# Test Group 2: CLAUDE.md references all policy files
# =============================================================================
section "CLAUDE.md References Policy Files"

CLAUDE_MD="${REPO_ROOT}/CLAUDE.md"

if [[ ! -f "${CLAUDE_MD}" ]]; then
  fail "CLAUDE.md not found — skipping reference checks"
else
  for pf in "${POLICY_FILES[@]}"; do
    policy_name="$(basename "${pf}")"
    # Accept references as either filename or full path fragment
    if grep -qF "${policy_name}" "${CLAUDE_MD}" || grep -qF "${pf}" "${CLAUDE_MD}"; then
      pass "CLAUDE.md references ${policy_name}"
    else
      fail "CLAUDE.md does not reference ${policy_name}"
    fi
  done
fi

# =============================================================================
# Test Group 3: AGENTS.md references .agents/skills/
# =============================================================================
section "AGENTS.md References .agents/skills/"

AGENTS_MD="${REPO_ROOT}/AGENTS.md"

if [[ ! -f "${AGENTS_MD}" ]]; then
  fail "AGENTS.md not found"
else
  if grep -qF ".agents/skills" "${AGENTS_MD}"; then
    pass "AGENTS.md references .agents/skills/"
  else
    fail "AGENTS.md does not reference .agents/skills/"
  fi
fi

# =============================================================================
# Test Group 4: Each .agents/skills/ SKILL.md has valid YAML frontmatter
# =============================================================================
section "SKILL.md YAML Frontmatter"

AGENTS_SKILLS_DIR="${REPO_ROOT}/.agents/skills"

if [[ ! -d "${AGENTS_SKILLS_DIR}" ]]; then
  fail ".agents/skills/ directory not found — skipping frontmatter checks"
else
  SKILL_COUNT=0
  while IFS= read -r -d '' skill_dir; do
    skill_name="$(basename "${skill_dir}")"
    skill_md="${skill_dir}/SKILL.md"

    if [[ ! -f "${skill_md}" ]]; then
      fail "${skill_name}/SKILL.md: file not found"
      continue
    fi

    SKILL_COUNT=$((SKILL_COUNT + 1))

    # Check that file starts with ---
    first_line="$(head -1 "${skill_md}")"
    if [[ "${first_line}" != "---" ]]; then
      fail "${skill_name}/SKILL.md: does not start with YAML frontmatter (---)"
      continue
    fi

    # Extract frontmatter block (between first and second ---)
    frontmatter="$(awk '/^---/{if(found) exit; found=1; next} found{print}' "${skill_md}")"

    # Check for 'name:' field
    if echo "${frontmatter}" | grep -qE '^name:\s*.+'; then
      name_val="$(echo "${frontmatter}" | grep -E '^name:' | head -1)"
      pass "${skill_name}/SKILL.md: has ${name_val}"
    else
      fail "${skill_name}/SKILL.md: missing 'name:' in frontmatter"
    fi

    # Check for 'description:' field
    if echo "${frontmatter}" | grep -qE '^description:\s*.+'; then
      desc_val="$(echo "${frontmatter}" | grep -E '^description:' | head -1)"
      pass "${skill_name}/SKILL.md: has ${desc_val}"
    else
      fail "${skill_name}/SKILL.md: missing 'description:' in frontmatter"
    fi

  done < <(find "${AGENTS_SKILLS_DIR}" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

  if [[ "${SKILL_COUNT}" -eq 0 ]]; then
    fail "No skill directories found in .agents/skills/"
  else
    echo -e "  ${CYAN}→${RESET}  Checked ${SKILL_COUNT} skill(s)"
  fi
fi

# =============================================================================
# Test Group 5: No skill directory referenced in CLAUDE.md that doesn't exist
# =============================================================================
section "CLAUDE.md Skill References Are Valid"

if [[ ! -f "${CLAUDE_MD}" ]]; then
  fail "CLAUDE.md not found — skipping skill reference validation"
else
  # Extract all references to .agents/skills/<name> or .claude/skills/<name>
  # Look for patterns like `.agents/skills/skill-name` or `.claude/skills/skill-name`
  referenced_skills=$(grep -oE '\.(agents|claude)/skills/[a-zA-Z0-9_-]+' "${CLAUDE_MD}" | sort -u || true)

  if [[ -z "${referenced_skills}" ]]; then
    echo -e "  ${YELLOW}·  INFO${RESET}  No specific skill paths found in CLAUDE.md to validate"
  else
    while IFS= read -r skill_ref; do
      skill_path="${REPO_ROOT}/${skill_ref}"
      if [[ -d "${skill_path}" ]]; then
        pass "Referenced skill exists: ${skill_ref}"
      else
        fail "Referenced skill NOT found: ${skill_ref}"
      fi
    done <<< "${referenced_skills}"
  fi
fi

# =============================================================================
# Summary
# =============================================================================
TOTAL=$((PASS_COUNT + FAIL_COUNT))
echo ""
echo -e "${BOLD}══════════════════════════════════════════════════════════${RESET}"
echo -e "${BOLD}  Test Summary${RESET}"
echo -e "${BOLD}══════════════════════════════════════════════════════════${RESET}"
echo -e "  Total tests : ${TOTAL}"
echo -e "  ${GREEN}Passed${RESET}      : ${PASS_COUNT}"
echo -e "  ${RED}Failed${RESET}      : ${FAIL_COUNT}"
echo ""

if [[ "${FAIL_COUNT}" -eq 0 ]]; then
  echo -e "  ${GREEN}${BOLD}✓ All tests passed!${RESET}"
  echo ""
  exit 0
else
  echo -e "  ${RED}${BOLD}✗ ${FAIL_COUNT} test(s) failed.${RESET}"
  echo ""
  exit 1
fi
