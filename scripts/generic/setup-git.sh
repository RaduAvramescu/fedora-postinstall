#!/usr/bin/env bash

function setup_git() {
    echo -ne "
-------------------------------------------------------------------------
                    Setting up git
-------------------------------------------------------------------------
"
    echo "Name: "
    read name
    git config --global --unset user.name
    git config --global user.name ${name}
    echo "Email Address: "
    read email
    git config --global --unset user.email
    git config --global user.email ${email}
    git config --global init.defaultBranch main

    # Setup commit signing
    git config --global "gpg.ssh.defaultKeyCommand" "ssh-add -L"
    git config --global gpg.format ssh
    git config --global commit.gpgsign true
    git config --global format.signoff true
}

function prompt_git() {
    if [ $(which git) ]; then
        read -p "Do you want to setup git? (y/N) " answer

        case $answer in
            y ) setup_git;;
            N ) ;;
            * ) ;;
        esac
    fi
}

prompt_git