#!/usr/bin/env bash
# Minimal, opt-in installer. No global tools or integrations are installed.
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash install.sh [--target project|global] [--platform agents|claude|cursor|antigravity] [--skills name,...] [--force]

Default: minimal project install for agents (policies and entry-point adapters).
Add only the specialist skills you want with --skills. The "agents" target uses
.agents/skills, "claude" uses .claude/skills, "cursor" uses .cursor/skills,
and "antigravity" uses its product-specific global skills folder. In a project,
agents and antigravity both use .agents/skills. No npm packages or third-party
integrations are installed.
EOF
}

TARGET=project
PLATFORM=agents
SKILLS=""
FORCE=false
while (($#)); do
  case "$1" in
    --target) TARGET="${2:?Missing target}"; shift 2 ;;
    --platform) PLATFORM="${2:?Missing platform}"; shift 2 ;;
    --skills) SKILLS="${2:?Missing skill list}"; shift 2 ;;
    --force) FORCE=true; shift ;;
    --minimal) SKILLS=""; shift ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done
[[ "$TARGET" == project || "$TARGET" == global ]] || { echo "--target must be project or global" >&2; exit 2; }
[[ "$PLATFORM" == agents || "$PLATFORM" == claude || "$PLATFORM" == cursor || "$PLATFORM" == antigravity ]] || { echo "--platform must be agents, claude, cursor, or antigravity" >&2; exit 2; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -s "$SCRIPT_DIR/skills-lock.json" && -d "$SCRIPT_DIR/policies" ]]; then
  REPO="$SCRIPT_DIR"
else
  command -v git >/dev/null || { echo "git is required to fetch the installer source" >&2; exit 1; }
  REPO_TMP="$(mktemp -d)"
  REPO="$REPO_TMP"
  git clone --depth 1 https://github.com/omspradippatil/Claude-Skills.git "$REPO"
fi

if [[ "$TARGET" == global ]]; then
  DEST="$HOME"
else
  DEST="$(pwd)"
fi
SKILL_ROOT=".agents/skills"
[[ "$PLATFORM" == claude ]] && SKILL_ROOT=".claude/skills"
[[ "$PLATFORM" == cursor ]] && SKILL_ROOT=".cursor/skills"
if [[ "$PLATFORM" == antigravity ]]; then
  if [[ "$TARGET" == global ]]; then SKILL_ROOT=".gemini/config/skills"; else SKILL_ROOT=".agents/skills"; fi
fi
MANIFEST="$DEST/.claude-skills-install.manifest"
mkdir -p "$DEST"
if [[ -e "$MANIFEST" && "$FORCE" != true ]]; then
  echo "An install manifest already exists at $MANIFEST; use uninstall first or pass --force." >&2
  exit 1
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
echo "Installed minimal router and policies to $DEST."
if [[ -n "$SKILLS" ]]; then echo "Installed selected skills: $SKILLS"; else echo "No specialist skills selected; add them with --skills name,name."; fi
echo "No third-party tools were installed. Uninstall with bash $REPO/uninstall.sh --target $DEST."
