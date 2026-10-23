#!/usr/bin/env bash
# Install into the current project; add optional skills with --skills.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec bash "$ROOT/install.sh" --target project "$@"
