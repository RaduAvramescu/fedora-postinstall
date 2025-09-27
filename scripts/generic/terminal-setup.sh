function install_terminal() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing terminal
-------------------------------------------------------------------------
"
    sudo dnf install -y alacritty

    # Install homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Install all terminal related homebrew packages
    brew install fish starship tmux

    # Install tpm
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
install_fonts
