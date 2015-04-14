#!/bin/sh
if [ -z $1 ]
then 
 echo "Usage: wordpress_backup.sh {domain}"
 exit
fi

DOMAIN=$1

echo ""

echo "############### Backing Up $DOMAIN ###############"

backupfilename=zacfm_backup_`date '+%Y-%m-%d'`
tar cfP /backup/$DOMAIN/website/${backupfilename}.tar /var/www/html/$DOMAIN/wp-content
gzip /backup/$DOMAIN/website/${backupfilename}.tar

/usr/bin/mysqldump -h 'localhost' -u 'zacfm' -p'May111986!' 'zacfm'  | gzip > /backup/$DOMAIN/database/${backupfilename}.sql.gz

echo "############### Backup Completed ###############"
