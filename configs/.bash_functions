# shellcheck shell=bash

# Create a new directory and cd into it
mkcd() {
  local dir="$1"
  mkdir -p "$dir" && cd "$dir" || return 1
}
