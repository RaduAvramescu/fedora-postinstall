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
}

if [ $XDG_SESSION_DESKTOP == "gnome" ] || [ $XDG_SESSION_DESKTOP == "GNOME" ]; then
    handle_gnome_settings
fi