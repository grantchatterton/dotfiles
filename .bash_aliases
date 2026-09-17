# Entry point sourced by interactive bash (~/.bash_aliases).
# Shared definitions live in shell/*.sh (loaded via shell/load.sh).

_dotfiles_bootstrap() {
	local self root link
	if [[ -n "${BASH_VERSION:-}" ]]; then
		self="${BASH_SOURCE[0]}"
	else
		self="$0"
	fi
	# Resolve symlink target directory without GNU readlink -f.
	if [[ -L "$self" ]]; then
		link="$(readlink "$self")"
		case "$link" in
		/*) self="$link" ;;
		*) self="$(dirname "$self")/${link}" ;;
		esac
	fi
	root="$(cd "$(dirname "$self")" && pwd -P)"
	# shellcheck source=/dev/null
	source "${root}/shell/load.sh"
}

_dotfiles_bootstrap
unset -f _dotfiles_bootstrap
