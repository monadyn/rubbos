
#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh




ssh $TOMCAT1_HOST  ps -ef | grep tomcat 

lynx $TOMCAT1_HOST:8080/rubbos
