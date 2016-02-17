
#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

 

ssh $MYSQL1_HOST  /tmp/MYSQL1_reset.sh  &
 


sleep 120

