
#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh


ssh $MYSQL1_HOST  /tmp/MYSQL1_ignition.sh  &
sleep 10

ssh $TOMCAT1_HOST  /tmp/TOMCAT1_ignition.sh 
sleep 10

ssh $HTTPD_HOST  /tmp/HTTPD_ignition.sh 
sleep 5
