#!/usr/bin/env bash
set -euo pipefail

if (( EUID == 0 )); then
    echo "Run this script as your desktop user, without sudo." >&2
    exit 1
fi

for required_command in curl tar xz fc-cache; do
    if ! command -v "$required_command" > /dev/null 2>&1; then
        echo "Missing required command: $required_command" >&2
        exit 1
    fi
done

echo "Installing JetBrains Mono Nerd Font"
font_dir="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/JetBrainsMono"
download_dir=$(mktemp -d)
trap 'rm -rf -- "$download_dir"' EXIT
curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz \
    -o "$download_dir/JetBrainsMono.tar.xz"
mkdir -p "$font_dir"
tar -xJf "$download_dir/JetBrainsMono.tar.xz" -C "$font_dir" --no-same-owner
fc-cache -f "$font_dir"
