bash
====

Simple bash scripts.
As everything in life, these scripts can be lagerly improved. Everybody is allowed to use and modify them as most convinient. I am not responsible for any arm caused by the scripts.
This is always work in progress.

== Mysql backups ==

It's a simple script that can be used to backup different mysql servers from a centralized point.
The different suffixes on the client entries in the file .my.cnf can be used to connect to different machines by passing the arg --defaults-group-suffix=<suffix> to the command "mysqldump".

== EC2 Find ==

Script to find hosts on EC2. The script queries que EC2 list of instances and returns the matching ones.
Need to setup Amazon EC2 tools and access.

== System monitoring ==

Keeps trace of processes or services provided by a server. Use this script in conjunction with a cron entry to execute the script on a scheduled basis.
