#!/bin/bash

vms=(k-master1)
for vm in "${vms[@]}"
do
    echo sudo virsh start "${vm}"
done


