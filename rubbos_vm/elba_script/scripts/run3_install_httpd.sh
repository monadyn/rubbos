
cd /sshfsmount/elba_script
source set_elba_env.sh

cd /sshfsmount/elba_script/scripts


# Transfer all sub scripts to target hosts
echo "*** scp scripts *************************************************"


# Install and Configure and run Apache, Tomcat, CJDBC, and MySQL
echo "*** install scripts & configure & execute ***********************"







ssh $HTTPD_HOST /tmp/HTTPD_install.sh 


exit(0)
ssh $MYSQL1_HOST /tmp/MYSQL1_rubbos_install.sh 


ssh $TOMCAT1_HOST /tmp/TOMCAT1_rubbos_install.sh 


ssh $HTTPD_HOST /tmp/HTTPD_rubbos_install.sh 


ssh $BENCHMARK_HOST /tmp/BENCHMARK_rubbos_install.sh 


ssh $CLIENT1_HOST /tmp/CLIENT1_rubbos_install.sh 


ssh $BENCHMARK_HOST /tmp/BENCHMARK_install.sh 


ssh $CLIENT1_HOST /tmp/CLIENT1_install.sh 

exit(0)

ssh $MYSQL1_HOST /tmp/MYSQL1_configure.sh  &
sleep 60

ssh $TOMCAT1_HOST /tmp/TOMCAT1_configure.sh 


ssh $HTTPD_HOST /tmp/HTTPD_configure.sh 


ssh $BENCHMARK_HOST /tmp/BENCHMARK_configure.sh 


ssh $CLIENT1_HOST /tmp/CLIENT1_configure.sh 


ssh $TOMCAT1_HOST /tmp/TOMCAT1_rubbosSL_configure.sh 


ssh $CONTROL_HOST /tmp/CONTROL_rubbos_exec.sh 

