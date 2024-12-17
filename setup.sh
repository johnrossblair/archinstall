#!/bin/bash

clear

# Enable Parallel Downloads, and set the value to 10 at a time
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf

# Create a backup, and update the mirrorlist
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

echo "Finding best mirrors via reflector. This may take a bit."
reflector -c US -p https --age 6 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist

echo "$(lsblk)"
read -p "What drive are you installing Arch on? (/dev/xxx): " DISK;

# Disk Partitioning
umount -A --recursive /mnt # Verify everything is unmounted
sgdisk -Z $DISK # Zap disk

sgdisk -n 1::+1G --typecode=1:ef00 --change-name=1:'boot' $DISK
sgdisk -n 2::-0 --typecode=2:8300 --change-name=2:'root' $DISK

if [[ "${DISK}" =~ "nvme" ]]; then
    partition1=${DISK}p1
    partition2=${DISK}p2
else
    partition1=${DISK}1
    partition2=${DISK}2
fi

mkfs.vfat -F32 -n "boot" ${partition1}
mkfs.ext4 -L root ${partition2}

mount ${partition2} /mnt
mount --mkdir ${partition1} /mnt/boot

pacstrap -K /mnt base linux linux-firmware nano intel-ucode base-devel networkmanager pacman-contrib bash-completion reflector

genfstab -U /mnt >> /mnt/etc/fstab
