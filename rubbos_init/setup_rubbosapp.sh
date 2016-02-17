
echo ''
echo 'setup mysql'
curl -X POST http://192.168.0.1:8080/v2/apps -d @rubbos_mysql.json -H "Content-type: application/json" | python -m json.tool


./build_image.sh
sleep 3
./build_rubbos_initjson.sh

echo ''
echo 'setup rubbus'
./setup_initconf.sh
#echo curl -X POST http://192.168.0.1:8080/v2/apps -d @rubbos_init.json -H "Content-type: application/json" | python -m json.tool

sleep 3
echo ''
echo 'setup tomcat'
./setup_tomcat.sh
#echo curl -X POST http://192.168.0.1:8080/v2/apps -d @rubbos_tomcat.json -H "Content-type: application/json" | python -m json.tool

