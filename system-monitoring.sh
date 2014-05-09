#!/bin/bash

day=`date +%Y-%m-%d" "%H:%M`
ts=`date +%d%H%M`

## Output (log) files
perform_log="performance_${ts}.log"
ps_log="ps_${ts}.log"
netstat_log="netstat_${ts}.log"
disk_log="disk_${ts}.log"

## Read configuration file
. ./monitoring.conf

## Who am I
if [[ $(id -u) -ne 0 ]]
then
   echo -e "== Run me as root == \n"
   echo -e "The output of some commands is not the expected if \
this script is executed by a user with UID different than 0 \n"

exit 1
fi

## Clean up old logs
## Read the conf file for more info about this
## GNU date specific, this may not work with other bash implementations of "date"
pasthour=`date +%d%H -d "-$(( $n + 1 )) hours"`
rm -rf *_${pasthour}*.log

## Functions definition ##

## Performance metrics
function mytop {
   echo "== Top 20 cpu consuming processes $day ==" >> $perform_log 
   top -b -n 1 | tail -n +6 | head -20 >> $perform_log
   echo -e "=== \n" >> $perform_log

   echo "== Proc Queue length ==" >> $perform_log
   uptime >> $perform_log
   echo -e "=== \n" >> $perform_log

   echo "== Memory statistics ==" >> $perform_log
   vmstat 1 6 >> $perform_log
   echo -e "=== \n" >> $perform_log
}

## List of processess
function myps {
   echo "== List of processess $day ==" >> $ps_log

   if [ ! $THREADS ]
   then
      ps axjf >> $ps_log
   fi

   if [ $THREADS ]
   then
      ps -efL >> $ps_log
   fi
}

## List of connections
function myservices {
   echo "== List of services/ports $day ==" >> $netstat_log
   netstat -nputal >> $netstat_log
}

## Disk I/O and statistics
function myiotop {
   echo "== Disk usage $day ==" >> $disk_log
   iostat -d >> $disk_log
   echo -e "=== \n" >> $disk_log

   echo "== Disk i/o ==" >> $disk_log
   iotop -b -n 1 >> $disk_log
   echo -e "=== \n" >> $disk_log
}

## End of Functions definition ##

## Collect stats ##

if [ $RUNPERFORM ]
then
   mytop
fi

if [ $RUNPROC ]
then
   myps
fi

if [ $RUNSERVICES ]
then
   myservices
fi

if [ $RUNDISKIO ]
then
   myiotop
fi
