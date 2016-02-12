


curl -X DELETE http://192.168.0.1:8080/v2/apps/mysql3319 -H "Content-type: application/json" | python -m json.tool
curl -X DELETE http://192.168.0.1:8080/v2/apps/rubbosapp -H "Content-type: application/json" | python -m json.tool
curl -X DELETE http://192.168.0.1:8080/v2/apps/tomcat84 -H "Content-type: application/json" | python -m json.tool

