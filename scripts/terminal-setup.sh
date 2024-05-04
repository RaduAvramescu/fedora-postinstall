function install_terminal() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing terminal
-------------------------------------------------------------------------
"
    sudo dnf install -y alacritty zsh zsh-syntax-highlighting sqlite
    
    # Point to /bin/zsh for example, if using zsh
    if [ $(which chsh) ]; then
        chsh -s /bin/zsh
    elif [ $(which lchsh) ]; then
        sudo lchsh $USER
    fi

    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/zsh-syntax-highlighting
}

function install_tmux() {
    echo -ne "
-------------------------------------------------------------------------
                    Installing tmux
-------------------------------------------------------------------------
"
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
    sudo curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Bold/FiraCodeNerdFont-Bold.ttf
    sudo curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Light/FiraCodeNerdFont-Light.ttf
    sudo curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Medium/FiraCodeNerdFont-Medium.ttf
    sudo curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.ttf
    sudo curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Retina/FiraCodeNerdFont-Retina.ttf
    sudo curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/SemiBold/FiraCodeNerdFont-SemiBold.ttf
    fc-cache -f "${font_dir}"
)

install_terminal
install_tmux
install_fonts
