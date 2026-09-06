#!/usr/bin/env bash
set -euo pipefail

function setup_terminal_shortcut() {
    local terminal_command=$1
    local media_keys_schema=org.gnome.settings-daemon.plugins.media-keys
    local shortcut_path=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/fedora-postinstall-terminal/
    local shortcut_schema="org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$shortcut_path"
    local custom_keybindings

    custom_keybindings=$(gsettings get "$media_keys_schema" custom-keybindings)
    # Empty GVariant arrays may include an explicit type annotation.
    custom_keybindings=${custom_keybindings#@as }

    gsettings set "$shortcut_schema" binding '<Primary><Alt>t'
    gsettings set "$shortcut_schema" command "$terminal_command"
    gsettings set "$shortcut_schema" name 'Terminal'

    # Preserve other shortcuts and register our dedicated path only once.
    if [[ "$custom_keybindings" != *"'$shortcut_path'"* ]]; then
        if [[ "$custom_keybindings" == '[]' ]]; then
            custom_keybindings="['$shortcut_path']"
        else
            custom_keybindings="${custom_keybindings%]}, '$shortcut_path']"
        fi
        gsettings set "$media_keys_schema" custom-keybindings "$custom_keybindings"
    fi
}

function handle_gnome_settings() {
    local terminal_command=${1:-alacritty}
    echo -ne "
-------------------------------------------------------------------------
                    Handling GNOME settings
-------------------------------------------------------------------------
"
    # Add toggle fullscreen shortcut
    gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>f']"

    # Add terminal shortcut (Ctrl + Alt + T)
    setup_terminal_shortcut "$terminal_command"

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

handle_gnome_settings "$@"
