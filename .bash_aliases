#!/usr/bin/env bash
alias src="source $HOME/.bashrc"
alias c="clear"
alias ll="ls -la"

mkcd() {
	mkdir -p "$1" && cd "$1"
}
