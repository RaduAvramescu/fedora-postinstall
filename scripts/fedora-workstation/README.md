# Fedora Postinstall Script

This is my personal script which I use immediately after I install Fedora Workstation. It does basic setup, and handles the installation of all the apps I use.

## Usage

Type the following commands in a terminal:

```
git clone https://github.com/RaduAvramescu/fedora-postinstall.git
chmod u+x fedora-postinstall/scripts/fedora-workstation/fedora-workstation-postinstall.sh
fedora-postinstall/scripts/fedora-workstation/fedora-workstation-postinstall.sh
```

The script can be launched from any working directory. It:

- Installs the applications in [flatpaks.txt](../../data/flatpaks.txt).
- Installs the Fedora RPMs in [rpms.txt](../../data/rpms.txt) with DNF: `chezmoi` and `fish`.
- Runs the official standalone installer for [Starship](https://starship.rs/guide/).
- Downloads JetBrains Mono Nerd Font from the [upstream Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases) into `${XDG_DATA_HOME:-$HOME/.local/share}/fonts/JetBrainsMono` and refreshes the font cache.

Run the setup as your normal desktop user. Font installation requires `curl`, `tar`, `xz`, and `fc-cache`.

Configure Starship in your shell settings after installation.

## Gaming Setup

Install Steam and ProtonPlus from [gaming-flatpaks.txt](../../data/gaming-flatpaks.txt) separately after running the setup. From the repository root:

```sh
bash scripts/generic/install-flatpaks.sh "Gaming" data/gaming-flatpaks.txt
```
