#!/usr/bin/env bash
set -euo pipefail

function setup_git() {
    echo -ne "
-------------------------------------------------------------------------
                    Setting up git
-------------------------------------------------------------------------
"
    local name email
    read -r -p "Name: " name
    read -r -p "Email Address: " email
    if [[ -z "$name" || -z "$email" ]]; then
        echo "Name and email address must not be empty." >&2
        return 1
    fi

    git config --global --replace-all user.name "$name"
    git config --global --replace-all user.email "$email"
    git config --global init.defaultBranch main

    # Setup commit signing
    git config --global "gpg.ssh.defaultKeyCommand" "ssh-add -L"
    git config --global gpg.format ssh
    git config --global commit.gpgsign true
    git config --global format.signoff true
}

function prompt_git() {
    if ! command -v git > /dev/null 2>&1; then
        echo "Git is not installed." >&2
        return 1
    fi

    local answer
    read -r -p "Do you want to setup git? (y/N) " answer

    case $answer in
        y ) setup_git;;
        N ) ;;
        * ) ;;
    esac
}

prompt_git
