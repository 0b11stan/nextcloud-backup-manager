#!/bin/bash

#virsh net-start preprod1
#virsh start nextcloud
#virsh start next_backup
#virt-viewer nextcloud
#virt-viewer next_backup
tee -a /etc/hosts <<< '10.0.0.230 nextcloud.lab'
tee -a /etc/hosts <<< '10.0.0.152 backup.lab'
