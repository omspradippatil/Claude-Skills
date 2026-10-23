#!/usr/bin/env bash
# ==============================================================================
# AI Agent Skills Installer — Cross-Platform Engineering System
# Repository: https://github.com/omspradippatil/Claude-Skills
#
# Usage:
#   bash install.sh [OPTIONS]
#   curl -fsSL https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.sh | bash
#
# Options:
#   --global,  -g     Install globally (~/.claude/skills & ~/.gemini/config/skills)
#   --project, -p     Install into current project directory
#   --all,     -a     Install without prompts
#   --force,   -f     Overwrite existing skill files
#   --uninstall,-u    Remove installed skills
#   --help,    -h     Show this help
# ==============================================================================

set -euo pipefail

# ── Colors ────────────────────────────────────────────────────────────────────
BOLD="\033[1m"; DIM="\033[2m"
CYAN="\033[36m"; BLUE="\033[34m"; GREEN="\033[32m"
YELLOW="\033[33m"; RED="\033[31m"; RESET="\033[0m"

REPO_URL="https://github.com/omspradippatil/Claude-Skills.git"
REPO_RAW="https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main"
TMP_DIR="/tmp/claude-skills-install-$$"
FORCE=false

# ── Helpers ───────────────────────────────────────────────────────────────────
info()    { echo -e "${CYAN}${BOLD}ℹ${RESET}  $*"; }
success() { echo -e "${GREEN}${BOLD}✔${RESET}  $*"; }
warn()    { echo -e "${YELLOW}${BOLD}⚠${RESET}  $*"; }
error()   { echo -e "${RED}${BOLD}✖${RESET}  $*" >&2; }
header()  { echo -e "\n${BLUE}${BOLD}══ $* ══${RESET}"; }

cleanup() { rm -rf "$TMP_DIR" 2>/dev/null || true; }
trap cleanup EXIT

# ── Prerequisite checks ───────────────────────────────────────────────────────
check_prerequisites() {
  header "Checking Prerequisites"
  local ok=true

  if command -v git >/dev/null 2>&1; then
    success "git $(git --version | awk '{print $3}')"
  else
    error "git is required but not found. Install git and retry."
    ok=false
  fi

  if command -v node >/dev/null 2>&1; then
    success "node $(node -v)"
  else
    warn "Node.js not found — npm-based tools (firecrawl-cli, ctx7, etc.) will be unavailable."
  fi

  if command -v npm >/dev/null 2>&1; then
    success "npm $(npm -v)"
  fi

  $ok || { error "Prerequisites not met. Aborting."; exit 1; }
  echo ""
}

# ── Clone repo to temp dir ────────────────────────────────────────────────────
fetch_repo() {
  if [[ -d "$TMP_DIR" ]]; then return; fi
  info "Fetching latest skills from $REPO_URL …"
  if git clone --depth 1 --quiet "$REPO_URL" "$TMP_DIR" 2>/dev/null; then
    success "Repository fetched"
  else
    error "Failed to clone repository. Check your internet connection."
    exit 1
  fi
}

# ── Copy skills to a target dir ───────────────────────────────────────────────
install_skills_to() {
  local src="$TMP_DIR/.agents/skills"
  local dst="$1"
  local label="$2"

  if [[ ! -d "$src" ]]; then
    warn "No skills found in cloned repo ($src) — skipping $label"
    return
  fi

  mkdir -p "$dst"
  local count=0 skipped=0

  for skill_dir in "$src"/*/; do
    local skill_name
    skill_name="$(basename "$skill_dir")"
    local target="$dst/$skill_name"

    if [[ -d "$target" ]] && ! $FORCE; then
      skipped=$((skipped + 1))
      continue
    fi

    cp -r "$skill_dir" "$target"
    count=$((count + 1))
  done

  if [[ $count -gt 0 ]]; then
    success "Installed $count skill(s) to $label"
  fi
  if [[ $skipped -gt 0 ]]; then
    info "$skipped skill(s) already existed (use --force to overwrite)"
  fi
}

# ── Copy policy files ─────────────────────────────────────────────────────────
install_policies_to() {
  local dst_root="$1"
  local label="$2"
  local src_policies="$TMP_DIR/policies"

  if [[ -d "$src_policies" ]]; then
    mkdir -p "$dst_root/policies"
    cp -r "$src_policies/"* "$dst_root/policies/" 2>/dev/null || true
    success "Copied policies/ to $label"
  fi
}

# ── Copy entry-point files ────────────────────────────────────────────────────
install_entry_point() {
  local src="$TMP_DIR/$1"
  local dst="$2"
  local label="$3"

  if [[ ! -f "$src" ]]; then return; fi

  if [[ -f "$dst" ]] && ! $FORCE; then
    local answer="y"
    if [[ -t 0 ]]; then
      echo -n -e "${YELLOW}$dst already exists. Overwrite? [y/N]: ${RESET}"
      read -r answer </dev/tty 2>/dev/null || answer="n"
    fi
    [[ "$answer" =~ ^[Yy] ]] || { info "Skipped $label"; return; }
  fi

  cp "$src" "$dst"
  success "Installed $label → $dst"
}

# ── Global install ────────────────────────────────────────────────────────────
install_global() {
  header "Global Installation"
  fetch_repo

  local claude_skills="$HOME/.claude/skills"
  local gemini_skills="$HOME/.gemini/config/skills"
  local gemini_rules="$HOME/.gemini/config/rules"

  install_skills_to "$claude_skills"  "~/.claude/skills"
  install_skills_to "$gemini_skills"  "~/.gemini/config/skills"

  # Copy rules if source has them
  if [[ -d "$TMP_DIR/.agents/rules" ]]; then
    mkdir -p "$gemini_rules"
    cp -r "$TMP_DIR/.agents/rules/"* "$gemini_rules/" 2>/dev/null || true
    success "Installed rules to ~/.gemini/config/rules"
  fi

  # Install npm packages if node available
  if command -v npm >/dev/null 2>&1; then
    header "Optional npm Packages"
    local pkgs=(firecrawl-cli ctx7 antigravity-workflows)
    for pkg in "${pkgs[@]}"; do
      info "Installing $pkg …"
      npm install -g "$pkg" --quiet 2>/dev/null && success "$pkg installed" || warn "$pkg install failed (skipping)"
    done
  fi
}

# ── Project install ───────────────────────────────────────────────────────────
install_project() {
  local project_dir="${1:-$(pwd)}"
  header "Project Installation into $project_dir"
  fetch_repo

  install_skills_to "$project_dir/.agents/skills" ".agents/skills"
  install_skills_to "$project_dir/.claude/skills"  ".claude/skills"
  install_policies_to "$project_dir" "project policies"

  # Entry points
  for f in CLAUDE.md AGENTS.md GEMINI.md; do
    install_entry_point "$f" "$project_dir/$f" "$f"
  done

  # .cursor/rules
  if [[ -d "$TMP_DIR/.cursor/rules" ]]; then
    mkdir -p "$project_dir/.cursor/rules"
    cp -r "$TMP_DIR/.cursor/rules/"* "$project_dir/.cursor/rules/" 2>/dev/null || true
    success "Installed .cursor/rules"
  fi

  # Offer to update .gitignore
  local answer="n"
  if [[ -t 0 ]]; then
    echo -n -e "\n${YELLOW}Add skills directories to .gitignore? [Y/n]: ${RESET}"
    read -r answer </dev/tty 2>/dev/null || answer="y"
  fi
  if [[ ! "$answer" =~ ^[Nn] ]]; then
    local gitignore="$project_dir/.gitignore"
    touch "$gitignore"
    grep -q ".claude/skills" "$gitignore" || echo ".claude/skills" >> "$gitignore"
    grep -q ".agents/skills" "$gitignore" || echo ".agents/skills" >> "$gitignore"
    success "Updated .gitignore"
  fi
}

# ── Uninstall ─────────────────────────────────────────────────────────────────
uninstall_global() {
  header "Uninstalling Global Skills"
  warn "This will remove all skills installed by this repository."

  local answer="n"
  if [[ -t 0 ]]; then
    echo -n -e "${RED}Are you sure? [y/N]: ${RESET}"
    read -r answer </dev/tty 2>/dev/null || answer="n"
  fi
  [[ "$answer" =~ ^[Yy] ]] || { info "Aborted."; return; }

  # We only remove the skill names we know about — not all of ~/.claude/skills
  local known_skills=(
    security-auditor seo-marketing frontend-design api-architecture
    postgres-ecosystem firebase-expert cloudflare-expert devops-cicd
    testing-qa mobile-engineering llm-optimization state-management
    web-animation assets-media 3d-visuals web-gamedev
    git-collaboration sentry-expert ux-research
  )

  local removed=0
  for skill in "${known_skills[@]}"; do
    for dir in "$HOME/.claude/skills/$skill" "$HOME/.gemini/config/skills/$skill"; do
      if [[ -d "$dir" ]]; then
        rm -rf "$dir"
        success "Removed $dir"
        removed=$((removed + 1))
      fi
    done
  done

  # npm packages
  if command -v npm >/dev/null 2>&1; then
    npm uninstall -g firecrawl-cli ctx7 antigravity-workflows 2>/dev/null || true
  fi

  info "Removed $removed skill directories."
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  local mode=""

  # Parse args
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --global|-g)    mode="global";  shift ;;
      --project|-p)   mode="project"; shift ;;
      --all|-a)       mode="${mode:-global}"; shift ;;
      --force|-f)     FORCE=true; shift ;;
      --uninstall|-u) mode="uninstall"; shift ;;
      --help|-h)
        grep '^#' "$0" | sed 's/^# \{0,2\}//' | head -20
        exit 0
        ;;
      *) shift ;;
    esac
  done

  echo -e "${CYAN}${BOLD}"
  echo "╔══════════════════════════════════════════════════════════════════╗"
  echo "║        ⚡ Claude Skills — Cross-Platform Engineering System      ║"
  echo "║           Claude Code · Antigravity · Cursor · Codex            ║"
  echo "╚══════════════════════════════════════════════════════════════════╝"
  echo -e "${RESET}"

  check_prerequisites

  # Interactive mode selection
  if [[ -z "$mode" && -t 0 ]]; then
    echo -e "${BOLD}Installation scope:${RESET}"
    echo -e "  ${CYAN}1)${RESET} 🌍 Global   — ~/.claude/skills & ~/.gemini/config/skills"
    echo -e "  ${CYAN}2)${RESET} 📁 Project  — $(pwd)/.claude/skills & .agents/skills"
    echo -e "  ${RED}3)${RESET} 🗑️  Uninstall — Remove globally installed skills"
    echo ""
    echo -n -e "${YELLOW}Select [1-3] (default: 1): ${RESET}"
    read -r choice </dev/tty 2>/dev/null || choice="1"
    case "${choice:-1}" in
      2) mode="project" ;;
      3) mode="uninstall" ;;
      *) mode="global" ;;
    esac
  fi

  mode="${mode:-global}"

  case "$mode" in
    global)    install_global ;;
    project)   install_project ;;
    uninstall) uninstall_global ;;
    *)
      error "Unknown mode: $mode"
      exit 1
      ;;
  esac

  echo ""
  echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════════════${RESET}"
  echo -e "${GREEN}${BOLD}  ✅  Done! Run scripts/validate.sh to verify the installation.      ${RESET}"
  echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════════════${RESET}"
  echo ""
}

main "$@"
