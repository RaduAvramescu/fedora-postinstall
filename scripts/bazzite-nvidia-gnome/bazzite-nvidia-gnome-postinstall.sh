#!/usr/bin/env bash
# Bazzite Nvidia GNOME postinstall script

echo -ne "
=========================================================================
                    Step 1: Installing Applications
=========================================================================
"

# Install flatpaks
chmod u+x ../generic/install-flatpaks.sh
../generic/install-flatpaks.sh "Bazzite applications" "../../data/bazzite-flatpaks.txt"

# Install brew packages
chmod u+x ../generic/install-brew-packages.sh
../generic/install-brew-packages.sh stow starship

echo -ne "
=========================================================================
                    Step 2: Development Tools Setup
=========================================================================
"

# Turn off brew analytics
brew analytics off

# Setup git
chmod u+x ../generic/setup-git.sh
../generic/setup-git.sh

# Add user to docker group
echo "Adding user to docker group..."
sudo usermod -aG docker $USER

echo -ne "
=========================================================================
                    Step 3: Desktop Environment Setup
=========================================================================
"

# Setup GNOME desktop environment
chmod u+x ../generic/setup-gnome.sh
../generic/setup-gnome.sh

# Handle GoXLR setup if GoXLR device is detected
if grep -E "GoXLR|goxlr" <<< ${usb_devices}; then
    echo -ne "
=========================================================================
                    Step 4: GoXLR Setup
=========================================================================
"
    chmod u+x ../generic/setup-goxlr.sh
    ../generic/setup-goxlr.sh
fi
