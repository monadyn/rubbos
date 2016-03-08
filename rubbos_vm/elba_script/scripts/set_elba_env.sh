
#!/bin/bash

set -o allexport

# HOSTS
CONTROL_HOST=HPD1
BENCHMARK_HOST=hdp103
HTTPD_HOST=hshan-httpd
TOMCAT1_HOST=hshan-tomcat
MYSQL1_HOST=hshan-mysql



# Experiment name on Emulab
EMULAB_EXPERIMENT_NAME=rubbos.cs.lsu.edu
EXPERIMENT_CONFIG=hshan-111
EXPERIMENT_CONFIG_TIERS=3

# Directories from which files are copied
WORK_HOME=/sshfsmount/elba_script
OUTPUT_HOME=/sshfsmount/elba_script/scripts
SOFTWARE_HOME=/sshfsmount/softwares

# Output directory for results of RUBBoS benchmark
RUBBOS_RESULTS_HOST=hpd1
RUBBOS_RESULTS_DIR_BASE=/home/hshan/rubbos/results
RUBBOS_RESULTS_DIR_NAME=2016-02-24T134653-0600_hshan-111

# Output directory for results of RUBBoS benchmark on Bonn and SysViz servers
BONN_HOST=hpd1
BONN_RUBBOS_RESULTS_DIR_BASE=/home/hshan/rubbos/results
BONN_SCRIPTS_BASE=/home/hshan/rubbos_base/scripts


SYSVIZ_HOST=hdp1
SYSVIZ_RUBBOS_RESULTS_DIR_BASE=/home/hshan/rubbos/results





# Target directories
ELBA_TOP=/home/hshan/elba
RUBBOS_TOP=$ELBA_TOP/rubbos
TMP_RESULTS_DIR_BASE=/home/hshan/rubbos/results
RUBBOS_HOME=$RUBBOS_TOP/RUBBoS
SYSSTAT_HOME=$RUBBOS_TOP/sysstat-11.2.0
HTTPD_HOME=$ELBA_TOP/apache2
HTTPD_INSTALL_FILES=$RUBBOS_TOP/httpd-2.0.54
MOD_JK_INSTALL_FILES=$RUBBOS_TOP/tomcat-connectors-1.2.28-src
CATALINA_HOME=$RUBBOS_TOP/apache-tomcat-7.0.55
CATALINA_BASE=$CATALINA_HOME
CJDBC_HOME=$RUBBOS_TOP/c-jdbc-2.0.2-bin
MYSQL_HOME=$RUBBOS_TOP/mysql-5.1.62-linux-x86_64-glibc23
JONAS_ROOT=$RUBBOS_TOP/JONAS_4_6_6

# Java & Ant
JAVA_HOME=$SOFTWARE_HOME/jdk1.7.0_79
JAVA_OPTS="-Xmx1300m"
J2EE_HOME=$RUBBOS_TOP/j2sdkee1.3.1
ANT_HOME=$RUBBOS_TOP/apache-ant-1.6.5

# Tarballs
JAVA_TARBALL=jdk1.7.0_79.tar.gz
J2EE_TARBALL=j2sdkee1.3.1.jar.gz
ANT_TARBALL=apache-ant-1.6.5.tar.gz
SYSSTAT_TARBALL=sysstat-11.2.0.tar.gz
HTTPD_TARBALL=httpd-2.0.54.tar.gz
MOD_JK_TARBALL=tomcat-connectors-1.2.28-src.tar.gz
TOMCAT_TARBALL=apache-tomcat-7.0.55.tar.gz
CJDBC_TARBALL=c-jdbc-2.0.2-bin-modified.tar.gz
MYSQL_TARBALL_RT=mysql-5.0.51a-modified-bin.tar.gz
RUBBOS_TARBALL=RUBBoS-servlets.tar.gz
RUBBOS_DATA_TARBALL=rubbos_data.tar.gz
RUBBOS_DATA_TEXTFILES_TARBALL=smallDB-rubbos-modified.tgz

# for MySQL
MYSQL_CONNECTOR=mysql-connector-java-5.0.4-bin.jar
MYSQL_PORT=3313
MYSQL_SOCKET=$MYSQL_HOME/mysql.sock
MYSQL_DATA_DIR=$MYSQL_HOME/data
MYSQL_ERR_LOG=$MYSQL_HOME/data/mysql.log
MYSQL_PID_FILE=$MYSQL_HOME/run/mysqld.pid

# for DBs & C-JDBC
ROOT_PASSWORD=lsu2015
ELBA_USER=elba
ELBA_PASSWORD=elba


CLASSPATH=$CLASSPATH:$JONAS_ROOT/bin/unix/registry:$JAVA_HOME:$JAVA_HOME/lib/tools.jar:$CATALINA_HOME/common/lib/servlet-api.jar:.:$RUBBOS_HOME/Servlet_HTML/WEB-INF/lib/log4j.jar

PATH=$JAVA_HOME/bin:$JONAS_ROOT/bin/unix:$ANT_HOME/bin:$CATALINA_HOME/bin:$PATH
set +o allexport

