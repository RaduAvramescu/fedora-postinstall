#!/usr/bin/env bash

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

    # Install homebrew first
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # DNF packages
    dnf_packages=("alacritty")

    for package in "${dnf_packages[@]}"; do
        install_if_missing "$package" "sudo dnf install -y $package"
    done

    # Homebrew packages
    brew_packages=("starship" "fish" "tmux")

    for package in "${brew_packages[@]}"; do
        install_if_missing "$package" "brew install $package"
    done

    # Install tpm if not already cloned
    if [ ! -d ~/.tmux/plugins/tpm ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    else
        echo "tpm is already installed"
    fi
}

install_terminal