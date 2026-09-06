#!/usr/bin/env bash
# Fedora Silverblue postinstall script. Run as your desktop user.
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_dir=$(cd -- "$script_dir/../.." && pwd)
generic_dir="$repo_dir/scripts/generic"

if (( EUID == 0 )); then
    echo "Run this script as your desktop user, without sudo." >&2
    exit 1
fi

# Check prerequisites before installing applications or changing settings.
for required_command in rpm-ostree flatpak brew git gsettings; do
    if ! command -v "$required_command" > /dev/null 2>&1; then
        echo "Missing $required_command. Complete the prerequisites in $script_dir/README.md first." >&2
        exit 1
    fi
done

terminal_command=
for candidate in ptyxis gnome-terminal alacritty; do
    if command -v "$candidate" > /dev/null 2>&1; then
        terminal_command=$candidate
        break
    fi
done
if [[ -z "$terminal_command" ]]; then
    echo "Install Ptyxis, GNOME Terminal, or Alacritty before running this script." >&2
    exit 1
fi

echo "Step 1: Installing applications"
# Flatpak is provided by Silverblue; configure Flathub without DNF.
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-modify --system --enable flathub
bash -e "$generic_dir/install-flatpaks.sh" "Silverblue applications" "$repo_dir/data/silverblue-flatpaks.txt"

brew analytics off
bash -e "$generic_dir/install-brew-packages.sh" chezmoi

echo "Step 2: Development tools setup"
bash "$generic_dir/setup-git.sh"

echo "Step 3: Desktop environment setup"
bash -e "$generic_dir/setup-gnome.sh" "$terminal_command"

echo "Setup complete. Continue with the manual dotfiles and application setup in $script_dir/README.md."
