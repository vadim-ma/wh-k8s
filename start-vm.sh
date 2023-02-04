#!/bin/bash

vms=(k-master1)
for vm in "${vms[@]}"
do
    sudo virsh start "${vm}"
done


