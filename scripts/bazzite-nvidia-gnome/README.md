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

## Development Tools

13. Run `brew analytics off`
14. Login to Github
15. Setup git from repo script:
    ```
    git clone https://github.com/RaduAvramescu/fedora-postinstall.git
    chmod u+x fedora-postinstall/scripts/generic/setup-git.sh
    fedora-postinstall/scripts/generic/setup-git.sh
    ```
16. Clone dotfiles repo
17. Run `brew install stow`
18. From keepassxc move github keys to .ssh
19. stow mpv and mangohud configs
20. Install starship via brew
21. Add user to docker group

## Desktop Environment

22. Setup GNOME DE from repo script:
    ```
    chmod u+x fedora-postinstall/scripts/generic/setup-gnome.sh
    fedora-postinstall/scripts/generic/setup-gnome.sh
    ```
23. Change Ptyxis profile to fish
24. Change font to JetBrainsMono Nerd Font in Ptyxis
25. Set font to 12px in terminal

## Applications - Flatpaks

26. Install keepassxc flatpak
27. Install Proton Plus flatpak
28. Install OBS Studio flatpak
29. Install thunderbird flatpak
30. Install gimp flatpak
31. Install mpv flatpak
32. Install discord flatpak
33. Install element flatpak
34. Install deskflow flatpak
35. Install winbox flatpak
36. Install lact flatpak

## Gaming Setup - Steam

37. Login to Steam
38. Enable GPU acceleration in Steam
39. Disable "Run Steam when computer starts"
40. Enable low bandwidth and low performance modes in Steam
41. Disable community content in Steam
42. Disable shader pre-caching
43. Set Proton-GE as default in Steam
44. Install games

## Application Configuration

45. Setup Discord
46. Setup LACT
47. Set OC in LACT

## GoXLR Setup

48. Download GoXLR config
49. Run `distrobox-assemble create` in distrobox folder for goxlr-utility:
    ```
    distrobox-assemble create fedora-postinstall/distrobox/goxlr-utility
    ```
50. Launch GoXLR Utility
51. Fix GoXLR profiles

## Usage

You can run the automated script for git and GNOME setup:

```
git clone https://github.com/RaduAvramescu/fedora-postinstall.git
chmod u+x fedora-postinstall/scripts/bazzite-nvidia-gnome/bazzite-nvidia-gnome-postinstall.sh
fedora-postinstall/scripts/bazzite-nvidia-gnome/bazzite-nvidia-gnome-postinstall.sh
```

Most steps require manual configuration and are documented above.
