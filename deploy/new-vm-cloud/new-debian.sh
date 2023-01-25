#!/bin/sh

VM_NAME="debian-11-cloud-image"
USERNAME="programster"
PASSWORD="thisIsMyPassword"


lib=/mnt/virt/virt
disk=${lib}/images/$VM_NAME/root-disk.qcow2

[ -f "${disk}" ] && rm "${disk}"

mkdir -p ${lib}/images/${VM_NAME} &&
  qemu-img convert \
    -f qcow2 \
    -O qcow2 \
    ${lib}/images/templates/debian-11-genericcloud-amd64.qcow2 \
    ${lib}/images/$VM_NAME/root-disk.qcow2

qemu-img resize ${disk} 5G

sudo genisoimage -output cidata.iso -V cidata -r -J user-data meta-data

virt-install \
  --name=${VM_NAME} \
  --ram=2048 \
  --vcpus=2 \
  --import --disk path=${disk},format=qcow2 \
  --disk path=cidata.iso,device=cdrom \
  --os-variant=debian10 --network=default,model=virtio --graphics vnc,listen=0.0.0.0 --noautoconsole