#!/usr/bin/env bash
set -euo pipefail

if ! command -v stow >/dev/null; then
  printf '%s\n' 'Stow not found. Please install using apt install stow.' >&2
  exit 1
fi

exec stow --no-folding --target="$HOME" "$@" -- */
