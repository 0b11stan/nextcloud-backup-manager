#!/bin/bash

backupversion=$1
dbname={{database.name}}
dbuser={{database.user}}
dbpassword={{database.password}}
databasebackup=nextcloud-$backupversion.sql
filesystembackup=nextcloud-$backupversion

echo '>> puting nextcloud in maintenance mode ...'
ssh {{backup_user}}@{{nextcloud_host}} 'sudo -u www-data /usr/bin/php /var/www/html/nextcloud/occ maintenance:mode --on'

echo '>> restoring database ...' >> /tmp/backup.log
rsync -av /data/backup/$databasebackup {{backup_user}}@{{nextcloud_host}}:/home/{{backup_user}}/$databasebackup
ssh {{backup_user}}@{{nextcloud_host}} "mysql -u $dbuser -p$dbpassword $dbname < /home/{{backup_user}}/$databasebackup"

echo '>> restoring filesystem ...'
rsync -av --rsync-path="sudo /usr/bin/rsync" /data/backup/$filesystembackup/ {{backup_user}}@{{nextcloud_host}}:/var/www/html/nextcloud/

echo '>> puting nextcloud back to normal mode ...'
ssh {{backup_user}}@{{nextcloud_host}} 'sudo -u www-data /usr/bin/php /var/www/html/nextcloud/occ maintenance:mode --off'
