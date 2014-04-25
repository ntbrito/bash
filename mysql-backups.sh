#!/bin/bash

timestamp=`date +%Y%m%d`

## Define string to identify the mysql server to connect
## -- use the suffix on the client entry in the .my.cnf file
host=<hostname>

## Define databases to backup
DATABASES=( <db1> <db2> <db3> <...> )

working_dir="/home/backups"
log_dir="${working_dir}/log"
dumpdir="${working_dir}/mysqldumps/${host}"

## Test if exists / create the dumpdir
## just in case it was forgotten...
if [ ! -d ${dumpdir} ]
then
   mkdir -p ${dumpdir}
fi

## Clean up previous dumps
## I am just keeping the previous dump
## More can be kept by appending a timestamp
for database in "${DATABASES[@]}"
do
   if [ -f ${dumpdir}/${database}.sql.gz ]
   then
      mv -f ${dumpdir}/${database}.sql.gz ${dumpdir}/${database}_previous.sql.gz
   fi
done

## Do the dumps and compress the file
for database in "${DATABASES[@]}"
do
   echo "==== `date` ====" >> ${log_dir}/${database}.log
   echo "`date +%H:%M` - Starting backup of $database" >> ${log_dir}/${database}.log

   mysqldump --defaults-group-suffix=$host $database > ${dumpdir}/${database}.sql

   if [ $? -eq 0 ]
   then
      if [[ $(cat ${dumpdir}/${database}.sql | tail -1) =~ "Dump completed" ]]
      then
         gzip ${dumpdir}/${database}.sql
         echo "`date +%H:%M` - Finished backup of $database" >> ${log_dir}/${database}.log
         echo -e "\n" >> ${log_dir}/${database}.log
      fi
   else
      echo "`date +%H:%M` - Backup of $database was not successful" >> ${log_dir}/${database}.log
      echo -e "\n" >> ${log_dir}/${database}.log

      echo "Backup for ${database} failed" | mail -s "Failed backup for ${database}" my-email@gmail.com
   fi
done
