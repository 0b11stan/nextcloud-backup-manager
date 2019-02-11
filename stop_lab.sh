#!/bin/bash

sed -i -r 's/^.*lab//' /etc/hosts
virsh shutdown nextcloud
virsh shutdown next_backup
virsh net-destroy preprod1
