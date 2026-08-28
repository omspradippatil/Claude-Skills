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
# INSTALLATION FUNCTIONS
# ==============================================================================

# 🎨 1. CORE UI/UX, DESIGN SYSTEMS & TASTE (PRIMARY FOCUS)
install_core_ui_ux() {
  print_header "🎨 1. CORE UI/UX, DESIGN SYSTEMS & TASTE"
  
  # UI/UX Pro Max: Generates design guidelines, UI heuristics, color palettes, accessibility checks.
  run_step "UI/UX Pro Max CLI" \
    "Generates design guidelines, UI heuristics, color palettes, accessibility checks, and layout hierarchies." \
    "npm install -g uipro-cli"

  # Taste Skill: Enforces human-like visual balance, clean typography, and eliminates generic AI aesthetics.
  run_step "Taste Skill" \
    "Enforces human-like visual balance, clean typography, whitespace discipline, and eliminates generic AI aesthetics." \
    "npx --yes skills@latest add Leonxlnx/taste-skill -g"

  # Accessible Motion: Physics-based springs, easing curves, micro-interactions, gesture response.
  run_step "Accessible & Performant Motion" \
    "Provides context for physics-based springs, easing curves, micro-interactions, gesture response, and 60fps animations." \
    "npx --yes skills@latest add mthines/agent-skills -g"
}

# 🏛️ 2. ARCHITECTURE & SYSTEM VISUALIZATION
install_architecture_skills() {
  print_header "🏛️ 2. ARCHITECTURE & SYSTEM VISUALIZATION"

  # Archify: Turns codebases and architectures into verifiable interactive HTML/SVG system maps and workflow diagrams.
  run_step "Archify System Mapper" \
    "Compiles codebase topology and workflows into beautiful, verifiable interactive HTML/SVG diagrams with motion." \
    "npx --yes skills@latest add tt-a1i/archify -g"
}

# 📱 3. MOBILE APP DEVELOPMENT (FLUTTER / DART / NATIVE)
install_mobile_skills() {
  print_header "📱 3. MOBILE APP DEVELOPMENT (FLUTTER / DART / NATIVE)"

  if command -v dart >/dev/null 2>&1; then
    # Dart Skills CLI: Scans pubspec.yaml and registers official package-specific instructions.
    run_step "Dart Skills CLI" \
      "Scans pubspec.yaml and registers official, package-specific instructions directly into your agent." \
      "dart pub global activate skills"
  else
    echo -e "${YELLOW}⚠ Dart SDK not found. Skipping 'dart pub global activate skills'. (Install Flutter/Dart if developing mobile apps).${RESET}"
  fi

  # Community Flutter Claude Skills: Widget rebuild optimization, Riverpod/BLoC patterns.
  run_step "Community Flutter Claude Skills" \
    "Context rules for widget rebuild optimization, Riverpod/BLoC patterns, native bridges, and platform conventions." \
    "mkdir -p ~/.claude/skills && if [ -d ~/.claude/skills/flutter-skills ]; then git -C ~/.claude/skills/flutter-skills pull; else git clone https://github.com/Harishwarrior/flutter-claude-skills.git ~/.claude/skills/flutter-skills; fi"

  # Fastlane Skills: Automates screenshot generation, keystore signing, metadata packaging, build numbering.
  run_step "Fastlane Skills" \
    "Automates screenshot generation, keystore signing, metadata packaging, build numbering, and Play Store / TestFlight releases." \
    "npx --yes skills@latest add fastlane/agent-skills -g"

  # OWASP Mobile & API Security Playbook: Audits mobile source code for hardcoded secrets.
  run_step "OWASP Mobile & API Security Playbook" \
    "Audits mobile source code for hardcoded secrets, insecure IPC, weak local encryption, and broken mobile API endpoints." \
    "npx --yes skills@latest add OWASP/secure-agent-playbook -g"
}

# 🌐 4. WEB FRONTEND, DOM & BROWSER AUTOMATION
install_web_skills() {
  print_header "🌐 4. WEB FRONTEND, DOM & BROWSER AUTOMATION"

  # Frontend Agent Skills: Web-specific accessibility (WCAG), semantic HTML, responsive CSS grid/flexbox.
  run_step "Frontend Agent Skills" \
    "Web-specific accessibility (WCAG), semantic HTML, responsive CSS grid/flexbox layouts, and UX copy formatting." \
    "npx --yes skills@latest add hueyexe/frontend-agent-skills -g"

  # Web Design & Interaction Collection: Specialized CSS keyframes, layout transitions, Framer Motion.
  run_step "Web Design & Interaction Collection" \
    "Specialized CSS keyframes, layout transitions, scroll-driven effects, and Framer Motion patterns for modern websites." \
    "npx --yes skills@latest add MengTo/Skills -g"

  # TestDino Playwright Skill: AI-powered Playwright best practices, test generator, fixture optimizer, flaky test healer.
  run_step "TestDino Playwright Skill" \
    "AI-powered Playwright testing toolkit: best practices, test generators, fixture optimizations, and flaky test healing." \
    "npx --yes skills@latest add testdino-hq/playwright-skill -g"

  # Playwright Browser Automation CLI: Headless browser automation for UI regression checks and screenshots.
  run_step "Playwright Browser Automation CLI" \
    "Headless browser automation for UI visual regression checks, synthetic user workflows, E2E testing, and screenshots." \
    "npm install -g @playwright/cli@latest && playwright-cli install --skills"

  # Firecrawl CLI: Crawls, cleans, and converts web pages into LLM-ready clean markdown.
  run_step "Firecrawl CLI" \
    "Crawls, cleans, and converts web pages into LLM-ready clean markdown for real-time web scraping and doc ingestion." \
    "npm install -g firecrawl-cli"
}

# 🔍 5. AGENTIC SEO & SEARCH VISIBILITY
install_seo_skills() {
  print_header "🔍 5. AGENTIC SEO & SEARCH OPTIMIZATION"

  # Agentic SEO Skill: LLM-first SEO analysis with 16 sub-skills, 10 specialist agents, and 89 evidence collectors.
  run_step "Agentic SEO Skill Suite" \
    "LLM-first SEO analysis engine: 16 sub-skills, 10 specialist agents, and 89 utility scripts for deep audits and schemas." \
    "mkdir -p ~/.claude/skills/seo && if [ -d ~/.claude/skills/seo ]; then git -C ~/.claude/skills/seo pull; else git clone https://github.com/Bhanunamikaze/Agentic-SEO-Skill.git ~/.claude/skills/seo; fi"

  # Ashley SEO Agent: Technical on-page SEO, OpenGraph data, JSON-LD structured schemas, robots.txt.
  run_step "Ashley SEO & Indexing Agent" \
    "Audits technical on-page SEO, OpenGraph data, JSON-LD structured schemas, robots.txt, sitemaps, and Core Web Vitals." \
    "npx --yes skills@latest add ashleytheash/seo-agent-skill -g"
}

# 🔥 6. BACKEND, DATABASES & CLOUD EDGE
install_backend_skills() {
  print_header "🔥 6. BACKEND, DATABASES & CLOUD EDGE"

  # Supabase Agent Skills: PostgreSQL architecture, Row Level Security (RLS) policies, Edge Functions.
  run_step "Supabase Agent Skills" \
    "PostgreSQL architecture, Row Level Security (RLS) policies, Edge Functions (Deno), realtime subscriptions, and Auth triggers." \
    "npx --yes skills@latest add supabase/agent-skills -g"

  # Firebase Agent Skills: Firestore document design, Firebase Cloud Messaging (FCM) push notifications.
  run_step "Firebase Agent Skills" \
    "Firestore document design, Firebase Cloud Messaging (FCM) push notifications, security rules, and serverless Cloud Functions." \
    "npx --yes skills@latest add firebase/agent-skills -g"

  # Neon Database Skills: Serverless Postgres, database branching for PRs, index tuning.
  run_step "Neon Database Skills" \
    "Serverless Postgres, database branching for PRs, index tuning, connection pooling, and low-latency SQL optimization." \
    "npx --yes skills@latest add neondatabase/agent-skills -g"

  # Cloudflare Ecosystem: Workers, D1 SQL, R2 object storage, KV key-value stores.
  run_step "Cloudflare Ecosystem" \
    "Workers, D1 SQL, R2 object storage, KV key-value stores, rate limiting, and edge API caching configurations." \
    "npx --yes skills@latest add https://github.com/cloudflare/skills -g"
}

# 🐳 7. DEVOPS, LOCAL INFRASTRUCTURE & INTEGRATIONS
install_devops_skills() {
  print_header "🐳 7. DEVOPS, LOCAL INFRASTRUCTURE & INTEGRATIONS"

  # Docker Skills: Multi-stage Dockerfile generation, docker-compose orchestration.
  run_step "Docker Skills" \
    "Multi-stage Dockerfile generation, docker-compose orchestration, local database mock services, and container hardening." \
    "npx --yes skills@latest add docker/agent-skills -g"

  # Composio Integration: Connects agent directly to GitHub Actions, repository issues, pull requests.
  run_step "Composio Integration" \
    "Connects agent directly to GitHub Actions, repository issues, pull requests, Gmail alerts, and external workflow automations." \
    "npx --yes skills@latest add composiohq/skills -g"

  # Postman / OpenAPI Skills: Ingests Swagger/OpenAPI specifications, generates strongly typed data models.
  run_step "Postman / OpenAPI Skills" \
    "Ingests Swagger/OpenAPI specifications, generates strongly typed data models (Dart/TS), and automates endpoint contract testing." \
    "npx --yes skills@latest add postman/agent-skills -g"
}

# 🔄 8. INTELLIGENT WORKFLOWS & CROSS-AGENT PLUGINS
install_workflows_and_plugins() {
  print_header "🔄 8. INTELLIGENT WORKFLOWS & CROSS-AGENT PLUGINS"

  # Antigravity Workflows: Stack-agnostic, question-driven workflows for AI coding assistants.
  run_step "Antigravity Workflows CLI" \
    "Stack-agnostic, question-driven workflows that detect project frameworks and adapt step-by-step." \
    "npm install -g antigravity-workflows"

  # Claude Skills Universal Library: 388+ production-ready Claude Code skills & plugins across 20 domains.
  run_step "Claude Skills Universal Library (388+ Skills)" \
    "Comprehensive suite of 388+ engineering, architecture, C-level advisory, security, and productivity skills." \
    "mkdir -p ~/.claude/skills/claude-skills && if [ -d ~/.claude/skills/claude-skills ]; then git -C ~/.claude/skills/claude-skills pull; else git clone https://github.com/alirezarezvani/claude-skills.git ~/.claude/skills/claude-skills; fi"
}

# 🧠 9. CODE QUALITY, SECURITY & PERSISTENT MEMORY
install_code_quality_skills() {
  print_header "🧠 9. CODE QUALITY, SECURITY & PERSISTENT MEMORY"

  # Claude-Mem: Captures session activity, compresses with AI, and injects context into future sessions.
  run_step "Claude-Mem Persistent Session Context" \
    "Preserves context across sessions by capturing tool actions and injecting semantic summaries into future chats." \
    "npx --yes claude-mem install 2>/dev/null || npx --yes skills@latest add thedotmack/claude-mem -g"

  # Andrej Karpathy Engineering Philosophy: Clarity, minimal abstractions, clean foundational code.
  run_step "Andrej Karpathy Engineering Philosophy" \
    "Prioritizes clarity, minimal abstractions, readability, clean foundational code, and strict engineering discipline." \
    "npx --yes skills@latest add multica-ai/andrej-karpathy-skills -g"

  # Caveman: Eliminates framework bloat, prevents over-engineering.
  run_step "Caveman (Anti-Overengineering)" \
    "Eliminates framework bloat, prevents over-engineering, enforces simple directory architectures, and refuses micro-abstractions." \
    "npx --yes skills@latest add JuliusBrussee/caveman -g"

  # Ponytail Skills: Enforces clean software design patterns.
  run_step "Ponytail Skills" \
    "Enforces clean software design patterns, eliminating bloated libraries and preserving codebase simplicity." \
    "npx --yes skills@latest add https://github.com/DietrichGebert/ponytail/tree/main/skills -g"

  # MemoryPlugin: Cross-session long-term memory.
  run_step "MemoryPlugin (Cross-Session Persistence)" \
    "Provides cross-session long-term memory so the agent retains project context, design preferences, and architectural decisions." \
    "npx --yes skills@latest add memoryplugin/agent-skills -g"

  # Sentry for AI: Automated root-cause analysis for production exceptions.
  run_step "Sentry for AI" \
    "Automated root-cause analysis for production exceptions, stack trace parsing, and regression pinpointing." \
    "npx --yes skills@latest add getsentry/sentry-for-ai -g"

  # CTX7 Documentation Indexer: Indexes and injects the latest framework documentation directly into agent context.
  run_step "CTX7 Documentation Indexer" \
    "Indexes and injects the latest framework/library documentation directly into the agent context, eliminating hallucinations." \
    "npm install -g ctx7"
}

# ==============================================================================
# UNINSTALLATION / REMOVAL FUNCTIONS
# ==============================================================================

uninstall_core_ui_ux() {
  print_header "🗑️  REMOVING CORE UI/UX & TASTE SKILLS"
  run_step "Uninstall UI/UX Pro Max CLI" "Removes global uipro-cli" "npm uninstall -g uipro-cli"
  run_step "Remove Taste Skill" "Removes taste skill from global skills" "npx --yes skills@latest remove -g -y taste-skill || true"
  run_step "Remove Motion Skills" "Removes motion skills from global skills" "npx --yes skills@latest remove -g -y agent-skills || true"
}

uninstall_architecture_skills() {
  print_header "🗑️  REMOVING ARCHITECTURE SKILLS"
  run_step "Remove Archify Skill" "Removes Archify system mapper" "npx --yes skills@latest remove -g -y archify || true"
}

uninstall_mobile_skills() {
  print_header "🗑️  REMOVING MOBILE APP SKILLS"
  if command -v dart >/dev/null 2>&1; then
    run_step "Deactivate Dart Skills CLI" "Removes global dart skills" "dart pub global deactivate skills || true"
  fi
  run_step "Remove Flutter Claude Skills Repo" "Deletes cloned flutter-skills folder" "rm -rf ~/.claude/skills/flutter-skills"
  run_step "Remove Fastlane Skills" "Removes fastlane agent skills" "npx --yes skills@latest remove -g -y fastlane || true"
  run_step "Remove OWASP Security Playbook" "Removes mobile security playbook" "npx --yes skills@latest remove -g -y secure-agent-playbook || true"
}

uninstall_web_skills() {
  print_header "🗑️  REMOVING WEB & BROWSER SKILLS"
  run_step "Uninstall Playwright CLI & Firecrawl" "Removes global web CLIs" "npm uninstall -g @playwright/cli firecrawl-cli"
  run_step "Remove Frontend Agent Skills" "Removes frontend skills" "npx --yes skills@latest remove -g -y frontend-agent-skills || true"
  run_step "Remove Web Design Collection" "Removes web animation skills" "npx --yes skills@latest remove -g -y Skills || true"
  run_step "Remove TestDino Playwright Skill" "Removes TestDino Playwright skill" "npx --yes skills@latest remove -g -y playwright-skill || true"
}

uninstall_seo_skills() {
  print_header "🗑️  REMOVING SEO SKILLS"
  run_step "Remove Agentic SEO Skill Repo" "Deletes cloned Agentic SEO folder" "rm -rf ~/.claude/skills/seo"
  run_step "Remove Ashley SEO Agent" "Removes Ashley SEO agent skills" "npx --yes skills@latest remove -g -y seo-agent-skill || true"
}

uninstall_backend_skills() {
  print_header "🗑️  REMOVING BACKEND & CLOUD SKILLS"
  run_step "Remove Supabase Skills" "Removes Supabase skills" "npx --yes skills@latest remove -g -y supabase || true"
  run_step "Remove Firebase Skills" "Removes Firebase skills" "npx --yes skills@latest remove -g -y firebase || true"
  run_step "Remove Neon Skills" "Removes Neon database skills" "npx --yes skills@latest remove -g -y neondatabase || true"
  run_step "Remove Cloudflare Skills" "Removes Cloudflare skills" "npx --yes skills@latest remove -g -y cloudflare || true"
}

uninstall_devops_skills() {
  print_header "🗑️  REMOVING DEVOPS & INTEGRATION SKILLS"
  run_step "Remove Docker Skills" "Removes Docker skills" "npx --yes skills@latest remove -g -y docker || true"
  run_step "Remove Composio Skills" "Removes Composio skills" "npx --yes skills@latest remove -g -y composio || true"
  run_step "Remove Postman Skills" "Removes Postman OpenAPI skills" "npx --yes skills@latest remove -g -y postman || true"
}

uninstall_workflows_and_plugins() {
  print_header "🗑️  REMOVING WORKFLOWS & PLUGIN LIBRARIES"
  run_step "Uninstall Antigravity Workflows CLI" "Removes global antigravity-workflows CLI" "npm uninstall -g antigravity-workflows"
  run_step "Remove Claude Skills Library" "Deletes cloned claude-skills repo" "rm -rf ~/.claude/skills/claude-skills"
}

uninstall_code_quality_skills() {
  print_header "🗑️  REMOVING CODE QUALITY & MEMORY SKILLS"
  run_step "Uninstall CTX7 Indexer" "Removes global ctx7 CLI" "npm uninstall -g ctx7"
  run_step "Remove Claude-Mem Context" "Removes claude-mem context" "npx --yes skills@latest remove -g -y claude-mem || true"
  run_step "Remove Andrej Karpathy Skills" "Removes Karpathy engineering rules" "npx --yes skills@latest remove -g -y andrej-karpathy-skills || true"
  run_step "Remove Caveman Skills" "Removes anti-bloat rules" "npx --yes skills@latest remove -g -y caveman || true"
  run_step "Remove Ponytail Skills" "Removes ponytail rules" "npx --yes skills@latest remove -g -y ponytail || true"
  run_step "Remove MemoryPlugin" "Removes cross-session memory skills" "npx --yes skills@latest remove -g -y memoryplugin || true"
  run_step "Remove Sentry for AI" "Removes Sentry AI skills" "npx --yes skills@latest remove -g -y sentry-for-ai || true"
}

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

# Main Execution Flow
main() {
  print_banner
  check_prerequisites

  echo -e "${BOLD}Select an action or project configuration:${RESET}"
  echo ""
  echo -e "  ${CYAN}1)${RESET} 📱 ${BOLD}Install: Mobile Application${RESET}   (UI/UX + Archify + Flutter/Dart + SEO + Cloud + DevOps + Memory)"
  echo -e "  ${CYAN}2)${RESET} 🌐 ${BOLD}Install: Web Application${RESET}      (UI/UX + Archify + Frontend/Playwright + SEO + Cloud + DevOps + Memory)"
  echo -e "  ${CYAN}3)${RESET} 🚀 ${BOLD}Install: All-in-One Full Suite${RESET} (Install ALL 9 Categories & 400+ Skills without conflicts)"
  echo -e "  ${CYAN}4)${RESET} 🎯 ${BOLD}Install: Custom Selection${RESET}      (Choose specific skill categories to install)"
  echo -e "  ${RED}5)${RESET} 🗑️  ${BOLD}Delete / Uninstall Skills${RESET}      (Remove installed skills, CLIs, and configs)"
  echo ""
  echo -n -e "${YELLOW}Select an option [1-5] (default: 3): ${RESET}"
  
  choice=""
  if [ -e /dev/tty ]; then
    read -r choice < /dev/tty 2>/dev/null || choice="3"
  else
    read -r choice || choice="3"
  fi
  [ -z "$choice" ] && choice="3"

  case "$choice" in
    1)
      echo -e "\n${GREEN}🚀 Starting Mobile Application Skills Installation...${RESET}"
      install_core_ui_ux
      install_architecture_skills
      install_mobile_skills
      install_seo_skills
      install_backend_skills
      install_devops_skills
      install_workflows_and_plugins
      install_code_quality_skills
      ;;
    2)
      echo -e "\n${GREEN}🚀 Starting Web Application Skills Installation...${RESET}"
      install_core_ui_ux
      install_architecture_skills
      install_web_skills
      install_seo_skills
      install_backend_skills
      install_devops_skills
      install_workflows_and_plugins
      install_code_quality_skills
      ;;
    3|"")
      echo -e "\n${GREEN}🚀 Starting Complete All-in-One Skills Installation...${RESET}"
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
    4)
      echo -e "\n${BOLD}Select categories to install:${RESET}"
      
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
      echo -e "\n${RED}${BOLD}🗑️  Uninstall Options:${RESET}"
      echo -e "  ${RED}1)${RESET} Delete ALL installed skills and global packages"
      echo -e "  ${YELLOW}2)${RESET} Delete specific skill categories"
      echo ""
      echo -n -e "${YELLOW}Select uninstall option [1-2] (default: 1): ${RESET}"
      
      un_choice=""
      if [ -e /dev/tty ]; then
        read -r un_choice < /dev/tty 2>/dev/null || un_choice="1"
      else
        read -r un_choice || un_choice="1"
      fi
      [ -z "$un_choice" ] && un_choice="1"

      if [ "$un_choice" == "2" ]; then
        echo -n -e "Remove 🎨 Core UI/UX skills? [y/N]: "
        read -r u1 < /dev/tty 2>/dev/null || u1="n"
        [[ "$u1" =~ ^[Yy] ]] && uninstall_core_ui_ux

        echo -n -e "Remove 🏛️ Architecture skills (Archify)? [y/N]: "
        read -r uArch < /dev/tty 2>/dev/null || uArch="n"
        [[ "$uArch" =~ ^[Yy] ]] && uninstall_architecture_skills

        echo -n -e "Remove 📱 Mobile App skills? [y/N]: "
        read -r u2 < /dev/tty 2>/dev/null || u2="n"
        [[ "$u2" =~ ^[Yy] ]] && uninstall_mobile_skills

        echo -n -e "Remove 🌐 Web Frontend & Browser skills? [y/N]: "
        read -r u3 < /dev/tty 2>/dev/null || u3="n"
        [[ "$u3" =~ ^[Yy] ]] && uninstall_web_skills

        echo -n -e "Remove 🔍 SEO skills? [y/N]: "
        read -r uSeo < /dev/tty 2>/dev/null || uSeo="n"
        [[ "$uSeo" =~ ^[Yy] ]] && uninstall_seo_skills

        echo -n -e "Remove 🔥 Backend & Cloud Edge skills? [y/N]: "
        read -r u4 < /dev/tty 2>/dev/null || u4="n"
        [[ "$u4" =~ ^[Yy] ]] && uninstall_backend_skills

        echo -n -e "Remove 🐳 DevOps & Integrations skills? [y/N]: "
        read -r u5 < /dev/tty 2>/dev/null || u5="n"
        [[ "$u5" =~ ^[Yy] ]] && uninstall_devops_skills

        echo -n -e "Remove 🔄 Workflows & Plugins? [y/N]: "
        read -r uWf < /dev/tty 2>/dev/null || uWf="n"
        [[ "$uWf" =~ ^[Yy] ]] && uninstall_workflows_and_plugins

        echo -n -e "Remove 🧠 Code Quality & Memory skills? [y/N]: "
        read -r u6 < /dev/tty 2>/dev/null || u6="n"
        [[ "$u6" =~ ^[Yy] ]] && uninstall_code_quality_skills
      else
        uninstall_all_skills
      fi
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
  echo -e "${GREEN}${BOLD} 🎉 ALL SKILLS HAVE BEEN CONFIGURED & INSTALLED SUCCESSFULLY! 🎉           ${RESET}"
  echo -e "${GREEN}${BOLD}═════════════════════════════════════════════════════════════════════════${RESET}"
  echo ""
  echo -e "${CYAN}💡 Quick Tip:${RESET} To initialize project-level design tokens in any UI project, run: ${YELLOW}uipro init --ai antigravity${RESET}"
  echo ""
}

main "$@"
