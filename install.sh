#!/bin/sh

umount /dev/vda*

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
) | fdisk /dev/vda

fdisk -l /dev/vda

# enable swap
mkswap -f /dev/vda1
swapon /dev/vda1
free -h

# wait
sleep 5

# create filesystem and mount
mkfs.ext4 /dev/vda3 -Lroot
mount /dev/vda3 /mnt

# generate NixOS config
nixos-generate-config --root /mnt

# install NixOS
nixos-install --experimental-features 'nix-command flakes' --flake github:coastalwhite/vps#vps

# unmount
sync
umount /dev/vda3

echo "Done. Now reboot via \"Remove ISO\" on the Vultr web UI."