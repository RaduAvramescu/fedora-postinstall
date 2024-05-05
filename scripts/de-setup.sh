#!/usr/bin/env bash

function handle_gnome_settings() {
    echo -ne "
-------------------------------------------------------------------------
                    Handling GNOME settings
-------------------------------------------------------------------------
"
    # Disable automatic updates
    gsettings set org.gnome.software download-updates false

    # Remove mouse accel
    gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat

    # Setup dark theme
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark

    # Disable hot corners
    gsettings set org.gnome.desktop.interface enable-hot-corners false

    # Add toggle fullscreen shortcut
    gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"

    # Add terminal shortcut (Ctrl + Alt + T)
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Primary><Alt>t'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'alacritty'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

    # Remove dynamic workspaces
    gsettings set org.gnome.mutter dynamic-workspaces false
    gsettings set org.gnome.desktop.wm.preferences num-workspaces 9

    # Remove switch to application shortcuts and add switch/move to workspace shortcuts
    for i in {1..9}; do
        gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
        gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
        gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>${i}']"
    done

    # Setup favorite apps that appear in the dock
    setup_favorite_apps
}

function setup_favorite_apps() {
    favorite_apps="$(getFavoriteApps)"
    favorite_apps="[${favorite_apps:2:${#favorite_apps}}]"

    gsettings set org.gnome.shell favorite-apps "$favorite_apps"
}

getFavoriteApps() {
    cat "../data/favorite-apps.txt" | while read line
    do
        echo -n ", '${line}'"
    done
}

function handle_kde_settings() {
    echo -ne "
-------------------------------------------------------------------------
                    Handling KDE settings
-------------------------------------------------------------------------
"
    # Set fractional scaling to 125%
    kscreen-doctor output.1.scale.1,25

    # Set adaptive sync to automatic
    kscreen-doctor output.1.vrrpolicy.automatic
}

function handle_hyprland_settings() {
    echo -ne "
-------------------------------------------------------------------------
                    Handling Hyprland settings
-------------------------------------------------------------------------
"
}

function setup_sddm() (
    sudo -s

    # Enable sddm to run on boot and start immediately
    systemctl set-default graphical.target
    systemctl enable sddm
    systemctl start sddm

    # Install theme dependencies
    dnf install -y qt6-qt5compat qt6-qtdeclarative qt6-qtsvg

    # Create all sddm folders if they don't exist
    mkdir -p /usr/share/sddm/themes
    mkdir -p /etc/sddm.conf.d/

    # Clone theme
    git clone https://github.com/RaduAvramescu/sddm-tokyo-night-theme /usr/share/sddm/themes/sddm-tokyo-night-theme

    # Set sddm theme
    echo -e "[Theme]\nCurrent=sddm-tokyo-night-theme" | tee /etc/sddm.conf.d/10-theme.conf
)

function install_hyprland() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing Hyprland
-------------------------------------------------------------------------
"

    sudo dnf install -y hyprland waybar sddm network-manager-applet

    setup_sddm

    # Install swaync from copr
    sudo dnf copr enable erikreider/SwayNotificationCenter
    sudo dnf install -y SwayNotificationCenter

    # Remove unnecessary packages installed as dependencies
    sudo dnf remove -y kitty

    # Fix xdg user dirs
    sudo dnf install -y xdg-user-dirs
    xdg-user-dirs-update

    handle_hyprland_settings
}

case $XDG_SESSION_DESKTOP in
    gnome | GNOME)
        handle_gnome_settings
        ;;

    kde | KDE)
        handle_kde_settings
        ;;

    hyprland | Hyprland)
        handle_hyprland_settings
        ;;

    *)
        echo "Unknown DE!"
        read -p "Do you want to install Hyprland? (y/N) " answer

        case $answer in 
            y ) install_hyprland;;
            N ) ;;
            * ) ;;
        esac
        ;;
esac