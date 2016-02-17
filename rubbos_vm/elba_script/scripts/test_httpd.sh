
#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh




ssh $HTTPD_HOST  ps -ef | grep httpd 

 echo lynx $HTTPD_HOST:8000
 lynx $HTTPD_HOST:8000/rubbos

