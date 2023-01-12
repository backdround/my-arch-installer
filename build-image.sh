#!/usr/bin/env bash
set -euo pipefail

#error() {
  #echo "$@" >&2
  #exit 1
#}

cd "$(dirname "$0")"
rm -rf ./output && mkdir ./output

# Prepare installation script.
cp -a ./archlive-installation-script ./output/installation-script
rm -rf ./output/installation-script/.git
cp -f ./src/installation-config ./output/installation-script/config

# Bulid archlive image
export rootfs_configure_script="src/rootfs-configure.sh"
export kernel_options="rw console=ttyS0"
export directory_to_copy="./output/installation-script"
./archlive-builder/run build-live-image

mv ./archlive-builder/output/live.img ./output
rm -fd ./archlive-builder/output/
