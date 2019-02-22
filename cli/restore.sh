#!/bin/bash

OPTIND=1

usage='usage : ./nbm.sh --restore -u <ssh user> -b <backup host>'

while getopts u:b:h opt; do
    case $opt in
        b) backup_host=$OPTARG ;;
        u) user=$OPTARG ;;
        h) echo $usage; exit 1 ;;
        :) echo "Option -$OPTARG require an argument"; exit 1 ;;
    esac
done

if [[ -z $backup_host || -z $user ]]; then echo $usage; exit 1; fi

cat << EOF
* We strongly recommand you to use ssh with publickeys for your user experience
* You can use the following command to use ssh pubkeys instead of password
* \`$ ssh-copy-id $backup_host\`
EOF

echo
read -p "  Mot de passe sudo pour $backup_host : " -s back_sudo_pass && echo
echo

echo '>> listing available backups ...'

versions=$(\
    ssh $user@$backup_host "echo $back_sudo_pass | sudo -S zfs list -t snapshot | grep data/backup | sed 's/.*@\([0-9]*\).*/\1/g'" 2>/dev/null \
)

count=0
for version in $versions; do
    echo $count\) $version
    ((count++))
done

echo
read -p '>> please choose the backup version you want to restore : ' chosen_version_number && echo

count=0
for version in $versions; do
    if [ $count -eq $chosen_version_number ]; then
        chosen_version=$version
    fi
    ((count++))
done

if [[ -z $chosen_version ]]; then echo 'Error : you should choose an existing version'; exit 1; fi

ssh $user@$backup_host "echo $back_sudo_pass | sudo -S -u nextsavior /home/nextsavior/restore.sh $chosen_version" 2>/dev/null

