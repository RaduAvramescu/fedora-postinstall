#!/usr/bin/env bash

function install_flatpaks() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing $1 flatpaks
-------------------------------------------------------------------------
"

    cat "$2" | while read line
    do
        if flatpak list | grep -q "${line}"; then
            echo "${line} is already installed"
        else
            flatpak install flathub -y --noninteractive "${line}"
        fi
    done
}

# Check if arguments are provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <flatpak_type> <flatpak_list_file>"
    exit 1
fi

install_flatpaks "$1" "$2"
