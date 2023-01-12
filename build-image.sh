#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
rm -rf ./output && mkdir ./output

# Prepare installation script.
cp -a ./archlive-installation-script ./output/installation-script
rm -rf ./output/installation-script/.git
cp -f ./src/os-installation-config ./output/installation-script/config
cp -f ./src/post-installation-utilities.sh ./output/installation-script/

# Bulid archlive image
export rootfs_configure_script="src/archlive-configure.sh"
export kernel_options="rw console=ttyS0"
export directory_to_copy="./output/installation-script"
./archlive-builder/run build-live-image

mv ./archlive-builder/output/live.img ./output
rm -fd ./archlive-builder/output/
