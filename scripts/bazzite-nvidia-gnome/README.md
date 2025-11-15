# Bazzite Nvidia GNOME Post-Installation Guide

This is my personal setup guide for Bazzite Nvidia GNOME installations. Follow these steps in order after a fresh install.

## Initial System Setup

1. Run `ujust update` on first boot
2. Reboot
3. Rebase to Bazzite DX Nvidia Gnome image
4. Reboot
5. Run `ujust update`
6. Reboot

## System Configuration

7. Disable Bluetooth
8. Increase refresh rate
9. Disable mouse acceleration
10. Enable automatic login in settings

## Browser Setup

11. Setup Firefox
12. Setup ublock medium mode

## Application Installation

13. Install flatpaks: KeePassXC, ProtonPlus, OBS Studio, Thunderbird, GIMP, Celluloid, Discord, Element, Deskflow, WinBox, LACT (automated by postinstall script - see Usage section)
14. Run `brew install stow starship` (automated by postinstall script - see Usage section)

## Development Tools

15. Run `brew analytics off` (automated by postinstall script - see Usage section)
16. Login to GitHub
17. Setup git from repo script (automated by postinstall script - see Usage section)
18. From KeePassXC move GitHub keys to ~/.ssh
19. Clone dotfiles repo
20. stow mpv and mangohud configs
21. Add user to docker group (automated by postinstall script - see Usage section)
22. Change Ptyxis profile to fish
23. Change font to JetBrainsMono Nerd Font in Ptyxis
24. Set font size to 12px in Ptyxis

## Desktop Environment

25. Setup GNOME DE from repo script (automated by postinstall script - see Usage section)

## Gaming Setup - Steam

26. Login to Steam
27. Install Proton-GE Latest from ProtonPlus
27. Configure Steam settings:
    - Disable "Run Steam when my computer starts"
    - Enable "GPU accelerated rendering in web views" (requires restart)
    - Enable "Low Bandwidth Mode"
    - Enable "Low Performance Mode"
    - Enable "Disable Community Content"
    - Disable "Enable Shader Pre-caching"
    - Set GE-Proton as default compatibility tool
28. Install games

## Application Configuration

29. Setup Discord
30. Setup LACT:
    - Enable GPU Locked Clocks checked
    - Maximum GPU Clock: 3000
    - GPU P-State 0 Clock Offset: 400
    - VRAM P-State 0 Clock Offset: 2000

## GoXLR Setup

31. Download GoXLR config
32. Run `distrobox-assemble create` in distrobox folder for goxlr-utility:
    ```
    distrobox-assemble create fedora-postinstall/distrobox/goxlr-utility
    ```
33. Launch GoXLR Utility
34. Setup GoXLR profiles (profile and mic profile)
35. Enable "AutoStart on Login"
36. Run `nano ~/.config/autostart/goxlr-daemon.desktop`
37. Change `Exec` line to `Exec=distrobox enter goxlr-utility -- goxlr-daemon`

## Usage

You can run the automated script to install applications, setup git, configure GNOME, and add user to docker group:

```
git clone https://github.com/RaduAvramescu/fedora-postinstall.git
chmod u+x fedora-postinstall/scripts/bazzite-nvidia-gnome/bazzite-nvidia-gnome-postinstall.sh
fedora-postinstall/scripts/bazzite-nvidia-gnome/bazzite-nvidia-gnome-postinstall.sh
```

The script will automate flatpak installation, Homebrew package installation, git setup, GNOME configuration, and docker group setup. Most other steps require manual configuration and are documented above.
