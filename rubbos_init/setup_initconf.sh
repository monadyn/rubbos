
#ip=$(curl -X GET  http://192.168.0.1:8080/v2/apps/mysql3319/tasks -H "Content-type: application/json" | python -c 'import sys, json; print json.load(sys.stdin)["tasks"][0]["host"];')
port=$(curl -X GET  http://192.168.0.1:8080/v2/apps/mysql3319/tasks -H "Content-type: application/json" | python -c 'import sys, json; print json.load(sys.stdin)["tasks"][0]["ports"][0];')
#echo $ip
echo $port

ssh node4 docker pull hudsonshan/rubbos_tomcat:app_$port

curl -X POST http://192.168.0.1:8080/v2/apps -d @rubbos_init.json -H "Content-type: application/json" | python -m json.tool



