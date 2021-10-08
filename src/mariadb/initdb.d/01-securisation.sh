#! /bin/bash
################################################################################
# Script de sécurisation de l'installation MariaDB
#
#													 		FS 13-11-2018, 15:54
################################################################################

dbRootPass=`cat /run/secrets/dbRootPass.txt`

mysql --user=root \
      --password="$dbRootPass" \
      --database='mysql' \
      --execute="DELETE FROM user WHERE User='';
                 DELETE FROM db WHERE Db='test' OR Db='test\\_%';"
mysql --user=root \
      --password="$dbRootPass" \
      --execute="DROP DATABASE IF EXISTS test;"
