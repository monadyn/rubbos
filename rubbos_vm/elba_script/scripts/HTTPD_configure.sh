 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "  CONFIGURING APACHE on $HOSTNAME"

cp $OUTPUT_HOME/apache_conf/httpd.conf $HTTPD_HOME/conf/
cp $OUTPUT_HOME/apache_conf/workers.properties $HTTPD_HOME/conf/
cp -r $WORK_HOME/apache_files/rubbos_html $HTTPD_HOME/htdocs/rubbos

echo "  APACHE CONFIGURED SUCCESSFULLY on $HOSTNAME"


 
