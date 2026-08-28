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

# Scope Flags (Global vs Project Directory)
SCOPE_FLAG="-g"
SCOPE_NPM="-g"
SCOPE_DESC="Global (~/.agents & system-wide)"
SKILLS_DIR="$HOME/.claude/skills"

set_scope() {
  local scope_choice="$1"
  if [ "$scope_choice" == "2" ] || [ "$scope_choice" == "project" ]; then
    SCOPE_FLAG=""
    SCOPE_NPM=""
    SCOPE_DESC="Project Directory ($(pwd))"
    SKILLS_DIR="$(pwd)/.claude/skills"
    mkdir -p "$SKILLS_DIR" "$(pwd)/.agent/skills"
  else
    SCOPE_FLAG="-g"
    SCOPE_NPM="-g"
    SCOPE_DESC="Global (~/.agents & system-wide)"
    SKILLS_DIR="$HOME/.claude/skills"
    mkdir -p "$SKILLS_DIR"
  fi
}

# ==============================================================================
# INSTALLATION FUNCTIONS (SUPPORTING BOTH GLOBAL & PROJECT DIRECTORY)
# ==============================================================================

# 🎨 1. CORE UI/UX, DESIGN SYSTEMS & TASTE (PRIMARY FOCUS)
install_core_ui_ux() {
  print_header "🎨 1. CORE UI/UX, DESIGN SYSTEMS & TASTE"
  
  if [ -n "$SCOPE_NPM" ]; then
    run_step "UI/UX Pro Max CLI" \
      "Generates design guidelines, UI heuristics, color palettes, accessibility checks, and layout hierarchies." \
      "npm install -g uipro-cli"
  else
    run_step "UI/UX Pro Max CLI" \
      "Generates design guidelines, UI heuristics, color palettes, accessibility checks, and layout hierarchies." \
      "npm install --save-dev uipro-cli"
  fi

  run_step "Taste Skill" \
    "Enforces human-like visual balance, clean typography, whitespace discipline, and eliminates generic AI aesthetics." \
    "npx --yes skills@latest add Leonxlnx/taste-skill $SCOPE_FLAG --all -y"

  run_step "Accessible & Performant Motion" \
    "Provides context for physics-based springs, easing curves, micro-interactions, gesture response, and 60fps animations." \
    "npx --yes skills@latest add mthines/agent-skills $SCOPE_FLAG --all -y"
}

# 🏛️ 2. ARCHITECTURE & SYSTEM VISUALIZATION
install_architecture_skills() {
  print_header "🏛️ 2. ARCHITECTURE & SYSTEM VISUALIZATION"

  run_step "Archify System Mapper" \
    "Compiles codebase topology and workflows into beautiful, verifiable interactive HTML/SVG diagrams with motion." \
    "npx --yes skills@latest add tt-a1i/archify $SCOPE_FLAG --all -y"
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
    "mkdir -p $SKILLS_DIR && if [ -d $SKILLS_DIR/flutter-skills ]; then git -C $SKILLS_DIR/flutter-skills pull; else git clone https://github.com/Harishwarrior/flutter-claude-skills.git $SKILLS_DIR/flutter-skills; fi"

  run_step "OWASP Mobile & API Security Playbook" \
    "Audits mobile source code for hardcoded secrets, insecure IPC, weak local encryption, and broken mobile API endpoints." \
    "npx --yes skills@latest add OWASP/secure-agent-playbook $SCOPE_FLAG --all -y"
}

# 🌐 4. WEB FRONTEND, DOM & BROWSER AUTOMATION
install_web_skills() {
  print_header "🌐 4. WEB FRONTEND, DOM & BROWSER AUTOMATION"

  run_step "Frontend Agent Skills" \
    "Web-specific accessibility (WCAG), semantic HTML, responsive CSS grid/flexbox layouts, and UX copy formatting." \
    "npx --yes skills@latest add hueyexe/frontend-agent-skills $SCOPE_FLAG --all -y"

  run_step "Web Design & Interaction Collection" \
    "Specialized CSS keyframes, layout transitions, scroll-driven effects, and Framer Motion patterns for modern websites." \
    "npx --yes skills@latest add MengTo/Skills $SCOPE_FLAG --all -y"

  run_step "TestDino Playwright Skill" \
    "AI-powered Playwright testing toolkit: best practices, test generators, fixture optimizations, and flaky test healing." \
    "npx --yes skills@latest add testdino-hq/playwright-skill $SCOPE_FLAG --all -y"

  if [ -n "$SCOPE_NPM" ]; then
    run_step "Playwright Browser Automation CLI" \
      "Headless browser automation for UI visual regression checks, synthetic user workflows, E2E testing, and screenshots." \
      "npm install -g @playwright/cli@latest && playwright-cli install --skills"

    run_step "Firecrawl CLI" \
      "Crawls, cleans, and converts web pages into LLM-ready clean markdown for real-time web scraping and doc ingestion." \
      "npm install -g firecrawl-cli"
  else
    run_step "Playwright Browser Automation CLI" \
      "Headless browser automation for UI visual regression checks, synthetic user workflows, E2E testing, and screenshots." \
      "npm install --save-dev @playwright/cli@latest"

    run_step "Firecrawl CLI" \
      "Crawls, cleans, and converts web pages into LLM-ready clean markdown for real-time web scraping and doc ingestion." \
      "npm install --save-dev firecrawl-cli"
  fi
}

# 🔍 5. AGENTIC SEO & SEARCH VISIBILITY
install_seo_skills() {
  print_header "🔍 5. AGENTIC SEO & SEARCH OPTIMIZATION"

  run_step "Agentic SEO Skill Suite" \
    "LLM-first SEO analysis engine: 16 sub-skills, 10 specialist agents, and 89 utility scripts for deep audits and schemas." \
    "mkdir -p $SKILLS_DIR/seo && if [ -d $SKILLS_DIR/seo/.git ]; then git -C $SKILLS_DIR/seo pull; else git clone https://github.com/Bhanunamikaze/Agentic-SEO-Skill.git $SKILLS_DIR/seo; fi"

  run_step "Ashley SEO & Indexing Agent" \
    "Audits technical on-page SEO, OpenGraph data, JSON-LD structured schemas, robots.txt, sitemaps, and Core Web Vitals." \
    "npx --yes skills@latest add ashleytheash/seo-agent-skill $SCOPE_FLAG --all -y"
}

# 🔥 6. BACKEND, DATABASES & CLOUD EDGE
install_backend_skills() {
  print_header "🔥 6. BACKEND, DATABASES & CLOUD EDGE"

  run_step "Supabase Agent Skills" \
    "PostgreSQL architecture, Row Level Security (RLS) policies, Edge Functions (Deno), realtime subscriptions, and Auth triggers." \
    "npx --yes skills@latest add supabase/agent-skills $SCOPE_FLAG --all -y"

  run_step "Firebase Agent Skills" \
    "Firestore document design, Firebase Cloud Messaging (FCM) push notifications, security rules, and serverless Cloud Functions." \
    "npx --yes skills@latest add firebase/agent-skills $SCOPE_FLAG --all -y"

  run_step "Neon Database Skills" \
    "Serverless Postgres, database branching for PRs, index tuning, connection pooling, and low-latency SQL optimization." \
    "npx --yes skills@latest add neondatabase/agent-skills $SCOPE_FLAG --all -y"

  run_step "Cloudflare Ecosystem" \
    "Workers, D1 SQL, R2 object storage, KV key-value stores, rate limiting, and edge API caching configurations." \
    "npx --yes skills@latest add https://github.com/cloudflare/skills $SCOPE_FLAG --all -y"
}

# 🐳 7. DEVOPS, LOCAL INFRASTRUCTURE & INTEGRATIONS
install_devops_skills() {
  print_header "🐳 7. DEVOPS, LOCAL INFRASTRUCTURE & INTEGRATIONS"

  run_step "Docker Skills" \
    "Multi-stage Dockerfile generation, docker-compose orchestration, local database mock services, and container hardening." \
    "npx --yes skills@latest add docker/agent-skills $SCOPE_FLAG --all -y"

  run_step "Composio Integration" \
    "Connects agent directly to GitHub Actions, repository issues, pull requests, Gmail alerts, and external workflow automations." \
    "npx --yes skills@latest add composiohq/skills $SCOPE_FLAG --all -y"

  run_step "Postman / OpenAPI Skills" \
    "Ingests Swagger/OpenAPI specifications, generates strongly typed data models (Dart/TS), and automates endpoint contract testing." \
    "npx --yes skills@latest add postman/agent-skills $SCOPE_FLAG --all -y"
}

# 🔄 8. INTELLIGENT WORKFLOWS & CROSS-AGENT PLUGINS
install_workflows_and_plugins() {
  print_header "🔄 8. INTELLIGENT WORKFLOWS & CROSS-AGENT PLUGINS"

  if [ -n "$SCOPE_NPM" ]; then
    run_step "Antigravity Workflows CLI" \
      "Stack-agnostic, question-driven workflows that detect project frameworks and adapt step-by-step." \
      "npm install -g antigravity-workflows"
  else
    run_step "Antigravity Workflows CLI" \
      "Stack-agnostic, question-driven workflows that detect project frameworks and adapt step-by-step." \
      "npm install --save-dev antigravity-workflows"
  fi

  run_step "Claude Skills Universal Library (388+ Skills)" \
    "Comprehensive suite of 388+ engineering, architecture, C-level advisory, security, and productivity skills." \
    "mkdir -p $SKILLS_DIR/claude-skills && if [ -d $SKILLS_DIR/claude-skills/.git ]; then git -C $SKILLS_DIR/claude-skills pull; else git clone https://github.com/alirezarezvani/claude-skills.git $SKILLS_DIR/claude-skills; fi"
}

# 🧠 9. CODE QUALITY, SECURITY & PERSISTENT MEMORY
install_code_quality_skills() {
  print_header "🧠 9. CODE QUALITY, SECURITY & PERSISTENT MEMORY"

  run_step "Claude-Mem Persistent Session Context" \
    "Preserves context across sessions by capturing tool actions and injecting semantic summaries into future chats." \
    "npx --yes claude-mem install 2>/dev/null || npx --yes skills@latest add thedotmack/claude-mem $SCOPE_FLAG --all -y"

  run_step "Andrej Karpathy Engineering Philosophy" \
    "Prioritizes clarity, minimal abstractions, readability, clean foundational code, and strict engineering discipline." \
    "npx --yes skills@latest add multica-ai/andrej-karpathy-skills $SCOPE_FLAG --all -y"

  run_step "Caveman (Anti-Overengineering)" \
    "Eliminates framework bloat, prevents over-engineering, enforces simple directory architectures, and refuses micro-abstractions." \
    "npx --yes skills@latest add JuliusBrussee/caveman $SCOPE_FLAG --all -y"

  run_step "Ponytail Skills" \
    "Enforces clean software design patterns, eliminating bloated libraries and preserving codebase simplicity." \
    "npx --yes skills@latest add https://github.com/DietrichGebert/ponytail/tree/main/skills $SCOPE_FLAG --all -y"

  run_step "MemoryPlugin (Cross-Session Persistence)" \
    "Provides cross-session long-term memory so the agent retains project context, design preferences, and architectural decisions." \
    "npx --yes skills@latest add memoryplugin/agent-skills $SCOPE_FLAG --all -y"

  run_step "Sentry for AI" \
    "Automated root-cause analysis for production exceptions, stack trace parsing, and regression pinpointing." \
    "npx --yes skills@latest add getsentry/sentry-for-ai $SCOPE_FLAG --all -y"

  if [ -n "$SCOPE_NPM" ]; then
    run_step "CTX7 Documentation Indexer" \
      "Indexes and injects the latest framework/library documentation directly into the agent context, eliminating hallucinations." \
      "npm install -g ctx7"
  else
    run_step "CTX7 Documentation Indexer" \
      "Indexes and injects the latest framework/library documentation directly into the agent context, eliminating hallucinations." \
      "npm install --save-dev ctx7"
  fi
}

# ==============================================================================
# UNINSTALLATION / REMOVAL FUNCTIONS
# ==============================================================================

uninstall_all_skills() {
  print_header "🗑️  REMOVING ALL INSTALLED SKILLS & GLOBAL PACKAGES"
  
  echo -e "${YELLOW}Uninstalling all skills CLI registry entries...${RESET}"
  npx --yes skills@latest remove --all -g -y 2>/dev/null || true
  npx --yes skills@latest remove --all -y 2>/dev/null || true

  echo -e "${YELLOW}Uninstalling global npm packages...${RESET}"
  npm uninstall -g uipro-cli @playwright/cli firecrawl-cli ctx7 antigravity-workflows 2>/dev/null || true

  if command -v dart >/dev/null 2>&1; then
    echo -e "${YELLOW}Deactivating global Dart skills...${RESET}"
    dart pub global deactivate skills 2>/dev/null || true
  fi

  echo -e "${YELLOW}Removing cloned Claude skills directories...${RESET}"
  rm -rf ~/.claude/skills/flutter-skills ~/.claude/skills/seo ~/.claude/skills/claude-skills
  rm -rf .claude/skills .agent/skills

  echo ""
  echo -e "${GREEN}${BOLD}═════════════════════════════════════════════════════════════════════════${RESET}"
  echo -e "${GREEN}${BOLD} 🗑️  ALL SKILLS & TOOLS HAVE BEEN UNINSTALLED SUCCESSFULLY!              ${RESET}"
  echo -e "${GREEN}${BOLD}═════════════════════════════════════════════════════════════════════════${RESET}"
}

# Main Execution Flow
main() {
  SCOPE_INPUT=""
  SUITE_INPUT=""

  # Parse CLI arguments if supplied
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --global|-g)
        SCOPE_INPUT="1"
        shift
        ;;
      --project|-p)
        SCOPE_INPUT="2"
        shift
        ;;
      --all|-a|--full)
        SUITE_INPUT="1"
        shift
        ;;
      --mobile|-m)
        SUITE_INPUT="2"
        shift
        ;;
      --web|-w)
        SUITE_INPUT="3"
        shift
        ;;
      --uninstall|-u)
        uninstall_all_skills
        exit 0
        ;;
      *)
        shift
        ;;
    esac
  done

  print_banner
  check_prerequisites

  # STEP 1: Choose Installation Scope (Global vs Project Directory)
  if [ -z "$SCOPE_INPUT" ]; then
    echo -e "${BOLD}Where would you like to install the skills?${RESET}"
    echo ""
    echo -e "  ${CYAN}1)${RESET} 🌍 ${BOLD}Global${RESET}            (Recommended: Available across all projects in ~/.agents & system-wide)"
    echo -e "  ${CYAN}2)${RESET} 📁 ${BOLD}Current Project${RESET}   (Install only in this project folder: $(pwd))"
    echo ""
    echo -n -e "${YELLOW}Select install scope [1-2] (default: 1): ${RESET}"
    
    if [ -t 0 ] || [ -e /dev/tty ]; then
      read -r SCOPE_INPUT < /dev/tty 2>/dev/null || read -r SCOPE_INPUT || SCOPE_INPUT="1"
    else
      read -r SCOPE_INPUT || SCOPE_INPUT="1"
    fi
    [ -z "$SCOPE_INPUT" ] && SCOPE_INPUT="1"
  fi
  set_scope "$SCOPE_INPUT"

  # STEP 2: Choose Skill Configuration Suite
  if [ -z "$SUITE_INPUT" ]; then
    echo ""
    echo -e "${BOLD}Which skills configuration would you like to install into [${SCOPE_DESC}]?${RESET}"
    echo ""
    echo -e "  ${CYAN}1)${RESET} 🚀 ${BOLD}All-in-One Full Suite${RESET} (Install ALL 9 Categories & 400+ Skills without conflicts)"
    echo -e "  ${CYAN}2)${RESET} 📱 ${BOLD}Mobile Application${RESET}   (UI/UX + Archify + Flutter/Dart + SEO + Cloud + DevOps + Memory)"
    echo -e "  ${CYAN}3)${RESET} 🌐 ${BOLD}Web Application${RESET}      (UI/UX + Archify + Frontend/Playwright + SEO + Cloud + DevOps + Memory)"
    echo -e "  ${CYAN}4)${RESET} 🎯 ${BOLD}Custom Selection${RESET}     (Choose specific skill categories to install)"
    echo -e "  ${RED}5)${RESET} 🗑️  ${BOLD}Delete / Uninstall${RESET}   (Remove installed skills and configurations)"
    echo ""
    echo -n -e "${YELLOW}Select skill suite [1-5] (default: 1): ${RESET}"

    if [ -t 0 ] || [ -e /dev/tty ]; then
      read -r SUITE_INPUT < /dev/tty 2>/dev/null || read -r SUITE_INPUT || SUITE_INPUT="1"
    else
      read -r SUITE_INPUT || SUITE_INPUT="1"
    fi
    [ -z "$SUITE_INPUT" ] && SUITE_INPUT="1"
  fi

  case "$SUITE_INPUT" in
    1|"")
      echo -e "\n${GREEN}🚀 Starting All-in-One Skills Installation into ${SCOPE_DESC}...${RESET}"
      install_core_ui_ux
      install_architecture_skills
      install_mobile_skills
      install_web_skills
      install_seo_skills
      install_backend_skills
      install_devops_skills
      install_workflows_and_plugins
      install_code_quality_skills
      ;;
    2)
      echo -e "\n${GREEN}🚀 Starting Mobile Application Skills Installation into ${SCOPE_DESC}...${RESET}"
      install_core_ui_ux
      install_architecture_skills
      install_mobile_skills
      install_seo_skills
      install_backend_skills
      install_devops_skills
      install_workflows_and_plugins
      install_code_quality_skills
      ;;
    3)
      echo -e "\n${GREEN}🚀 Starting Web Application Skills Installation into ${SCOPE_DESC}...${RESET}"
      install_core_ui_ux
      install_architecture_skills
      install_web_skills
      install_seo_skills
      install_backend_skills
      install_devops_skills
      install_workflows_and_plugins
      install_code_quality_skills
      ;;
    4)
      echo -e "\n${BOLD}Select categories to install into ${SCOPE_DESC}:${RESET}"
      
      echo -n -e "Install 🎨 Core UI/UX & Taste skills? [Y/n]: "
      read -r c1 < /dev/tty 2>/dev/null || c1="y"
      [[ "$c1" =~ ^[Nn] ]] || install_core_ui_ux

      echo -n -e "Install 🏛️ Architecture & System Visualizer (Archify)? [Y/n]: "
      read -r cArch < /dev/tty 2>/dev/null || cArch="y"
      [[ "$cArch" =~ ^[Nn] ]] || install_architecture_skills

      echo -n -e "Install 📱 Mobile App (Flutter/Dart) skills? [Y/n]: "
      read -r c2 < /dev/tty 2>/dev/null || c2="y"
      [[ "$c2" =~ ^[Nn] ]] || install_mobile_skills

      echo -n -e "Install 🌐 Web Frontend & Browser (Playwright) skills? [Y/n]: "
      read -r c3 < /dev/tty 2>/dev/null || c3="y"
      [[ "$c3" =~ ^[Nn] ]] || install_web_skills

      echo -n -e "Install 🔍 Agentic SEO & Indexing skills? [Y/n]: "
      read -r cSeo < /dev/tty 2>/dev/null || cSeo="y"
      [[ "$cSeo" =~ ^[Nn] ]] || install_seo_skills

      echo -n -e "Install 🔥 Backend & Cloud Edge skills? [Y/n]: "
      read -r c4 < /dev/tty 2>/dev/null || c4="y"
      [[ "$c4" =~ ^[Nn] ]] || install_backend_skills

      echo -n -e "Install 🐳 DevOps & Integrations skills? [Y/n]: "
      read -r c5 < /dev/tty 2>/dev/null || c5="y"
      [[ "$c5" =~ ^[Nn] ]] || install_devops_skills

      echo -n -e "Install 🔄 Intelligent Workflows & Claude Skills Suite? [Y/n]: "
      read -r cWf < /dev/tty 2>/dev/null || cWf="y"
      [[ "$cWf" =~ ^[Nn] ]] || install_workflows_and_plugins

      echo -n -e "Install 🧠 Code Quality, Claude-Mem & Sentry skills? [Y/n]: "
      read -r c6 < /dev/tty 2>/dev/null || c6="y"
      [[ "$c6" =~ ^[Nn] ]] || install_code_quality_skills
      ;;
    5)
      uninstall_all_skills
      return 0
      ;;
    *)
      echo -e "\n${RED}Invalid option. Defaulting to Complete All-in-One installation.${RESET}"
      install_core_ui_ux
      install_architecture_skills
      install_mobile_skills
      install_web_skills
      install_seo_skills
      install_backend_skills
      install_devops_skills
      install_workflows_and_plugins
      install_code_quality_skills
      ;;
  esac

  echo ""
  echo -e "${GREEN}${BOLD}═════════════════════════════════════════════════════════════════════════${RESET}"
  echo -e "${GREEN}${BOLD} 🎉 ALL SKILLS HAVE BEEN INSTALLED & CONFIGURED IN [${SCOPE_DESC}]! 🎉   ${RESET}"
  echo -e "${GREEN}${BOLD}═════════════════════════════════════════════════════════════════════════${RESET}"
  echo ""
  echo -e "${CYAN}💡 Quick Tip:${RESET} To initialize project-level design tokens in any UI project, run: ${YELLOW}uipro init --ai antigravity${RESET}"
  echo ""
}

main "$@"
