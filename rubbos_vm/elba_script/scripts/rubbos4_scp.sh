 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh



eco "Processing the results..."
ssh $BENCHMARK_HOST "
  cd $TMP_RESULTS_DIR_BASE
  cd $RUBBOS_RESULTS_DIR_NAME
#  scp $RUBBOS_RESULTS_HOST:$RUBBOS_RESULTS_DIR_BASE/calc-sarSummary.prl ../
  cp /sshfsmount/elba_script/set_elba_env.sh ./

#  ../calc-sarSummary.prl

#  scp $RUBBOS_RESULTS_HOST:$RUBBOS_RESULTS_DIR_BASE/calc-durationTime.prl ../

#  ../calc-durationTime.prl

#  rm -f 20*/*.bin

  cd ../
  tar zcvf $RUBBOS_RESULTS_DIR_NAME.tgz $RUBBOS_RESULTS_DIR_NAME
#  scp $RUBBOS_RESULTS_DIR_NAME.tgz $RUBBOS_RESULTS_HOST:$RUBBOS_RESULTS_DIR_BASE/
"

echo "Finish Experiment RUBBoS"

scp $BENCHMARK_HOST:$TMP_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME.tgz $RUBBOS_RESULTS_DIR_BASE/
echo scp $BENCHMARK_HOST:$TMP_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME.tgz $RUBBOS_RESULTS_DIR_BASE


#ssh $BONN_HOST "
  #cd $BONN_RUBBOS_RESULTS_DIR_BASE
  cd $RUBBOS_RESULTS_DIR_BASE
  tar -xzvf $RUBBOS_RESULTS_DIR_NAME.tgz
  cd $RUBBOS_RESULTS_DIR_NAME
  cp $BONN_SCRIPTS_BASE/generateResult.sh ./
  cp $BONN_SCRIPTS_BASE/transferScripts.sh ./
  cp $BONN_SCRIPTS_BASE/data*.py ./


exit 0
  ./generateResult.sh
  sleep 2
  ./transferScripts.sh
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

















 
