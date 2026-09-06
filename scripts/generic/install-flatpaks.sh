#!/usr/bin/env bash
set -euo pipefail

function install_flatpaks() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing $1 flatpaks
-------------------------------------------------------------------------
"

    local line installed_apps
    installed_apps=$(flatpak list --app --columns=application)

    while IFS= read -r line || [[ -n "$line" ]]
    do
        [[ -z "$line" ]] && continue
        if grep -Fxq -- "$line" <<< "$installed_apps"; then
            echo "${line} is already installed"
        else
            flatpak install flathub -y --noninteractive "${line}"
        fi
    done < "$2"
}

# Check if arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <flatpak_type> <flatpak_list_file>"
    exit 1
fi

if [[ ! -f "$2" || ! -r "$2" ]]; then
    echo "Flatpak list is not a readable file: $2" >&2
    exit 1
fi

install_flatpaks "$1" "$2"
