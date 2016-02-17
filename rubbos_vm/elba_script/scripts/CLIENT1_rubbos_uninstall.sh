 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

cd $SYSSTAT_HOME
sudo make uninstall
sudo rm -rf $SYSSTAT_HOME
rm -rf $RUBBOS_HOME
rm -rf $ELBA_TOP

 
