#!/bin/sh
if [ -z $1 ]
then
 echo "Usage: add_domain.sh {domain}"
 exit
fi

DOMAIN=$1
LC=${DOMAIN,,}

# see if domain exists
if grep -q "$LC" /root/domains/domain_list
then
	echo -e "\e[1;31mDomain exists.\e[0m"
	exit
else
	continue
fi

# only check whois if it's a .com
if [[ $LC == *.com ]]
then
	EXP=`whois $LC | grep -i expir | sed 's/.*Date: //g' | colrm 11`
	ENTRY=`echo -e "$LC \t $EXP"`
	echo $ENTRY > /tmp/domain_list
else
	ENTRY=`echo -e "$LC"`
	echo $ENTRY > /tmp/domain_list
fi

grep ^[a-z] /root/domains/domain_list | grep -v "miscellaneous" >> /tmp/domain_list
sort /tmp/domain_list | uniq | column -t > /tmp/domain_list2
grep ".com" /tmp/domain_list2 > /tmp/domain_list_com
grep ".net" /tmp/domain_list2 > /tmp/domain_list_net
grep ".org" /tmp/domain_list2 > /tmp/domain_list_org
egrep -v '.com|.net|.org' /tmp/domain_list2 > /tmp/domain_list_misc

echo ".com" > /root/domains/domain_list
echo "------------------------------" >> /root/domains/domain_list
cat /tmp/domain_list_com >> /root/domains/domain_list
echo "" >> /root/domains/domain_list

echo ".net" >> /root/domains/domain_list
echo "------------------------------" >> /root/domains/domain_list
cat /tmp/domain_list_net >> /root/domains/domain_list
echo "" >> /root/domains/domain_list

echo ".org" >> /root/domains/domain_list
echo "------------------------------" >> /root/domains/domain_list
cat /tmp/domain_list_org >> /root/domains/domain_list
echo "" >> /root/domains/domain_list

echo "miscellaneous" >> /root/domains/domain_list
echo "------------------------------" >> /root/domains/domain_list
cat /tmp/domain_list_misc >> /root/domains/domain_list
echo "" >> /root/domains/domain_list

rm -rf /tmp/domain_list*
echo -e "\e[1;32mDomain added.\e[0m"


