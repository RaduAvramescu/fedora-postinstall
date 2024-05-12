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

function handle_hyprland_settings() (
    echo -ne "
-------------------------------------------------------------------------
                    Handling Hyprland settings
-------------------------------------------------------------------------
"
    # Setup themes
    mkdir -p ~/.icons
    mkdir -p ~/.config/gtk-4.0

    cd ../themes

    # Copy cursor theme
    tar -xvf Simp1e-Tokyo-Night.tar.xz
    mkdir -p ~/.icons/Simp1e-Tokyo-Night
    sudo mkdir -p /usr/share/icons/Simp1e-Tokyo-Night
    cp -rf Simp1e-Tokyo-Night ~/.icons/Simp1e-Tokyo-Night
    sudo cp -rf Simp1e-Tokyo-Night /usr/share/icons/Simp1e-Tokyo-Night

    # Copy general theme
    unzip 01-Tokyonight-Dark-B.zip -d 01-Tokyonight-Dark-B
    cd 01-Tokyonight-Dark-B/
    mkdir -p ~/.themes/Tokyonight-Dark-B
    sudo mkdir -p /usr/share/themes/Tokyonight-Dark-B
    cp -rf Tokyonight-Dark-B ~/.themes/Tokyonight-Dark-B
    sudo cp -rf Tokyonight-Dark-B /usr/share/themes/Tokyonight-Dark-B

    # Copy icon theme
    cd ~/Repos
    sudo rm -rf Tokyo-Night-GTK-Theme
    git clone https://github.com/Fausto-Korpsvart/Tokyo-Night-GTK-Theme
    cd Tokyo-Night-GTK-Theme
    mkdir -p ~/.icons/Tokyonight-Dark
    sudo mkdir -p /usr/share/icons/Tokyonight-Dark
    cp -rf Tokyonight-Dark ~/.icons/Tokyonight-Dark
    sudo cp -rf Tokyonight-Dark /usr/share/icons/Tokyonight-Dark
    cd ..
    sudo rm -rf Tokyo-Night-GTK-Theme
    
    ln -s ~/.themes/Tokyonight-Dark-B/gtk-4.0/assets ~/.config/gtk-4.0/assets
    ln -s ~/.themes/Tokyonight-Dark-B/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css
    ln -s ~/.themes/Tokyonight-Dark-B/gtk-4.0/gtk-dark.css ~/.config/gtk-4.0/gtk-dark.css

    sudo flatpak override --filesystem=~/.themes
    sudo flatpak override --filesystem=~/.icons
    flatpak override --user --env=XCURSOR_PATH=~/.icons
    flatpak override --user --filesystem=~/.themes:ro --filesystem=~/.icons:ro
    flatpak override --user --filesystem=~/.icons:ro --filesystem=/usr/share/icons/:ro
    flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
    flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
    sudo flatpak override --filesystem=xdg-config/gtk-4.0:ro

    gsettings set org.gnome.desktop.interface icon-theme 'Tokyonight-Dark'
    gsettings set org.gnome.desktop.interface gtk-theme 'Tokyonight-Dark-B'
    gsettings set org.gnome.desktop.interface cursor-theme 'Simp1e-Tokyo-Night'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    gsettings set org.gnome.desktop.interface font-name 'JetBrainsMono Nerd Font, 11'
)

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
    # Install Hyprland specific packages
    cat "../data/hyprland-rpms.txt" | while read line
    do
        sudo dnf install -y "${line}"
    done

    # Update Hyprland packages from copr
    sudo dnf copr enable solopasha/hyprland
    sudo dnf upgrade -y --refresh

    # Install swaync from copr
    sudo dnf copr enable erikreider/SwayNotificationCenter
    sudo dnf install -y SwayNotificationCenter

    # Remove unnecessary packages installed as dependencies
    sudo dnf remove -y kitty

    xdg-user-dirs-update
    setup_sddm
    handle_hyprland_settings
}

handle_hyprland_settings