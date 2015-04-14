#!/bin/sh
if [ -z $1 ]
then
 echo "Usage: gen_apache_config.sh {domain}"
 exit
fi

DOMAIN=$1
SITE=`echo $DOMAIN | sed 's/\.com//g'`

echo ""

echo "############### Creating Apache Config ###############"
sleep 3
echo '<VirtualHost *:80>' >> /etc/httpd/conf.d/$SITE.conf
echo -e "\tServerName $DOMAIN" >> /etc/httpd/conf.d/$SITE.conf
echo -e "\tServerAlias *.$DOMAIN" >> /etc/httpd/conf.d/$SITE.conf
echo -e "\tDocumentRoot /var/www/html/$DOMAIN" >> /etc/httpd/conf.d/$SITE.conf
echo -e "\tServerAdmin admin@$DOMAIN" >> /etc/httpd/conf.d/$SITE.conf
echo -e "\tErrorLog /var/log/httpd/$DOMAIN/error.log" >> /etc/httpd/conf.d/$SITE.conf
echo -e "\tCustomLog /var/log/httpd/$DOMAIN/requests.log common" >> /etc/httpd/conf.d/$SITE.conf
echo '</VirtualHost>' >> /etc/httpd/conf.d/$SITE.conf

#echo "############### Restarting Apache ###############"
#sleep 3
#/usr/sbin/apachectl graceful

echo "############### Apache Config Generated for $DOMAIN ###############"
echo
