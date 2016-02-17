 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "  STOPPING APACHE on $HOSTNAME"

$HTTPD_HOME/bin/apachectl -f $HTTPD_HOME/conf/httpd.conf -k stop

echo "  APACHE IS STOPPED on $HOSTNAME"

 
