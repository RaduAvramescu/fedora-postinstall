#!/usr/bin/env bash
# Install host tools and fonts in the desktop user's writable directories.
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

mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

echo "Installing Codex CLI"
curl -fsSL https://chatgpt.com/codex/install.sh | sh

echo "Installing Starship"
curl -sS https://starship.rs/install.sh | sh

echo "Installing mise"
curl -fsSL https://mise.run | sh

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
bash "$script_dir/../generic/install-fonts.sh"

echo 'Ensure ~/.local/bin is on your shell PATH. Configure Starship and mise shell integration through your dotfiles.'
