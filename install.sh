#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

backup() {
  local file_path backup_file_path
  file_path="$1"
  backup_file_path="${file_path}_$(date +%Y%m%d_%H%M%S)"
  cp "${file_path}" "${backup_file_path}"
}

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

    if [[ -f "${config_home_path}" ]] && ! cmp --silent "${config}" "${config_home_path}"; then
      echo "Backing up ${config_home_path}"
      backup "${config_home_path}"
    fi

    install -m 644 -o "${USER}" -g "${USER}" "${config}" "${config_home_path}"
  fi
done

shopt -u dotglob
