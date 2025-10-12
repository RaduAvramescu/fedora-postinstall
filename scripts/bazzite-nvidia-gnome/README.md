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

13. Install flatpaks: KeePassXC, Proton Plus, OBS Studio, Thunderbird, GIMP, mpv, Discord, Element, Deskflow, WinBox, LACT
14. Run `brew install stow starship`

## Development Tools

15. Run `brew analytics off`
16. Login to GitHub
17. Setup git from repo script (automated by postinstall script - see Usage section)
18. Clone dotfiles repo
19. From KeePassXC move GitHub keys to ~/.ssh
20. stow mpv and mangohud configs
21. Add user to docker group
22. Change Ptyxis profile to fish
23. Change font to JetBrainsMono Nerd Font in Ptyxis
24. Set font to 12px in terminal

## Desktop Environment

25. Setup GNOME DE from repo script (automated by postinstall script - see Usage section)

## Gaming Setup - Steam

26. Login to Steam
27. Enable GPU acceleration in Steam
28. Disable "Run Steam when computer starts"
29. Enable low bandwidth and low performance modes in Steam
30. Disable community content in Steam
31. Disable shader pre-caching
32. Set Proton-GE as default in Steam
33. Install games

## Application Configuration

34. Setup Discord
35. Setup LACT:
    - Enable GPU Locked Clocks checked
    - Maximum GPU Clock: 3000
    - GPU P-State 0 Clock Offset: 400
    - VRAM P-State 0 Clock Offset: 2000

## GoXLR Setup

36. Download GoXLR config
37. Run `distrobox-assemble create` in distrobox folder for goxlr-utility:
    ```
    distrobox-assemble create fedora-postinstall/distrobox/goxlr-utility
    ```
38. Launch GoXLR Utility
39. Fix GoXLR profiles

## Usage

You can run the automated script for git and GNOME setup:

```
git clone https://github.com/RaduAvramescu/fedora-postinstall.git
chmod u+x fedora-postinstall/scripts/bazzite-nvidia-gnome/bazzite-nvidia-gnome-postinstall.sh
fedora-postinstall/scripts/bazzite-nvidia-gnome/bazzite-nvidia-gnome-postinstall.sh
```

Most steps require manual configuration and are documented above.
