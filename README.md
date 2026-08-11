# dotfiles

Personal bash aliases and helper functions, structured for local shells and Cursor Cloud Agents.

## Layout

```text
.
├── .bash_aliases          # loader: sources shell/*.sh
├── install.sh             # symlink installer
├── shell/
│   ├── nav.sh             # directory navigation
│   ├── general.sh         # everyday QOL aliases
│   ├── apt.sh             # apt shortcuts
│   ├── git.sh             # git shortcuts
│   ├── podman.sh          # podman / compose
│   ├── node.sh            # npm / lockfile-aware pj
│   ├── bun.sh             # bun shortcuts
│   └── functions.sh       # mkcd, bkp, extract, ff, …
└── .cursor/environment.json
```

## Install

```bash
./install.sh
source ~/.bashrc   # or open a new shell
```

Re-run anytime to refresh the symlink. If `~/.bash_aliases` is a regular file, it is moved aside as a timestamped `.bak.*` before linking.

```bash
./install.sh --force   # always re-link
./install.sh --help
```

Cursor Cloud uses the same installer via `.cursor/environment.json`.

## Highlights

| Area | Examples |
|------|----------|
| Git | `gs`, `gcm`, `gpsu`, `glog`, `gsta` / `gstap` |
| Podman | `pps`, `pex`, `prun`, `pcpu` / `pcpd` |
| Node | `ni`, `nrd`, `pj` / `pjrd` (picks bun/pnpm/yarn/npm from lockfile) |
| Bun | `bi`, `ba`, `brd`, `brt`, `bx` |
| General | `ll`, `ports`, `please` (sudo prev cmd, keeps quoting), `serve`, `extract`, `ff`, `fgr`, `killport`, `bkp`, `mkcd` |

## Reload after edits

```bash
src    # or: reload
```
