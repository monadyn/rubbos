
#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh




ssh $MYSQL1_HOST  ps -ef | grep mysql


#mysql -uelba  -pelba -hhshan-mysql -P3313
