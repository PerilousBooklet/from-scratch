#!/bin/bash
qemu-system-x86_64 \
  -enable-kvm \
  -m 8G \
  -smp 4 \
  -hda arch.qcow2 \
  -bios /usr/share/ovmf/x64/OVMF.4m.fd \
  -cdrom ../archlinux-2025.05.01-x86_64.iso \
  -netdev user,id=net0,net=192.168.0.0/24,dhcpstart=192.168.0.9 \
  -device virtio-net-pci,netdev=net0 \
  -vga qxl \
  -device AC97 \
  -enable-kvm
