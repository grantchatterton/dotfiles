# dotfiles

Personal bash aliases and helper functions, plus git config.

## Layout

```text
.
├── .bash_aliases          # loader: sources shell/*.sh
├── .gitconfig             # identity, defaultBranch, GitHub via SSH
├── install.sh             # symlink installer + bin/ PATH setup
├── bin/                   # personal scripts (added to PATH)
└── shell/
    ├── nav.sh             # directory navigation
    ├── general.sh         # everyday QOL aliases
    ├── apt.sh             # apt shortcuts
    ├── git.sh             # git shortcuts
    └── functions.sh       # mkcd
```

## Install

```bash
./install.sh
source ~/.bashrc   # or open a new shell
```

Re-run anytime to refresh symlinks. Regular `~/.bash_aliases` / `~/.gitconfig` files are moved aside as timestamped `.bak.*` before linking. `bin/` is added to `PATH` via `~/.bashrc` if missing.

```bash
./install.sh --force   # always re-link
./install.sh --help
```

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
