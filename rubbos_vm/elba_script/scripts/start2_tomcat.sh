
#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh



ssh $TOMCAT1_HOST  /tmp/TOMCAT1_ignition.sh 

