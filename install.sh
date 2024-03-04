#!/bin/sh

set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <base device>"
fi

if [ "$(id -u)" -ne 0 ]; then
        echo 'This script must be run by root' >&2
        exit 1
fi

BASE_DEVICE="$1"

umount $BASE_DEVICE*

# create partitions (with 2G swap)
(
echo g

# swap
echo n
echo
echo
echo +2GB
echo t
echo
echo 19

# bios boot (for grub)
echo n
echo
echo
echo +16MB
echo t
echo
echo 4

# /
echo n
echo
echo
echo

echo w
) | fdisk $BASE_DEVICE

fdisk -l $BASE_DEVICE

# enable swap
mkswap -f ${BASE_DEVICE}1
swapon ${BASE_DEVICE}1
free -h

# wait
sleep 5

# create filesystem and mount
mkfs.ext4 ${BASE_DEVICE}3 -Lroot
mount ${BASE_DEVICE}3 /mnt

# generate NixOS config
nixos-generate-config --root /mnt

# install NixOS
curl https://raw.githubusercontent.com/coastalwhite/vps/main/configuration.nix /mnt/etc/nixos/configuration.nix

pushd /mnt
nixos-install --flake github:coastalwhite/vps#vps

echo "Changing password:"
echo ""
passwd
popd

# unmount
sync
umount ${BASE_DEVICE}3

echo "Done. Now reboot via \"Remove ISO\" on the Vultr web UI."