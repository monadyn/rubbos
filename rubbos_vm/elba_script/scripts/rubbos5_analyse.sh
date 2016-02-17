 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh




#ssh $BONN_HOST "
  #cd $BONN_RUBBOS_RESULTS_DIR_BASE
  cd $RUBBOS_RESULTS_DIR_BASE
  cd $RUBBOS_RESULTS_DIR_NAME
  cp $BONN_SCRIPTS_BASE/generateResult.sh ./
  cp $BONN_SCRIPTS_BASE/transferScripts.sh ./


  ./generateResult.sh
  sleep 2
#  ./transferScripts.sh
#"
echo "Finish processing RUBBoS Result in Bonn"

exit 0

sleep 10
echo "start processing RUBBoS experimental SysViz result"
ssh $SYSVIZ_HOST "
chmod 777 $SYSVIZ_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/*.sh
cd $SYSVIZ_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME
./resultAnalysis.sh
"

echo "Finish RUBBoS"

















 
