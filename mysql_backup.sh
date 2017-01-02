#!/bin/bash

for db in $(echo "show databases;" | mysql -h localhost)
  do
    if [ "$db" != "Database" ] && [ "$db" != "information_schema" ]  && [ "$db" != "performance_schema" ] ; then
      mysqldump -h localhost $db > /root/$db-$(date +%d-%m).sql
    fi
  done

