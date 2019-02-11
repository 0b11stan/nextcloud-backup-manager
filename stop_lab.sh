#!/bin/bash

sed -i -r 's/^.*lab//' /etc/hosts
virsh stop nextcloud
virsh stop next_backup
virsh net-stop preprod1
