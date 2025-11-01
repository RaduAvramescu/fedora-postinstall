#!/usr/bin/env bash

function install_fonts() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing fonts
-------------------------------------------------------------------------
"
    brew install --cask font-jetbrains-mono-nerd-font
    fc-cache -f
}

install_fonts
