#!/usr/bin/env bash
set -euo pipefail

if ! command -v starship &> /dev/null; then
    echo "Installing Starship"
    curl -sS https://starship.rs/install.sh | sh
else
    echo "starship is already installed"
fi
