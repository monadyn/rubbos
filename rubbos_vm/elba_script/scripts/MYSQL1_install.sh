 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh


echo "  INSTALLING MYSQL on $HOSTNAME"

mkdir -p $ELBA_TOP
chmod 755 $ELBA_TOP
mkdir -p $RUBBOS_TOP
chmod 755 $RUBBOS_TOP


tar xzf $SOFTWARE_HOME/$MYSQL_TARBALL_RT --directory=$RUBBOS_TOP 

  
cd $MYSQL_HOME 
scripts/mysql_install_db --no-defaults --basedir=$MYSQL_HOME --port=$MYSQL_PORT --datadir=$MYSQL_DATA_DIR --log=$MYSQL_ERR_LOG --pid-file=$MYSQL_PID_FILE --socket=$MYSQL_SOCKET

echo "  DONE INSTALLING MYSQL on $HOSTNAME"


 
