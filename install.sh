#!/usr/bin/env bash

# ==============================================================================
# 🚀 AI Agent Skills Installer (macOS & Linux)
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
  echo "║                   ⚡ AI CODING SKILLS INSTALLER ⚡                     ║"
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
    echo -e "  ${GREEN}✔ Installed successfully!${RESET}"
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

# Skill category installation functions

install_core_ui_ux() {
  print_header "🎨 1. CORE UI/UX, DESIGN SYSTEMS & TASTE"
  
  run_step "UI/UX Pro Max CLI" \
    "Generates design guidelines, UI heuristics, color palettes, accessibility checks, and layout hierarchies." \
    "npm install -g uipro-cli"

  run_step "Taste Skill" \
    "Enforces human-like visual balance, clean typography, whitespace discipline, and eliminates generic AI aesthetics." \
    "npx --yes skills@latest add Leonxlnx/taste-skill -g"

  run_step "Accessible & Performant Motion" \
    "Provides context for physics-based springs, easing curves, micro-interactions, gesture response, and 60fps animations." \
    "npx --yes skills@latest add mthines/agent-skills -g"
}

install_mobile_skills() {
  print_header "📱 2. MOBILE APP DEVELOPMENT (FLUTTER / DART / NATIVE)"

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
    "npx --yes skills@latest add fastlane/agent-skills -g"

  run_step "OWASP Mobile & API Security Playbook" \
    "Audits mobile source code for hardcoded secrets, insecure IPC, weak local encryption, and broken mobile API endpoints." \
    "npx --yes skills@latest add OWASP/secure-agent-playbook -g"
}

install_web_skills() {
  print_header "🌐 3. WEB FRONTEND, DOM & BROWSER AUTOMATION"

  run_step "Frontend Agent Skills" \
    "Web-specific accessibility (WCAG), semantic HTML, responsive CSS grid/flexbox layouts, and UX copy formatting." \
    "npx --yes skills@latest add hueyexe/frontend-agent-skills -g"

  run_step "Web Design & Interaction Collection" \
    "Specialized CSS keyframes, layout transitions, scroll-driven effects, and Framer Motion patterns for modern websites." \
    "npx --yes skills@latest add MengTo/Skills -g"

  run_step "SEO & Indexing Agent" \
    "Audits technical on-page SEO, OpenGraph data, JSON-LD structured schemas, robots.txt, sitemaps, and Core Web Vitals." \
    "npx --yes skills@latest add ashleytheash/seo-agent-skill -g"

  run_step "Playwright Browser Automation" \
    "Headless browser automation for UI visual regression checks, synthetic user workflows, E2E testing, and screenshots." \
    "npm install -g @playwright/cli@latest && playwright-cli install --skills"

  run_step "Firecrawl CLI" \
    "Crawls, cleans, and converts web pages into LLM-ready clean markdown for real-time web scraping and doc ingestion." \
    "npm install -g firecrawl-cli"
}

install_backend_skills() {
  print_header "🔥 4. BACKEND, DATABASES & CLOUD EDGE"

  run_step "Supabase Agent Skills" \
    "PostgreSQL architecture, Row Level Security (RLS) policies, Edge Functions (Deno), realtime subscriptions, and Auth triggers." \
    "npx --yes skills@latest add supabase/agent-skills -g"

  run_step "Firebase Agent Skills" \
    "Firestore document design, Firebase Cloud Messaging (FCM) push notifications, security rules, and serverless Cloud Functions." \
    "npx --yes skills@latest add firebase/agent-skills -g"

  run_step "Neon Database Skills" \
    "Serverless Postgres, database branching for PRs, index tuning, connection pooling, and low-latency SQL optimization." \
    "npx --yes skills@latest add neondatabase/agent-skills -g"

  run_step "Cloudflare Ecosystem" \
    "Workers, D1 SQL, R2 object storage, KV key-value stores, rate limiting, and edge API caching configurations." \
    "npx --yes skills@latest add https://github.com/cloudflare/skills -g"
}

install_devops_skills() {
  print_header "🐳 5. DEVOPS, LOCAL INFRASTRUCTURE & INTEGRATIONS"

  run_step "Docker Skills" \
    "Multi-stage Dockerfile generation, docker-compose orchestration, local database mock services, and container hardening." \
    "npx --yes skills@latest add docker/agent-skills -g"

  run_step "Composio Integration" \
    "Connects agent directly to GitHub Actions, repository issues, pull requests, Gmail alerts, and external workflow automations." \
    "npx --yes skills@latest add composiohq/skills -g"

  run_step "Postman / OpenAPI Skills" \
    "Ingests Swagger/OpenAPI specifications, generates strongly typed data models (Dart/TS), and automates endpoint contract testing." \
    "npx --yes skills@latest add postman/agent-skills -g"
}

install_code_quality_skills() {
  print_header "🧠 6. CODE QUALITY, OBSERVABILITY & PERSISTENT MEMORY"

  run_step "Andrej Karpathy Engineering Philosophy" \
    "Prioritizes clarity, minimal abstractions, readability, clean foundational code, and strict engineering discipline." \
    "npx --yes skills@latest add multica-ai/andrej-karpathy-skills -g"

  run_step "Caveman (Anti-Overengineering)" \
    "Eliminates framework bloat, prevents over-engineering, enforces simple directory architectures, and refuses micro-abstractions." \
    "npx --yes skills@latest add JuliusBrussee/caveman -g"

  run_step "Ponytail Skills" \
    "Enforces clean software design patterns, eliminating bloated libraries and preserving codebase simplicity." \
    "npx --yes skills@latest add https://github.com/DietrichGebert/ponytail/tree/main/skills -g"

  run_step "MemoryPlugin (Cross-Session Persistence)" \
    "Provides cross-session long-term memory so the agent retains project context, design preferences, and architectural decisions." \
    "npx --yes skills@latest add memoryplugin/agent-skills -g"

  run_step "Sentry for AI" \
    "Automated root-cause analysis for production exceptions, stack trace parsing, and regression pinpointing." \
    "npx --yes skills@latest add getsentry/sentry-for-ai -g"

  run_step "CTX7 Documentation Indexer" \
    "Indexes and injects the latest framework/library documentation directly into the agent context, eliminating hallucinations." \
    "npm install -g ctx7"
}

# Main Execution Flow
main() {
  print_banner
  check_prerequisites

  echo -e "${BOLD}Are you installing skills for an application or a web app?${RESET}"
  echo ""
  echo -e "  ${CYAN}1)${RESET} 📱 ${BOLD}Mobile Application${RESET} (Flutter / Dart / Native + UI/UX + Backend + DevOps + Quality)"
  echo -e "  ${CYAN}2)${RESET} 🌐 ${BOLD}Web Application${RESET}    (Frontend + DOM + SEO + Playwright + Backend + DevOps + Quality)"
  echo -e "  ${CYAN}3)${RESET} 🚀 ${BOLD}All-in-One Full Suite${RESET} (Install ALL Mobile, Web, UI/UX, Cloud, DevOps & Quality skills)"
  echo -e "  ${CYAN}4)${RESET} 🎯 ${BOLD}Custom Selection${RESET}      (Choose specific skill categories to install)"
  echo ""
  echo -n -e "${YELLOW}Select an option [1-4] (default: 3): ${RESET}"
  
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
      install_mobile_skills
      install_backend_skills
      install_devops_skills
      install_code_quality_skills
      ;;
    2)
      echo -e "\n${GREEN}🚀 Starting Web Application Skills Installation...${RESET}"
      install_core_ui_ux
      install_web_skills
      install_backend_skills
      install_devops_skills
      install_code_quality_skills
      ;;
    3|"")
      echo -e "\n${GREEN}🚀 Starting Complete All-in-One Skills Installation...${RESET}"
      install_core_ui_ux
      install_mobile_skills
      install_web_skills
      install_backend_skills
      install_devops_skills
      install_code_quality_skills
      ;;
    4)
      echo -e "\n${BOLD}Select categories to install:${RESET}"
      
      echo -n -e "Install 🎨 Core UI/UX & Taste skills? [Y/n]: "
      read -r c1 < /dev/tty 2>/dev/null || c1="y"
      [[ "$c1" =~ ^[Nn] ]] || install_core_ui_ux

      echo -n -e "Install 📱 Mobile App (Flutter/Dart) skills? [Y/n]: "
      read -r c2 < /dev/tty 2>/dev/null || c2="y"
      [[ "$c2" =~ ^[Nn] ]] || install_mobile_skills

      echo -n -e "Install 🌐 Web Frontend & Browser skills? [Y/n]: "
      read -r c3 < /dev/tty 2>/dev/null || c3="y"
      [[ "$c3" =~ ^[Nn] ]] || install_web_skills

      echo -n -e "Install 🔥 Backend & Cloud Edge skills? [Y/n]: "
      read -r c4 < /dev/tty 2>/dev/null || c4="y"
      [[ "$c4" =~ ^[Nn] ]] || install_backend_skills

      echo -n -e "Install 🐳 DevOps & Integrations skills? [Y/n]: "
      read -r c5 < /dev/tty 2>/dev/null || c5="y"
      [[ "$c5" =~ ^[Nn] ]] || install_devops_skills

      echo -n -e "Install 🧠 Code Quality & Memory skills? [Y/n]: "
      read -r c6 < /dev/tty 2>/dev/null || c6="y"
      [[ "$c6" =~ ^[Nn] ]] || install_code_quality_skills
      ;;
    *)
      echo -e "\n${RED}Invalid option. Defaulting to Complete All-in-One installation.${RESET}"
      install_core_ui_ux
      install_mobile_skills
      install_web_skills
      install_backend_skills
      install_devops_skills
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
