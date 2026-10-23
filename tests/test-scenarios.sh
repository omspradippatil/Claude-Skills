#!/usr/bin/env bash
# Exercise the actual candidate router with representative task descriptions.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 "$ROOT/tests/test-routing.py"
python3 "$ROOT/tests/test-skill-reach.py"
