 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "  INSTALLING RUBBOS CLIENT on $HOSTNAME"

tar xzf $SOFTWARE_HOME/$JAVA_TARBALL --directory=$RUBBOS_TOP

echo "  DONE INSTALLING RUBBOS CLIENT on $HOSTNAME"

 
