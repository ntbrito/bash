bash
====

Simple bash scripts.


== Mysql backups ==

It's a simple script that can be used to backup different mysql servers from a centralized point.
The different suffixes on the client entries in the file .my.cnf can be used to connect to different machines by passing the arg --defaults-group-suffix=<suffix> to the command "mysqldump".

== EC2 Find ==

Script to find hosts on EC2. The script queries que EC2 list of instances and returns the matching ones.
Need to setup Amazon EC2 tools and access.
