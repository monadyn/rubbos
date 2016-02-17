
#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh




ssh $HTTPD_HOST  /tmp/HTTPD_ignition.sh 
sleep 5
