#!/usr/bin/env bash

function install_fonts() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing fonts
-------------------------------------------------------------------------
"
    FONT_DIR=~/.local/share/fonts/NerdFonts
    sudo mkdir -p "${FONT_DIR}"
    cd "${FONT_DIR}"
    sudo curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    sudo unzip JetBrainsMono.zip
    sudo rm -rf JetBrainsMono.zip
    fc-cache -f "${FONT_DIR}"
}

install_fonts
