#!/usr/bin/env bash
# to create the partitions programatically (rather than manually)
# we're going to simulate the manual input to fdisk
# The sed script strips off all the comments so that we can
# document what we're doing in-line with the actual commands
# Note that a blank line (commented as "defualt" will send a empty
# line terminated with a newline to take the fdisk default.
CWD=$(pwd)
DISK=$(lsblk -io SIZE,KNAME,TYPE | grep disk | sort -n | tail -n 1 | awk '{ print "/dev/"$2 }')

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${DISK}
  g # clear the in memory partition table
  n # new partition
  1 # partition number 1
    # default - start at beginning of disk
  +256M # 256 MB boot parttion
  n # new partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +8G  # 8 GB swap partition
  n # new partition
  3 # partion number 3
    # default, start immediately after preceding partition
    # the rest of the disk
  t # type
  1 #
  uefi #
  t # type
  2 #
  swap #
  t # type
  3 #
  linux #
  w # write the partition table
  q # and we're done
EOF


mkfs.fat -F32 ${DISK}1
mkswap ${DISK}2
swapon ${DISK}2
mkfs.btrfs -f ${DISK}3
mount ${DISK}3 /mnt
cd /mnt
btrfs subvol create root
btrfs subvol create home
btrfs subvol create nix
btrfs subvol create workplace
cd ..
umount /mnt
mount -o compress=zstd,subvol=root ${DISK}3 /mnt
mkdir /mnt/{boot,nix,home,workplace}
mount -o compress=zstd,subvol=home ${DISK}3 /mnt/home
mount -o compress=zstd,subvol=nix ${DISK}3 /mnt/nix
mount -o compress=zstd,subvol=workplace ${DISK}3 /mnt/workplace
mount ${DISK}1 /mnt/boot
nixos-generate-config --root /mnt
cd ${CWD}
sudo nix-prefetch-url --name displaylink-580.zip https://www.synaptics.com/sites/default/files/exe_files/2023-08/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu5.8-EXE.zip
sudo cp -r * /mnt/etc/nixos
sudo nixos-install --root /mnt --flake /mnt/etc/nixos#rand
