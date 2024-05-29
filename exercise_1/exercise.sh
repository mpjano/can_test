#!/bin/bash

set -e

sudo apt-get update
sudo apt-get install -y qemu-system-x86 qemu-utils wget build-essential \
    linux-image-generic busybox-static gcc

KERNEL="/boot/vmlinuz-$(uname -r)"
FILESYSTEM="rootfs.img"

if [ ! -f "init.c" ]; then
    echo "init.c not found. Exiting."
    exit 1
fi

gcc -static init.c -o init

mkdir -p rootfs
mv init rootfs/
busybox --install -s rootfs


dd if=/dev/zero of=$FILESYSTEM bs=1M count=100
mkfs.ext2 $FILESYSTEM



mkdir -p mnt
sudo mount -o loop $FILESYSTEM mnt
sudo cp -R rootfs/* mnt/
sudo umount mnt

if [ ! -f "$KERNEL" ]; then
    echo "Kernel image not found at path: $KERNEL"
    exit 1
fi

if [ ! -f "$FILESYSTEM" ]; then
    echo "Filesystem image not found at path: $FILESYSTEM"
    exit 1
fi

sudo qemu-system-x86_64 -kernel /boot/vmlinuz-$(uname -r) -m 1024 -append "root=/dev/sda init=/init console=ttyS0 nokaslr" -nographic -drive file=rootfs.img,format=raw
