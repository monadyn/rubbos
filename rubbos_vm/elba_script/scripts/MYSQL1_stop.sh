 


#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh


echo "  STOPPING MYSQL on $HOSTNAME"

cd $MYSQL_HOME
bin/mysqladmin --socket=$MYSQL_SOCKET  --user=root --password=$ROOT_PASSWORD shutdown

echo "  MYSQL IS STOPPED on $HOSTNAME"

 
