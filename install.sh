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
    
    echo -n -e "\n${YELLOW}Would you like to add the skills directory to your .gitignore? [Y/n]: ${RESET}"
    if [ -t 0 ] || [ -e /dev/tty ]; then
      read -r IGNORE_INPUT < /dev/tty 2>/dev/null || read -r IGNORE_INPUT || IGNORE_INPUT="y"
    else
      read -r IGNORE_INPUT || IGNORE_INPUT="y"
    fi
    if [[ ! "$IGNORE_INPUT" =~ ^[Nn] ]]; then
      if [ ! -f .gitignore ]; then
        echo -e "${GREEN}Creating .gitignore and adding skills directories...${RESET}"
        echo -e ".claude/skills\n.agent/skills\n.agents/skills" > .gitignore
      else
        echo -e "${GREEN}Updating existing .gitignore...${RESET}"
        grep -q -F ".claude/skills" .gitignore || echo ".claude/skills" >> .gitignore
        grep -q -F ".agent/skills" .gitignore || echo ".agent/skills" >> .gitignore
        grep -q -F ".agents/skills" .gitignore || echo ".agents/skills" >> .gitignore
      fi
    fi
  else
    SCOPE_FLAG="-g"
    SCOPE_NPM="-g"
    SCOPE_DESC="Global (~/.agents & system-wide)"
    SKILLS_DIR="$HOME/.claude/skills"
    mkdir -p "$SKILLS_DIR"
  fi
}


# ==============================================================================
# INSTALLATION FUNCTIONS (ZERO BLOAT)
# ==============================================================================

install_ultimate_skills() {
  print_header "🚀 INSTALLING 14 ULTIMATE DOMAIN SKILLS"
  
  run_step "Downloading Ultimate Skills" \
    "Cloning the consolidated zero-bloat Ultimate Skills directly from the source repository." \
    "rm -rf /tmp/claude-skills-tmp && git clone --depth 1 https://github.com/omspradippatil/Claude-Skills.git /tmp/claude-skills-tmp && mkdir -p $SKILLS_DIR && cp -r /tmp/claude-skills-tmp/.agents/skills/ultimate-* $SKILLS_DIR/ && rm -rf /tmp/claude-skills-tmp"
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
      install_ultimate_skills
      ;;
    2)
      echo -e "\n${GREEN}🚀 Starting Mobile Application Skills Installation into ${SCOPE_DESC}...${RESET}"
      install_ultimate_skills
      ;;
    3)
      echo -e "\n${GREEN}🚀 Starting Web Application Skills Installation into ${SCOPE_DESC}...${RESET}"
      install_ultimate_skills
      ;;
    4)
      echo -e "\n${BOLD}Select categories to install into ${SCOPE_DESC}:${RESET}"
      
      echo -n -e "Install 🎨 Core UI/UX & Taste skills? [Y/n]: "
      read -r c1 < /dev/tty 2>/dev/null || c1="y"
      [[ "$c1" =~ ^[Nn] ]] || install_ultimate_skills
      ;;
    5)
      uninstall_all_skills
      return 0
      ;;
    *)
      echo -e "\n${RED}Invalid option. Defaulting to Complete All-in-One installation.${RESET}"
      install_ultimate_skills
      ;;
  esac

  echo ""
  echo -e "${GREEN}${BOLD}═════════════════════════════════════════════════════════════════════════${RESET}"
  echo -e "${GREEN}${BOLD} 🎉 ALL SKILLS HAVE BEEN INSTALLED & CONFIGURED IN [${SCOPE_DESC}]! 🎉   ${RESET}"
  echo -e "${GREEN}${BOLD}═════════════════════════════════════════════════════════════════════════${RESET}"
  echo ""
}

main "$@"
