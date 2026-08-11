# Utility functions

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
	file_path="$(readlink -f "$file")"
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
		*.tar.bz2|*.tbz2) tar xjf "$archive" ;;
		*.tar.gz|*.tgz) tar xzf "$archive" ;;
		*.tar.xz|*.txz) tar xJf "$archive" ;;
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
	hostname -I 2>/dev/null | awk '{print $1}'
}

# Create a temp dir and cd into it
tmpcd() {
	local dir
	dir="$(mktemp -d "${TMPDIR:-/tmp}/tmpcd.XXXXXX")"
	cd "$dir" || return 1
	echo "$dir"
}

# Kill process listening on a port
killport() {
	local port="$1"
	if [[ -z "$port" ]]; then
		echo "Usage: killport <port>" >&2
		return 1
	fi

	local pids
	pids="$(ss -lptn "sport = :$port" 2>/dev/null | sed -n 's/.*pid=\([0-9]\+\).*/\1/p' | sort -u)"
	if [[ -z "$pids" ]]; then
		echo "No process listening on port $port" >&2
		return 1
	fi

	echo "$pids" | xargs -r kill
	echo "Killed: $pids"
}

# Follow a command's output with a timestamped echo of the command
run() {
	echo "+ $*"
	"$@"
}
