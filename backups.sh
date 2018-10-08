#!/bin/bash

source /pgenv.sh

#echo "Running with these environment options" >> /var/log/cron.log
#set | grep PG >> /var/log/cron.log



MYBASEDIR=/backups

mkdir -p ${MYBASEDIR}
cd ${MYBASEDIR}

echo "Backup running to ${MYBASEDIR}" >> /var/log/cron.log

#
# Loop through each pg database backing it up
#

DBLIST=`psql -l | awk '{print $1}' | grep -v "+" | grep -v "Name" | grep -v "List" | grep -v "(" | grep -v "template" | grep -v "postgres" | grep -v "|" | grep -v ":"`
# echo "Databases to backup: ${DBLIST}" >> /var/log/cron.log

function backup_tables(){
    MULTIPLE_TABLES=osm_roads,osm_buildings
    for TABLE in $(echo ${MULTIPLE_TABLES} | tr ',' ' ');
    do
        echo ${TABLE} && pgsql2shp -f ${MYBASEDIR}/${TABLE}.shp -g "geometry" -p 5432  -h ${PGHOST} -p ${PGPORT} -P ${PGPASSWORD} -u ${PGUSER} ${DB} public.${TABLE};
    done
}


for DB in ${DBLIST}
do
  echo "Backing up $DB"  >> /var/log/cron.log
  backup_tables

done
