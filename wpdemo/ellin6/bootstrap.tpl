#!/bin/bash -xe
whoami
apt-get -y update
apt-get -y install unattended-upgrades
apt-get -y install nfs-common 
mkdir /efs
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${efsid}.efs.us-east-1.amazonaws.com:/ /efs
curl 'https://bootstrap.pypa.io/get-pip.py' -o 'get-pip.py'
python get-pip.py
pip install awscli
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo 'deb https://apt.dockerproject.org/repo ubuntu-trusty main' > /etc/apt/sources.list.d/docker.list
apt-get -y update
apt-get -y install docker-engine
apt-get -y install fail2ban
pip install docker-compose
docker run -d -e WORDPRESS_DB_HOST=${dbhost}:3306 -e WORDPRESS_DB_PASSWORD=wpdbwpdb -e WORDPRESS_DB_USER=wpdb -e WORDPRESS_DB_NAME=wpdb  -v /efs/wordpress:/var/www/html -p 80:80 wordpress:latest

while [ ! -f /efs/wordpress/.htaccess ]
do
  sleep 2
done
grep "RewriteCond %{HTTP:X_CDN}" /efs/wordpress/.htaccess || echo $'<IfModule mod_rewrite.c>\nRewriteCond %{HTTP:X_CDN} !=AMAZON\nRewriteRule ^wp-content/uploads/(.*)$ http://${cloudfront}/wp-content/uploads/$1 [r=301,nc]\n</IfModule>' >> /efs/wordpress/.htaccess
