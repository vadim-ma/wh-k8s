создаем Debian11 VM из облачного диска cloud-init

https://zhimin-wen.medium.com/provision-a-vm-with-cloud-image-and-cloud-init-36f356a33b90
https://github.com/schtritoff/hyperv-vm-provisioning
https://github.com/ranjithrajaram/debutsav/blob/master/README.md

выбор образа: https://cloud.debian.org/images/cloud/
        нужен genericcloud: Should run in any virtualised environment. Is smaller than `generic` by excluding drivers for physical hardware.
wget https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-genericcloud-amd64.qcow2

cd /d c:\soft
qemu-img info debian-11-genericcloud-amd64.qcow2
qemu-img convert -O vhdx -o subformat=dynamic debian-11-genericcloud-amd64.qcow2 debian-11-genericcloud-amd64.vhdx
fsutil.exe sparse setFlag debian-11-genericcloud-amd64.vhdx 0

Create Debian 11 (Bullseye) KVM Guest From Cloud Image
https://blog.programster.org/create-debian-11-kvm-guest-from-cloud-image


Maka cloud-init iso 
    meta-data
    user-data
    generate iso file (1 or 2)
        1.
            sudo apt install genisoimage
            genisoimage -output cloud.iso -volid cidata -joliet -rock iso/meta-data iso/user-data 
        2.
            sudo apt install cloud-image-utils
            #cloud-localds [options] output user-data [meta-data]
            #cloud-localds -v --network-config=network.yaml cl-ubuntu-seed.qcow2 userdata.yaml
            #cloud-localds -v cl-debian-seed.qcow2 iso/userdata.yaml
            cloud-localds -v /mnt/d/hv/d1/cloud.iso iso/user-data.m1.yaml iso/meta-data.m1.json
            #- qemu-img convert cl-debian-seed.raw /mnt/d/hv/d1/cloud.iso


Create VM
    secure boot - Microsoft UEFI Sertificaate Authority or None

