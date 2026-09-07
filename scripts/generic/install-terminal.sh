#!/usr/bin/env bash
set -euo pipefail

function install_if_missing() {
    local package=$1
    local install_cmd=$2

    if ! command -v "$package" &> /dev/null; then
        eval "$install_cmd"
    else
        echo "$package is already installed"
    fi
}

function install_terminal() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing terminal
-------------------------------------------------------------------------
"

    # DNF packages
    local package
    local -a dnf_packages=("alacritty" "fish" "tmux")

    for package in "${dnf_packages[@]}"; do
        install_if_missing "$package" "sudo dnf install -y $package"
    done

    if ! command -v starship &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh
    else
        echo "starship is already installed"
    fi

    # Install tpm if not already cloned
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        echo "tpm is already installed"
    fi
}

install_terminal
