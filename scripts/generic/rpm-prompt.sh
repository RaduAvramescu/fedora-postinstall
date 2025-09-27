#!/usr/bin/env bash

function prompt_rpm_setup() {
    read -p "Do you want to install rpms? (y/N) " answer

    case $answer in
        y ) ./rpms-install.sh;;
        N ) ;;
        * ) ;;
    esac
}

prompt_rpm_setup
