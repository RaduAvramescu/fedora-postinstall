#!/usr/bin/env bash

function add_flathub_repo() {
    echo -ne "
-------------------------------------------------------------------------
                    Adding Flathub repo
-------------------------------------------------------------------------
"
    sudo dnf install -y flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak remote-modify --enable flathub
    flatpak update -y
}

add_flathub_repo
