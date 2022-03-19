#!/usr/bin/env bash
# Fedora Workstation postinstall script

echo -ne "
-------------------------------------------------------------------------
                    Handling basic settings
-------------------------------------------------------------------------
"
# Remove mouse accel
gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat

# Setup dark theme
gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark

# Disable hot corners
gsettings set org.gnome.desktop.interface enable-hot-corners false

# Add terminal shortcut (Ctrl + Alt + T)
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Primary><Alt>t'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

# Set default Git branch to main
git config --global init.defaultBranch main

echo -ne "
-------------------------------------------------------------------------
                    Adding RPM non-free and free repos
-------------------------------------------------------------------------
"
sudo dnf upgrade -y
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo -ne "
-------------------------------------------------------------------------
                    Installing Nvidia drivers
-------------------------------------------------------------------------
"
sudo dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda

echo -ne "
-------------------------------------------------------------------------
                    Adding Flathub repo
-------------------------------------------------------------------------
"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update -y

echo -ne "
-------------------------------------------------------------------------
                    Installing Flatpaks
-------------------------------------------------------------------------
"
cat "./flatpaks.txt" | while read line
do
	if flatpak list | grep -q "${line}"; then
        echo "${line} is already installed"
	else
        flatpak install -y "${line}"
	fi
done

echo -ne "
-------------------------------------------------------------------------
                    Removing unnecessary default apps
-------------------------------------------------------------------------
"
sudo dnf remove -y totem

echo -ne "
-------------------------------------------------------------------------
                    Setting up favorite apps
-------------------------------------------------------------------------
"
getFavoriteApps() {
    cat "./favorite-apps.txt" | while read line
    do
        echo -n ", '${line}'"
    done
}

favorite_apps="$(getFavoriteApps)"
favorite_apps="[${favorite_apps:2:${#favorite_apps}}]"

gsettings set org.gnome.shell favorite-apps "$favorite_apps"
