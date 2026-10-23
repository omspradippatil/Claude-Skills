#!/usr/bin/env bash
# ==============================================================================
# Claude-Skills: Cross-Platform Uninstaller
# Repository: https://github.com/omspradippatil/Claude-Skills
#
# Usage:
#   bash uninstall.sh [--target DIRECTORY] [--all]
#   ./uninstall.sh (detects manifest in current project or home)
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/omspradippatil/Claude-Skills/main/uninstall.sh)"
# ==============================================================================

set -euo pipefail

BOLD="\033[1m"; DIM="\033[2m"
CYAN="\033[36m"; GREEN="\033[32m"; YELLOW="\033[33m"; RED="\033[31m"; RESET="\033[0m"

if [[ -n "${NO_COLOR:-}" ]] || [[ ! -t 1 && ! -c /dev/tty ]]; then
  BOLD=""; DIM=""; CYAN=""; GREEN=""; YELLOW=""; RED=""; RESET=""
fi

TARGET=""
ALL_MODE=false
while (($#)); do
  case "$1" in
    --all|-a) ALL_MODE=true; shift ;;
    --target|-t) TARGET="${2:?Missing target}"; shift 2 ;;
    --help|-h)
      echo "Usage: bash uninstall.sh [--target DIRECTORY] [--all]"
      echo "Removes unchanged files listed by installation manifest(s)."
      echo "Options:"
      echo "  --target, -t    Specify target directory to uninstall"
      echo "  --all, -a       All-in-one uninstall: remove both project and global installations"
      echo "  --help, -h      Show this help message"
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done

ask_user() {
  local prompt_text="$1"
  local var_name="$2"
  local default_val="${3:-}"
  local response=""
  if [[ -c /dev/tty ]] && { exec 3</dev/tty; } 2>/dev/null; then
    printf "%b" "$prompt_text" > /dev/tty
    read -r response < /dev/tty || true
    exec 3<&-
  elif [[ -t 0 ]]; then
    printf "%b" "$prompt_text"
    read -r response || true
  else
    response="$default_val"
  fi
  response="$(echo "$response" | tr -d '\r\n')"
  if [[ -z "$response" && -n "$default_val" ]]; then
    response="$default_val"
  fi
  printf -v "$var_name" "%s" "$response"
}

uninstall_directory() {
  local dir="$1"
  dir="$(cd "$dir" 2>/dev/null && pwd || echo "$dir")"
  local manifest="$dir/.claude-skills-install.manifest"
  if [[ ! -f "$manifest" ]]; then
    echo -e "${DIM}No install manifest found at $manifest; skipping.${RESET}"
    return 0
  fi

  echo -e "${CYAN}Uninstalling from:${RESET} $dir"
  local removed=0 skipped=0
  while IFS=$'\t' read -r relative expected; do
    [[ -n "$relative" && -n "$expected" ]] || continue
    case "/$relative/" in /*/../*|*\\*) echo "Unsafe manifest path; skipping: $relative" >&2; continue ;; esac
    [[ "$relative" != /* ]] || { echo "Unsafe absolute manifest path: $relative" >&2; continue; }
    local file="$dir/$relative"
    if [[ -f "$file" ]] && [[ "$(shasum -a 256 "$file" | awk '{print $1}')" == "$expected" ]]; then
      rm "$file"; removed=$((removed + 1))
    else
      echo "Kept changed or missing file: $file"
      skipped=$((skipped + 1))
    fi
  done < "$manifest"
  rm "$manifest"

  # Clean up empty directories if left behind
  for sub in ".claude/skills" ".agents/skills" ".gemini/config/skills" ".cursor/skills" "policies"; do
    if [[ -d "$dir/$sub" ]]; then
      find "$dir/$sub" -type d -empty -delete 2>/dev/null || true
      rmdir "$dir/$sub" 2>/dev/null || true
    fi
  done

  echo -e "${GREEN}✔ Removed $removed unchanged installed files from $dir; kept $skipped changed or missing files.${RESET}"
}

if [[ "$ALL_MODE" == true ]]; then
  echo -e "${CYAN}${BOLD}══ Running All-in-One Uninstall ══${RESET}"
  found_any=false
  if [[ -f "./.claude-skills-install.manifest" ]]; then
    uninstall_directory "$(pwd)"
    found_any=true
  fi
  if [[ -f "$HOME/.claude-skills-install.manifest" && "$(pwd)" != "$HOME" ]]; then
    uninstall_directory "$HOME"
    found_any=true
  fi
  if [[ "$found_any" == false ]]; then
    echo -e "${YELLOW}No install manifests found in current project or user home.${RESET}"
  else
    echo -e "${GREEN}${BOLD}✔ All-in-one uninstall complete!${RESET}"
  fi
  exit 0
fi

if [[ -z "$TARGET" ]]; then
  has_local=false
  has_global=false
  [[ -f "./.claude-skills-install.manifest" ]] && has_local=true
  [[ -f "$HOME/.claude-skills-install.manifest" ]] && has_global=true

  if [[ "$has_local" == true && "$has_global" == true && "$(pwd)" != "$HOME" ]]; then
    echo -e "${YELLOW}Install manifests found in both Current Project and User Home.${RESET}"
    echo -e "  1) 📁 Current Project ($(pwd))"
    echo -e "  2) 🌍 Global          ($HOME)"
    echo -e "  3) 💥 Everything      (Uninstall from both project and global)"
    echo ""
    ask_user "Which installation would you like to remove? [1-3] (default: 1): " choice "1"
    case "$choice" in
      2|global)
        TARGET="$HOME"
        ;;
      3|all|everything)
        uninstall_directory "$(pwd)"
        uninstall_directory "$HOME"
        echo -e "${GREEN}${BOLD}✔ All-in-one uninstall complete!${RESET}"
        exit 0
        ;;
      *)
        TARGET="$(pwd)"
        ;;
    esac
  elif [[ "$has_local" == true ]]; then
    TARGET="$(pwd)"
  elif [[ "$has_global" == true ]]; then
    TARGET="$HOME"
  else
    if [[ -t 0 || -c /dev/tty ]]; then
      ask_user "Enter target directory containing .claude-skills-install.manifest: " TARGET "$(pwd)"
    else
      echo "Specify --target DIRECTORY; no install manifest found in current directory or user home." >&2
      exit 2
    fi
  fi
fi

uninstall_directory "$TARGET"
