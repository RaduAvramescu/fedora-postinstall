#!/usr/bin/env bash

case $XDG_SESSION_DESKTOP in
    gnome | GNOME)
        chmod u+x ./gnome-setup.sh
        ./gnome-setup.sh
        ;;

    kde | KDE)
        chmod u+x ./kde-setup.sh
        ./kde-setup.sh
        ;;

    *)
        echo "Unknown DE!"
esac
