#!/usr/bin/env bash
set +o history
set -euo pipefail

pacman -Sy

core_packages=(linux-firmware amd-ucode intel-ucode)
instllation_script_requirements=(dosfstools arch-install-scripts curl)
network_packages=(iwd modemmanager)
utility_packages=(nano tree)

# Gets packages
pacman --needed --noconfirm --cachedir /cache -S \
  "${core_packages[@]}" \
  "${instllation_script_requirements[@]}" \
  "${network_packages[@]}" \
  "${utility_packages[@]}"

systemctl enable iwd
