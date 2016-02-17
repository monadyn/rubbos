 


#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "  STOPPING TOMCAT on $HOSTNAME"

cd $CATALINA_HOME/bin
./shutdown.sh

echo "  TOMCAT IS STOPPED on $HOSTNAME"

 
