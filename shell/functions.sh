# shellcheck shell=bash
# Utility functions

mkcd() {
	mkdir -p "$1" && cd "$1" || return 1
}
