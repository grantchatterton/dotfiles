#!/usr/bin/env bash
set -euo pipefail

# Installs these dotfiles into $HOME:
#   - symlinks .bash_aliases and .gitconfig
#   - adds this repo's bin/ to PATH via ~/.bashrc
# Idempotent: safe to re-run.

# Canonical absolute path of the repo (resolves symlinks to this script).
SCRIPT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
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

# --- Parse args ---
for arg in "$@"; do
	case "$arg" in
		-h | --help)
			usage
			exit 0
			;;
		-f | --force) FORCE=1 ;;
		*)
			echo "Unknown option: $arg" >&2
			usage >&2
			exit 1
			;;
	esac
done

# .bash_aliases sources shell/*.sh; linking it without shell/ would break it.
if [[ ! -d "${SCRIPT_DIR}/shell" ]]; then
	echo "ERROR: missing ${SCRIPT_DIR}/shell" >&2
	exit 1
fi

# Symlink $HOME/<name> -> <repo>/<name>.
# - Correct link already present: skip (unless --force).
# - Wrong/stale link: replaced.
# - Regular file/dir: moved to <name>.bak.<timestamp> first.
ensure_link() {
	local name="$1"
	local source="${SCRIPT_DIR}/${name}"
	local target="${HOME}/${name}"

	if [[ ! -f "$source" ]]; then
		echo "ERROR: missing ${source}" >&2
		return 1
	fi

	if [[ -L "$target" ]]; then
		# SCRIPT_DIR is canonical and we always link with it, so a raw
		# readlink match means the link is ours and current.
		if [[ "$(readlink "$target")" == "$source" && "$FORCE" -eq 0 ]]; then
			echo "Already installed: ${target}"
			return 0
		fi
	elif [[ -e "$target" ]]; then
		local backup
		backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
		mv -- "$target" "$backup"
		echo "Backed up existing file to ${backup}"
	fi

	# -f: replace existing link; -n: don't follow target if it links to a dir.
	ln -sfn -- "$source" "$target"
	echo "Linked ${target} -> ${source}"
}

# Make sure <repo>/bin is on PATH. If not on the current PATH and not
# already exported in ~/.bashrc, append an export line there.
ensure_bin_on_path() {
	local bin_dir="${SCRIPT_DIR}/bin"
	local bashrc="${HOME}/.bashrc"
	local export_line="export PATH=\"${bin_dir}:\$PATH\""

	# Create bin/ in case it's missing (e.g. empty dirs aren't tracked by git).
	mkdir -p "$bin_dir"

	# Colon-wrap both sides so we match whole PATH entries only.
	if [[ ":${PATH}:" == *":${bin_dir}:"* ]]; then
		echo "Already on PATH: ${bin_dir}"
		return 0
	fi

	# Exported in .bashrc but current shell hasn't sourced it yet.
	if [[ -f "$bashrc" ]] && grep -Fqx -- "$export_line" "$bashrc"; then
		echo "PATH export already in ${bashrc} (source to apply)"
		return 0
	fi

	printf '\n# dotfiles bin\n%s\n' "$export_line" >>"$bashrc"
	echo "Added ${bin_dir} to PATH in ${bashrc}"
}

# --- Main ---
ensure_link ".bash_aliases"
ensure_link ".gitconfig"
ensure_bin_on_path
