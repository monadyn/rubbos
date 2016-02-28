

#!/bin/bash 
 
 
 cd /sshfsmount/elba_script 
 source set_elba_env.sh 
 
 
 
 
 echo "clearn the collectl data in benchmark node" 
 \rm /tmp/VMelba*.csv 
 sleep 1 
 
 
 echo "collect collectl data" 
 
 
 for i in "$HTTPD_HOST" "$TOMCAT1_HOST" "$MYSQL1_HOST" "$BENCHMARK_HOST" "$CLIENT1_HOST" 
 do 
   ssh $i " 
 	pkill collectl 
     " 
   sleep 2 
   #scp $i:/tmp/VMelba* /tmp/ 
   scp $i:/tmp/*raw.gz /tmp/ 
 done 
 
 
 
 
 #for i in "$HTTPD_HOST" "$TOMCAT1_HOST" "$MYSQL1_HOST" "$BENCHMARK_HOST" "$CLIENT1_HOST" 
 #do 
 #  ssh $i " 
 #        rm /tmp/VMelba* 
 #    " 
 #done 

