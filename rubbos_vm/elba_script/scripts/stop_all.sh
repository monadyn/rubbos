
#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh


ssh $HTTPD_HOST  /tmp/HTTPD_stop.sh 


ssh $TOMCAT1_HOST  /tmp/TOMCAT1_stop.sh 


ssh $MYSQL1_HOST  /tmp/MYSQL1_stop.sh 

