#!/bin/bash

dbname={{database.name}}
dbuser={{database.user}}
dbpassword={{database.password}}
databasebackup=nextcloud-db-`date +"%Y%m%d"`.sql
filesystembackup=nextcloud-fs-`date +"%Y%m%d"`

# put nextcloud instance to maintenance mode
ssh {{backup_user}}@{{nextcloud_host}} php occ maintenance:mode --on

# dump the database
ssh {{backup_user}}@{{nextcloud_host}} "mysqldump --single-transaction -u $dbuser -p$dbpassword $dbname > ~/$databasebackup"

# copy datas from the backup server
rsync -avx {{backup_user}}@{{nextcloud_host}}:/var/www/html/nextcloud/ /backups/$filesystembackup/
rsync -avx {{backup_user}}@{{nextcloud_host}}:/home/{{backup_user}}/$databasebackup /backups/$databasebackup

# put nextcloud back to normal mode
ssh {{backup_user}}@{{nextcloud_host}} php occ maintenance:mode --off
