#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
LOCKFILE="$SCRIPT_DIR/.dotfiles_installed"
OLD_BASH_ALIASES="$HOME/.bash_aliases"
NEW_BASH_ALIASES="$SCRIPT_DIR/.bash_aliases"

if [[ -f "$LOCKFILE" ]]; then
  exit 0
fi

ln -sf "$NEW_BASH_ALIASES" "$OLD_BASH_ALIASES"

