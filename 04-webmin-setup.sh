#!/bin/bash

curl -o /opt/webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
bash /opt/webmin-setup-repo.sh -f

apt-get update
apt-get -y -qq install webmin



## change port from 10000 to 8383
sed -i "s/10000/8383/g" /etc/webmin/miniserv.conf
/etc/init.d/webmin restart 2>/dev/null

echo "Webmin run https on port 8383 use Firefox Browser to Access not Google Chrome as SSL Certifcate is not applied yet"; 
