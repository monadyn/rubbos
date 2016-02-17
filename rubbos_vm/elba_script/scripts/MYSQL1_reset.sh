 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh


echo "  RESETING MYSQL on $HOSTNAME"
# copy rubbos data files
tar xzf $SOFTWARE_HOME/$RUBBOS_DATA_TARBALL --directory=$MYSQL_HOME/data/rubbos

echo "  DONE RESETING MYSQL on $HOSTNAME"
sleep 5

 
