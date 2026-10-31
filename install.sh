#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")"

shopt -s dotglob

for config in "${SCRIPT_DIR}"/configs/*; do
  if [[ -f "${config}" ]]; then
    config_basename="$(basename -- "${config}")"
    config_home_path="${HOME}/${config_basename}"
    install -m 644 -o "${USER}" -g "${USER}" "${config}" "${config_home_path}"
  fi
done

shopt -u dotglob

for script in "${SCRIPT_DIR}"/bin/*; do
  if [[ -f "${script}" ]]; then
    script_basename="$(basename -- "${script}")"
    script_home_path="${HOME}/bin/${script_basename}"
    mkdir -p -- "${HOME}/bin"
    install -m 755 -o "${USER}" -g "${USER}" "${script}" "${script_home_path}"
  fi
done
