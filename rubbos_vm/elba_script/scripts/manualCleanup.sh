
#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

echo "Uninstalling ...."

ssh $BENCHMARK_HOST /tmp/BENCHMARK_uninstall.sh
ssh $HTTPD_HOST /tmp/HTTPD_uninstall.sh
ssh $TOMCAT1_HOST /tmp/TOMCAT1_uninstall.sh
ssh $MYSQL1_HOST /tmp/MYSQL1_uninstall.sh

echo "Cleaning up ...."
for i in "$BENCHMARK_HOST" "$HTTPD_HOST" "$TOMCAT1_HOST" "$MYSQL1_HOST"
do
  ssh $i "
    sudo \rm -r $RUBBOS_TOP
    "
done


ssh $CONTROL_HOST  rm -f /tmp/CONTROL_checkScp_exec.sh
ssh $CONTROL_HOST  rm -f /tmp/CONTROL_rubbos_exec.sh
ssh $BENCHMARK_HOST  rm -f /tmp/BENCHMARK_rubbos_install.sh
ssh $BENCHMARK_HOST  rm -f /tmp/BENCHMARK_install.sh
ssh $BENCHMARK_HOST  rm -f /tmp/BENCHMARK_configure.sh
ssh $BENCHMARK_HOST  rm -f /tmp/BENCHMARK_uninstall.sh
ssh $BENCHMARK_HOST  rm -f /tmp/BENCHMARK_rubbos_uninstall.sh
ssh $HTTPD_HOST  rm -f /tmp/HTTPD_install.sh
ssh $HTTPD_HOST  rm -f /tmp/HTTPD_rubbos_install.sh
ssh $HTTPD_HOST  rm -f /tmp/HTTPD_configure.sh
ssh $HTTPD_HOST  rm -f /tmp/HTTPD_ignition.sh
ssh $HTTPD_HOST  rm -f /tmp/HTTPD_stop.sh
ssh $HTTPD_HOST  rm -f /tmp/HTTPD_rubbos_uninstall.sh
ssh $HTTPD_HOST  rm -f /tmp/HTTPD_uninstall.sh
ssh $TOMCAT1_HOST  rm -f /tmp/TOMCAT1_install.sh
ssh $TOMCAT1_HOST  rm -f /tmp/TOMCAT1_rubbos_install.sh
ssh $TOMCAT1_HOST  rm -f /tmp/TOMCAT1_configure.sh
ssh $TOMCAT1_HOST  rm -f /tmp/TOMCAT1_rubbosSL_configure.sh
ssh $TOMCAT1_HOST  rm -f /tmp/TOMCAT1_ignition.sh
ssh $TOMCAT1_HOST  rm -f /tmp/TOMCAT1_stop.sh
ssh $TOMCAT1_HOST  rm -f /tmp/TOMCAT1_rubbos_uninstall.sh
ssh $TOMCAT1_HOST  rm -f /tmp/TOMCAT1_uninstall.sh
ssh $MYSQL1_HOST  rm -f /tmp/MYSQL1_install.sh
ssh $MYSQL1_HOST  rm -f /tmp/MYSQL1_rubbos_install.sh
ssh $MYSQL1_HOST  rm -f /tmp/MYSQL1_configure.sh
ssh $MYSQL1_HOST  rm -f /tmp/MYSQL1_reset.sh
ssh $MYSQL1_HOST  rm -f /tmp/MYSQL1_ignition.sh
ssh $MYSQL1_HOST  rm -f /tmp/MYSQL1_stop.sh
ssh $MYSQL1_HOST  rm -f /tmp/MYSQL1_rubbos_uninstall.sh
ssh $MYSQL1_HOST  rm -f /tmp/MYSQL1_uninstall.sh
