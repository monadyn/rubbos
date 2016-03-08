 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh



#ssh $BONN_HOST "
 
  cd $BONN_RUBBOS_RESULTS_DIR_BASE
 
  cd $RUBBOS_RESULTS_DIR_NAME
  cp $BONN_SCRIPTS_BASE/hshan_debug.sh ./
  cp $BONN_SCRIPTS_BASE/generateResult1.sh ./

echo ./generateResult.sh


#  ./transferScripts.sh
#"
echo "Finish processing RUBBoS Result in Bonn"
 

cp $BONN_SCRIPTS_BASE/gen_graph_*.sh ./
cp $BONN_SCRIPTS_BASE/gen_*.sh ./

cp $BONN_SCRIPTS_BASE/Pre_*.py ./
 
chmod 777 $SYSVIZ_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/*.sh
chmod 777 $SYSVIZ_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/*.py


echo "Finish Experiment RUBBoS"
./gen_graph_main.sh
./hshan_debug.sh

#chmod 777 $SYSVIZ_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/*.sh
#cd $SYSVIZ_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME
#./resultAnalysis.sh
#"

echo "Finish RUBBoS"


















 
