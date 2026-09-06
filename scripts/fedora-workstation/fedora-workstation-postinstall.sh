#!/usr/bin/env bash
# Fedora Workstation postinstall script
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_dir=$(cd -- "$script_dir/../.." && pwd)
generic_dir="$repo_dir/scripts/generic"

function add_rpm_fusion_repos() {
    echo -ne "
-------------------------------------------------------------------------
                    Adding RPM free and nonfree repos
-------------------------------------------------------------------------
"
    local fedora_version
    fedora_version=$(rpm -E %fedora)
    sudo dnf install -y "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora_version}.noarch.rpm" "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora_version}.noarch.rpm"
    bash -e -o pipefail "$generic_dir/prompt-rpm.sh"
}

function prompt_rpm_fusion_repos() {
    local answer
    read -r -p "Do you want to add RPM Fusion Free and Nonfree repos? (y/N) " answer

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

# Update all packages before doing the rest of the setup
sudo dnf upgrade -y --refresh

# Make folder where all repos are stored
mkdir -p ~/Repos

# Setup git
bash -e -o pipefail "$generic_dir/setup-git.sh"

prompt_rpm_fusion_repos

# Handle GPU setup
if grep -E "NVIDIA|GeForce" <<< "$gpu_type"; then
    install_nvidia_drivers
fi

remove_default_pkgs

# Setup flatpaks
bash -e -o pipefail "$generic_dir/setup-flathub.sh"
bash -e -o pipefail "$generic_dir/install-flatpaks.sh" "flatpaks" "$repo_dir/data/flatpaks.txt"

# Setup terminal
bash -e -o pipefail "$generic_dir/install-terminal.sh"
bash -e -o pipefail "$generic_dir/install-fonts.sh"

# Setup desktop environment
case ${XDG_SESSION_DESKTOP:-} in
    gnome | GNOME)
        bash -e -o pipefail "$generic_dir/setup-gnome.sh"
        ;;

    kde | KDE)
        bash -e -o pipefail "$generic_dir/setup-kde.sh"
        ;;

    *)
        echo "Unknown DE!"
esac
