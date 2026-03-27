#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_SRC="$DOTFILES_DIR/home/config"
CONFIG_DST="$HOME/.config"

mkdir -p "$CONFIG_DST"

for item in "$CONFIG_SRC"/*/; do
  name="$(basename "$item")"
  target="$CONFIG_DST/$name"

  if [ -L "$target" ]; then
    echo "Updating symlink: $target"
    rm "$target"
  elif [ -e "$target" ]; then
    echo "Warning: $target already exists and is not a symlink, skipping"
    continue
  fi

  ln -s "$item" "$target"
  echo "Linked: $target -> $item"
done
