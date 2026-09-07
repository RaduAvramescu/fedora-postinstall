# Fedora Postinstall Script

This is my personal script which I use immediately after I install Fedora Workstation. It does basic setup, and handles the installation of all the apps I use.

## Usage

Type the following commands in a terminal:

```
git clone https://github.com/RaduAvramescu/fedora-postinstall.git
chmod u+x fedora-postinstall/scripts/fedora-workstation/fedora-workstation-postinstall.sh
fedora-postinstall/scripts/fedora-workstation/fedora-workstation-postinstall.sh
```

The script can be launched from any working directory. It resolves helper scripts and package lists relative to the repository and stops if a setup step fails.

Terminal setup installs Alacritty, fish, and tmux with DNF, and Starship with its standalone installer into `~/.local/bin`. Ensure that directory is on your shell's `PATH` and configure Starship in your shell settings. JetBrains Mono Nerd Font is downloaded from upstream into `${XDG_DATA_HOME:-$HOME/.local/share}/fonts/JetBrainsMono` and the font cache is refreshed. Font installation requires `curl`, `tar`, `xz`, and `fc-cache`; run the setup as your normal desktop user.
