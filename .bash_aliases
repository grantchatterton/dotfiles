#!/usr/bin/env bash
# Entry point sourced by interactive bash (~/.bash_aliases).
# Modular definitions live in shell/*.sh next to this file (or via symlink).

_DOTFILES_ROOT="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]:-$0}")")" && pwd)"
_DOTFILES_SHELL="${_DOTFILES_ROOT}/shell"

if [[ -d "$_DOTFILES_SHELL" ]]; then
	for _dotfiles_file in "$_DOTFILES_SHELL"/*.sh; do
		# shellcheck source=/dev/null
		[[ -r "$_dotfiles_file" ]] && source "$_dotfiles_file"
	done
	unset _dotfiles_file
fi

unset _DOTFILES_ROOT _DOTFILES_SHELL
