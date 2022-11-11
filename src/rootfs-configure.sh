#!/usr/bin/env bash
set +o history
set -euo pipefail

pacman -Sy

# Installs archlive-installation-script requirements
pacman --needed --noconfirm --cachedir /cache -S dosfstools arch-install-scripts curl

# Gets packages for installation script
pacman --needed --noconfirm --cachedir /cache -S nano tree
