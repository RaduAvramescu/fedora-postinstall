#!/usr/bin/env bash

function install_fonts() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing fonts
-------------------------------------------------------------------------
"
    sudo mkdir -p ~/.local/share/fonts/nerd-fonts
    sudo curl -fL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz | sudo tar --extract --xz --directory ~/.local/share/fonts/nerd-fonts
    fc-cache -f
}

install_fonts
