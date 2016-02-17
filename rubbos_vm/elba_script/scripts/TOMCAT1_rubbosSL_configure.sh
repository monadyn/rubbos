 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "  CONFIGURING RUBBOS SERVLET on $HOSTNAME"

\cp $OUTPUT_HOME/rubbos_conf/build.properties $RUBBOS_HOME/

\rm -rf $RUBBOS_HOME/Servlets
\cp -r $WORK_HOME/rubbos_files/Servlets $RUBBOS_HOME/
#\mv $RUBBOS_HOME/Servlets $RUBBOS_HOME/Servlets



\cp $SOFTWARE_HOME/mysql-connector-java-5.0.4-bin.jar $RUBBOS_HOME/Servlets/
\cp $OUTPUT_HOME/rubbos_conf/mysql.properties $RUBBOS_HOME/Servlets/
\cp $OUTPUT_HOME/rubbos_conf/build.xml $RUBBOS_HOME/Servlets/
\cp $OUTPUT_HOME/rubbos_conf/Config.java /root/elba/rubbos/RUBBoS/Servlets/edu/rice/rubbos/servlets/
\cp $OUTPUT_HOME/rubbos_conf/web.xml $RUBBOS_HOME/Servlet_HTML/WEB-INF/

cp $OUTPUT_HOME/rubbos_conf/TOMCAT_log4j.properties $RUBBOS_HOME/Servlet_HTML/WEB-INF/log4j.properties


cd $RUBBOS_HOME/Servlets/edu/rice/rubbos/servlets
sed 's/public static final int    BrowseCategoriesPoolSize      = 6;/public static final int    BrowseCategoriesPoolSize      = 12;/g' Config.java > Config.java.tmp
mv Config.java.tmp Config.java


cd $RUBBOS_HOME/Servlets
ant clean
ant dist
make
rm -rf $CATALINA_HOME/webapps/rubbos*
cp rubbos.war $CATALINA_HOME/webapps/

echo "  DONE CONFIGURING RUBBOS SERVLET on $HOSTNAME"




 
