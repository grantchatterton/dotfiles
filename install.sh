#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
# Prefer canonical path when possible (symlink-aware without GNU readlink -f).
if command -v realpath >/dev/null 2>&1; then
	SCRIPT_DIR="$(realpath "$SCRIPT_DIR")"
elif [[ -d "$SCRIPT_DIR" ]]; then
	SCRIPT_DIR="$(cd "$SCRIPT_DIR" && pwd -P)"
fi

FORCE=0

DOTFILES_ZSHRC_BEGIN='# >>> dotfiles >>>'
DOTFILES_ZSHRC_END='# <<< dotfiles <<<'
DOTFILES_ZSHRC_BLOCK=$(
	cat <<EOF
${DOTFILES_ZSHRC_BEGIN}
[[ -f "\$HOME/.zsh_aliases" ]] && source "\$HOME/.zsh_aliases"
${DOTFILES_ZSHRC_END}
EOF
)

usage() {
	cat <<'EOF'
Usage: ./install.sh [--force]

Symlink this repo's .bash_aliases, .zsh_aliases, and .gitconfig into $HOME.
Ensures ~/.zshrc sources .zsh_aliases (appends a guarded block; does not
replace an existing ~/.zshrc).

Re-running is safe. An existing symlink into this repo is left alone (or
refreshed with --force). A regular file is backed up first.

On Cursor Cloud Agents, .gitconfig is skipped so managed GitHub auth is kept.
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

if [[ ! -f "${SCRIPT_DIR}/.bash_aliases" ]]; then
	echo "ERROR: missing ${SCRIPT_DIR}/.bash_aliases" >&2
	exit 1
fi

if [[ ! -f "${SCRIPT_DIR}/.zsh_aliases" ]]; then
	echo "ERROR: missing ${SCRIPT_DIR}/.zsh_aliases" >&2
	exit 1
fi

if [[ ! -d "${SCRIPT_DIR}/shell" ]]; then
	echo "ERROR: missing ${SCRIPT_DIR}/shell" >&2
	exit 1
fi

if [[ ! -f "${SCRIPT_DIR}/.gitconfig" ]]; then
	echo "ERROR: missing ${SCRIPT_DIR}/.gitconfig" >&2
	exit 1
fi

# Cursor Cloud injects HTTPS token rewrites into ~/.gitconfig; do not replace it.
is_cursor_cloud() {
	[[ -n "${CURSOR_AGENT:-}" ]] ||
		[[ -x "${HOME}/.cursor/bin/cursor-git-ssh-keygen" ]] ||
		[[ "$(git config --global --get cursor.managedghconfig 2>/dev/null || true)" == "true" ]]
}

# Canonicalize a path without requiring GNU readlink -f.
canonical_path() {
	local path="$1"
	if command -v realpath >/dev/null 2>&1; then
		realpath "$path" 2>/dev/null && return 0
	fi
	if [[ -d "$path" ]]; then
		(cd "$path" && pwd -P)
		return $?
	fi
	if [[ -L "$path" ]]; then
		local link dir
		link="$(readlink "$path")"
		dir="$(cd "$(dirname "$path")" && pwd -P)"
		case "$link" in
		/*) canonical_path "$link" ;;
		*) canonical_path "${dir}/${link}" ;;
		esac
		return $?
	fi
	if [[ -e "$path" ]]; then
		local dir base
		dir="$(cd "$(dirname "$path")" && pwd -P)"
		base="$(basename "$path")"
		printf '%s\n' "${dir}/${base}"
		return 0
	fi
	return 1
}

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
		local desired current
		desired="$(canonical_path "$source")"
		if current="$(canonical_path "$target" 2>/dev/null)" &&
			[[ "$current" == "$desired" && "$FORCE" -eq 0 ]]; then
			echo "Already installed: ${target}"
			return 0
		fi
		ln -sfn "$source" "$target"
		echo "Linked ${target} -> ${source}"
		return 0
	fi

	if [[ -e "$target" ]]; then
		local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
		mv "$target" "$backup"
		echo "Backed up existing file to ${backup}"
	fi

	ln -sfn "$source" "$target"
	echo "Linked ${target} -> ${source}"
}

# Append (or create) a guarded source block in ~/.zshrc without clobbering.
ensure_zshrc_hook() {
	local zshrc="${HOME}/.zshrc"

	if [[ -f "$zshrc" ]] && grep -Fqx "$DOTFILES_ZSHRC_BEGIN" "$zshrc"; then
		echo "Already configured: ${zshrc} sources .zsh_aliases"
		return 0
	fi

	if [[ -f "$zshrc" ]]; then
		# Ensure a blank line before the block when appending to non-empty files.
		if [[ -s "$zshrc" ]] && [[ -n "$(tail -c 1 "$zshrc" 2>/dev/null || true)" ]]; then
			printf '\n' >>"$zshrc"
		fi
		printf '\n%s\n' "$DOTFILES_ZSHRC_BLOCK" >>"$zshrc"
		echo "Updated ${zshrc} to source .zsh_aliases"
	else
		printf '%s\n' "$DOTFILES_ZSHRC_BLOCK" >"$zshrc"
		echo "Created ${zshrc} to source .zsh_aliases"
	fi
}

ensure_link ".bash_aliases"
ensure_link ".zsh_aliases"
ensure_zshrc_hook

if is_cursor_cloud; then
	echo "Skipping .gitconfig on Cursor Cloud (managed auth)"
else
	ensure_link ".gitconfig"
fi
