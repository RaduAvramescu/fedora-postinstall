#!/usr/bin/env bash

function install_brew_packages() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing Homebrew packages
-------------------------------------------------------------------------
"

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Please install Homebrew first."
        exit 1
    fi

    # Install packages passed as arguments
    for package in "$@"; do
        if brew list "$package" &> /dev/null; then
            echo "$package is already installed"
        else
            brew install "$package"
        fi
    done
}

# Check if arguments are provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <package1> <package2> ..."
    exit 1
fi

install_brew_packages "$@"
