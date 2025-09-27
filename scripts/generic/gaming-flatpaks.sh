#!/usr/bin/env bash

function handle_gaming_flatpaks() {
    read -p "Do you want to install gaming flatpaks? (y/N) " answer

    case $answer in
        y ) ./flatpaks-install.sh "gaming" "../data/gaming-flatpaks.txt";;
        N ) ;;
        * ) ;;
    esac
}

handle_gaming_flatpaks
