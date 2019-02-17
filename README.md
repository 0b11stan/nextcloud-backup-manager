GIT : git@github.com:TristanPinaudeau/nextcloud-backup-manager.git

Situation Initiale :
- Un serveur sur lequel tourne un nextcloud
- Un serveur de backup vierge
- Connecté l'un à l'autre et à internet
- Dispose d'un compte sudoer sur les deux systèmes
- accès ssh aux deux machines

Demande :
- Sauvegarde du nextcloud
- Historisation des sauvegardes avec rétention de 30j
- Sauvegarde automatique
- Sauvegarde aussi fréquente que possible
- Potentiellement de gros volumes

Lab :
- Lancer le lab avec `sudo ./start_lab.sh`
- Stoper le lab avec `sudo ./stop_lab.sh`
- Identifiants nextcloud :
  * login : admin
  * password : P@ssw0rd
- config nextcloud :
  * 1 pv = 1 vg = 100G
  * 1 lv = 10G --> /
  * 1 lv = 80G --> /var
  * package : lvm, apache2, php, mysql-server
- config next_backup :
  * 1 pv = 1 vg = 200G
  * 1 lv = 10G  --> /
  * 1 lv = 150G --> /data
  * package : lvm, zfs

Doc :
- nextcloud : https://docs.nextcloud.com/servers/stable/admin_manual/contents.html
- backup : https://docs.nextcloud.com/server/stable/admin_manual/maintenance/backup.html
- restore : https://docs.nextcloud.com/server/stable/admin_manual/maintenance/restore.html

Plan de bataille :
- [x] Monter Réseau (0,5h) => il faut réaliser un dhclient pour avoir une ip
- [x] Faire snap des machines (15m)
- [x] Réaliser Backup recommandé (1,5h)
- [x] Réaliser script de setup (1h)
- [x] Réaliser la connexion ssh entre machine (2h)
- [x] Ajouter l'hote nextcloud dans les known hosts de l'hote backup
- [x] S'assurer de la variabilisation de l'hote (ip) (1h)
- [x] Faire fonctionner backup en cron (ip) (2h)
- [ ] Tester cron
- [ ] Ameliorer avec snap (2h)
- [ ] Ameliorer avec log mariadb (2h)
- [ ] Finaliser automation (1,5h)
- [ ] Rédiger doc utilisateur (1h)
- [ ] Clean recette pour check mode et idimpotence
