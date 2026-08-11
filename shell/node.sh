# Node / npm
alias ni="npm install"
alias nid="npm install --save-dev"
alias nig="npm install -g"
alias nu="npm uninstall"
alias nr="npm run"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"
alias nrs="npm start"
alias nrl="npm run lint"
alias nci="npm ci"
alias nout="npm outdated"
alias nup="npm update"
alias nls="npm ls --depth=0"
alias nxl="npx --yes"

# Prefer package-manager scripts when present
pj() {
	if [[ -f bun.lockb || -f bun.lock ]]; then
		bun "$@"
	elif [[ -f pnpm-lock.yaml ]]; then
		pnpm "$@"
	elif [[ -f yarn.lock ]]; then
		yarn "$@"
	else
		npm "$@"
	fi
}

alias pji="pj install"
alias pjr="pj run"
alias pjrd="pj run dev"
alias pjrb="pj run build"
alias pjrt="pj run test"
