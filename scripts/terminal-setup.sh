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

    # tide configure --auto --style=Rainbow --prompt_colors='True color' --show_time='12-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, frame' --prompt_connection=Disconnected --powerline_right_prompt_frame=Yes --prompt_connection_andor_frame_color=Dark --prompt_spacing=Sparse --icons='Many icons' --transient=Yes
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
