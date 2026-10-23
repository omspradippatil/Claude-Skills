#!/usr/bin/env bash
# Remove only unchanged files listed by this install's manifest.
set -euo pipefail
TARGET=""
while (($#)); do
  case "$1" in
    --target) TARGET="${2:?Missing target}"; shift 2 ;;
    --help|-h) echo "Usage: bash uninstall.sh --target DIRECTORY"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done
[[ -n "$TARGET" ]] || { echo "Specify --target DIRECTORY; nothing was removed." >&2; exit 2; }
TARGET="$(cd "$TARGET" && pwd)"
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
echo "Removed $removed unchanged installed files; kept $skipped changed or missing files."
