#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

if ! command -v stow >/dev/null 2>&1; then
  printf '%s\n' 'GNU Stow is required. On Debian/Ubuntu: sudo apt install stow' >&2
  exit 1
fi

# Keep ~/bin a real directory so other tools can safely install files there.
# Additional arguments are passed to Stow (e.g. --simulate or --delete).
exec stow --dir="${SCRIPT_DIR}/stow" --target="${HOME}" \
  --no-folding --verbose "$@" -- bash git scripts
