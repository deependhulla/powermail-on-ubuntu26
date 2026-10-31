#!/bin/bash

DEBIAN_FRONTEND=noninteractive

## if installed stop it -- normally not there
systemctl stop  mariadb 1>/dev/null 2>/dev/null


DEBIAN_FRONTEND=noninteractive
echo "mariadb-server	mariadb-server/feedback_optin	boolean	false" | debconf-set-selections

apt-get -y install mariadb-server mariadb-client mariadb-backup dbconfig-common
echo "---------------------------------------------------------------------";
 dpkg -l | grep mariadb
echo "---------------------------------------------------------------------";


systemctl stop  mariadb 1>/dev/null 2>/dev/null
/bin/cp -pRv files/powermail-rootdir/etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/ 
sed -i "s/LimitNOFILE=32768/LimitNOFILE=62768/"   /usr/lib/systemd/system/mariadb.service
systemctl daemon-reload
systemctl start mariadb

MYSQLPASSVPOP=`pwgen -c -1 12`
echo $MYSQLPASSVPOP > /usr/local/src/mariadb-mydbadmin-pass
echo "mydbadmin password in /usr/local/src/mariadb-mydbadmin-pass"

echo "GRANT ALL PRIVILEGES ON *.* TO mydbadmin@localhost IDENTIFIED BY '$MYSQLPASSVPOP'" with grant option | mariadb -uroot
mariadb-admin -uroot reload
mariadb-admin -uroot refresh

systemctl restart  mariadb

#mysqladmin -u root -ptmppassword status
#mysqladmin -u root -p extended-status
#mysqladmin -u root -p processlist

echo "Database Password Setup done."


