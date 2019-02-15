#!/bin/bash

ls /root 2>/dev/null | {
    echo 'Error : This script require root privilèges.'
}

sed -i -r 's/^.*lab//' /etc/hosts
virsh shutdown nextcloud
virsh shutdown backup
virsh net-destroy preprod1
