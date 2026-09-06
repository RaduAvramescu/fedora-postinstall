# Fedora Post-Installation Scripts

This repository contains my personal post-installation scripts and configurations for Fedora Workstation and Fedora Silverblue. It includes automated setup scripts, generic utilities, and application lists.

## Contents

- **scripts/** - Post-installation scripts for different distributions
  - **fedora-workstation/** - Fedora Workstation setup script
  - **fedora-silverblue/** - Fedora Silverblue setup guide and script
  - **generic/** - Reusable scripts for common tasks (flatpak installation, RPM installation, Git setup, GNOME/KDE configuration, fonts, terminal setup, etc.)
- **data/** - Data files including flatpak and RPM package lists

## Usage

Follow the guide for [Fedora Workstation](scripts/fedora-workstation/README.md) or [Fedora Silverblue](scripts/fedora-silverblue/README.md). Silverblue uses Flatpak for desktop applications and rpm-ostree for host packages; the Workstation DNF setup is specific to Workstation.

## Contributing

This is a personal configuration repository, but feel free to fork and adapt it for your own needs.
