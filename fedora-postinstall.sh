#!/usr/bin/env bash
# Fedora Workstation postinstall script

function handle_basic_settings() {
    echo -ne "
-------------------------------------------------------------------------
                    Handling basic settings
-------------------------------------------------------------------------
"
    # Remove mouse accel
    gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat

    # Setup dark theme
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark

    # Disable hot corners
    gsettings set org.gnome.desktop.interface enable-hot-corners false

    # Add terminal shortcut (Ctrl + Alt + T)
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Primary><Alt>t'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-terminal'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

    # Remove dynamic workspaces
    gsettings set org.gnome.mutter dynamic-workspaces false
    gsettings set org.gnome.desktop.wm.preferences num-workspaces 9

    # Remove switch to application shortcuts
    for i in {1..9}; do
        gsettings set "org.gnome.shell.keybindings" "switch-to-application-$i" "[]"
    done

    # Add switch to workspace shortcuts
    for i in {1..9}; do
        gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-$i" "['<Super>$i']"
    done

    # Add move to workspace shortcuts
    for i in {1..9}; do
        gsettings set "org.gnome.desktop.wm.keybindings" "move-to-workspace-$i" "['<Super><Shift>${i}']"
    done
}

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
    echo "Email Address:"
    read email
    git config --global --unset user.email
    git config --global user.email ${email}
    git config --global init.defaultBranch main
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
                    Adding RPM non-free and free repos
-------------------------------------------------------------------------
"
    sudo dnf upgrade -y
    sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
}

function install_nvidia_drivers() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing Nvidia drivers
-------------------------------------------------------------------------
"
    sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
}

function add_flathub_repo() {
    echo -ne "
-------------------------------------------------------------------------
                    Adding Flathub repo
-------------------------------------------------------------------------
"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak update -y
}

function install_flatpaks() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing $1 flatpaks
-------------------------------------------------------------------------
"

    cat "$2" | while read line
    do
        if flatpak list | grep -q "${line}"; then
            echo "${line} is already installed"
        else
            flatpak install flathub -y --noninteractive "${line}"
        fi
    done
}

function handle_gaming_flatpaks() {
    read -p "Do you want to install gaming flatpaks? (y/N) " answer

    case $answer in 
        y ) install_flatpaks "gaming" "gaming-flatpaks.txt";;
        N ) ;;
        * ) ;;
    esac
}

function remove_default_apps() {
    echo -ne "
-------------------------------------------------------------------------
                    Removing unnecessary default apps
-------------------------------------------------------------------------
"
    sudo dnf remove -y totem
}

function setup_favorite_apps() {
    echo -ne "
-------------------------------------------------------------------------
                    Setting up favorite apps
-------------------------------------------------------------------------
"
    favorite_apps="$(getFavoriteApps)"
    favorite_apps="[${favorite_apps:2:${#favorite_apps}}]"

    gsettings set org.gnome.shell favorite-apps "$favorite_apps"
}

getFavoriteApps() {
    cat "./favorite-apps.txt" | while read line
    do
        echo -n ", '${line}'"
    done
}

handle_basic_settings
prompt_git
add_rpm_fusion_repos
install_nvidia_drivers
add_flathub_repo
install_flatpaks "generic" "generic-flatpaks.txt"
handle_gaming_flatpaks
remove_default_apps
setup_favorite_apps
