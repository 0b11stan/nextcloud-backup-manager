#!/bin/bash

OPTIND=1

usage='usage : ./setup.sh -u <ssh user> -n <nextcloud host> -b <backup host>'

while getopts u:n::b:h opt; do
    case $opt in
        n) nextcloud_host=$OPTARG ;;
        b) backup_host=$OPTARG ;;
        u) user=$OPTARG ;;
        h) echo $usage; exit 1 ;;
        :) echo "Option -$OPTARG require an argument"; exit 1 ;;
    esac
done

if [[ -z $nextcloud_host || -z $backup_host || -z $user ]]; then echo $usage; exit 1; fi

read -p "Mot de passe sudo pour $nextcloud_host : " next_sudo_pass
read -p "Mot de passe sudo pour $backup_host : " back_sudo_pass

ssh-keygen -f roles/backup-host/files/id_rsa -N '' >/dev/null

echo "\n>> update and upgrade $nextcloud_host..."
ssh $user@$nextcloud_host "echo $next_sudo_pass | sudo -S apt-get update" &>/dev/null
ssh $user@$nextcloud_host "echo $next_sudo_pass | sudo -S apt-get upgrade -y" &>/dev/null

echo "\n>> update and upgrade $backup_host..."
ssh $user@$backup_host "echo $back_sudo_pass | sudo -S apt-get update" &>/dev/null
ssh $user@$backup_host "echo $back_sudo_pass | sudo -S apt-get upgrade -y" &>/dev/null

echo "\n>> install python on $nextcloud_host..."
ssh $user@$nextcloud_host "echo $next_sudo_pass | sudo -S apt-get install python" &>/dev/null

echo "\n>> install python on $backup_host..."
ssh $user@$backup_host "echo $back_sudo_pass | sudo -S apt-get install python" &>/dev/null

# rm roles/backup-host/files/ssh-key*
