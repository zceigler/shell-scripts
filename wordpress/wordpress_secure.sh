#!/bin/sh
if [ -z $1 ]
then 
 echo "Usage: wordpress_secure.sh {domain}"
 exit
fi

DOMAIN=$1
SITE=`echo $DOMAIN | sed 's/\.com//g' | sed 's/\.org//g'`

echo ""

echo "############### Securing $DOMAIN ###############"
sleep 2

chmod -R 0755 /var/www/$DOMAIN/
chmod 0644 /var/www/$DOMAIN/.htaccess
chmod 0644 /var/www/$DOMAIN/wp-admin/index.php
chmod 0644 /var/www/$DOMAIN/wp-config.php

if [ -d "/var/www/$DOMAIN/wp-content/themes/pinboard/cache" ]; then
	chmod 0777 /var/www/$DOMAIN/wp-content/themes/pinboard/cache
fi

if [ -d "/var/www/$DOMAIN/wp-content/cache/timthumb" ]; then
        chmod 0777 /var/www/$DOMAIN/wp-content/cache/timthumb
fi

if [ -d "/var/www/$DOMAIN/wp-content/upready" ]; then
        chmod 0777 /var/www/$DOMAIN/wp-content/upready
fi

if [ -d "/var/www/$DOMAIN/wp-content/uploads" ]; then
        chmod -R 0777 /var/www/$DOMAIN/wp-content/uploads
fi

if [ -d "/var/www/$DOMAIN/wp-content/plugins/special-recent-posts-pro/cache" ]; then
        chmod -R 0777 /var/www/$DOMAIN/wp-content/plugins/special-recent-posts-pro/cache
fi

echo "############### Wordpress Secured ###############"
echo
