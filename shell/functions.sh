# Utility functions (bash + zsh; Linux + macOS)

mkcd() {
	mkdir -p "$1" && cd "$1" || return 1
}

bkp() {
	local file="$1"

	if [[ -z "$file" || ! -e "$file" ]]; then
		echo "Usage: bkp <file-or-dir>" >&2
		return 1
	fi

	local file_path
	if command -v _dotfiles_realpath >/dev/null 2>&1; then
		file_path="$(_dotfiles_realpath "$file")"
	elif command -v realpath >/dev/null 2>&1; then
		file_path="$(realpath "$file")"
	else
		# Fallback: absolute path without full symlink resolution
		if [[ "$file" = /* ]]; then
			file_path="$file"
		else
			file_path="$(pwd)/$file"
		fi
	fi

	local file_name
	file_name="$(basename "$file_path")"
	local file_dir
	file_dir="$(dirname "$file_path")"

	local backup_base="${file_dir}/${file_name}.backup_$(date +%m%d%Y)"
	local backup_num=1
	local backup_file="${backup_base}_${backup_num}"

	while [[ -e "$backup_file" ]]; do
		((backup_num++))
		backup_file="${backup_base}_${backup_num}"
	done

	cp -r "$file_path" "$backup_file"
	echo "Backup created: $backup_file"
}

# Extract common archive types
extract() {
	local archive="$1"

	if [[ -z "$archive" || ! -f "$archive" ]]; then
		echo "Usage: extract <archive>" >&2
		return 1
	fi

	case "$archive" in
	*.tar.bz2 | *.tbz2) tar xjf "$archive" ;;
	*.tar.gz | *.tgz) tar xzf "$archive" ;;
	*.tar.xz | *.txz) tar xJf "$archive" ;;
	*.tar.zst) tar --zstd -xf "$archive" ;;
	*.tar) tar xf "$archive" ;;
	*.bz2) bunzip2 "$archive" ;;
	*.gz) gunzip "$archive" ;;
	*.xz) unxz "$archive" ;;
	*.zip) unzip "$archive" ;;
	*.rar) unrar x "$archive" ;;
	*.7z) 7z x "$archive" ;;
	*.Z) uncompress "$archive" ;;
	*)
		echo "Unknown archive type: $archive" >&2
		return 1
		;;
	esac
}

# Find files by name (case-insensitive)
ff() {
	if [[ -z "$1" ]]; then
		echo "Usage: ff <name>" >&2
		return 1
	fi
	find . -iname "*$1*" 2>/dev/null
}

# Find directories by name
fdn() {
	if [[ -z "$1" ]]; then
		echo "Usage: fdn <name>" >&2
		return 1
	fi
	find . -type d -iname "*$1*" 2>/dev/null
}

# Grep recursively, skip common junk dirs
fgr() {
	if [[ -z "$1" ]]; then
		echo "Usage: fgr <pattern> [path]" >&2
		return 1
	fi
	local pattern="$1"
	local path="${2:-.}"
	grep -RIn --color=auto \
		--exclude-dir=.git \
		--exclude-dir=node_modules \
		--exclude-dir=dist \
		--exclude-dir=build \
		--exclude-dir=.next \
		-- "$pattern" "$path"
}

localip() {
	local ip=""
	# Linux
	if command -v hostname >/dev/null 2>&1; then
		ip="$(hostname -I 2>/dev/null | awk '{print $1}')"
	fi
	# macOS: try common interfaces
	if [[ -z "$ip" ]] && command -v ipconfig >/dev/null 2>&1; then
		ip="$(ipconfig getifaddr en0 2>/dev/null || true)"
		if [[ -z "$ip" ]]; then
			ip="$(ipconfig getifaddr en1 2>/dev/null || true)"
		fi
	fi
	# Generic fallback via ifconfig
	if [[ -z "$ip" ]] && command -v ifconfig >/dev/null 2>&1; then
		ip="$(ifconfig 2>/dev/null | awk '/inet / && $2 != "127.0.0.1" { print $2; exit }')"
	fi
	if [[ -n "$ip" ]]; then
		printf '%s\n' "$ip"
	else
		echo "Could not determine local IP" >&2
		return 1
	fi
}

# Create a temp dir and cd into it
tmpcd() {
	local dir
	dir="$(mktemp -d "${TMPDIR:-/tmp}/tmpcd.XXXXXX")"
	cd "$dir" || return 1
	echo "$dir"
}
