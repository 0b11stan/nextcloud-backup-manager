#!/bin/bash

if [ $EUID -ne 0 ]; then
    echo "Error: this script need root privilèges"
    exit 1
fi

sed -i -r 's/^.*lab//' /etc/hosts
virsh shutdown nextcloud
virsh shutdown backup
virsh net-destroy preprod1
