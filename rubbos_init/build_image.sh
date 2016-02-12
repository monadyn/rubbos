ip=$(curl -X GET  http://192.168.0.1:8080/v2/apps/mysql3319/tasks -H "Content-type: application/json" | python -c 'import sys, json; print json.load(sys.stdin)["tasks"][0]["host"];')
port=$(curl -X GET  http://192.168.0.1:8080/v2/apps/mysql3319/tasks -H "Content-type: application/json" | python -c 'import sys, json; print json.load(sys.stdin)["tasks"][0]["ports"][0];')
sed "s/RUBBOS_DB_URL/${ip}:${port}/g" mysql.properties.template > mysql.properties
echo $ip
echo $port

docker rmi hudsonshan/rubbos_tomcat:app_dyn
docker build -t hudsonshan/rubbos_tomcat:app_dyn .


