function install_terminal() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing terminal
-------------------------------------------------------------------------
"
    sudo dnf install -y alacritty fish

    # Install tide
    # set -l _tide_tmp_dir (command mktemp -d)
    # curl https://codeload.github.com/ilancosman/tide/tar.gz/v6 | tar -xzC $_tide_tmp_dir
    # command cp -R $_tide_tmp_dir/*/{completions,conf.d,functions} $__fish_config_dir
    # fish_path=(status fish-path) exec $fish_path -C "emit _tide_init_install"

    # Point to /bin/zsh for example, if using zsh
    if [ $(which chsh) ]; then
        chsh -s /bin/fish
    elif [ $(which lchsh) ]; then
        sudo lchsh $USER
    else
        echo "Failed to change shell!"
    fi
}

function install_tmux() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing tmux
-------------------------------------------------------------------------
"
    # Install tmux dependencies
    sudo dnf install -y google-noto-sans-symbols2-fonts

    # Install tmux
    sudo dnf install -y tmux
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

function install_fonts() (
    echo -ne "
-------------------------------------------------------------------------
                    Installing fonts
-------------------------------------------------------------------------
"
    font_dir="/usr/share/fonts/NerdFonts"
    sudo mkdir -p "${font_dir}"
    cd "${font_dir}"
    sudo curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    sudo unzip JetBrainsMono.zip
    sudo rm -rf JetBrainsMono.zip
    fc-cache -f "${font_dir}"
)

install_terminal
install_tmux
install_fonts
