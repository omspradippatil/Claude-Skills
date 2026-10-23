#!/usr/bin/env bash
# ==============================================================================
# Claude-Skills: Cross-Platform Uninstaller
# Repository: https://github.com/omspradippatil/Claude-Skills
#
# Usage:
#   bash uninstall.sh [--target DIRECTORY]
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
while (($#)); do
  case "$1" in
    --target|-t) TARGET="${2:?Missing target}"; shift 2 ;;
    --help|-h)
      echo "Usage: bash uninstall.sh [--target DIRECTORY]"
      echo "Removes only unchanged files listed by this installation's manifest."
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

if [[ -z "$TARGET" ]]; then
  has_local=false
  has_global=false
  [[ -f "./.claude-skills-install.manifest" ]] && has_local=true
  [[ -f "$HOME/.claude-skills-install.manifest" ]] && has_global=true

  if [[ "$has_local" == true && "$has_global" == true ]]; then
    echo -e "${YELLOW}Install manifests found in both Current Project and User Home.${RESET}"
    echo -e "  1) 📁 Current Project ($(pwd))"
    echo -e "  2) 🌍 Global          ($HOME)"
    ask_user "Which installation would you like to remove? [1-2] (default: 1): " choice "1"
    if [[ "$choice" == "2" || "$choice" == "global" ]]; then
      TARGET="$HOME"
    else
      TARGET="$(pwd)"
    fi
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

TARGET="$(cd "$TARGET" 2>/dev/null && pwd || echo "$TARGET")"
MANIFEST="$TARGET/.claude-skills-install.manifest"
[[ -f "$MANIFEST" ]] || { echo "No install manifest found at $MANIFEST; nothing was removed." >&2; exit 1; }

removed=0 skipped=0
while IFS=$'\t' read -r relative expected; do
  [[ -n "$relative" && -n "$expected" ]] || continue
  case "/$relative/" in /*/../*|*\\*) echo "Unsafe manifest path; stopping: $relative" >&2; exit 1 ;; esac
  [[ "$relative" != /* ]] || { echo "Unsafe absolute manifest path: $relative" >&2; exit 1; }
  file="$TARGET/$relative"
  if [[ -f "$file" ]] && [[ "$(shasum -a 256 "$file" | awk '{print $1}')" == "$expected" ]]; then
    rm "$file"; removed=$((removed + 1))
  else
    echo "Kept changed or missing file: $file"
    skipped=$((skipped + 1))
  fi
done < "$MANIFEST"
rm "$MANIFEST"
echo -e "${GREEN}Removed $removed unchanged installed files; kept $skipped changed or missing files.${RESET}"
