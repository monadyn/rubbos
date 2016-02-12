#ip=$(curl -X GET  http://192.168.0.1:8080/v2/apps/mysql3319/tasks -H "Content-type: application/json" | python -c 'import sys, json; print json.load(sys.stdin)["tasks"][0]["host"];')
port=$(curl -X GET  http://192.168.0.1:8080/v2/apps/mysql3319/tasks -H "Content-type: application/json" | python -c 'import sys, json; print json.load(sys.stdin)["tasks"][0]["ports"][0];')
#echo $ip
echo $port
 
rubbosapp=hudsonshan/rubbos_tomcat:app_$port

rubbosapp_container_id=$(ssh node4 docker ps | grep $rubbosapp | awk '{print $1}')
echo $rubbosapp_container_id

sed "s/RUBBOS_APP_CONTAINER_ID/${rubbosapp_container_id}/g" rubbos_tomcat.json.template > rubbos_tomcat.json


curl -X POST http://192.168.0.1:8080/v2/apps -d @rubbos_tomcat.json -H "Content-type: application/json" | python -m json.tool

