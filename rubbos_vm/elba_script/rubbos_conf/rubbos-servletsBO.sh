#!/bin/bash

###############################################################################
#
# This script runs first the RUBBoS browsing mix, then the read/write mix 
# for each rubbos.properties_XX specified where XX is the number of emulated
# clients. Note that the rubbos.properties_XX files must be configured
# with the corresponding number of clients.
# In particular set the following variables in rubis.properties_XX:
# httpd_use_version = Servlets
# workload_number_of_clients_per_node = XX/number of client machines
# workload_transition_table = yourPath/RUBBoS/workload/transitions.txt 
#
# This script should be run from the RUBBoS/bench directory on the local 
# client machine. 
# Results will be generated in the RUBBoS/bench directory.
#
################################################################################

#setenv SERVLETDIR $RUBBOS_HOME/Servlets

# Go back to RUBBoS root directory
cd ..

# Browse only

#cp --reply=yes ./workload/browse_only_transitions.txt ./workload/user_transitions.txt
#cp --reply=yes ./workload/browse_only_transitions.txt ./workload/author_transitions.txt
cp  ./workload/browse_only_transitions.txt ./workload/user_transitions.txt -f
cp  ./workload/browse_only_transitions.txt ./workload/author_transitions.txt -f

scp ./workload/browse_only_transitions.txt ${CLIENT1_HOST}:${RUBBOS_HOME}/workload/user_transitions.txt
scp ./workload/browse_only_transitions.txt ${CLIENT1_HOST}:${RUBBOS_HOME}/workload/author_transitions.txt

scp Client/rubbos.properties ${CLIENT1_HOST}:${RUBBOS_HOME}/Client/rubbos.properties


bench/flush_cache 490000
ssh $HTTPD_HOST "$RUBBOS_HOME/bench/flush_cache 880000"       # web server
ssh $MYSQL1_HOST "$RUBBOS_HOME/bench/flush_cache 880000"       # database server
ssh $TOMCAT1_HOST "$RUBBOS_HOME/bench/flush_cache 780000"       # servlet server
ssh $CLIENT1_HOST "$RUBBOS_HOME/bench/flush_cache 490000"       # remote client

RAMPUP=120000
MI=180000
current_seconds=`date +%s`
start_seconds=`echo \( $RAMPUP / 1000 \) + $current_seconds - 60 | bc`
SMI=`date -d "1970-01-01 $start_seconds secs UTC" +%Y%m%d%H%M%S`
end_seconds=`echo \( $RAMPUP / 1000 + $MI / 1000 + 30 \) + $current_seconds | bc`
EMI=`date -d "1970-01-01 $end_seconds secs UTC" +%Y%m%d%H%M%S`

echo SMI
echo EMI
 echo ssh $BENCHMARK_HOST "nice -n -1 $RUBBOS_TOP/cpu_mem.sh $SMI $EMI" &
 echo ssh $CLIENT1_HOST "nice -n -1 $RUBBOS_TOP/cpu_mem.sh $SMI $EMI" &
 echo ssh $HTTPD_HOST "nice -n -1 $RUBBOS_TOP/cpu_mem.sh $SMI $EMI" &
 echo ssh $TOMCAT1_HOST "nice -n -1 $RUBBOS_TOP/cpu_mem.sh $SMI $EMI" &
 echo ssh $MYSQL1_HOST "nice -n -1 $RUBBOS_TOP/cpu_mem.sh $SMI $EMI" &


make emulator

echo 'rubbos emulator done!'
echo '--------------------------------------------------------->'

