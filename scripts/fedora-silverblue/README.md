# Fedora Silverblue Post-Installation Guide

This is my personal setup guide for Fedora Silverblue with GNOME.

## Initial System Setup

1. Update the system with `rpm-ostree upgrade`, then reboot to use the updated deployment.
2. Install any hardware-specific drivers required by your machine before continuing. This script does not install NVIDIA drivers.

Silverblue uses Flatpak for desktop applications, Toolbx for development environments, and `rpm-ostree install <package>` for packages that must run on the host. Reboot after layering host packages. See the [Silverblue overview](https://www.fedoraproject.org/atomic-desktops/silverblue/) and [package management guide](https://docs.fedoraproject.org/en-US/fedora-silverblue/getting-started/).

## Prerequisites

Run the script from a terminal in your GNOME session as your normal user. It requires `rpm-ostree`, `flatpak`, `git`, `gsettings`, `curl`, `tar`, `xz`, and `fc-cache`, and an installed terminal: Ghostty, Ptyxis, GNOME Terminal, or Alacritty. The first available terminal in that order is used for Ctrl+Alt+T. Layer any missing prerequisites with `rpm-ostree` and reboot first.

## Usage

```sh
git clone https://github.com/RaduAvramescu/fedora-postinstall.git
bash fedora-postinstall/scripts/fedora-silverblue/fedora-silverblue-postinstall.sh
```

The script can be launched from any working directory. It:

- Enables the system Flathub remote and installs the applications in [silverblue-flatpaks.txt](../../data/silverblue-flatpaks.txt).
- Layers the Fedora `chezmoi` and `fish` RPMs.
- Runs the official standalone installers for [Codex CLI](https://learn.chatgpt.com/docs/codex/cli), [Starship](https://starship.rs/guide/), and [mise](https://mise.jdx.dev/getting-started.html).
- Downloads JetBrains Mono Nerd Font from the [upstream Nerd Fonts releases](https://github.com/ryanoasis/nerd-fonts/releases) into `${XDG_DATA_HOME:-$HOME/.local/share}/fonts/JetBrainsMono` and refreshes the font cache.
- Offers Git configuration.
- Applies the shared GNOME settings for nine fixed workspaces and keyboard shortcuts.

Reboot after the script finishes to activate chezmoi and fish before continuing with dotfiles setup.

## Desktop Preferences

Set these preferences manually; the script leaves them unchanged:

- Bluetooth: disabled.
- Display refresh rate: highest available.
- Atuomatic Login: enabled.
- Mouse Acceleration: disabled.
- Appearance: dark mode.
- Hot Corner: disabled.
- Automatic update downloads in GNOME Software: disabled.

Run system and Flatpak updates manually.

## Browser and Application Setup

1. Set up Firefox and uBlock Origin medium mode.
2. Sign in to Thunderbird, Discord, Element, and other installed applications as needed.
3. Launch LACT and accept its prompt to set up the system service needed to change GPU settings. The Flatpak sets up and starts this service outside its sandbox; see the [upstream Flatpak instructions](https://github.com/ilya-zlobintsev/LACT/blob/master/flatpak/README.md). You can check the service with `systemctl status lactd`.

### Personal LACT Settings

Apply these settings manually in LACT:

- Enable GPU Locked Clocks: checked
- Maximum GPU Clock: 3000
- GPU P-State 0 Clock Offset: 400
- VRAM P-State 0 Clock Offset: 2000

## GoXLR Utility

Install GoXLR Utility from the [GoXLR-on-Linux/GoXLR-Utility repository](https://github.com/GoXLR-on-Linux/GoXLR-Utility), following its installation instructions for Fedora Atomic desktops.

## Development Tools and Dotfiles

1. Follow GitHub's guide to [generate a new SSH key and add it to your SSH agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=linux), then [add the public key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account). The optional Git setup enables SSH commit signing; to use the same key for authentication and signing, register it with GitHub separately for each purpose.
2. Initialize the dotfiles repository:

   ```sh
   chezmoi init --ssh RaduAvramescu/dotfiles
   ```

   If GitHub SSH access is not available, use `chezmoi init RaduAvramescu/dotfiles` instead.

3. Review and apply the dotfiles:

   ```sh
   chezmoi status
   chezmoi diff
   chezmoi apply
   ```

   Initializing and applying dotfiles remains manual. Configure Starship and mise shell integration in your dotfiles.

4. Select fish and the installed JetBrainsMono Nerd Font in your terminal preferences and set the font size to 12.

## Gaming Setup

Steam and ProtonPlus are installed as Flatpaks by the script.

1. Sign in to Steam.
2. Use ProtonPlus to install GE-Proton for the Flatpak Steam installation, then restart Steam.
3. Configure Steam settings:

   - Run Steam when my computer starts: disabled.
   - GPU accelerated rendering in web views: enabled (requires restart).
   - Low Bandwidth Mode: enabled.
   - Low Performance Mode: enabled.
   - Disable Community Content: enabled.
   - Enable Shader Pre-caching: disabled.
   - Default compatibility tool: GE-Proton.

4. Install your games.
