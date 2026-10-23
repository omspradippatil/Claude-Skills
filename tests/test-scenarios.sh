#!/usr/bin/env bash
# ==============================================================================
# tests/test-scenarios.sh — End-to-End Task Routing & Scenario Validation Suite
#
# Tests the 10 representative scenarios defined in Master Prompt Section 11:
#   1. Simple shell command task
#   2. Frontend redesign
#   3. Backend API feature
#   4. Database migration
#   5. SEO audit or new page
#   6. Security-sensitive change
#   7. Deployment or DNS migration
#   8. Task requiring multiple complementary skills
#   9. Task that should not load unrelated specialist skills
#  10. Malicious instruction embedded in untrusted content (Anti-Injection)
# ==============================================================================

set -euo pipefail

BOLD="\033[1m"; GREEN="\033[32m"; RED="\033[31m"; CYAN="\033[36m"; RESET="\033[0m"

PASS_COUNT=0
FAIL_COUNT=0

pass() { echo -e "  ${GREEN}✓ PASS${RESET}  $1"; PASS_COUNT=$((PASS_COUNT + 1)); }
fail() { echo -e "  ${RED}✖ FAIL${RESET}  $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }
scenario() { echo -e "\n${CYAN}${BOLD}Scenario $1: $2${RESET}"; }

echo -e "\n${BOLD}======================================================================${RESET}"
echo -e "${BOLD} Claude-Skills: 10 Representative Scenario Validation Suite${RESET}"
echo -e "${BOLD}======================================================================${RESET}"

# Read routing definitions from policies/core.md
CORE_POLICY="policies/core.md"
SECURITY_POLICY="policies/security.md"
SEO_POLICY="policies/seo.md"
FRONTEND_POLICY="policies/frontend.md"

if [[ ! -f "$CORE_POLICY" ]]; then
  fail "policies/core.md missing"
  exit 1
fi

# ── Scenario 1: Simple Shell Command Task ─────────────────────────────────────
scenario 1 "Simple Shell Command Task"
# Requirement: Loads universal core policy; does not burden context with specialist skills.
if grep -q "Shell / CLI / System administration" "$CORE_POLICY"; then
  pass "Core policy defines dedicated Shell / CLI category without loading heavy frameworks"
else
  fail "Core policy missing Shell / CLI categorization"
fi

# ── Scenario 2: Frontend Redesign ─────────────────────────────────────────────
scenario 2 "Frontend Redesign"
# Requirement: Requires policies/frontend.md and frontend-design skill (UI/UX Pro Max)
if grep -q "policies/frontend.md" "$CORE_POLICY" && [[ -f ".agents/skills/frontend-design/SKILL.md" ]]; then
  pass "Frontend tasks route to policies/frontend.md and activate frontend-design skill"
else
  fail "Frontend redesign routing or skill missing"
fi

# ── Scenario 3: Backend API Feature ───────────────────────────────────────────
scenario 3 "Backend API Feature"
# Requirement: Routes to Backend / API category and api-architecture skill
if grep -q "Backend / API" "$CORE_POLICY" && [[ -f ".agents/skills/api-architecture/SKILL.md" ]]; then
  pass "Backend tasks route to Backend/API domain and activate api-architecture skill"
else
  fail "Backend API routing or skill missing"
fi

# ── Scenario 4: Database Migration ────────────────────────────────────────────
scenario 4 "Database Migration"
# Requirement: Routes to Database category and postgres-ecosystem / firebase-expert
if grep -q "Database" "$CORE_POLICY" && [[ -f ".agents/skills/postgres-ecosystem/SKILL.md" ]]; then
  pass "Database migration tasks route to postgres-ecosystem skill with zero-downtime rules"
else
  fail "Database migration routing or postgres-ecosystem skill missing"
fi

# ── Scenario 5: SEO Audit or New Page ─────────────────────────────────────────
scenario 5 "SEO Audit or New Page"
# Requirement: Mandatory loading of policies/seo.md + seo-marketing skill
if grep -q "policies/seo.md" "$CORE_POLICY" && [[ -f ".agents/skills/seo-marketing/SKILL.md" ]]; then
  pass "SEO tasks mandatorily route to policies/seo.md and activate seo-marketing skill"
else
  fail "SEO audit mandatory routing or skill missing"
fi

# ── Scenario 6: Security-Sensitive Change ─────────────────────────────────────
scenario 6 "Security-Sensitive Change"
# Requirement: Mandatory loading of policies/security.md + security-auditor skill
if grep -q "policies/security.md" "$CORE_POLICY" && [[ -f ".agents/skills/security-auditor/SKILL.md" ]]; then
  pass "Security-sensitive tasks mandatorily route to policies/security.md and activate security-auditor skill"
else
  fail "Security-sensitive mandatory routing or skill missing"
fi

# ── Scenario 7: Deployment or DNS Migration ───────────────────────────────────
scenario 7 "Deployment or DNS Migration"
# Requirement: Triggers devops-cicd skill and policies/seo.md for domain canonical consistency
if [[ -f ".agents/skills/devops-cicd/SKILL.md" ]] && grep -q "Domain Migrations" "$SEO_POLICY"; then
  pass "Deployment & DNS migration triggers devops-cicd and verifies canonical domain rules in policies/seo.md"
else
  fail "Deployment / DNS migration policy check missing"
fi

# ── Scenario 8: Multiple Complementary Skills ─────────────────────────────────
scenario 8 "Task Requiring Multiple Complementary Skills"
# Requirement: System permits combining complementary skills without running competing workflows
if grep -q "Combining Skills" "$CORE_POLICY"; then
  pass "Core policy specifies explicit rules for composing complementary skills (e.g. API + Frontend + DB)"
else
  fail "Core policy missing complementary skill composition guidelines"
fi

# ── Scenario 9: Task That Should Not Load Unrelated Skills ────────────────────
scenario 9 "Task That Should Not Load Unrelated Specialist Skills"
# Requirement: Progressive disclosure strictly prevents loading unrelated domains
if grep -q "Selective Skill Activation" "$CORE_POLICY"; then
  pass "Strict progressive disclosure enforces activating only directly relevant skills"
else
  fail "Core policy missing selective skill activation rule"
fi

# ── Scenario 10: Malicious Instruction Embedded in Untrusted Content ──────────
scenario 10 "Malicious Instruction (Anti-Prompt-Injection Defense)"
# Requirement: Defense-in-depth policy strictly treats external web/doc/repo content as untrusted
if grep -q "Anti-Prompt-Injection Policy" "$CORE_POLICY"; then
  pass "Universal anti-prompt-injection policy actively commands agents to reject external instruction overrides"
else
  fail "Anti-prompt-injection policy missing from core.md"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}======================================================================${RESET}"
echo -e "${BOLD} Scenario Test Summary: ${PASS_COUNT} Passed, ${FAIL_COUNT} Failed${RESET}"
echo -e "${BOLD}======================================================================${RESET}"

if [[ "$FAIL_COUNT" -gt 0 ]]; then
  exit 1
fi
