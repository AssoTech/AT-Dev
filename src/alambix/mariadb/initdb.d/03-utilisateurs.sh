#! /bin/bash
################################################################################
# Script de configuration des utilisateurs de MariaDB
#
#													 		FS 13-11-2018, 15:54
################################################################################

dbRootPass=`cat /run/secrets/dbRootPass.txt`
uMariadbPass=`cat /run/secrets/uMariadbPass.txt`
uPhpmyadminPass=`cat /run/secrets/uPhpmyadminPass.txt`

mysql --user=root \
      --password="$dbRootPass" \
      --execute="GRANT ALL PRIVILEGES ON *.* TO 'mariadb'@'localhost' IDENTIFIED BY '"$uMariadbPass"' WITH GRANT OPTION;
                 GRANT ALL PRIVILEGES ON *.* TO 'mariadb'@'172.20.0.22' IDENTIFIED BY '"$uMariadbPass"' WITH GRANT OPTION;
                 GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'phpmyadmin'@'172.20.0.22' IDENTIFIED BY '"$uPhpmyadminPass"' WITH GRANT OPTION;"