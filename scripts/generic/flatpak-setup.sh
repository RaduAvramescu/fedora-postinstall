#!/usr/bin/env bash

chmod u+x ./flathub-setup.sh
./flathub-setup.sh

chmod u+x ./flatpaks-install.sh
./flatpaks-install.sh "flatpaks" "../data/flatpaks.txt"
