#!/bin/bash

#ip=$(curl -X GET  http://192.168.0.1:8080/v2/apps/tomcat84/tasks -H "Content-type: application/json" | python -c 'import sys, json; print json.load(sys.stdin)["tasks"][0]["host"];')
port=$(curl -X GET  http://192.168.0.1:8080/v2/apps/tomcat84/tasks -H "Content-type: application/json" | python -c 'import sys, json; print json.load(sys.stdin)["tasks"][0]["ports"][0];')
#echo $ip
echo $port

#echo $1
# Go back to RUBBoS root directory
cd ..

# Browse only

#cp -f ./workload/browse_only_transitions.txt ./workload/user_transitions.txt
#cp -f ./workload/browse_only_transitions.txt ./workload/author_transitions.txt

#foreach i (rubbos.properties_100 rubbos.properties_200 rubbos.properties_300 rubbos.properties_400 rubbos.properties_500 rubbos.properties_600 rubbos.properties_700 rubbos.properties_800 rubbos.properties_900 rubbos.properties_1000) 
#foreach i (rubbos.properties_100)
#for i in 1000 2000 3000 4000 5000 6000 7000 8000 9000  10000
for i in 7000
do
  echo '--->'
  echo $i
  rm -f rubbos.properties
  sed "s/T_WORKLOAD_CONC/$i/g; s/T_HTTPD_PORT/${port}/g" rubbos.properties.template > rubbos.properties_$i 
  cp -f rubbos.properties_$i rubbos.properties
#  flush_cache 490000
#  rsh sci23 RUBBoS/flush_cache 880000 	# web server
#  rsh sci22 RUBBoS/flush_cache 880000	# database
#  rsh sci6 RUBBoS/flush_cache 490000	# remote client
#  rsh sci7 RUBBoS/flush_cache 490000	# remote client
#  rsh sci8 RUBBoS/flush_cache 490000	# remote client
  make emulator 
done 

echo 'done BO'
# Default

#cp -f ./workload/user_default_transitions.txt ./workload/user_transitions.txt
#cp -f ./workload/author_default_transitions.txt ./workload/author_transitions.txt

#foreach i (rubbos.properties_100 rubbos.properties_200 rubbos.properties_300 rubbos.properties_400 rubbos.properties_500 rubbos.properties_600 rubbos.properties_700 rubbos.properties_800 rubbos.properties_900 rubbos.properties_1000) 
foreach i (rubbos.properties_100)
  rm -f rubbos.properties
  cp bench/$i rubbos.properties
  #flush_cache 490000
  #rsh sci23 RUBBoS/flush_cache 880000 	# web server
  #rsh sci22 RUBBoS/flush_cache 880000	# database
  #rsh sci6 RUBBoS/flush_cache 490000	# remote client
  #rsh sci7 RUBBoS/flush_cache 490000	# remote client
  #rsh sci8 RUBBoS/flush_cache 490000	# remote client
  #make emulator
end
echo 'RW done'
