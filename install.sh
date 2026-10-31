#!/usr/bin/env bash
set -euo pipefail

# Global variables
SCRIPT_DIR="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

# Creates a backup of a file in the same dir with date
backup() {
  local file_path backup_file_path
  file_path="$1"
  backup_file_path="${file_path}_"$(date +%Y%m%d_%H%M%S)""
  cp "${file_path}" "${backup_file_path}"
}

# Install everything from ./configs to ~/
configs_dir="${SCRIPT_DIR}/configs"
if ! [[ -d "${configs_dir}" ]]; then
  echo "ERROR: configs dir not found!" >&2
  exit 1
fi

shopt -s dotglob

for config in "${configs_dir}"/*; do
  if [[ -f "${config}" ]]; then
    config_basename="$(basename -- "${config}")"
    config_home_path="${HOME}/${config_basename}"

    if [[ -f "${config_home_path}" ]]; then
      echo "Backing up ${config_home_path}"
      backup "${config_home_path}"
    fi

    install -m 644 -o "${USER}" -g "${USER}" "${config}" "${config_home_path}"
  fi
done

shopt -u dotglob

