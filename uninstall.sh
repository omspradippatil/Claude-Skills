#!/usr/bin/env bash

# ==============================================================================
# 🗑️ AI Agent Skills Uninstaller (macOS & Linux)
# Repository: https://github.com/omspradippatil/Claude-Skills
# ==============================================================================

BOLD="\033[1m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${RED}${BOLD}"
echo "╔═════════════════════════════════════════════════════════════════════════╗"
echo "║                  🗑️  AI CODING SKILLS UNINSTALLER                      ║"
echo "╚═════════════════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

echo -e "${YELLOW}Uninstalling all global skills CLI entries...${RESET}"
npx --yes skills@latest remove --all -g -y 2>/dev/null || true

echo -e "${YELLOW}Uninstalling global npm packages (uipro-cli, @playwright/cli, firecrawl-cli, ctx7, antigravity-workflows)...${RESET}"
npm uninstall -g uipro-cli @playwright/cli firecrawl-cli ctx7 antigravity-workflows 2>/dev/null || true

if command -v dart >/dev/null 2>&1; then
  echo -e "${YELLOW}Deactivating global Dart skills CLI...${RESET}"
  dart pub global deactivate skills 2>/dev/null || true
fi

echo -e "${YELLOW}Removing cloned Claude skills directories...${RESET}"
rm -rf ~/.claude/skills/flutter-skills ~/.claude/skills/seo ~/.claude/skills/claude-skills

echo ""
echo -e "${GREEN}${BOLD}✔ All AI skills and global tools have been removed successfully!${RESET}"
echo ""
