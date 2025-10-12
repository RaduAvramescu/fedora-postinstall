#!/usr/bin/env bash
# Bazzite Nvidia GNOME postinstall script

# Setup git
chmod u+x ../generic/setup-git.sh
../generic/setup-git.sh

# Setup GNOME desktop environment
chmod u+x ../generic/setup-gnome.sh
../generic/setup-gnome.sh

echo "Postinstall script completed. Please see README.md for additional manual setup steps."
