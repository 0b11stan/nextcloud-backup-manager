# put nextcloud instance to maintenance mode
sudo -u www-data php occ maintenance:mode --on

# copy datas from the backup server
rsync -avx nextcloud.lab:/var/www/html/nextcloud/ nextcloud-data-`date +"%Y%m%d"`/

# dump the database
dbname=nextcloud
dbhost=localhost
dbuser=oc_admin
dbpassword=k6wvf+vqhqlwT9zXS9oLXA0X+l9Imm
mysqldump --single-transaction -u $dbuser -p$dbpassword $dbname > nextcloud-db-`date +"%Y%m%d"`.sql

# put nextcloud back to normal mode
sudo -u www-data php occ maintenance:mode --off
