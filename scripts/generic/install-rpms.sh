#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_dir=$(cd -- "$script_dir/../.." && pwd)
package_manager=${1:-dnf}

case "$package_manager" in
    dnf | rpm-ostree) ;;
    *)
        echo "Usage: $0 [dnf|rpm-ostree]" >&2
        exit 1
        ;;
esac

packages=()
while IFS= read -r package || [[ -n "$package" ]]; do
    [[ -z "$package" || "$package" == \#* ]] && continue
    packages+=("$package")
done < "$repo_dir/data/rpms.txt"

if (( ${#packages[@]} == 0 )); then
    exit 0
fi

echo "Installing RPMs"
case "$package_manager" in
    dnf) sudo dnf install -y "${packages[@]}" ;;
    rpm-ostree) rpm-ostree install --idempotent "${packages[@]}" ;;
esac
