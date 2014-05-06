#!/bin/bash

keyword=$1
hostname=$2
PROGNAME=`basename $0`

function find_name {
   clear
   printf " Searching for Host_Name(s) that match ${hostname}... \n"
   for name in `ec2-describe-instances --filter tag:Name=*${hostname}* | grep Name | awk '{ print $5 }'`
   do
      echo -e "-- ${name}"
   done
   echo -e "\n"
}

function find_ip {
   clear
   (printf "Host_Name(s) Public_IP Private_IP \n"; \
   ec2-describe-instances --filter tag:Name=*${hostname}* | grep -E "^NICASSOCIATION|Name" | sed '$!N;s/\n/ /' | awk '{ print $9, $2, $4 }') | column -t
   echo -e "\n"
}

function usage {
   printf "Usage: \n \
   $PROGNAME <keyword> <host> \n \
   <keyword> is a key word for the search (e.g ip, name) \n \
   <host> is a string identifying the host name \n"

   exit
}

function main() {
   case $1 in
      'name') 
         find_name
         ;;
      'ip')
         find_ip
         ;;
      *)
         usage
         ;;
   esac
}

if [ $# -ne 2 ]
then
   usage
else
   main $keyword $hostname
fi
