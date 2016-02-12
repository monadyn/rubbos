curl -X POST http://192.168.0.1:8080/v2/apps -d @rubbos_mysql.json -H "Content-type: application/json" | python -m json.tool
echo 'dynamic ip and port'
./build_image.sh
sleep 3
./build_rubbos_initjson.sh

curl -X POST http://192.168.0.1:8080/v2/apps -d @rubbos_init.json -H "Content-type: application/json" | python -m json.tool
curl -X POST http://192.168.0.1:8080/v2/apps -d @rubbos_tomcat.json -H "Content-type: application/json" | python -m json.tool

