 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "  STARTING APACHE on $HOSTNAME"

$HTTPD_HOME/bin/apachectl -f $HTTPD_HOME/conf/httpd.conf -k start

echo "  APACHE IS RUNNING on $HOSTNAME"
 
