#!/bin/bash

dbname={{database.name}}
dbuser={{database.user}}
dbpassword={{database.password}}
databasebackup=nextcloud-`date +"%Y%m%d"`.sql
filesystembackup=nextcloud-`date +"%Y%m%d"`

# put nextcloud instance to maintenance mode
ssh {{backup_user}}@{{nextcloud_host}} 'sudo -u www-data /usr/bin/php /var/www/html/nextcloud/occ maintenance:mode --on'

# dump the database
ssh {{backup_user}}@{{nextcloud_host}} "mysqldump --single-transaction -u $dbuser -p$dbpassword $dbname > ~/$databasebackup"

# copy datas from the backup server
rsync -avx {{backup_user}}@{{nextcloud_host}}:/var/www/html/nextcloud/ /data/backup/$filesystembackup/
rsync -avx {{backup_user}}@{{nextcloud_host}}:/home/{{backup_user}}/$databasebackup /data/backup/$databasebackup

# put nextcloud back to normal mode
ssh {{backup_user}}@{{nextcloud_host}} 'sudo -u www-data /usr/bin/php /var/www/html/nextcloud/occ maintenance:mode --off'
