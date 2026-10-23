#!/usr/bin/env bash
# Refresh only the upstream UI/UX Pro Max skill using its supported CLI.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: Node.js/npm (npx) is required to refresh UI/UX Pro Max." >&2
  exit 1
fi
if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required to retrieve the upstream reference files." >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "${TMP_DIR}"; }
trap cleanup EXIT

(
  cd "${TMP_DIR}"
  npx --yes --package ui-ux-pro-max-cli uipro init --ai universal --offline
)

GENERATED="${TMP_DIR}/.agents/skills/ui-ux-pro-max"
if [[ ! -s "${GENERATED}/SKILL.md" ]]; then
  echo "Error: upstream CLI completed without producing the expected UI/UX Pro Max skill." >&2
  exit 1
fi

# The official universal CLI output references these files but omits them.
git clone --depth 1 https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git "${TMP_DIR}/upstream" >/dev/null
UPSTREAM_REFS="${TMP_DIR}/upstream/.claude/skills/ui-ux-pro-max/references"
if [[ ! -s "${UPSTREAM_REFS}/quick-reference.md" || ! -s "${UPSTREAM_REFS}/pro-rules.md" ]]; then
  echo "Error: required references are missing from the upstream repository." >&2
  exit 1
fi
mkdir -p "${GENERATED}/references"
cp "${UPSTREAM_REFS}/quick-reference.md" "${UPSTREAM_REFS}/pro-rules.md" "${GENERATED}/references/"

rm -rf "${REPO_ROOT}/.agents/skills/ui-ux-pro-max" "${REPO_ROOT}/.claude/skills/ui-ux-pro-max"
mkdir -p "${REPO_ROOT}/.agents/skills" "${REPO_ROOT}/.claude/skills"
cp -R "${GENERATED}" "${REPO_ROOT}/.agents/skills/ui-ux-pro-max"
cp -R "${GENERATED}" "${REPO_ROOT}/.claude/skills/ui-ux-pro-max"

echo "Updated UI/UX Pro Max in both platform skill directories. Review the diff before committing."
