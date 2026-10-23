#!/usr/bin/env bash
# ==============================================================================
# Claude-Skills: Cross-Platform AI Agent Skills Installer
# Repository: https://github.com/omspradippatil/Claude-Skills
#
# Usage:
#   bash install.sh [OPTIONS]
#   ./install.sh (interactive terminal mode)
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.sh)"
# ==============================================================================

set -euo pipefail

# ── Color Palette ─────────────────────────────────────────────────────────────
BOLD="\033[1m"; DIM="\033[2m"
CYAN="\033[36m"; BLUE="\033[34m"; GREEN="\033[32m"
YELLOW="\033[33m"; MAGENTA="\033[35m"; RED="\033[31m"; RESET="\033[0m"

if [[ -n "${NO_COLOR:-}" ]] || [[ ! -t 1 && ! -c /dev/tty ]]; then
  BOLD=""; DIM=""; CYAN=""; BLUE=""; GREEN=""; YELLOW=""; MAGENTA=""; RED=""; RESET=""
fi

usage() {
  cat <<'EOF'
Usage: bash install.sh [OPTIONS]

Options:
  --target, -t          Target directory scope: 'project' or 'global' (default: project)
  --platform, -p        Target platform: 'claude', 'antigravity', 'cursor', or 'agents' (default: agents)
  --skills, -s          Comma-separated list of skills to install
  --all, -a             Install all available domain skills
  --minimal, -m         Minimal install (router and policies only, no specialist skills)
  --force, -f           Overwrite existing files without prompting
  --uninstall, -u       Uninstall previously installed skills from target
  --non-interactive, -y Run non-interactively using defaults
  --help, -h            Show this help message

Interactive:
  Run without skill options in a terminal to launch the interactive setup menu:
    ./install.sh
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/install.sh)"
EOF
}

TARGET=""
PLATFORM=""
SKILLS=""
FORCE=false
MODE_EXPLICIT=false
DO_UNINSTALL=false
INSTALL_ALL=false
NON_INTERACTIVE=false

while (($#)); do
  case "$1" in
    --target|-t) TARGET="${2:?Missing target}"; shift 2 ;;
    --platform|-p) PLATFORM="${2:?Missing platform}"; shift 2 ;;
    --skills|-s) SKILLS="${2:?Missing skill list}"; MODE_EXPLICIT=true; shift 2 ;;
    --all|-a|--full) INSTALL_ALL=true; MODE_EXPLICIT=true; shift ;;
    --minimal|-m) SKILLS=""; MODE_EXPLICIT=true; shift ;;
    --force|-f) FORCE=true; shift ;;
    --uninstall|-u) DO_UNINSTALL=true; MODE_EXPLICIT=true; shift ;;
    --non-interactive|-y) NON_INTERACTIVE=true; shift ;;
    --global|-g) TARGET="global"; shift ;;
    --project) TARGET="project"; shift ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ -n "$TARGET" && "$TARGET" != "project" && "$TARGET" != "global" ]]; then
  echo "--target must be 'project' or 'global'" >&2; exit 2
fi
if [[ -n "$PLATFORM" && "$PLATFORM" != "agents" && "$PLATFORM" != "claude" && "$PLATFORM" != "cursor" && "$PLATFORM" != "antigravity" ]]; then
  echo "--platform must be 'agents', 'claude', 'cursor', or 'antigravity'" >&2; exit 2
fi

# ── Locate Repository Source ──────────────────────────────────────────────────
SCRIPT_SOURCE="${BASH_SOURCE[0]:-}"
if [[ -n "$SCRIPT_SOURCE" && -f "$SCRIPT_SOURCE" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_SOURCE")" && pwd)"
else
  SCRIPT_DIR="$(pwd)"
fi

REPO_TMP=""
if [[ -s "$SCRIPT_DIR/skills-lock.json" && -d "$SCRIPT_DIR/policies" && -d "$SCRIPT_DIR/.agents/skills" ]]; then
  REPO="$SCRIPT_DIR"
else
  command -v git >/dev/null 2>&1 || { echo "git is required to fetch the installer source" >&2; exit 1; }
  REPO_TMP="$(mktemp -d)"
  REPO="$REPO_TMP"
  echo -e "${CYAN}Fetching installer source from git repository...${RESET}"
  GIT_REPO="${CLAUDE_SKILLS_REPO:-https://github.com/omspradippatil/Claude-Skills.git}"
  GIT_REF="${CLAUDE_SKILLS_REF:-}"
  if [[ -n "$GIT_REF" ]]; then
    git clone --depth 1 --branch "$GIT_REF" "$GIT_REPO" "$REPO" 2>/dev/null || git clone --depth 1 "$GIT_REPO" "$REPO"
  else
    git clone --depth 1 "$GIT_REPO" "$REPO"
  fi
fi

# ── Discover Available Skills ─────────────────────────────────────────────────
AVAILABLE_SKILLS=()
if [[ -d "$REPO/.agents/skills" ]]; then
  while IFS= read -r dir; do
    [[ -s "$dir/SKILL.md" ]] && AVAILABLE_SKILLS+=("$(basename "$dir")")
  done < <(find "$REPO/.agents/skills" -mindepth 1 -maxdepth 1 -type d | sort)
fi
ALL_SKILLS_CSV=$(IFS=,; echo "${AVAILABLE_SKILLS[*]}")

RECOMMENDED_SKILLS="ui-ux-pro-max,api-architecture,testing-qa,security-auditor,devops-cicd,state-management"

# ── Interactive TTY Detection & Helper ─────────────────────────────────────────
if [[ -z "$SCRIPT_SOURCE" ]]; then
  INPUT_SOURCE="tty"
else
  INPUT_SOURCE="stdin"
fi

HAS_TTY=false
if [[ "$NON_INTERACTIVE" == true || "${CI:-}" == "true" ]]; then
  HAS_TTY=false
elif [[ "$INPUT_SOURCE" == "tty" ]]; then
  if [[ -c /dev/tty ]] && { exec 3</dev/tty; } 2>/dev/null; then
    exec 3<&-
    HAS_TTY=true
  fi
elif [[ -t 0 ]]; then
  HAS_TTY=true
elif [[ ! -t 0 ]]; then
  HAS_TTY=true
fi

ask_user() {
  local prompt_text="$1"
  local var_name="$2"
  local default_val="${3:-}"
  local response=""
  if [[ "$INPUT_SOURCE" == "tty" && -c /dev/tty ]]; then
    printf "%b" "$prompt_text" > /dev/tty
    read -r response < /dev/tty || true
  else
    printf "%b" "$prompt_text"
    read -r response || true
  fi
  response="$(echo "$response" | tr -d '\r\n')"
  if [[ -z "$response" && -n "$default_val" ]]; then
    response="$default_val"
  fi
  printf -v "$var_name" "%s" "$response"
}

# ── Interactive Menu ──────────────────────────────────────────────────────────
if [[ "$MODE_EXPLICIT" == false && "$HAS_TTY" == true ]]; then
  echo -e "${CYAN}${BOLD}"
  echo "╔═════════════════════════════════════════════════════════════════════════╗"
  echo "║        ⚡ Claude-Skills — Cross-Platform AI Agent Suite                 ║"
  echo "║           Claude Code · Antigravity · Cursor · Codex                    ║"
  echo "╚═════════════════════════════════════════════════════════════════════════╝"
  echo -e "${RESET}"

  # Step 1: Target Scope
  if [[ -z "$TARGET" ]]; then
    echo -e "${BOLD}Where would you like to install?${RESET}"
    echo -e "  ${CYAN}1)${RESET} 📁 Current Project (${DIM}$(pwd)${RESET})"
    echo -e "  ${CYAN}2)${RESET} 🌍 Global          (${DIM}$HOME${RESET})"
    echo ""
    ask_user "${YELLOW}Select target [1-2] (default: 1): ${RESET}" target_choice "1"
    case "$target_choice" in
      2|global) TARGET="global" ;;
      *) TARGET="project" ;;
    esac
    echo ""
  fi

  # Step 2: Target Platform
  if [[ -z "$PLATFORM" ]]; then
    echo -e "${BOLD}Which AI platform / agent are you configuring?${RESET}"
    echo -e "  ${CYAN}1)${RESET} 🤖 Claude Code       (${DIM}.claude/skills${RESET})"
    echo -e "  ${CYAN}2)${RESET} ⚡ Antigravity / AGY (${DIM}.gemini/config/skills or .agents/skills${RESET})"
    echo -e "  ${CYAN}3)${RESET} 🖱️  Cursor            (${DIM}.cursor/skills${RESET})"
    echo -e "  ${CYAN}4)${RESET} 🧠 Codex / Agents    (${DIM}.agents/skills${RESET})"
    echo ""
    ask_user "${YELLOW}Select platform [1-4] (default: 1): ${RESET}" platform_choice "1"
    case "$platform_choice" in
      2|antigravity) PLATFORM="antigravity" ;;
      3|cursor) PLATFORM="cursor" ;;
      4|agents|codex) PLATFORM="agents" ;;
      *) PLATFORM="claude" ;;
    esac
    echo ""
  fi

  # Step 3: What all to install in terminal
  echo -e "${BOLD}What all would you like to install?${RESET}"
  echo -e "  ${CYAN}1)${RESET} 🚀 All Skills        (${DIM}Install all 19 domain skills${RESET})"
  echo -e "  ${CYAN}2)${RESET} ⭐ Recommended Pack  (${DIM}ui-ux-pro-max, api-architecture, testing-qa, security-auditor, devops-cicd, state-management${RESET})"
  echo -e "  ${CYAN}3)${RESET} 🎯 Custom Selection  (${DIM}Choose specific skills from catalog${RESET})"
  echo -e "  ${CYAN}4)${RESET} 📄 Minimal           (${DIM}Policies and task router only — no specialist skills${RESET})"
  echo -e "  ${RED}5)${RESET} 🗑️  Uninstall         (${DIM}Remove installed skills and clean up${RESET})"
  echo ""
  ask_user "${YELLOW}Select option [1-5] (default: 1): ${RESET}" suite_choice "1"

  case "$suite_choice" in
    1)
      INSTALL_ALL=true
      ;;
    2)
      SKILLS="$RECOMMENDED_SKILLS"
      ;;
    3)
      echo ""
      echo -e "${BOLD}Available Domain Skills (${#AVAILABLE_SKILLS[@]}):${RESET}"
      local_idx=1
      for sk in "${AVAILABLE_SKILLS[@]}"; do
        printf "  ${CYAN}[%2d]${RESET} %-22s" "$local_idx" "$sk"
        if (( local_idx % 3 == 0 )); then echo ""; fi
        local_idx=$((local_idx + 1))
      done
      if (( (local_idx - 1) % 3 != 0 )); then echo ""; fi
      echo ""
      ask_user "${YELLOW}Enter skill numbers or names (comma-separated, e.g. 2,11,16): ${RESET}" custom_input ""
      IFS=',' read -r -a input_parts <<< "$custom_input"
      selected_custom=()
      for part in "${input_parts[@]}"; do
        clean_part="$(echo "$part" | xargs)"
        if [[ "$clean_part" =~ ^[0-9]+$ ]]; then
          idx_num=$((clean_part - 1))
          if (( idx_num >= 0 && idx_num < ${#AVAILABLE_SKILLS[@]} )); then
            selected_custom+=("${AVAILABLE_SKILLS[$idx_num]}")
          fi
        elif [[ -n "$clean_part" ]]; then
          selected_custom+=("$clean_part")
        fi
      done
      SKILLS=$(IFS=,; echo "${selected_custom[*]}")
      ;;
    4)
      SKILLS=""
      ;;
    5)
      DO_UNINSTALL=true
      ;;
    *)
      INSTALL_ALL=true
      ;;
  esac
fi

# ── Default Fallbacks for Non-Interactive Runs ────────────────────────────────
TARGET="${TARGET:-project}"
PLATFORM="${PLATFORM:-agents}"
if [[ "$INSTALL_ALL" == true ]]; then
  SKILLS="$ALL_SKILLS_CSV"
fi

if [[ "$TARGET" == global ]]; then
  DEST="$HOME"
else
  DEST="$(pwd)"
fi

# ── Handle Uninstallation ─────────────────────────────────────────────────────
if [[ "$DO_UNINSTALL" == true ]]; then
  if [[ -f "$REPO/uninstall.sh" ]]; then
    exec bash "$REPO/uninstall.sh" --target "$DEST"
  else
    echo "uninstall.sh not found in $REPO" >&2
    exit 1
  fi
fi

# ── Platform Skill Folder Setup ───────────────────────────────────────────────
SKILL_ROOT=".agents/skills"
[[ "$PLATFORM" == claude ]] && SKILL_ROOT=".claude/skills"
[[ "$PLATFORM" == cursor ]] && SKILL_ROOT=".cursor/skills"
if [[ "$PLATFORM" == antigravity ]]; then
  if [[ "$TARGET" == global ]]; then SKILL_ROOT=".gemini/config/skills"; else SKILL_ROOT=".agents/skills"; fi
fi

MANIFEST="$DEST/.claude-skills-install.manifest"
mkdir -p "$DEST"

if [[ -e "$MANIFEST" && "$FORCE" != true ]]; then
  if [[ "$HAS_TTY" == true && "$MODE_EXPLICIT" == false ]]; then
    ask_user "${YELLOW}An install manifest already exists at $DEST. Overwrite? [y/N]: ${RESET}" overwrite_ans "n"
    if [[ "$overwrite_ans" =~ ^[Yy] ]]; then
      FORCE=true
    else
      echo "Installation cancelled." >&2
      exit 1
    fi
  else
    echo "An install manifest already exists at $MANIFEST; use uninstall first or pass --force." >&2
    exit 1
  fi
fi

if [[ -n "$SKILLS" ]]; then
  IFS=',' read -r -a requested <<< "$SKILLS"
  for name in "${requested[@]}"; do
    [[ "$name" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ && -d "$REPO/.agents/skills/$name" && -s "$REPO/.agents/skills/$name/SKILL.md" ]] || {
      echo "Unknown or incomplete skill: $name" >&2; exit 1;
    }
  done
fi

TMP_MANIFEST="$(mktemp)"
trap 'rm -f "$TMP_MANIFEST"; [[ -z "${REPO_TMP:-}" ]] || rm -rf "$REPO_TMP"' EXIT

copy_file() {
  local source="$1" relative="$2"
  local destination="$DEST/$relative"
  if [[ -e "$destination" && "$FORCE" != true ]]; then
    echo "Refusing to overwrite existing file: $destination (use --force)" >&2
    return 1
  fi
  mkdir -p "$(dirname "$destination")"
  cp "$source" "$destination"
  digest="$(shasum -a 256 "$destination" 2>/dev/null | awk '{print $1}')"
  [[ -n "$digest" ]] || { echo "Unable to calculate SHA-256 for $destination" >&2; return 1; }
  printf '%s\t%s\n' "$relative" "$digest" >> "$TMP_MANIFEST"
}

# Router, shared policies, and lightweight platform adapters form the minimal install.
copy_file "$REPO/CLAUDE.md" "CLAUDE.md"
copy_file "$REPO/AGENTS.md" "AGENTS.md"
copy_file "$REPO/GEMINI.md" "GEMINI.md"
copy_file "$REPO/.cursor/rules/always-on.mdc" ".cursor/rules/always-on.mdc"
for file in "$REPO"/policies/*.md; do copy_file "$file" "policies/$(basename "$file")"; done
copy_file "$REPO/skills-lock.json" "skills-lock.json"
copy_file "$REPO/scripts/route-task.py" "scripts/route-task.py"

if [[ -n "$SKILLS" ]]; then
  for name in "${requested[@]}"; do
    while IFS= read -r -d '' source; do
      rel="${source#"$REPO/"}"
      rel="${rel/.agents\/skills/$SKILL_ROOT}"
      copy_file "$source" "$rel"
    done < <(find "$REPO/.agents/skills/$name" -type f -print0)
  done
fi

mv "$TMP_MANIFEST" "$MANIFEST"

echo ""
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}  ✅ Installation complete!${RESET}"
echo -e "${GREEN}${BOLD}══════════════════════════════════════════════════════════════════════${RESET}"
echo -e "  ${CYAN}Destination:${RESET}      $DEST"
echo -e "  ${CYAN}Platform:${RESET}         $PLATFORM ($SKILL_ROOT)"
if [[ -n "$SKILLS" ]]; then
  echo -e "  ${CYAN}Installed skills:${RESET} $SKILLS"
else
  echo -e "  ${CYAN}Installed skills:${RESET} None (minimal router and policies only)"
fi
echo ""
echo -e "  ${DIM}Verify routing:${RESET}   python3 scripts/route-task.py --task \"your task\""
echo -e "  ${DIM}To uninstall:${RESET}     bash $REPO/uninstall.sh --target $DEST"
echo ""
