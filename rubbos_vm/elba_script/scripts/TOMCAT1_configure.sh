 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "  CONFIGURING TOMCAT on $HOSTNAME"

#cp $WORK_HOME/tomcat_files/startup.sh $CATALINA_HOME/bin/
#cp $WORK_HOME/tomcat_files/shutdown.sh $CATALINA_HOME/bin/
\cp $WORK_HOME/tomcat_files/catalina.sh $CATALINA_HOME/bin/
\cp $OUTPUT_HOME/tomcat_conf/server.xml-$HOSTNAME $CATALINA_HOME/conf/server.xml
\cp $OUTPUT_HOME/tomcat_conf/server.xml- $CATALINA_HOME/conf/server.xml
\cp $OUTPUT_HOME/tomcat_conf/server.xml- $CATALINA_HOME/conf/server.xml
\cp $OUTPUT_HOME/tomcat_conf/server.xml.tomcat-7.0.55 $CATALINA_HOME/conf/server.xml

echo "  DONE CONFIGURING TOMCAT on $HOSTNAME"


 
