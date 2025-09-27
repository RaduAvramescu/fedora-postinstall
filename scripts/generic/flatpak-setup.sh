#!/usr/bin/env bash

chmod u+x ./flathub-setup.sh
./flathub-setup.sh

chmod u+x ./flatpaks-install.sh
./flatpaks-install.sh "generic" "../data/generic-flatpaks.txt"

chmod u+x ./gaming-flatpaks.sh
./gaming-flatpaks.sh
