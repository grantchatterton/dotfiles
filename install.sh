#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
TARGET_ALIASES="${HOME}/.bash_aliases"
SOURCE_ALIASES="${SCRIPT_DIR}/.bash_aliases"
FORCE=0

usage() {
	cat <<'EOF'
Usage: ./install.sh [--force]

Symlink this repo's .bash_aliases into ~/.bash_aliases so shell/*.sh is loaded.
Re-running is safe. An existing symlink into this repo is left alone (or
refreshed with --force). A regular ~/.bash_aliases file is backed up first.
EOF
}

for arg in "$@"; do
	case "$arg" in
		-h|--help)
			usage
			exit 0
			;;
		-f|--force)
			FORCE=1
			;;
		*)
			echo "Unknown option: $arg" >&2
			usage >&2
			exit 1
			;;
	esac
done

if [[ ! -f "$SOURCE_ALIASES" ]]; then
	echo "ERROR: missing ${SOURCE_ALIASES}" >&2
	exit 1
fi

if [[ ! -d "${SCRIPT_DIR}/shell" ]]; then
	echo "ERROR: missing ${SCRIPT_DIR}/shell" >&2
	exit 1
fi

link_aliases() {
	ln -sfn "$SOURCE_ALIASES" "$TARGET_ALIASES"
	echo "Linked ${TARGET_ALIASES} -> ${SOURCE_ALIASES}"
}

if [[ -L "$TARGET_ALIASES" ]]; then
	# readlink -f fails when the symlink target is missing (moved/deleted
	# checkout). Treat failed canonicalization as stale and refresh the link.
	desired="$(readlink -f "$SOURCE_ALIASES")"
	if current="$(readlink -f "$TARGET_ALIASES" 2>/dev/null)" &&
		[[ "$current" == "$desired" && "$FORCE" -eq 0 ]]; then
		echo "Already installed: ${TARGET_ALIASES}"
		exit 0
	fi
	link_aliases
	exit 0
fi

if [[ -e "$TARGET_ALIASES" ]]; then
	backup="${TARGET_ALIASES}.bak.$(date +%Y%m%d%H%M%S)"
	mv "$TARGET_ALIASES" "$backup"
	echo "Backed up existing file to ${backup}"
fi

link_aliases
