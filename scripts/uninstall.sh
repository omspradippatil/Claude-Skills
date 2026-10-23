#!/usr/bin/env bash
# Compatibility wrapper for the manifest-safe root uninstaller.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec bash "$ROOT/uninstall.sh" "$@"
