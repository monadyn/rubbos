 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "  STARTING TOMCAT on $HOSTNAME"

cd $CATALINA_HOME/bin
./startup.sh

echo "  TOMCAT IS RUNNING on $HOSTNAME"

 
