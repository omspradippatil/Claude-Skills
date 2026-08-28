#!/usr/bin/env bash

# ==============================================================================
# 🚀 AI Agent Skills Installer & Manager (macOS & Linux)
# Repository: https://github.com/omspradippatil/Claude-Skills
# ==============================================================================

# Color Palette & Formatting
BOLD="\033[1m"
DIM="\033[2m"
CYAN="\033[36m"
BLUE="\033[34m"
GREEN="\033[32m"
YELLOW="\033[33m"
MAGENTA="\033[35m"
RED="\033[31m"
RESET="\033[0m"

# Print helper functions
print_banner() {
  echo -e "${CYAN}${BOLD}"
  echo "╔═════════════════════════════════════════════════════════════════════════╗"
  echo "║                ⚡ AI CODING SKILLS & AGENT SUITE ⚡                    ║"
  echo "║         High-Performance Skills & Tooling for AI Coding Agents          ║"
  echo "╚═════════════════════════════════════════════════════════════════════════╝"
  echo -e "${RESET}"
}

print_header() {
  echo ""
  echo -e "${MAGENTA}${BOLD}==============================================================================${RESET}"
  echo -e "${MAGENTA}${BOLD} $1 ${RESET}"
  echo -e "${MAGENTA}${BOLD}==============================================================================${RESET}"
}

run_step() {
  local title="$1"
  local description="$2"
  local cmd="$3"

  echo ""
  echo -e "${CYAN}▶ ${BOLD}${title}${RESET}"
  echo -e "  ${DIM}Purpose:${RESET} ${description}"
  echo -e "  ${DIM}Command:${RESET} ${YELLOW}${cmd}${RESET}"

  eval "$cmd"
  local exit_code=$?

  if [ $exit_code -eq 0 ]; then
    echo -e "  ${GREEN}✔ Completed successfully!${RESET}"
  else
    echo -e "  ${RED}✖ Warning: Command exited with status ${exit_code}. Continuing...${RESET}"
  fi
}

check_prerequisites() {
  echo -e "${BLUE}${BOLD}🔍 Checking system prerequisites...${RESET}"
  
  if command -v node >/dev/null 2>&1; then
    echo -e "  ${GREEN}✔ Node.js:${RESET} $(node -v)"
  else
    echo -e "  ${RED}✖ Node.js is not installed!${RESET} Please install Node.js (https://nodejs.org) to use npx & npm skills."
  fi

  if command -v npm >/dev/null 2>&1; then
    echo -e "  ${GREEN}✔ npm:${RESET} $(npm -v)"
  else
    echo -e "  ${RED}✖ npm is not installed!${RESET}"
  fi

  if command -v git >/dev/null 2>&1; then
    echo -e "  ${GREEN}✔ Git:${RESET} $(git --version)"
  else
    echo -e "  ${YELLOW}⚠ Git is not installed! Some repository skills may fail.${RESET}"
  fi
  echo ""
}

# ==============================================================================
# INSTALLATION FUNCTIONS (ALL SKILLS SELECTED BY DEFAULT VIA --all)
# ==============================================================================

# 🎨 1. CORE UI/UX, DESIGN SYSTEMS & TASTE (PRIMARY FOCUS)
install_core_ui_ux() {
  print_header "🎨 1. CORE UI/UX, DESIGN SYSTEMS & TASTE"
  
  run_step "UI/UX Pro Max CLI" \
    "Generates design guidelines, UI heuristics, color palettes, accessibility checks, and layout hierarchies." \
    "npm install -g uipro-cli"

  run_step "Taste Skill" \
    "Enforces human-like visual balance, clean typography, whitespace discipline, and eliminates generic AI aesthetics." \
    "npx --yes skills@latest add Leonxlnx/taste-skill -g --all"

  run_step "Accessible & Performant Motion" \
    "Provides context for physics-based springs, easing curves, micro-interactions, gesture response, and 60fps animations." \
    "npx --yes skills@latest add mthines/agent-skills -g --all"
}

# 🏛️ 2. ARCHITECTURE & SYSTEM VISUALIZATION
install_architecture_skills() {
  print_header "🏛️ 2. ARCHITECTURE & SYSTEM VISUALIZATION"

  run_step "Archify System Mapper" \
    "Compiles codebase topology and workflows into beautiful, verifiable interactive HTML/SVG diagrams with motion." \
    "npx --yes skills@latest add tt-a1i/archify -g --all"
}

# 📱 3. MOBILE APP DEVELOPMENT (FLUTTER / DART / NATIVE)
install_mobile_skills() {
  print_header "📱 3. MOBILE APP DEVELOPMENT (FLUTTER / DART / NATIVE)"

  if command -v dart >/dev/null 2>&1; then
    run_step "Dart Skills CLI" \
      "Scans pubspec.yaml and registers official, package-specific instructions directly into your agent." \
      "dart pub global activate skills"
  else
    echo -e "${YELLOW}⚠ Dart SDK not found. Skipping 'dart pub global activate skills'. (Install Flutter/Dart if developing mobile apps).${RESET}"
  fi

  run_step "Community Flutter Claude Skills" \
    "Context rules for widget rebuild optimization, Riverpod/BLoC patterns, native bridges, and platform conventions." \
    "mkdir -p ~/.claude/skills && if [ -d ~/.claude/skills/flutter-skills ]; then git -C ~/.claude/skills/flutter-skills pull; else git clone https://github.com/Harishwarrior/flutter-claude-skills.git ~/.claude/skills/flutter-skills; fi"

  run_step "Fastlane Skills" \
    "Automates screenshot generation, keystore signing, metadata packaging, build numbering, and Play Store / TestFlight releases." \
    "npx --yes skills@latest add fastlane/agent-skills -g --all"

  run_step "OWASP Mobile & API Security Playbook" \
    "Audits mobile source code for hardcoded secrets, insecure IPC, weak local encryption, and broken mobile API endpoints." \
    "npx --yes skills@latest add OWASP/secure-agent-playbook -g --all"
}

# 🌐 4. WEB FRONTEND, DOM & BROWSER AUTOMATION
install_web_skills() {
  print_header "🌐 4. WEB FRONTEND, DOM & BROWSER AUTOMATION"

  run_step "Frontend Agent Skills" \
    "Web-specific accessibility (WCAG), semantic HTML, responsive CSS grid/flexbox layouts, and UX copy formatting." \
    "npx --yes skills@latest add hueyexe/frontend-agent-skills -g --all"

  run_step "Web Design & Interaction Collection" \
    "Specialized CSS keyframes, layout transitions, scroll-driven effects, and Framer Motion patterns for modern websites." \
    "npx --yes skills@latest add MengTo/Skills -g --all"

  run_step "TestDino Playwright Skill" \
    "AI-powered Playwright testing toolkit: best practices, test generators, fixture optimizations, and flaky test healing." \
    "npx --yes skills@latest add testdino-hq/playwright-skill -g --all"

  run_step "Playwright Browser Automation CLI" \
    "Headless browser automation for UI visual regression checks, synthetic user workflows, E2E testing, and screenshots." \
    "npm install -g @playwright/cli@latest && playwright-cli install --skills"

  run_step "Firecrawl CLI" \
    "Crawls, cleans, and converts web pages into LLM-ready clean markdown for real-time web scraping and doc ingestion." \
    "npm install -g firecrawl-cli"
}

# 🔍 5. AGENTIC SEO & SEARCH VISIBILITY
install_seo_skills() {
  print_header "🔍 5. AGENTIC SEO & SEARCH OPTIMIZATION"

  run_step "Agentic SEO Skill Suite" \
    "LLM-first SEO analysis engine: 16 sub-skills, 10 specialist agents, and 89 utility scripts for deep audits and schemas." \
    "mkdir -p ~/.claude/skills/seo && if [ -d ~/.claude/skills/seo ]; then git -C ~/.claude/skills/seo pull; else git clone https://github.com/Bhanunamikaze/Agentic-SEO-Skill.git ~/.claude/skills/seo; fi"

  run_step "Ashley SEO & Indexing Agent" \
    "Audits technical on-page SEO, OpenGraph data, JSON-LD structured schemas, robots.txt, sitemaps, and Core Web Vitals." \
    "npx --yes skills@latest add ashleytheash/seo-agent-skill -g --all"
}

# 🔥 6. BACKEND, DATABASES & CLOUD EDGE
install_backend_skills() {
  print_header "🔥 6. BACKEND, DATABASES & CLOUD EDGE"

  run_step "Supabase Agent Skills" \
    "PostgreSQL architecture, Row Level Security (RLS) policies, Edge Functions (Deno), realtime subscriptions, and Auth triggers." \
    "npx --yes skills@latest add supabase/agent-skills -g --all"

  run_step "Firebase Agent Skills" \
    "Firestore document design, Firebase Cloud Messaging (FCM) push notifications, security rules, and serverless Cloud Functions." \
    "npx --yes skills@latest add firebase/agent-skills -g --all"

  run_step "Neon Database Skills" \
    "Serverless Postgres, database branching for PRs, index tuning, connection pooling, and low-latency SQL optimization." \
    "npx --yes skills@latest add neondatabase/agent-skills -g --all"

  run_step "Cloudflare Ecosystem" \
    "Workers, D1 SQL, R2 object storage, KV key-value stores, rate limiting, and edge API caching configurations." \
    "npx --yes skills@latest add https://github.com/cloudflare/skills -g --all"
}

# 🐳 7. DEVOPS, LOCAL INFRASTRUCTURE & INTEGRATIONS
install_devops_skills() {
  print_header "🐳 7. DEVOPS, LOCAL INFRASTRUCTURE & INTEGRATIONS"

  run_step "Docker Skills" \
    "Multi-stage Dockerfile generation, docker-compose orchestration, local database mock services, and container hardening." \
    "npx --yes skills@latest add docker/agent-skills -g --all"

  run_step "Composio Integration" \
    "Connects agent directly to GitHub Actions, repository issues, pull requests, Gmail alerts, and external workflow automations." \
    "npx --yes skills@latest add composiohq/skills -g --all"

  run_step "Postman / OpenAPI Skills" \
    "Ingests Swagger/OpenAPI specifications, generates strongly typed data models (Dart/TS), and automates endpoint contract testing." \
    "npx --yes skills@latest add postman/agent-skills -g --all"
}

# 🔄 8. INTELLIGENT WORKFLOWS & CROSS-AGENT PLUGINS
install_workflows_and_plugins() {
  print_header "🔄 8. INTELLIGENT WORKFLOWS & CROSS-AGENT PLUGINS"

  run_step "Antigravity Workflows CLI" \
    "Stack-agnostic, question-driven workflows that detect project frameworks and adapt step-by-step." \
    "npm install -g antigravity-workflows"

  run_step "Claude Skills Universal Library (388+ Skills)" \
    "Comprehensive suite of 388+ engineering, architecture, C-level advisory, security, and productivity skills." \
    "mkdir -p ~/.claude/skills/claude-skills && if [ -d ~/.claude/skills/claude-skills ]; then git -C ~/.claude/skills/claude-skills pull; else git clone https://github.com/alirezarezvani/claude-skills.git ~/.claude/skills/claude-skills; fi"
}

# 🧠 9. CODE QUALITY, SECURITY & PERSISTENT MEMORY
install_code_quality_skills() {
  print_header "🧠 9. CODE QUALITY, SECURITY & PERSISTENT MEMORY"

  run_step "Claude-Mem Persistent Session Context" \
    "Preserves context across sessions by capturing tool actions and injecting semantic summaries into future chats." \
    "npx --yes claude-mem install 2>/dev/null || npx --yes skills@latest add thedotmack/claude-mem -g --all"

  run_step "Andrej Karpathy Engineering Philosophy" \
    "Prioritizes clarity, minimal abstractions, readability, clean foundational code, and strict engineering discipline." \
    "npx --yes skills@latest add multica-ai/andrej-karpathy-skills -g --all"

  run_step "Caveman (Anti-Overengineering)" \
    "Eliminates framework bloat, prevents over-engineering, enforces simple directory architectures, and refuses micro-abstractions." \
    "npx --yes skills@latest add JuliusBrussee/caveman -g --all"

  run_step "Ponytail Skills" \
    "Enforces clean software design patterns, eliminating bloated libraries and preserving codebase simplicity." \
    "npx --yes skills@latest add https://github.com/DietrichGebert/ponytail/tree/main/skills -g --all"

  run_step "MemoryPlugin (Cross-Session Persistence)" \
    "Provides cross-session long-term memory so the agent retains project context, design preferences, and architectural decisions." \
    "npx --yes skills@latest add memoryplugin/agent-skills -g --all"

  run_step "Sentry for AI" \
    "Automated root-cause analysis for production exceptions, stack trace parsing, and regression pinpointing." \
    "npx --yes skills@latest add getsentry/sentry-for-ai -g --all"

  run_step "CTX7 Documentation Indexer" \
    "Indexes and injects the latest framework/library documentation directly into the agent context, eliminating hallucinations." \
    "npm install -g ctx7"
}

# ==============================================================================
# UNINSTALLATION / REMOVAL FUNCTIONS
# ==============================================================================

uninstall_all_skills() {
  print_header "🗑️  REMOVING ALL INSTALLED SKILLS & GLOBAL PACKAGES"
  
  echo -e "${YELLOW}Uninstalling all global skills CLI registry entries...${RESET}"
  npx --yes skills@latest remove --all -g -y 2>/dev/null || true

  echo -e "${YELLOW}Uninstalling global npm packages...${RESET}"
  npm uninstall -g uipro-cli @playwright/cli firecrawl-cli ctx7 antigravity-workflows 2>/dev/null || true

  if command -v dart >/dev/null 2>&1; then
    echo -e "${YELLOW}Deactivating global Dart skills...${RESET}"
    dart pub global deactivate skills 2>/dev/null || true
  fi

  echo -e "${YELLOW}Removing cloned Claude skills directories...${RESET}"
  rm -rf ~/.claude/skills/flutter-skills ~/.claude/skills/seo ~/.claude/skills/claude-skills

  echo ""
  echo -e "${GREEN}${BOLD}═════════════════════════════════════════════════════════════════════════${RESET}"
  echo -e "${GREEN}${BOLD} 🗑️  ALL SKILLS & TOOLS HAVE BEEN UNINSTALLED SUCCESSFULLY!              ${RESET}"
  echo -e "${GREEN}${BOLD}═════════════════════════════════════════════════════════════════════════${RESET}"
}

# Main Execution Flow - Directly installs all best-in-class skills with --all default selection
main() {
  if [ "$1" == "--uninstall" ] || [ "$1" == "-u" ]; then
    uninstall_all_skills
    exit 0
  fi

  print_banner
  check_prerequisites

  echo -e "${GREEN}${BOLD}🚀 Automatically installing and configuring all elite skills with default selection enabled...${RESET}"
  
  install_core_ui_ux
  install_architecture_skills
  install_mobile_skills
  install_web_skills
  install_seo_skills
  install_backend_skills
  install_devops_skills
  install_workflows_and_plugins
  install_code_quality_skills

  echo ""
  echo -e "${GREEN}${BOLD}═════════════════════════════════════════════════════════════════════════${RESET}"
  echo -e "${GREEN}${BOLD} 🎉 ALL SKILLS HAVE BEEN INSTALLED & CONFIGURED SUCCESSFULLY! 🎉          ${RESET}"
  echo -e "${GREEN}${BOLD}═════════════════════════════════════════════════════════════════════════${RESET}"
  echo ""
  echo -e "${CYAN}💡 Quick Tip:${RESET} To initialize project-level design tokens in any UI project, run: ${YELLOW}uipro init --ai antigravity${RESET}"
  echo ""
}

main "$@"
