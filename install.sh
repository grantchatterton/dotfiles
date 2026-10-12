#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
FORCE=0

usage() {
	cat <<'EOF'
Usage: ./install.sh [--force]

Symlink this repo's .bash_aliases and .gitconfig into $HOME, and ensure the
repo's bin/ is on PATH via ~/.bashrc.

Re-running is safe. An existing symlink into this repo is left alone (or
refreshed with --force). A regular file is backed up first.
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

if [[ ! -d "${SCRIPT_DIR}/shell" ]]; then
	echo "ERROR: missing ${SCRIPT_DIR}/shell" >&2
	exit 1
fi

# Link $1 (repo-relative name under SCRIPT_DIR) to $HOME/$1
ensure_link() {
	local name="$1"
	local source="${SCRIPT_DIR}/${name}"
	local target="${HOME}/${name}"

	if [[ ! -f "$source" ]]; then
		echo "ERROR: missing ${source}" >&2
		return 1
	fi

	if [[ -L "$target" ]]; then
		# readlink -f fails when the symlink target is missing (moved/deleted
		# checkout). Treat failed canonicalization as stale and refresh the link.
		local desired current
		desired="$(readlink -f "$source")"
		if current="$(readlink -f "$target" 2>/dev/null)" &&
			[[ "$current" == "$desired" && "$FORCE" -eq 0 ]]; then
			echo "Already installed: ${target}"
			return 0
		fi
	elif [[ -e "$target" ]]; then
		local backup
		backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
		mv "$target" "$backup"
		echo "Backed up existing file to ${backup}"
	fi

	ln -sfn "$source" "$target"
	echo "Linked ${target} -> ${source}"
}

# Ensure ${SCRIPT_DIR}/bin is on PATH; append export to ~/.bashrc if missing.
ensure_bin_on_path() {
	local bin_dir="${SCRIPT_DIR}/bin"
	local bashrc="${HOME}/.bashrc"
	local export_line="export PATH=\"${bin_dir}:\$PATH\""

	mkdir -p "$bin_dir"

	case ":${PATH}:" in
		*":${bin_dir}:"*)
			echo "Already on PATH: ${bin_dir}"
			return 0
			;;
	esac

	if [[ -f "$bashrc" ]] && grep -Fqx "$export_line" "$bashrc"; then
		echo "PATH export already in ${bashrc} (source to apply)"
		return 0
	fi

	printf '\n# dotfiles bin\n%s\n' "$export_line" >>"$bashrc"
	echo "Added ${bin_dir} to PATH in ${bashrc}"
}

ensure_link ".bash_aliases"
ensure_link ".gitconfig"
ensure_bin_on_path
