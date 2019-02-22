#!/bin/bash

dbname={{database.name}}
dbuser={{database.user}}
dbpassword={{database.password}}
databasebackup=nextcloud.sql
filesystembackup=nextcloud

# put nextcloud instance to maintenance mode
ssh {{backup_user}}@{{nextcloud_host}} 'sudo -u www-data /usr/bin/php /var/www/html/nextcloud/occ maintenance:mode --on'

# dump the database
ssh {{backup_user}}@{{nextcloud_host}} "mysqldump --single-transaction -u $dbuser -p$dbpassword $dbname > ~/$databasebackup"

# copy datas from the backup server
sudo /usr/bin/rsync -e "ssh -i /home/nextsavior/.ssh/id_rsa" --rsync-path="sudo /usr/bin/rsync" -av {{backup_user}}@{{nextcloud_host}}:/var/www/html/nextcloud/ /data/backup/$filesystembackup/
sudo /usr/bin/rsync -e "ssh -i /home/nextsavior/.ssh/id_rsa" --rsync-path="sudo /usr/bin/rsync" -av {{backup_user}}@{{nextcloud_host}}:/home/{{backup_user}}/$databasebackup /data/backup/$databasebackup

# snapshot backups
sudo zfs snapshot data/backup@$(date +%Y%m%d%H%M)

# put nextcloud back to normal mode
ssh {{backup_user}}@{{nextcloud_host}} 'sudo -u www-data /usr/bin/php /var/www/html/nextcloud/occ maintenance:mode --off'
