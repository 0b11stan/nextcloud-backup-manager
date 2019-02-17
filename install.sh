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

cat << EOF
* We strongly recommand you to use ssh with publickeys for your user experience
* You can use the following command to use ssh pubkeys instead of password
* \`$ ssh-copy-id $nextcloud_host && ssh-copy-id $backup_host\`
EOF

echo
read -p "  Mot de passe sudo pour $nextcloud_host : " -s next_sudo_pass && echo
read -p "  Mot de passe sudo pour $backup_host : " -s back_sudo_pass && echo
echo

echo ">> start ssh-agent for single sign-on ..."
eval `ssh-agent` >/dev/null && ssh-add &>/dev/null

echo ">> update and upgrade $nextcloud_host ..."
ssh $user@$nextcloud_host "echo $next_sudo_pass | sudo -S apt-get update" &>/dev/null
ssh $user@$nextcloud_host "echo $next_sudo_pass | sudo -S apt-get upgrade -y" &>/dev/null

echo ">> update and upgrade $backup_host ..."
ssh $user@$backup_host "echo $back_sudo_pass | sudo -S apt-get update" &>/dev/null
ssh $user@$backup_host "echo $back_sudo_pass | sudo -S apt-get upgrade -y" &>/dev/null

echo ">> install python on $nextcloud_host ..."
ssh $user@$nextcloud_host "echo $next_sudo_pass | sudo -S apt-get -y install python" &>/dev/null

echo ">> install python on $backup_host ..."
ssh $user@$backup_host "echo $back_sudo_pass | sudo -S apt-get -y install python" &>/dev/null

echo ">> write config file ..."
tee group_vars/all.yml >>/dev/null << EOF
# This user will be created on nextcloud host and the backups host
# it will be in charge of all operations.
backup_user: nextsavior

# This is nextcloud's hostname from the point of vue of the backup
# host (you can enter an ip address).
nextcloud_host: $nextcloud_host

# You can add any occurence you want the server to make a backup
# A cron job will be created at the defined hour.
# You MUST give a name to your occurence
backup_occurrence:
  - name: first occurence
    hour: 00
    minute: 15
  - name: second occurence
    hour: 12
    minute: 30

# This is nextcloud's default credentials for its database, you
# must change the password accordingly.
database:
  name: nextcloud
  user: oc_admin
  password: k6wvf+vqhqlwT9zXS9oLXA0X+l9Imm
EOF

read -sp ">> press enter to access the config file :" && echo
vim group_vars/all.yml

echo ">> write inventory file..."
tee inventory.ini >/dev/null << EOF
[nextcloud-host]
$nextcloud_host
[backup-host]
$backup_host
EOF

echo ">> generate ssh keys for host and backup connexion ..."
ssh-keygen -f roles/backup-host/files/id_rsa -N '' >/dev/null

echo ">> thank you, installation process will continue with ansible ..."
echo && ansible-playbook -Kb -i inventory.ini site.yml

rm roles/backup-host/files/id_rsa*
rm group_vars/all.yml
rm inventory.ini
