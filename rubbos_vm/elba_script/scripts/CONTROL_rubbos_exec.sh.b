 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "Starting RUBBoS"

ssh $RUBBOS_RESULTS_HOST "
  mkdir -p $RUBBOS_RESULTS_DIR_BASE
"
ssh $BENCHMARK_HOST "
  mkdir -p $TMP_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME
  rm -rf $TMP_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/*
"
#ssh $SYSVIZ_HOST "
#  sudo rm -rf /cap/capssd/*
#"

for i in "rubbos.properties_1000" "rubbos.properties_1600" "rubbos.properties_1800" "rubbos.properties_2000" "rubbos.properties_2200" "rubbos.properties_2400" "rubbos.properties_2600" "rubbos.properties_2800" "rubbos.properties_3000" "rubbos.properties_4000" "rubbos.properties_5000"
do

  ssh $BENCHMARK_HOST "
    source /sshfsmount/elba_script/set_elba_env.sh
    rm -f $RUBBOS_HOME/Client/rubbos.properties
  "
  scp $OUTPUT_HOME/rubbos_conf/$i $BENCHMARK_HOST:$RUBBOS_HOME/Client/rubbos.properties

  # echo "Resetting all data"
  # $OUTPUT_HOME/scripts/reset_all.sh

  # Browsing Only
  echo "Start Browsing Only with $i"
  echo "Removing previous logs..."
  ssh $HTTPD_HOST "rm -f $HTTPD_HOME/logs/*log"
   ssh $HTTPD_HOST "rm -f /iostat-*"
  ssh $TOMCAT1_HOST "rm -f $CATALINA_HOME/logs/*"
   ssh $TOMCAT1_HOST "rm -f /iostat-*"
  ssh $MYSQL1_HOST "rm -f $MYSQL_HOME/run/*.log $RUBBOS_TOP/mysql_mon-*"
   ssh $MYSQL1_HOST "rm -f /iostat-*"

exit 0
  $OUTPUT_HOME/scripts/start_all.sh
  sleep 15
  ssh $BENCHMARK_HOST "rm -f $RUBBOS_TOP/sar-* $RUBBOS_TOP/ps-* $RUBBOS_TOP/iostat-* /tmp/*html"
  ssh $CLIENT1_HOST "rm -f $RUBBOS_TOP/sar-* $RUBBOS_TOP/ps-* $RUBBOS_TOP/iostat-* /tmp/*html"
  ssh $HTTPD_HOST "rm -f $RUBBOS_TOP/sar-* $RUBBOS_TOP/ps-* $RUBBOS_TOP/iostat-* /tmp/*html"
  ssh $TOMCAT1_HOST "rm -f $RUBBOS_TOP/sar-* $RUBBOS_TOP/ps-* $RUBBOS_TOP/iostat-* /tmp/*html"
  ssh $MYSQL1_HOST "rm -f $RUBBOS_TOP/sar-* $RUBBOS_TOP/ps-* $RUBBOS_TOP/iostat-* /tmp/*html"


  ssh $BENCHMARK_HOST "
    source /sshfsmount/elba_script/set_elba_env.sh
    cd $RUBBOS_HOME/bench
    \rm -r 20*

    # Execute benchmark
    $OUTPUT_HOME/startEsxtopMonitor.sh & 
    $OUTPUT_HOME/collectlMonitor.sh 
    echo '**************start************'
    date
    ./rubbos-servletsBO.sh

    # Collect results
    echo "The benchmark has finished. Now, collecting results..."
    cd 20*
    scp $HTTPD_HOST:$HTTPD_HOME/logs/access_log ./HTTPD.log
     scp $HTTPD_HOST:$HTTPD_HOME/logs/mod_jk.log ./mod_jk.log
     scp $HTTPD_HOST:$HTTPD_HOME/conf/httpd.conf ./
     scp $HTTPD_HOST:$HTTPD_HOME/conf/workers.properties ./
    gzip HTTPD.log
    
     scp $TOMCAT1_HOST:$CATALINA_HOME/logs/gc-*.log ./

     scp $TOMCAT1_HOST:$CATALINA_HOME/conf/server.xml ./TOMCAT1_server.xml
     scp $TOMCAT1_HOST:$CATALINA_HOME/bin/catalina.sh ./TOMCAT1_catalina.sh
     scp $TOMCAT1_HOST:/tmp/*rubbosSL_configure.sh ./	
    scp $MYSQL1_HOST:$MYSQL_HOME/run/mysqld-slow.log ./MYSQL1.log
    gzip MYSQL1.log


scp $CJDBC_HOST:$CJDBC_HOME/log/*.log ./
scp $CJDBC_HOST:$CJDBC_HOME/bin/controller.sh ./
scp $CJDBC_HOST:$CJDBC_HOME/config/virtualdatabase/mysqldb-raidb1-elba.xml ./

cp -r $OUTPUT_HOME ./

    scp $BENCHMARK_HOST:$RUBBOS_TOP/sar-* ./
    scp $BENCHMARK_HOST:$RUBBOS_TOP/ps-* ./
    scp $BENCHMARK_HOST:$RUBBOS_TOP/iostat-* ./
    scp $BENCHMARK_HOST:$RUBBOS_TOP/mysql_mon-* ./
    scp $BENCHMARK_HOST:$RUBBOS_TOP/postgres_lock-* ./
    scp $CLIENT1_HOST:$RUBBOS_TOP/sar-* ./
    scp $CLIENT1_HOST:$RUBBOS_TOP/ps-* ./
    scp $CLIENT1_HOST:$RUBBOS_TOP/iostat-* ./
    scp $CLIENT1_HOST:$RUBBOS_TOP/mysql_mon-* ./
    scp $CLIENT1_HOST:$RUBBOS_TOP/postgres_lock-* ./
    scp $HTTPD_HOST:$RUBBOS_TOP/sar-* ./
    scp $HTTPD_HOST:$RUBBOS_TOP/ps-* ./
    scp $HTTPD_HOST:$RUBBOS_TOP/iostat-* ./
    scp $HTTPD_HOST:$RUBBOS_TOP/mysql_mon-* ./
    scp $HTTPD_HOST:$RUBBOS_TOP/postgres_lock-* ./
    scp $TOMCAT1_HOST:$RUBBOS_TOP/sar-* ./
    scp $TOMCAT1_HOST:$RUBBOS_TOP/ps-* ./
    scp $TOMCAT1_HOST:$RUBBOS_TOP/iostat-* ./
    scp $TOMCAT1_HOST:$RUBBOS_TOP/mysql_mon-* ./
    scp $TOMCAT1_HOST:$RUBBOS_TOP/postgres_lock-* ./
    scp $MYSQL1_HOST:$RUBBOS_TOP/sar-* ./
    scp $MYSQL1_HOST:$RUBBOS_TOP/ps-* ./
    scp $MYSQL1_HOST:$RUBBOS_TOP/iostat-* ./
    scp $MYSQL1_HOST:$RUBBOS_TOP/mysql_mon-* ./
    scp $MYSQL1_HOST:$RUBBOS_TOP/postgres_lock-* ./

    ## collect esxtop information       
    $OUTPUT_HOME/endEsxtopMonitor.sh
    $OUTPUT_HOME/endCollectl.sh
    cp /tmp/esxtopCPU*.csv ./
    cp /tmp/power*.csv ./
    cp /tmp/VMelba* ./
    sleep 2

    cd ..
    mv 20* $TMP_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/
  "

  #$OUTPUT_HOME/scripts/stop_all.sh
  $OUTPUT_HOME/scripts/kill_all.sh
  sleep 15
  echo "End Browsing Only with $i"

  # Read/Write
  echo "Start Read/Write with $i"
  echo "Removing previous logs"

  echo "End Read/Write with $i"

done

echo "Processing the results..."
ssh $BENCHMARK_HOST "
  cd $TMP_RESULTS_DIR_BASE
  cd $RUBBOS_RESULTS_DIR_NAME
  scp $RUBBOS_RESULTS_HOST:$RUBBOS_RESULTS_DIR_BASE/calc-sarSummary.prl ../
  cp /sshfsmount/elba_script/set_elba_env.sh ./

  ../calc-sarSummary.prl

  scp $RUBBOS_RESULTS_HOST:$RUBBOS_RESULTS_DIR_BASE/calc-durationTime.prl ../

  ../calc-durationTime.prl

  rm -f 20*/*.bin

  cd ../
  tar zcvf $RUBBOS_RESULTS_DIR_NAME.tgz $RUBBOS_RESULTS_DIR_NAME
  scp $RUBBOS_RESULTS_DIR_NAME.tgz $RUBBOS_RESULTS_HOST:$RUBBOS_RESULTS_DIR_BASE/
"

echo "Finish Experiment RUBBoS"

sleep 10

echo "Start processing RUBBoS experimental results in Bonn"

ssh $BONN_HOST "
  cd $BONN_RUBBOS_RESULTS_DIR_BASE
  tar -xzvf $RUBBOS_RESULTS_DIR_NAME.tgz
  cd $RUBBOS_RESULTS_DIR_NAME
  cp $BONN_SCRIPTS_BASE/generateResult.sh ./
  cp $BONN_SCRIPTS_BASE/transferScripts.sh ./
  cp $BONN_SCRIPTS_BASE/data*.py ./
  ./generateResult.sh
  sleep 2
  ./transferScripts.sh
"
echo "Finish processing RUBBoS Result in Bonn"


sleep 10
echo "start processing RUBBoS experimental SysViz result"
ssh $SYSVIZ_HOST "
chmod 777 $SYSVIZ_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/*.sh
cd $SYSVIZ_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME
./resultAnalysis.sh
"

echo "Finish RUBBoS"

















 
