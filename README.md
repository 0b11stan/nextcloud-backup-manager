# Nextcloud Backup Manager

## User Documentation

Installing *nextcloud backup manager* is crazy simple.
Simply use the nbm script in this repository.

**Short install example :**
```
./nbm.sh --install -u tristan -n nextcloud.lab -b backup.lab
```

**Short restore example :**
```
./nbm.sh --restore -u tristan -b backup.lab
```

**For the long version :**

The first argument of the nbm script specify the main action you want to performe.
For installing and seting up a new backup server for nextcloud, specify the `--install` argument.
For restoring a version, specify the `--restore` argument.

All allowed arguments :
* `-u` : a user account with sudoers rights present on both servers
* `-n` : a hostname or ip address of the nextcloud server
* `-b` : a hostname or ip address of the backup server

During an installation, the `-n`, `-u` and `-b` arguments are required.
A configuration file will be opened during the process with default variables.
You can configure thoses variables to your needs.
**! Beware ! the nextcloud's hostname (or ip address) in the config file is needed to join the nextcloud host from the backup host it may not be the same as the one in your command line.**

During a restoration you should not specify the `-n` arguments.

## Description

Tech stack :
- rsync
- zfs
- crontab
- ansible
- bash

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
- backup    : https://docs.nextcloud.com/server/stable/admin_manual/maintenance/backup.html
- restore   : https://docs.nextcloud.com/server/stable/admin_manual/maintenance/restore.html

Roadmap :
- [x] Monter Réseau (0,5h) => il faut réaliser un dhclient pour avoir une ip
- [x] Faire snap des machines (15m)
- [x] Réaliser Backup recommandé (1,5h)
- [x] Réaliser script de setup (1h)
- [x] Réaliser la connexion ssh entre machine (2h)
- [x] Ajouter l'hote nextcloud dans les known hosts de l'hote backup
- [x] S'assurer de la variabilisation de l'hote (ip) (1h)
- [x] Faire fonctionner backup en cron (ip) (2h)
- [x] Tester cron
- [x] Ajout réstoration
- [x] Ameliorer avec snap (2h)
- [ ] Ameliorer avec log mariadb (2h)
- [x] Finaliser automation (1,5h)
- [ ] Rédiger doc utilisateur (1h)
- [ ] Clean recette pour check mode et idimpotence
