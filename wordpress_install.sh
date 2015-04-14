#!/bin/sh
if [ -z $1 ]
then 
 echo "Usage: wordpress_install.sh {domain}"
 exit
fi

DOMAIN=$1
SITE=`echo $DOMAIN | sed 's/\.com//g' | sed 's/\.fm/fm/g'`

echo ""

echo "############### Setting Up Domain ###############"
sleep 3
useradd -d /var/www/$DOMAIN -G apache $SITE
#mkdir /var/www/$DOMAIN
mkdir /var/log/httpd/$DOMAIN
mkdir /backups/$DOMAIN
mkdir /backups/$DOMAIN/website
mkdir /backups/$DOMAIN/database
echo -e "198.58.117.41\t$DOMAIN >> /etc/hosts"

echo "############### Creating Apache Config ###############"
sleep 3
echo '<VirtualHost *:80>' >> /etc/httpd/conf.d/$SITE.conf
echo -e "\tServerName $DOMAIN" >> /etc/httpd/conf.d/$SITE.conf
echo -e "\tServerAlias *.$DOMAIN" >> /etc/httpd/conf.d/$SITE.conf
echo -e "\tDocumentRoot /var/www/$DOMAIN" >> /etc/httpd/conf.d/$SITE.conf
echo -e "\tServerAdmin admin@$DOMAIN" >> /etc/httpd/conf.d/$SITE.conf
echo -e "\tErrorLog /var/log/httpd/$DOMAIN/error.log" >> /etc/httpd/conf.d/$SITE.conf
echo -e "\tCustomLog /var/log/httpd/$DOMAIN/requests.log common" >> /etc/httpd/conf.d/$SITE.conf
echo '</VirtualHost>' >> /etc/httpd/conf.d/$SITE.conf

echo "############### Restarting Apache ###############"
sleep 3
/usr/sbin/apachectl graceful

echo "############### Creating Database ###############"
sleep 3
DBNAME=`echo $DOMAIN | sed 's/\.com//g' | sed 's/\.fm/fm/g' | sed 's/$/db/g'`
DBUSER=`echo $DOMAIN | sed 's/\.com//g' | sed 's/\.fm/fm/g' | sed 's/$/db/g'`
DBPASS="May111986!"
DBHOST="localhost"
QUERY1="CREATE DATABASE $DBNAME;"
QUERY2="CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS';"
QUERY3="GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost';"
QUERY4="FLUSH PRIVILEGES;"
FULLQUERY="$QUERY1$QUERY2$QUERY3$QUERY4"
mysql -uroot -p'e3049140!' -e "$FULLQUERY"

echo "############### Downloading Package ###############"
sleep 3
wget -q http://wordpress.org/latest.zip -P /var/www/$DOMAIN/

echo "############### Installing WordPress ###############"
sleep 3
unzip -q /var/www/$DOMAIN/latest.zip -d /var/www/$DOMAIN/
mv /var/www/$DOMAIN/wordpress/* /var/www/$DOMAIN/
rmdir /var/www/$DOMAIN/wordpress
rm /var/www/$DOMAIN/latest.zip
mkdir /var/www/$DOMAIN/wp-content/uploads
mkdir /var/www/$DOMAIN/wp-content/upgrade
cp /var/www/$DOMAIN/wp-config-sample.php /var/www/$DOMAIN/wp-config.php
sed -i "s/database_name_here/$DBNAME/g" /var/www/$DOMAIN/wp-config.php
sed -i "s/username_here/$DBUSER/g" /var/www/$DOMAIN/wp-config.php
sed -i "s/password_here/$DBPASS/g" /var/www/$DOMAIN/wp-config.php

echo "############### Setting Permissions ###############"
sleep 3
chown -R -f $SITE:apache /var/www/$DOMAIN
find /var/www/$DOMAIN -type d -exec chmod 755 {} \;
find /var/www/$DOMAIN -type f -exec chmod 644 {} \;
#chmod 440 /var/www/$DOMAIN/*.php # verified minimum OK with WP
#find /var/www/$DOMAIN/wp-admin -type f -exec chmod 640 {} \;
#find /var/www/$DOMAIN/wp-includes -type f -exec chmod 640 {} \;
#chmod 440 /var/www/$DOMAIN/.htaccess
#chmod 766 /var/www/$DOMAIN/sitemap.*
chown -R -f apache:apache /var/www/$DOMAIN/wp-content/uploads
#chmod 777 -R /var/www/$DOMAIN/wp-content/uploads
#find /var/www/$DOMAIN/wp-content/uploads -type f -exec chmod 660 {} \;
#chmod 770 -R /var/www/$DOMAIN/wp-content/upgrade
#chmod 750 -R /var/www/$DOMAIN/wp-content/plugins
#find /var/www/$DOMAIN -name 'index.php' -exec chmod 440 {} \;

echo "############### Installation Complete ###############"
echo
