
cd /sshfsmount/elba_script
source set_elba_env.sh

cd /sshfsmount/elba_script/scripts





ssh $HTTPD_HOST /tmp/HTTPD_rubbos_install.sh 





exit(0)

ssh $MYSQL1_HOST /tmp/MYSQL1_configure.sh  &
sleep 60

ssh $TOMCAT1_HOST /tmp/TOMCAT1_configure.sh 


ssh $HTTPD_HOST /tmp/HTTPD_configure.sh 


ssh $BENCHMARK_HOST /tmp/BENCHMARK_configure.sh 


ssh $CLIENT1_HOST /tmp/CLIENT1_configure.sh 


ssh $TOMCAT1_HOST /tmp/TOMCAT1_rubbosSL_configure.sh 


exit(0)
ssh $CONTROL_HOST /tmp/CONTROL_rubbos_exec.sh 

