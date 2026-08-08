#!/usr/bin/env bash
set -euo pipefail

OLD_BASH_ALIASES_FILE="$HOME/.bash_aliases"
NEW_BASH_ALIASES_FILE="$HOME/dotfiles/.bash_aliases"

if [[ -f "$OLD_BASH_ALIASES_FILE" ]]; then
  rm -f "$OLD_BASH_ALIASES_FILE"
fi

ln -s "$NEW_BASH_ALIASES_FILE" "$OLD_BASH_ALIASES_FILE"
