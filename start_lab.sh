#!/bin/bash

ls /root 2>/dev/null | {
    echo 'Error : This script require root privilèges.'
}

virsh net-start preprod1
virsh start nextcloud
virsh start backup
virt-viewer nextcloud
virt-viewer backup
tee -a /etc/hosts <<< '10.0.0.167 nextcloud.lab'
tee -a /etc/hosts <<< '10.0.0.222 backup.lab'
