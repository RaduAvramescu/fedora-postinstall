#!/usr/bin/env bash

function install_terminal() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing terminal
-------------------------------------------------------------------------
"
    sudo dnf install -y alacritty

    # Install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Install all terminal related homebrew packages
    brew install fish starship tmux

    # Install tpm
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

install_terminal
