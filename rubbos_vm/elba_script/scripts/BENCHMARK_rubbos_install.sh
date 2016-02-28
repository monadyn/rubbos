 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "  INSTALLING RUBBOS/SYSSTAT on $HOSTNAME"

mkdir -p $RUBBOS_TOP

# install RUBBoS
tar xzf $SOFTWARE_HOME/$RUBBOS_TARBALL --directory=$RUBBOS_TOP
#tar xzf $SOFTWARE_HOME/rubbos_html.tar.gz --directory=$RUBBOS_HOME/Servlet_HTML/
cp $SOFTWARE_HOME/flush_cache $RUBBOS_HOME/bench/.

# install sysstat
#tar xzf $SOFTWARE_HOME/$SYSSTAT_TARBALL --directory=$RUBBOS_TOP
#cp $OUTPUT_HOME/sysstat_conf/CONFIG $SYSSTAT_HOME/build/
#cd $SYSSTAT_HOME
#./configure
#make
#sudo make install

# install a script to collect statistics data
cp $OUTPUT_HOME/rubbos_conf/cpu_mem.sh $RUBBOS_TOP/.
chmod 755 $RUBBOS_TOP/cpu_mem.sh

echo "  DONE INSTALLING RUBBOS/SYSSTAT on $HOSTNAME"


 
