#!/usr/bin/env bash

function install_rpms() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing rpms
-------------------------------------------------------------------------
"

    cat "../data/rpms.txt" | while read line
    do
        sudo dnf install -y "${line}"
    done
}

install_rpms
