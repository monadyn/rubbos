#ip=$(curl -X GET  http://192.168.0.1:8080/v2/apps/tomcat84/tasks -H "Content-type: application/json" | python -c 'import sys, json; print json.load(sys.stdin)["tasks"][0]["host"];')
port=$(curl -X GET  http://192.168.0.1:8080/v2/apps/tomcat84/tasks -H "Content-type: application/json" | python -c 'import sys, json; print json.load(sys.stdin)["tasks"][0]["ports"][0];')
#echo $ip
echo $port


lynx node4:$port/rubbos 

