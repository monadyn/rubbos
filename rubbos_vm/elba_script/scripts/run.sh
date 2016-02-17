
cd /sshfsmount/elba_script
source set_elba_env.sh

cd /sshfsmount/elba_script/scripts


# Transfer all sub scripts to target hosts
echo "*** scp scripts *************************************************"

scp -o StrictHostKeyChecking=no -o BatchMode=yes CONTROL_checkScp_exec.sh  $CONTROL_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes CONTROL_rubbos_exec.sh  $CONTROL_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes BENCHMARK_rubbos_install.sh  $BENCHMARK_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes BENCHMARK_install.sh  $BENCHMARK_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes BENCHMARK_configure.sh  $BENCHMARK_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes BENCHMARK_uninstall.sh  $BENCHMARK_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes BENCHMARK_rubbos_uninstall.sh  $BENCHMARK_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes HTTPD_install.sh  $HTTPD_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes HTTPD_rubbos_install.sh  $HTTPD_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes HTTPD_configure.sh  $HTTPD_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes HTTPD_ignition.sh  $HTTPD_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes HTTPD_stop.sh  $HTTPD_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes HTTPD_rubbos_uninstall.sh  $HTTPD_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes HTTPD_uninstall.sh  $HTTPD_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes TOMCAT1_install.sh  $TOMCAT1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes TOMCAT1_rubbos_install.sh  $TOMCAT1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes TOMCAT1_configure.sh  $TOMCAT1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes TOMCAT1_rubbosSL_configure.sh  $TOMCAT1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes TOMCAT1_ignition.sh  $TOMCAT1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes TOMCAT1_stop.sh  $TOMCAT1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes TOMCAT1_rubbos_uninstall.sh  $TOMCAT1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes TOMCAT1_uninstall.sh  $TOMCAT1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes MYSQL1_install.sh  $MYSQL1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes MYSQL1_rubbos_install.sh  $MYSQL1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes MYSQL1_configure.sh  $MYSQL1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes MYSQL1_reset.sh  $MYSQL1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes MYSQL1_ignition.sh  $MYSQL1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes MYSQL1_stop.sh  $MYSQL1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes MYSQL1_rubbos_uninstall.sh  $MYSQL1_HOST:/tmp

scp -o StrictHostKeyChecking=no -o BatchMode=yes MYSQL1_uninstall.sh  $MYSQL1_HOST:/tmp


# Install and Configure and run Apache, Tomcat, CJDBC, and MySQL
echo "*** install scripts & configure & execute ***********************"

ssh $CONTROL_HOST /tmp/CONTROL_checkScp_exec.sh 
ssh $MYSQL1_HOST /tmp/MYSQL1_install.sh 


ssh $TOMCAT1_HOST /tmp/TOMCAT1_install.sh 


ssh $HTTPD_HOST /tmp/HTTPD_install.sh 


ssh $MYSQL1_HOST /tmp/MYSQL1_rubbos_install.sh 


ssh $TOMCAT1_HOST /tmp/TOMCAT1_rubbos_install.sh 


ssh $HTTPD_HOST /tmp/HTTPD_rubbos_install.sh 


ssh $BENCHMARK_HOST /tmp/BENCHMARK_rubbos_install.sh 


ssh $BENCHMARK_HOST /tmp/BENCHMARK_install.sh 


ssh $MYSQL1_HOST /tmp/MYSQL1_configure.sh  &
sleep 60

ssh $TOMCAT1_HOST /tmp/TOMCAT1_configure.sh 


ssh $HTTPD_HOST /tmp/HTTPD_configure.sh 


ssh $BENCHMARK_HOST /tmp/BENCHMARK_configure.sh 


ssh $TOMCAT1_HOST /tmp/TOMCAT1_rubbosSL_configure.sh 


ssh $CONTROL_HOST /tmp/CONTROL_rubbos_exec.sh 

