sudo -i
umount /dev/vda*

fdisk /dev/vda
# Commands:
# g
# n _ _ +2GB t _ 19
# n _ _ +16MB t _ 4
# n _ _ _
# w

fdisk -l /dev/vda

# enable swap
mkswap -f /dev/vda1
swapon /dev/vda1
free -h

# create filesystem and mount
mkfs.ext4 /dev/vda3 -Lroot
mount /dev/vda3 /mnt

# generate NixOS config
nixos-generate-config --root /mnt

cd /mnt

vim etc/nixos/configuration.nix
# Add:
# uncomment: boot.loader.grub.device = "/dev/vda";
# services.openssh = {
# 	enable = true;
# 	settings.PermitRootLogin = "yes";
# };

nixos-install

# unmount
sync
umount /dev/vda3