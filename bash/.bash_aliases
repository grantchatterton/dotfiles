# shellcheck shell=bash

# general
alias src='source "$HOME/.bashrc"'
alias c='clear'
alias dotfiles='cd "$HOME/dotfiles"'

# nav
alias ..='cd ..'
alias -- -='cd -'

# apt (Debian/Ubuntu)
alias aptu='sudo apt update && sudo apt upgrade -y'
alias apti='sudo apt install'

# git
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gf='git fetch'
alias gpl='git pull'
alias gaa='git add --all'
alias gcm='git commit -m'
alias gps='git push origin main'

# ls
alias ll='ls -la'

# functions
mkcd() {
  mkdir -p -- "$1" && cd -- "$1" || return 1
}
