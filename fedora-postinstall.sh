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

    # Remove switch to application shortcuts
    for i in {1..9}; do
        gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
    done

    # Add switch to workspace shortcuts
    for i in {1..9}; do
        gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
    done

    # Add move to workspace shortcuts
    for i in {1..9}; do
        gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>${i}']"
    done

    # Make folder where all repos are stored
    mkdir -p ~/Repos
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
    flatpak remote-modify --enable flathub
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

function install_terminal() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing terminal
-------------------------------------------------------------------------
"
    sudo dnf install -y alacritty zsh zsh-syntax-highlighting sqlite
    # Point to /bin/zsh for example, if using zsh
    sudo lchsh $USER
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/zsh-syntax-highlighting
}

function install_fonts() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing fonts
-------------------------------------------------------------------------
"
    font_dir="/usr/share/fonts/fira-code"
    sudo mkdir -p ${font_dir}
    sudo curl -fLo "${font_dir}/Fira Code Bold Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Bold/complete/Fira%20Code%20Bold%20Nerd%20Font%20Complete.ttf
    sudo curl -fLo "${font_dir}/Fira Code Retina Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Retina/complete/Fira%20Code%20Retina%20Nerd%20Font%20Complete.ttf
    sudo curl -fLo "${font_dir}/Fira Code Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/complete/Fira%20Code%20Regular%20Nerd%20Font%20Complete.ttf
    sudo curl -fLo "${font_dir}/Fira Code Medium Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Medium/complete/Fira%20Code%20Medium%20Nerd%20Font%20Complete.ttf
    sudo curl -fLo "${font_dir}/Fira Code SemiBold Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/SemiBold/complete/Fira%20Code%20SemiBold%20Nerd%20Font%20Complete.ttf
    sudo curl -fLo "${font_dir}/Fira Code Light Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Light/complete/Fira%20Code%20Light%20Nerd%20Font%20Complete.ttf
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

gpu_type=$(lspci)

handle_basic_settings
prompt_git
add_rpm_fusion_repos

if grep -E "NVIDIA|GeForce" <<< ${gpu_type}; then
    install_nvidia_drivers
fi

add_flathub_repo
install_flatpaks "generic" "generic-flatpaks.txt"
handle_gaming_flatpaks
install_terminal
install_fonts
remove_default_apps
setup_favorite_apps
