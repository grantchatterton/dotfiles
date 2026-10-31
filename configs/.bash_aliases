# shellcheck shell=bash
# apt (Debian/Ubuntu)
alias aptu="sudo apt update && sudo apt upgrade -y"
alias apti="sudo apt install"
alias aptr="sudo apt remove"
alias aptp="sudo apt purge"
alias aptc="sudo apt clean"
alias aptar="sudo apt autoremove"
alias aptac="sudo apt autoclean"
alias apts="apt search"
alias aptsh="apt show"

# shellcheck shell=bash
# Utility functions
mkcd() {
	mkdir -p "$1" && cd "$1" || return 1
}

# shellcheck shell=bash
# General
alias src='source "$HOME/.bashrc"'
alias reload="src"
alias c="clear"
alias ll="ls -lah --color=auto"
alias la="ls -A --color=auto"
alias l="ls -CF --color=auto"
alias ports="ss -tulpn"
alias h="history"
alias hg="history | grep"

alias dfh="df -h"
alias duh="du -h --max-depth=1"
alias freeh="free -h"
alias path='echo "$PATH" | tr ":" "\n"'
alias now='date "+%Y-%m-%d %H:%M:%S"'
alias week='date "+%V"'
alias myip='curl -fsS https://ifconfig.me; echo'

alias grep="grep --color=auto"
alias diff="diff --color=auto"

alias ..l="cd .. && ll"
alias mkdirp="mkdir -p"

# shellcheck shell=bash
# Git
# Mnemonics: gps/gpl = puSh/pulL; gsta* = STAsh (gs/gss = Status);
#            gr* = Rebase; grest* = RESTore (avoids colliding with rebase).
alias g="git"
alias gs="git status"
alias gss="git status -s"
alias ga="git add"
alias gaa="git add --all"
alias gap="git add -p"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcan="git commit --amend --no-edit"
alias gps="git push"
alias gpsf="git push --force-with-lease"
alias gpsu="git push -u origin HEAD"
alias gpl="git pull"
alias gplr="git pull --rebase"
alias gf="git fetch"
alias gfa="git fetch --all --prune"
alias gd="git diff"
alias gds="git diff --staged"
alias gdst="git diff --stat"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
alias gba="git branch -a"
alias gbd="git branch -d"
alias gbD="git branch -D"
alias gm="git merge"
alias gr="git rebase"
alias gri="git rebase -i"
alias grc="git rebase --continue"
alias gra="git rebase --abort"
alias grm="git rebase origin/main"
alias gsta="git stash"
alias gstap="git stash pop"
alias gstal="git stash list"
alias glog="git log --oneline --graph --decorate"
alias gloga="git log --oneline --graph --decorate --all"
alias glast="git log -1 --stat"
alias gwho="git shortlog -sn"
alias gundo="git reset --soft HEAD~1"
alias gwip='git add -A && git commit -m "wip"'
alias gunwip="git reset HEAD~1"
alias gclean="git clean -fd"
alias gsw="git switch"
alias gswc="git switch -c"
alias gswm="git switch main"
alias gcp="git cherry-pick"
alias grest="git restore"
alias grests="git restore --staged"

# shellcheck shell=bash
# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -="cd -"
