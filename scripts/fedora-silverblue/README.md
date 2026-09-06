# Fedora Silverblue Post-Installation Guide

This is my personal setup guide for Fedora Silverblue with GNOME.

## Initial System Setup

1. Update the system with `rpm-ostree upgrade`, then reboot to use the updated deployment.
2. Install any hardware-specific drivers required by your machine before continuing. This script does not install NVIDIA drivers.
3. Disable Bluetooth if unused, select the desired display refresh rate, and configure login preferences in Settings.

Silverblue uses Flatpak for desktop applications, Toolbx for development environments, and `rpm-ostree install <package>` for packages that must run on the host. Reboot after layering host packages. See the [Silverblue overview](https://www.fedoraproject.org/atomic-desktops/silverblue/) and [package management guide](https://docs.fedoraproject.org/en-US/fedora-silverblue/getting-started/).

## Prerequisites

Install Homebrew on the host using the [official Linux instructions](https://docs.brew.sh/Homebrew-on-Linux), then follow the installer's next steps to put `brew` on your shell's `PATH`. Use `rpm-ostree` to layer any missing host build dependencies (such as `gcc`, `gcc-c++`, `make`, and `patch`) and reboot before installing Homebrew; the DNF commands in those instructions are for traditional Fedora installations.

Run the script from a terminal in your GNOME session as your normal user. It requires `rpm-ostree`, `flatpak`, `brew`, `git`, and `gsettings`, and an installed terminal: Ghostty, Ptyxis, GNOME Terminal, or Alacritty. The first available terminal in that order is used for Ctrl+Alt+T.

## Usage

```sh
git clone https://github.com/RaduAvramescu/fedora-postinstall.git
bash fedora-postinstall/scripts/fedora-silverblue/fedora-silverblue-postinstall.sh
```

The script can be launched from any working directory. It enables the system Flathub remote, installs the applications in [silverblue-flatpaks.txt](../../data/silverblue-flatpaks.txt), disables Homebrew analytics, installs chezmoi, offers Git configuration, and applies the shared GNOME settings. Those settings include dark mode, flat mouse acceleration, nine fixed workspaces, keyboard shortcuts, and disabling automatic update downloads in GNOME Software. Run system and Flatpak updates manually if you keep that setting.

## Browser and Application Setup

1. Set up Firefox and uBlock Origin medium mode.
2. Sign in to Thunderbird, Discord, Element, and other installed applications as needed.
3. The LACT Flatpak supplies the interface; install and enable its host daemon separately using the [upstream installation instructions](https://github.com/ilya-zlobintsev/LACT#installation) for Fedora Atomic desktops before using it.

### Personal LACT Settings

Apply these settings manually in LACT:

- Enable GPU Locked Clocks: checked
- Maximum GPU Clock: 3000
- GPU P-State 0 Clock Offset: 400
- VRAM P-State 0 Clock Offset: 2000

## GoXLR Utility

Install GoXLR Utility from the [GoXLR-on-Linux/GoXLR-Utility repository](https://github.com/GoXLR-on-Linux/GoXLR-Utility), following its installation instructions for Fedora Atomic desktops.

## Development Tools and Dotfiles

1. Restore your GitHub SSH keys from your password manager to `~/.ssh`, set their permissions, and configure your SSH agent. The optional Git setup enables SSH commit signing.
2. Initialize the dotfiles repository:

   ```sh
   chezmoi init --ssh RaduAvramescu/dotfiles
   ```

   If GitHub SSH access is not available, use `chezmoi init RaduAvramescu/dotfiles` instead.

3. Review and apply the dotfiles and their Homebrew packages:

   ```sh
   chezmoi status
   chezmoi diff
   chezmoi apply "$HOME/Brewfile"
   brew bundle --file="$HOME/Brewfile"
   chezmoi diff
   chezmoi apply
   ```

   The Brewfile installs Starship and the other managed command-line packages. Initializing and applying dotfiles remains manual.

4. Once fish and JetBrainsMono Nerd Font are installed, select them in your terminal preferences and set the font size to 12.
5. Use `toolbox create` and `toolbox enter` for development packages that do not need to run on the host.

## Gaming Setup

Steam and ProtonPlus are installed as Flatpaks by the script.

1. Sign in to Steam.
2. Use ProtonPlus to install GE-Proton for the Flatpak Steam installation, then restart Steam.
3. Configure Steam's startup, library performance, and compatibility preferences.
4. Install your games and select the desired compatibility tool where needed.
