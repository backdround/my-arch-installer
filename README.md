## My-arch-installer
This is a project that allows me to build custom live image for archlinux
installation. It's just a top level project that unions live builder,
installation scripts and corresponding config with my prferences.

### Build
```bash
./build-image.sh
```

### Flash
```bash
# Get usb path
lsblk

# Flash usb
dd status=progress bs=5M if=./output/live.img of=/dev/%USB_BLOCK_HERE%
```

### Install archlinux
```bash
# Boot to live image

# Connect to internet
...

# Go to installation-script
cd installation-script

# Search disk path to install
lsblk

# Edit installation config
nano ./config

# Run installation script
./install.sh
```
