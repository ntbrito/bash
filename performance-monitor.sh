

### WORK IN PROGRESS ###

#!/bin/bash

day=`date +%Y-%m-%d`
ts=`date +%d%H%M`
perform_log="performance_${ts}.log"
ps_log="ps_${ts}.log"

## Read configuration file
. ./monitoring.conf

## Functions definition ##

## Performance metrics
function mytop {
   echo "== Top 20 cpu consuming processes ==" >> $perform_log 
   top -b -n 1 | tail -n +6 | head -20 >> $perform_log
   echo -e "=== \n" >> $perform_log

   echo "== vmstat command output ==" >> $perform_log
   vmstat 1 6 >> $perform_log
   echo -e "=== \n" >> $perform_log

   echo "== Disk usage ==" >> $perform_log
   iostat -d >> $perform_log
   echo -e "=== \n" >> $perform_log
}

## List of processess
function myps {
   echo "== List of processess ==" >> $ps_log

   if [ ! $THREADS ]
   then
      ps axjf >> $ps_log
   fi

   if [ $THREADS ]
   then
      ps -efL >> $ps_log
   fi
}

## End of Functions definition ##

mytop
myps
