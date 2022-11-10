#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# Build script that configure archlive rootfs
rm -rf ./output
src/make-rootfs-configure-script.sh ./archlive-installation-script ./output archlive-rootfs-configure.sh

# Bulid archlive image
export rootfs_configure_script="output/archlive-rootfs-configure.sh"
export kernel_options="rw console=ttyS0"
./archlive-builder/run build-live-image

mv ./archlive-builder/output/live.img ./output
rm -fd ./archlive-builder/output/
