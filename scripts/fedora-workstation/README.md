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
