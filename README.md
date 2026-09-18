# dotfiles

Personal bash aliases and helper functions, structured for local shells and Cursor Cloud Agents.

## Layout

```text
.
├── .bash_aliases          # loader: sources shell/*.sh
├── .gitconfig             # identity, defaultBranch, GitHub via SSH
├── install.sh             # symlink installer
├── shell/
│   ├── nav.sh             # directory navigation
│   ├── general.sh         # everyday QOL aliases
│   ├── apt.sh             # apt shortcuts
│   ├── git.sh             # git shortcuts
│   └── functions.sh       # mkcd
└── .cursor/environment.json
```

## Install

```bash
./install.sh
source ~/.bashrc   # or open a new shell
```

Re-run anytime to refresh symlinks. Regular `~/.bash_aliases` / `~/.gitconfig` files are moved aside as timestamped `.bak.*` before linking.

```bash
./install.sh --force   # always re-link
./install.sh --help
```

Cursor Cloud uses the same installer via `.cursor/environment.json`. On Cloud Agents, `.gitconfig` is skipped so Cursor’s managed GitHub auth is left alone.

## Highlights

| Area | Examples |
|------|----------|
| Git | `gs`, `gcm`, `gpsu`, `glog`, `gsta` / `gstap` |
| Apt | `aptu`, `apti`, `apts`, `aptar` |
| Nav | `..`, `...`, `....`, `-` |
| General | `ll`, `ports`, `path`, `myip`, `src` / `reload` |
| Functions | `mkcd` |

## Reload after edits

```bash
src    # or: reload
```
