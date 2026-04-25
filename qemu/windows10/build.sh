#!/bin/bash
qemu-system-x86_64 \
  -M q35,usb=on,acpi=on,hpet=off \
  -m 8G \
  -cpu host,hv_relaxed,hv_frequencies,hv_vpindex,hv_ipi,hv_tlbflush,hv_spinlocks=0x1fff,hv_synic,hv_runtime,hv_time,hv_stimer,hv_vapic \
  -smp cores=4 \
  -accel kvm \
  -drive file=windows10.qcow2 \
  -device usb-tablet \
  -device VGA,vgamem_mb=256 \
  -nic user,model=e1000 \
  -monitor stdio \
  -cdrom Win10_22H2_English_x64v1.iso
