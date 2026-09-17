# dotfiles

Personal bash and zsh aliases and helper functions, structured for local shells
(Linux and macOS) and Cursor Cloud Agents.

## Layout

```text
.
├── .bash_aliases          # bash entry: sources shell/load.sh
├── .zsh_aliases           # zsh entry: sources shell/load.sh
├── .gitconfig             # identity, pull.rebase, GitHub via SSH
├── install.sh             # symlink installer (+ ~/.zshrc hook)
├── shell/
│   ├── load.sh            # shared portable loader
│   ├── nav.sh             # directory navigation
│   ├── general.sh         # everyday QOL aliases
│   ├── apt.sh             # apt shortcuts (Debian/Ubuntu)
│   ├── git.sh             # git shortcuts
│   ├── node.sh            # npm / lockfile-aware pj
│   ├── bun.sh             # bun shortcuts
│   └── functions.sh       # mkcd, bkp, extract, ff, …
└── .cursor/environment.json
```

## Install

```bash
./install.sh
```

Then reload your shell:

```bash
# bash
source ~/.bashrc

# zsh (macOS default)
source ~/.zshrc
```

Or open a new terminal.

`install.sh` symlinks `~/.bash_aliases` and `~/.zsh_aliases` into this repo, and
ensures `~/.zshrc` sources `.zsh_aliases` via a guarded block (existing zsh
config is left intact — nothing is replaced wholesale).

Re-run anytime to refresh symlinks. Regular `~/.bash_aliases` /
`~/.zsh_aliases` / `~/.gitconfig` files are moved aside as timestamped `.bak.*`
before linking.

```bash
./install.sh --force   # always re-link
./install.sh --help
```

Cursor Cloud uses the same installer via `.cursor/environment.json`. On Cloud
Agents, `.gitconfig` is skipped so Cursor’s managed GitHub auth is left alone.

## Highlights

| Area | Examples |
|------|----------|
| Git | `gs`, `gcm`, `gpsu`, `glog`, `gsta` / `gstap` |
| Node | `ni`, `nrd`, `pj` / `pjrd` (picks bun/pnpm/yarn/npm from lockfile) |
| Bun | `bi`, `ba`, `brd`, `brt`, `bx` |
| General | `ll`, `ports`, `extract`, `ff`, `fgr`, `bkp`, `mkcd`, `localip` |

## Reload after edits

```bash
src    # or: reload
```

Reloads `~/.zshrc` under zsh and `~/.bashrc` under bash.
