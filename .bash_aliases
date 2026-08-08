#!/usr/bin/env bash

# Navigation
alias ..="cd .."
alias ...="cd ../.."

# Dev utilities
alias src="source $HOME/.bashrc"
alias c="clear"
alias ll="ls -la"
alias ports="ss -tulpn"
alias reload="src"                   # if you prefer the name
alias please="sudo !!"               # note: needs hist expansion; or use a function
alias h="history"
alias hg="history | grep"

# Package managers
alias aptu="sudo apt update && sudo apt upgrade -y"
alias apti="sudo apt install"
alias aptr="sudo apt remove"
alias aptp="sudo apt purge"
alias aptc="sudo apt clean"
alias aptar="sudo apt autoremove"
alias aptac="sudo apt autoclean"

# Git
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
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gpu="git push -u origin HEAD"
alias gl="git pull"
alias gpr="git pull --rebase"
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
alias gst="git stash"
alias gstp="git stash pop"
alias gstl="git stash list"
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
alias grs="git restore"
alias grss="git restore --staged"

# Utility
mkcd() {
	mkdir -p "$1" && cd "$1"
}

bkp() {
	local file="$1"

	if [[ ! -e "$file" ]]; then
		echo "ERROR: File not found" >&2
		return 1
	fi

	local file_path="$(readlink -f "$file")"
	local file_name="$(basename "$file_path")"
	local file_dir="$(dirname "$file_path")"

	local backup_base="${file_dir}/${file_name}.backup_$(date +%m%d%Y)"
	local backup_num=1
	local backup_file="${backup_base}_${backup_num}"

	while [[ -e "$backup_file" ]]; do
		((backup_num++))
		backup_file="${backup_base}_${backup_num}"
	done

	cp -r "$file" "$backup_file"

	echo "Backup created: $backup_file"
}
