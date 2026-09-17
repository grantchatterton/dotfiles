# Shared loader for bash and zsh. Sourced by .bash_aliases / .zsh_aliases.
# Resolves the repo root via this file's path (symlink-safe, no GNU readlink -f).

# Portable realpath: follow symlinks, then print absolute path.
# Works on Linux and macOS. Kept after load for helpers (e.g. bkp).
_dotfiles_realpath() {
	local target="${1:-}"
	if [[ -z "$target" ]]; then
		return 1
	fi

	if command -v realpath >/dev/null 2>&1; then
		realpath "$target" 2>/dev/null && return 0
	fi

	local dir base cur leaf link
	if [[ -d "$target" ]]; then
		(cd "$target" && pwd -P)
		return $?
	fi

	dir="$(dirname "$target")"
	base="$(basename "$target")"
	cur="$(cd "$dir" 2>/dev/null && pwd -P)" || return 1

	leaf="${cur}/${base}"
	while [[ -L "$leaf" ]]; do
		link="$(readlink "$leaf")" || break
		case "$link" in
		/*) leaf="$link" ;;
		*) leaf="$(dirname "$leaf")/${link}" ;;
		esac
		dir="$(dirname "$leaf")"
		base="$(basename "$leaf")"
		cur="$(cd "$dir" 2>/dev/null && pwd -P)" || break
		leaf="${cur}/${base}"
	done
	printf '%s\n' "$leaf"
}

_dotfiles_this_file() {
	if [[ -n "${BASH_VERSION:-}" ]]; then
		printf '%s\n' "${BASH_SOURCE[0]}"
	elif [[ -n "${ZSH_VERSION:-}" ]]; then
		# zsh: %x = path of current file being sourced
		# shellcheck disable=SC2296
		printf '%s\n' "${(%):-%x}"
	else
		printf '%s\n' "$0"
	fi
}

_DOTFILES_LOAD="$(_dotfiles_realpath "$(_dotfiles_this_file)")"
_DOTFILES_SHELL="$(dirname "$_DOTFILES_LOAD")"
_DOTFILES_ROOT="$(dirname "$_DOTFILES_SHELL")"

if [[ -d "$_DOTFILES_SHELL" ]]; then
	for _dotfiles_file in "$_DOTFILES_SHELL"/*.sh; do
		[[ "$_dotfiles_file" == "$_DOTFILES_LOAD" ]] && continue
		# shellcheck source=/dev/null
		[[ -r "$_dotfiles_file" ]] && source "$_dotfiles_file"
	done
	unset _dotfiles_file
fi

unset _DOTFILES_LOAD _DOTFILES_SHELL _DOTFILES_ROOT
unset -f _dotfiles_this_file
# Keep _dotfiles_realpath for shell/functions.sh helpers.
