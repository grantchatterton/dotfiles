# Dotfiles

GNU Stow links this repository's configuration into your home directory. Edits
through those links update the files in this checkout, so keep it in place.

## Install

Install GNU Stow first (on Debian/Ubuntu: `sudo apt install stow`), then run
these commands from this repository:

```sh
./install.sh --simulate
./install.sh
```

The installer works from any directory and targets `$HOME` explicitly. It links
all three packages under [stow/](./stow):

| Package | Destination |
| --- | --- |
| `bash` | `~/.bashrc`, `~/.bash_aliases`, `~/.bash_functions`, `~/.bash_logout`, `~/.profile` |
| `git` | `~/.gitconfig` |
| `scripts` | `~/bin/bunc` |

Stow leaves existing files alone and reports conflicts. Review the Git identity
in [the Git config](./stow/git/.gitconfig) before installing on another machine.

## Migrate from the copy-based installer

The old installer created ordinary files, which conflict with Stow's links.
Review any local changes in those files and merge anything you want to keep into
this repository first. Then back up the old destinations:

```sh
backup_dir="$(mktemp -d "$HOME/dotfiles-backup.XXXXXX")"
for path in .bashrc .bash_aliases .bash_functions .bash_logout .profile .gitconfig bin/bunc; do
  if [ -e "$HOME/$path" ] || [ -L "$HOME/$path" ]; then
    mkdir -p "$backup_dir/$(dirname "$path")"
    mv -- "$HOME/$path" "$backup_dir/$path"
  fi
done
printf 'Backup: %s\n' "$backup_dir"
./install.sh --simulate
./install.sh
```

Keep the backup until you have checked the linked configuration. Avoid Stow's
`--adopt` option unless you intend to replace repository files with local copies.

## Manage links

```sh
./install.sh --restow     # Refresh links after adding/removing package files
./install.sh --delete    # Remove managed links; keep repository files
```

To manage individual packages, use Stow directly from the repository root:

```sh
stow --dir=stow --target="$HOME" --no-folding bash
stow --dir=stow --target="$HOME" --no-folding --delete bash
```

Each package mirrors paths relative to your home directory. Add shell files to
[stow/bash/](./stow/bash), Git configuration to [stow/git/](./stow/git), and
executable scripts to [stow/scripts/bin/](./stow/scripts/bin). Keep scripts
executable (`chmod +x`). The installer disables directory folding so `~/bin`
remains a real directory that can also contain unmanaged scripts.
