#!/bin/bash

OPTIND=1

usage='usage : ./restore.sh -u <ssh user> -b <backup host>'

while getopts u:b:h opt; do
    case $opt in
        b) nextcloud_host=$OPTARG ;;
        u) user=$OPTARG ;;
        h) echo $usage; exit 1 ;;
        :) echo "Option -$OPTARG require an argument"; exit 1 ;;
    esac
done

if [[ -z $nextcloud_host || -z $backup_host || -z $user ]]; then echo $usage; exit 1; fi

cat << EOF
* We strongly recommand you to use ssh with publickeys for your user experience
* You can use the following command to use ssh pubkeys instead of password
* \`$ ssh-copy-id $nextcloud_host && ssh-copy-id $backup_host\`
EOF

echo
read -p "  Mot de passe sudo pour $nextcloud_host : " -s next_sudo_pass && echo
echo

echo ">> write inventory file ..."
tee inventory.ini >/dev/null << EOF
[nextcloud-host]
$nextcloud_host ansible_sudo_pass=$next_sudo_pass
EOF

echo ">> launching restore process via ansible ..."
ansible-playbook -b -t restore -i inventory.ini site.yml

