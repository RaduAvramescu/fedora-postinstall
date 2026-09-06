#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_dir=$(cd -- "$script_dir/../.." && pwd)

function install_rpms() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing rpms
-------------------------------------------------------------------------
"

    local line
    while IFS= read -r line || [[ -n "$line" ]]
    do
        [[ -z "$line" ]] && continue
        sudo dnf install -y "${line}"
    done < "$repo_dir/data/rpms.txt"
}

install_rpms
