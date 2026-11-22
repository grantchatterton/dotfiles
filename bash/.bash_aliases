# shellcheck shell=bash

# general
alias src='source "$HOME/.bashrc"'
alias c='clear'

# nav
alias ..='cd ..'
alias -- -='cd -'
alias dotfiles='mkdir -p -- "$HOME/dotfiles" && cd -- "$HOME/dotfiles"'
alias projects='mkdir -p -- "$HOME/Projects" && cd -- "$HOME/Projects"'

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
