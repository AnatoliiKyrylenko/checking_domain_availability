#!/bin/bash

DOMAIN_LIST=`cat domain.txt`
#trap 'rm -f $TOKEN' 0 1 2 5 15 
TOKEN=`mktemp 2>/dev/null`
ZONE="com net com.ua"

for domain in $DOMAIN_LIST 
do
  for ZON in $ZONE
  do
#  echo -n "$domain : "
  whois $domain.$ZON | egrep -i "(NO.*FOUND|NO.*match)" 
    if [[ $? -ne 0 ]]; then
      echo $domain.$ZON >> $TOKEN
    fi
 done
done
NEW_DOMAIN=`diff --changed-group-format='%>' --unchanged-group-format='' registered.txt $TOKEN`
if [[ $NEW_DOMAIN != "" ]]
        then
        echo $NEW_DOMAIN | mail -s "New Domain" admin@domain.com
        cat $TOKEN > registered.txt
        else
        echo "No new domains" | mail -s "No New Domains" admin@domain.com
fi
