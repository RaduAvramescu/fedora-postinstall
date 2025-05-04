function install_terminal() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing terminal
-------------------------------------------------------------------------
"
    sudo dnf install -y alacritty fish

    # Install starship
    curl -sS https://starship.rs/install.sh | sh
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
    FONT_DIR=~/.local/share/fonts/NerdFonts
    sudo mkdir -p "${FONT_DIR}"
    cd "${FONT_DIR}"
    sudo curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    sudo unzip JetBrainsMono.zip
    sudo rm -rf JetBrainsMono.zip
    fc-cache -f "${FONT_DIR}"
)

install_terminal
install_tmux
install_fonts
