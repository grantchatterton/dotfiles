# Dev utilities
alias src="source \"$HOME/.bashrc\""
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
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias diff="diff --color=auto"

alias cls="clear"
alias ..l="cd .. && ll"
alias mkdirp="mkdir -p"
alias please='sudo $(fc -ln -1)'

alias serve="python3 -m http.server"
alias json="python3 -m json.tool"
alias urlencode='python3 -c "import sys,urllib.parse; print(urllib.parse.quote(sys.argv[1]))"'
alias urldecode='python3 -c "import sys,urllib.parse; print(urllib.parse.unquote(sys.argv[1]))"'
