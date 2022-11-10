#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# Script that configure archlive rootfs
archlive_rootfs_configure=output/archlive-rootfs-configure.sh

# Build script that configure archlive rootfs
src/make-rootfs-configure-script.sh "$archlive_rootfs_configure"

# Bulid archlive image
export rootfs_configure_script="$archlive_rootfs_configure"
export kernel_options="rw console=ttyS0"
./archlive-builder/run build-live-image

mv ./archlive-builder/output/live.img ./output
rm -fd ./archlive-builder/output/
