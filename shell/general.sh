# Dev utilities (bash + zsh; Linux + macOS)

# Reload the interactive shell config for the current shell.
if [[ -n "${ZSH_VERSION:-}" ]]; then
	alias src='source "$HOME/.zshrc"'
else
	alias src='source "$HOME/.bashrc"'
fi
alias reload="src"

alias c="clear"
alias cls="clear"
alias h="history"
alias hg="history | grep"

# Colorized ls: GNU --color vs BSD/macOS -G
if ls --color=auto / >/dev/null 2>&1; then
	alias ll="ls -lah --color=auto"
	alias la="ls -A --color=auto"
	alias l="ls -CF --color=auto"
elif ls -G / >/dev/null 2>&1; then
	alias ll="ls -lahG"
	alias la="ls -AG"
	alias l="ls -CFG"
else
	alias ll="ls -lah"
	alias la="ls -A"
	alias l="ls -CF"
fi

# Listening ports: ss on Linux, lsof on macOS
if command -v ss >/dev/null 2>&1; then
	alias ports="ss -tulpn"
elif command -v lsof >/dev/null 2>&1; then
	alias ports="lsof -nP -iTCP -sTCP:LISTEN"
fi

# Disk / memory helpers (GNU vs BSD)
if du -h --max-depth=1 / >/dev/null 2>&1; then
	alias duh="du -h --max-depth=1"
else
	alias duh="du -h -d 1"
fi
alias dfh="df -h"
if command -v free >/dev/null 2>&1; then
	alias freeh="free -h"
fi

alias path='echo "$PATH" | tr ":" "\n"'
alias now='date "+%Y-%m-%d %H:%M:%S"'
alias week='date "+%V"'
alias myip='curl -fsS https://ifconfig.me; echo'

alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
# GNU diff supports --color; BSD diff does not — only alias when available.
if diff --color=auto /dev/null /dev/null >/dev/null 2>&1; then
	alias diff="diff --color=auto"
fi

alias ..l="cd .. && ll"
alias mkdirp="mkdir -p"
