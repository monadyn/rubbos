ssh node9 rm -rf /mnt/elba/rubbos/apache-tomcat-5.5.17/webapps/rubbos/WEB-INF/lib/rubbos_servlets.jar
scp rubbos_servlets.jar node9:/mnt/elba/rubbos/apache-tomcat-5.5.17/webapps/rubbos/WEB-INF/lib
ssh node8 rm -rf /mnt/elba/rubbos/apache-tomcat-5.5.17/webapps/rubbos/WEB-INF/lib/rubbos_servlets.jar
scp rubbos_servlets.jar node8:/mnt/elba/rubbos/apache-tomcat-5.5.17/webapps/rubbos/WEB-INF/lib

