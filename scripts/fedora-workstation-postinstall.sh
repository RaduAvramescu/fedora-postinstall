#!/usr/bin/env bash
# Fedora Workstation postinstall script


function add_rpm_fusion_repos() {
    echo -ne "
-------------------------------------------------------------------------
                    Adding RPM free and nonfree repos
-------------------------------------------------------------------------
"
    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    chmod u+x ./generic/rpm-setup.sh
    ./generic/rpm-setup.sh
}

function prompt_rpm_fusion_repos() {
    read -p "Do you want to add RPM Fusion Free and Nonfree repos? (y/N) " answer

    case $answer in 
        y ) add_rpm_fusion_repos;;
        N ) ;;
        * ) ;;
    esac
}

function install_nvidia_drivers() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing Nvidia drivers
-------------------------------------------------------------------------
"
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
}

function remove_default_pkgs() {
    echo -ne "
-------------------------------------------------------------------------
                    Removing unnecessary default packages
-------------------------------------------------------------------------
"
    sudo dnf group remove libreoffice
    sudo dnf remove -y totem firefox "libreoffice*"

    # Remove KDE native packages
    sudo dnf remove -y dragon konsole neochat kmahjongg kmines kpat kolourpaint okular skanpage kwrite kfind kmousetool gwenview kcharselect kmouth
}

gpu_type=$(lspci)
usb_devices=$(lsusb)

# Update all packages before doing the rest of the setup
sudo dnf upgrade -y --refresh

# Make folder where all repos are stored
mkdir -p ~/Repos

# Setup git
chmod u+x ./generic/git-setup.sh
./generic/git-setup.sh

prompt_rpm_fusion_repos

# Handle GPU setup
if grep -E "NVIDIA|GeForce" <<< ${gpu_type}; then
    install_nvidia_drivers

remove_default_pkgs

# Setup flatpaks
chmod u+x ./generic/flathub-setup.sh
./generic/flathub-setup.sh
chmod u+x ./generic/flatpaks-install.sh
./generic/flatpaks-install.sh "flatpaks" "./data/flatpaks.txt"

# Setup terminal
chmod u+x ./generic/terminal-install.sh
./generic/terminal-install.sh
chmod u+x ./generic/fonts-install.sh
./generic/fonts-install.sh

# Setup desktop environment
case $XDG_SESSION_DESKTOP in
    gnome | GNOME)
        chmod u+x ./generic/gnome-setup.sh
        ./generic/gnome-setup.sh
        ;;

    kde | KDE)
        chmod u+x ./generic/kde-setup.sh
        ./generic/kde-setup.sh
        ;;

    *)
        echo "Unknown DE!"
esac
