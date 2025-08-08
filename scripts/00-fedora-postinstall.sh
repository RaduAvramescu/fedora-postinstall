#!/usr/bin/env bash
# Fedora Workstation postinstall script

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

function add_rpm_fusion_repos() {
    echo -ne "
-------------------------------------------------------------------------
                    Adding RPM free and nonfree repos
-------------------------------------------------------------------------
"
    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    chmod u+x ./rpm-setup.sh
    ./rpm-setup.sh
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
prompt_git
prompt_rpm_fusion_repos

# Handle GPU setup
if grep -E "NVIDIA|GeForce" <<< ${gpu_type}; then
    install_nvidia_drivers
elif grep -E "7900 XTX" <<< ${gpu_type}; then
    chmod u+x ./setup-gpu-profile.sh
    ./setup-gpu-profile.sh
fi

remove_default_pkgs
chmod u+x ./flatpak-setup.sh
./flatpak-setup.sh
chmod u+x ./terminal-setup.sh
./terminal-setup.sh
chmod u+x ./de-setup.sh
./de-setup.sh
