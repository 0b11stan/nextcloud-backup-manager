#!/bin/bash

backupversion=$1
dbname={{database.name}}
dbuser={{database.user}}
dbpassword={{database.password}}
databasebackup=nextcloud-$backupversion.sql
filesystembackup=nextcloud-$backupversion

echo '>> puting nextcloud in maintenance mode ...'
ssh {{backup_user}}@{{nextcloud_host}} 'sudo -u www-data /usr/bin/php /var/www/html/nextcloud/occ maintenance:mode --on'

echo '>> restoring database ...'
rsync -av /data/backup/$databasebackup {{backup_user}}@{{nextcloud_host}}:/home/{{backup_user}}/$databasebackup
ssh {{backup_user}}@{{nextcloud_host}} "mysql -u $dbuser -p$dbpassword $dbname < /home/{{backup_user}}/$databasebackup"

echo '>> restoring filesystem ...'
sudo /usr/bin/rsync -e "ssh -i /home/nextsavior/.ssh/id_rsa" --rsync-path="sudo /usr/bin/rsync" -av /data/backup/$filesystembackup/ {{backup_user}}@{{nextcloud_host}}:/var/www/html/nextcloud/

echo '>> puting nextcloud back to normal mode ...'
ssh {{backup_user}}@{{nextcloud_host}} 'sudo -u www-data /usr/bin/php /var/www/html/nextcloud/occ maintenance:mode --off'
