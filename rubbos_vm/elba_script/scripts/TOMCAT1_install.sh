 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "  INSTALLING TOMCAT on $HOSTNAME"

mkdir -p $ELBA_TOP
chmod 755 $ELBA_TOP
mkdir -p $RUBBOS_TOP
chmod 755 $RUBBOS_TOP

tar xzf $SOFTWARE_HOME/$TOMCAT_TARBALL --directory=$RUBBOS_TOP
tar xzf $SOFTWARE_HOME/$JAVA_TARBALL   --directory=$RUBBOS_TOP
tar xzf $SOFTWARE_HOME/$J2EE_TARBALL   --directory=$RUBBOS_TOP
tar xzf $SOFTWARE_HOME/$ANT_TARBALL    --directory=$RUBBOS_TOP

echo "  DONE INSTALLING TOMCAT on $HOSTNAME"

 
