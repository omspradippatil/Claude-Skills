#!/usr/bin/env bash
# Uninstall all skills installed by Claude-Skills repository
# Usage: bash uninstall.sh
exec "$(dirname "$0")/install.sh" --uninstall "$@"
