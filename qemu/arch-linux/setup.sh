#!/bin/bash

# TODO: check if there's a new version; if there is -> warn

# Download ISO and signature files
wget "https://arch.mirror.hyperbit.it/iso/2026.03.01/archlinux-2026.03.01-x86_64.iso"
wget "https://arch.mirror.hyperbit.it/iso/2026.03.01/archlinux-2026.03.01-x86_64.iso.sig"

# Verify signature
sudo pacman-key -v "archlinux-2026.03.01-x86_64.iso.sig"

# Create img file
qemu-img create -f qcow2 arch.qcow2 32G
