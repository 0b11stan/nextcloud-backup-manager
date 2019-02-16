#!/bin/bash

if [ $EUID -ne 0 ]; then
    echo "Error: this script need root privilèges"
    exit 1
fi

virsh net-start preprod1
virsh start nextcloud
virsh start backup
virt-viewer nextcloud
virt-viewer backup
tee -a /etc/hosts <<< '10.0.0.167 nextcloud.lab'
tee -a /etc/hosts <<< '10.0.0.222 backup.lab'
