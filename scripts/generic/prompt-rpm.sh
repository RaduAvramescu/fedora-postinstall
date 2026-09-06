#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

function prompt_rpm_setup() {
    local answer
    read -r -p "Do you want to install rpms? (y/N) " answer

    case $answer in
        y ) bash "$script_dir/install-rpms.sh";;
        N ) ;;
        * ) ;;
    esac
}

prompt_rpm_setup
