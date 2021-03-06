<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='control_server' and @actype='rubbos_exec' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='control_server' and @actype='rubbos_exec' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='control_server' and @actype='rubbos_exec' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/RUBBOSexecution.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "Starting RUBBoS"

ssh $RUBBOS_RESULTS_HOST "
  mkdir -p $RUBBOS_RESULTS_DIR_BASE
"
ssh $BENCHMARK_HOST "
  mkdir -p $TMP_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME
  rm -rf $TMP_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/*
"
#ssh $SYSVIZ_HOST "
#  rm -rf /cap/capssd/*
#"

for i in<xsl:for-each select="//params/workloads/param[@name='workload']"
    > "rubbos.properties_<xsl:value-of select="./@value"/>"</xsl:for-each>
do

  ssh $BENCHMARK_HOST "
    source <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/set_elba_env.sh
    rm -f $RUBBOS_HOME/Client/rubbos.properties
  "
  scp $OUTPUT_HOME/rubbos_conf/$i $BENCHMARK_HOST:$RUBBOS_HOME/Client/rubbos.properties

  # echo "Resetting all data"
  # $OUTPUT_HOME/scripts/reset_all.sh

  # Browsing Only
  echo "Start Browsing Only with $i"
  echo "Removing previous logs..."
<xsl:for-each select="//instances/instance[@type='web_server']"
>  ssh $<xsl:value-of select="./@name"/>_HOST "rm -f $HTTPD_HOME/logs/*log"
   ssh $<xsl:value-of select="./@name"/>_HOST "rm -f /iostat-*"
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='app_server']"
>  ssh $<xsl:value-of select="./@name"/>_HOST "rm -f $CATALINA_HOME/logs/*"
   ssh $<xsl:value-of select="./@name"/>_HOST "m -f /iostat-*"
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='cjdbc_server']"
>  ssh $<xsl:value-of select="./@name"/>_HOST "rm -f $CJDBC_HOME/log/*"
   ssh $<xsl:value-of select="./@name"/>_HOST "rm -f /iostat-*"
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='db_server' and not(swname='postgres')]"
>  ssh $<xsl:value-of select="./@name"/>_HOST "rm -f $MYSQL_HOME/run/*.log $RUBBOS_TOP/mysql_mon-*"
   ssh $<xsl:value-of select="./@name"/>_HOST "rm -f /iostat-*"
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='db_server' and swname='postgres']"
>  ssh $<xsl:value-of select="./@name"/>_HOST "rm -f $POSTGRES_HOME/data/logs/* $RUBBOS_TOP/postgres_lock-*"
   ssh $<xsl:value-of select="./@name"/>_HOST "rm -f /iostat-*"
</xsl:for-each>
  $OUTPUT_HOME/scripts/start_all.sh
  sleep 15

<xsl:for-each select="//instances/instance[contains(@type, '_server') and @type!='control_server']"
>  ssh $<xsl:value-of select="./@name"/>_HOST "rm -f $RUBBOS_TOP/sar-* $RUBBOS_TOP/ps-* $RUBBOS_TOP/iostat-* /tmp/*html"
</xsl:for-each>

  ssh $BENCHMARK_HOST "
    source <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/set_elba_env.sh
    cd $RUBBOS_HOME/bench
    \rm -r 20*

    # Execute benchmark
    #$OUTPUT_HOME/startEsxtopMonitor.sh &amp; 
    $OUTPUT_HOME/collectlMonitor.sh 
    echo '**************start************'
    date
    ./rubbos-servletsBO.sh

    # Collect results
    echo "The benchmark has finished. Now, collecting results..."
    cd 20*
<xsl:if test="//params/logging/param[@name='apacheResponseTime']/@value='true'">
<xsl:for-each select="//instances/instance[@type='web_server']"
>    scp $<xsl:value-of select="./@name"/>_HOST:$HTTPD_HOME/logs/access_log ./<xsl:value-of select="./@name"/>.log
     scp $<xsl:value-of select="./@name"/>_HOST:$HTTPD_HOME/logs/mod_jk.log ./mod_jk.log
     scp $<xsl:value-of select="./@name"/>_HOST:$HTTPD_HOME/conf/httpd.conf ./
     scp $<xsl:value-of select="./@name"/>_HOST:$HTTPD_HOME/conf/workers.properties ./
    gzip <xsl:value-of select="./@name"/>.log
</xsl:for-each>
</xsl:if>

<xsl:for-each select="//instances/instance[@type='app_server']">    
     scp $<xsl:value-of select="./@name"/>_HOST:$CATALINA_HOME/logs/gc-*.log ./
<xsl:if test="//params/logging/param[@name='tomcatResponseTime']/@value='true'">
     scp $<xsl:value-of select="./@name"/>_HOST:$CATALINA_HOME/logs/localhost_access_log.* ./<xsl:value-of select="./@name"/>.log
     scp $<xsl:value-of select="./@name"/>_HOST:$CATALINA_HOME/logs/servlets.log ./<xsl:value-of select="./@name"/>_servlets.log
</xsl:if>
     scp $<xsl:value-of select="./@name"/>_HOST:$CATALINA_HOME/conf/server.xml ./<xsl:value-of select="./@name"/>_server.xml
     scp $<xsl:value-of select="./@name"/>_HOST:$CATALINA_HOME/bin/catalina.sh ./<xsl:value-of select="./@name"/>_catalina.sh
     scp $<xsl:value-of select="./@name"/>_HOST:/tmp/*rubbosSL_configure.sh ./	
</xsl:for-each>


<!--
<xsl:if test="//params/logging/param[@name='tomcatResponseTime']/@value='true'">
<xsl:for-each select="//instances/instance[@type='app_server']"
>    scp $<xsl:value-of select="./@name"/>_HOST:$CATALINA_HOME/logs/localhost_* ./<xsl:value-of select="./@name"/>.log
    gzip <xsl:value-of select="./@name"/>.log
</xsl:for-each>
</xsl:if>  -->

<xsl:if test="//params/logging/param[@name='cjdbcResponseTime']/@value='true'">
<xsl:for-each select="//instances/instance[@type='cjdbc_server']"
>   #scp $<xsl:value-of select="./@name"/>_HOST:$CJDBC_HOME/log/response_time.log ./<xsl:value-of select="./@name"/>.log
    #gzip <xsl:value-of select="./@name"/>.log
    #scp $CJDBC_HOST:$CJDBC_HOME/log/*.log ./
    scp $CJDBC_HOST:$CJDBC_HOME/log/response_time.log ./CJDBC_response_time.log
</xsl:for-each>
</xsl:if>

<xsl:for-each select="//instances/instance[@type='db_server' and not(swname='postgres')]"
>    scp $<xsl:value-of select="./@name"/>_HOST:$MYSQL_HOME/run/mysqld-slow.log ./<xsl:value-of select="./@name"/>.log
    gzip <xsl:value-of select="./@name"/>.log
</xsl:for-each>

<!--
<xsl:if test="//params/logging/param[@name='mysqlResponseTime']/@value='true'">
<xsl:for-each select="//instances/instance[@type='db_server' and not(swname='postgres')]"
>    scp $<xsl:value-of select="./@name"/>_HOST:$MYSQL_HOME/run/mysqld-slow.log ./<xsl:value-of select="./@name"/>.log
    gzip <xsl:value-of select="./@name"/>.log
</xsl:for-each>
</xsl:if>
-->

<xsl:if test="//params/logging/param[@name='postgresResponseTime']/@value='true'">
<xsl:for-each select="//instances/instance[@type='db_server' and swname='postgres']"
>    scp $<xsl:value-of select="./@name"/>_HOST:$POSTGRES_HOME/data/logs/pg.log* ./<xsl:value-of select="./@name"/>.log
    gzip <xsl:value-of select="./@name"/>.log
</xsl:for-each>
</xsl:if>

scp $CJDBC_HOST:$CJDBC_HOME/log/*.log ./
scp $CJDBC_HOST:$CJDBC_HOME/bin/controller.sh ./
scp $CJDBC_HOST:$CJDBC_HOME/config/virtualdatabase/mysqldb-raidb1-elba.xml ./

cp -r $OUTPUT_HOME ./

<xsl:for-each select="//instances/instance[contains(@type, '_server') and @type!='control_server']"
> #  scp $<xsl:value-of select="./@name"/>_HOST:$RUBBOS_TOP/sar-* ./
  #  scp $<xsl:value-of select="./@name"/>_HOST:$RUBBOS_TOP/ps-* ./
  #  scp $<xsl:value-of select="./@name"/>_HOST:$RUBBOS_TOP/iostat-* ./
    scp $<xsl:value-of select="./@name"/>_HOST:$RUBBOS_TOP/mysql_mon-* ./
  #  scp $<xsl:value-of select="./@name"/>_HOST:$RUBBOS_TOP/postgres_lock-* ./
</xsl:for-each>
    ## collect esxtop information       
    #$OUTPUT_HOME/endEsxtopMonitor.sh
    $OUTPUT_HOME/endCollectl.sh
    cp /tmp/esxtopCPU*.csv ./
    cp /tmp/power*.csv ./
    cp /tmp/VMelba* ./

    cp /tmp/*raw.gz ./
    sleep 2

    cd ..
    mv 20* $TMP_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/
  "

  $OUTPUT_HOME/scripts/stop_all.sh
  #$OUTPUT_HOME/scripts/kill_all.sh
  sleep 15
  echo "End Browsing Only with $i"

  # Read/Write
  echo "Start Read/Write with $i"
  echo "Removing previous logs"
<!--
<xsl:for-each select="//instances/instance[@type='web_server']"
>  ssh $<xsl:value-of select="./@name"/>_HOST "rm -f $HTTPD_HOME/logs/*log"
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='app_server']"
>  ssh $<xsl:value-of select="./@name"/>_HOST "rm -f $CATALINA_HOME/logs/*"
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='cjdbc_server']"
>  ssh $<xsl:value-of select="./@name"/>_HOST "rm -f $CJDBC_HOME/log/*"
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='db_server' and not(swname='postgres')]"
>  ssh $<xsl:value-of select="./@name"/>_HOST "rm -f $MYSQL_HOME/run/*.log $RUBBOS_TOP/mysql_mon-*"
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='db_server' and swname='postgres']"
>  ssh $<xsl:value-of select="./@name"/>_HOST "rm -f $POSTGRES_HOME/data/logs/* $RUBBOS_TOP/postgres_lock-*"
</xsl:for-each>
  $OUTPUT_HOME/scripts/start_all.sh
  sleep 15

<xsl:for-each select="//instances/instance[contains(@type, '_server') and @type!='control_server']"
>  ssh $<xsl:value-of select="./@name"/>_HOST "rm -f $RUBBOS_TOP/sar-* $RUBBOS_TOP/ps-* $RUBBOS_TOP/iostat-*"
</xsl:for-each>

  ssh $BENCHMARK_HOST "
    source <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/set_elba_env.sh
    cd $RUBBOS_HOME/bench
    \rm -r 20*

    # Execute benchmark
    ./rubbos-servletsRW.sh

    # Collect results
    echo "The benchmark has finished. Now, collecting results..."
    cd 20*
<xsl:if test="//params/logging/param[@name='apacheResponseTime']/@value='true'">
<xsl:for-each select="//instances/instance[@type='web_server']">    
    scp -r $<xsl:value-of select="./@name"/>_HOST:$HTTPD_HOME/logs/*log ./<xsl:value-of select="./@name"/>.log
    gzip <xsl:value-of select="./@name"/>.log
</xsl:for-each>
</xsl:if>
<xsl:if test="//params/logging/param[@name='tomcatResponseTime']/@value='true'">
<xsl:for-each select="//instances/instance[@type='app_server']"
>    scp $<xsl:value-of select="./@name"/>_HOST:$CATALINA_HOME/logs/localhost.* ./<xsl:value-of select="./@name"/>.log
    gzip <xsl:value-of select="./@name"/>.log
</xsl:for-each>
</xsl:if>
<xsl:if test="//params/logging/param[@name='cjdbcResponseTime']/@value='true'">
<xsl:for-each select="//instances/instance[@type='cjdbc_server']"
>    scp $<xsl:value-of select="./@name"/>_HOST:$CJDBC_HOME/log/response_time.log ./<xsl:value-of select="./@name"/>.log
    gzip <xsl:value-of select="./@name"/>.log
</xsl:for-each>
</xsl:if>
<xsl:if test="//params/logging/param[@name='mysqlResponseTime']/@value='true'">
<xsl:for-each select="//instances/instance[@type='db_server' and not(swname='postgres')]"
>    scp $<xsl:value-of select="./@name"/>_HOST:$MYSQL_HOME/run/mysqld-slow.log ./<xsl:value-of select="./@name"/>.log
    gzip <xsl:value-of select="./@name"/>.log
</xsl:for-each>
</xsl:if>
<xsl:if test="//params/logging/param[@name='postgresResponseTime']/@value='true'">
<xsl:for-each select="//instances/instance[@type='db_server' and swname='postgres']"
>    scp $<xsl:value-of select="./@name"/>_HOST:$POSTGRES_HOME/data/logs/pg.log* ./<xsl:value-of select="./@name"/>.log
    gzip <xsl:value-of select="./@name"/>.log
</xsl:for-each>
</xsl:if>

<xsl:for-each select="//instances/instance[contains(@type, '_server') and @type!='control_server']"
>    scp $<xsl:value-of select="./@name"/>_HOST:$RUBBOS_TOP/sar-* ./
    scp $<xsl:value-of select="./@name"/>_HOST:$RUBBOS_TOP/ps-* ./
    scp $<xsl:value-of select="./@name"/>_HOST:$RUBBOS_TOP/iostat-* ./
    scp $<xsl:value-of select="./@name"/>_HOST:$RUBBOS_TOP/mysql_mon-* ./
    scp $<xsl:value-of select="./@name"/>_HOST:$RUBBOS_TOP/postgres_lock-* ./
</xsl:for-each>
    cd ..
    mv 20* $TMP_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/
  "

  #$OUTPUT_HOME/scripts/stop_all.sh
  $OUTPUT_HOME/scripts/kill_all.sh
  sleep 15
-->
  echo "End Read/Write with $i"

done

echo "Processing the results..."
ssh $BENCHMARK_HOST "
  cd $TMP_RESULTS_DIR_BASE
  cd $RUBBOS_RESULTS_DIR_NAME
  scp $RUBBOS_RESULTS_HOST:$RUBBOS_RESULTS_DIR_BASE/calc-sarSummary.prl ../
  cp <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/set_elba_env.sh ./

  ../calc-sarSummary.prl
<xsl:if test="//params/logging/param[@name='apacheResponseTime']/@value='true'">
  scp $RUBBOS_RESULTS_HOST:$RUBBOS_RESULTS_DIR_BASE/calc-durationTime.prl ../
<xsl:choose>
<xsl:when test="//params/logging/param[@name='tomcatResponseTime' and @value='true']/sampling/@ratio and
                //params/logging/param[@name='tomcatResponseTime' and @value='true']/sampling/@ratio and
                //params/logging/param[@name='tomcatResponseTime' and @value='true']/sampling/@ratio">
  ../calc-durationTime.prl <xsl:value-of select="//params/logging/param[@name='tomcatResponseTime' and @value='true']/sampling/@ratio"/><xsl:text> </xsl:text><xsl:value-of select="//params/logging/param[@name='cjdbcResponseTime' and @value='true']/sampling/@ratio"/><xsl:text> </xsl:text><xsl:value-of select="//params/logging/param[@name='mysqlResponseTime' and @value='true']/sampling/@ratio"/> 
</xsl:when>
<xsl:otherwise>
  ../calc-durationTime.prl
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="//params/rubbos-conf/param[@name='removeBinFiles']/@value='true'">
  rm -f 20*/*.bin
</xsl:if>
  cd ../
  tar zcvf $RUBBOS_RESULTS_DIR_NAME.tgz $RUBBOS_RESULTS_DIR_NAME
  #scp $RUBBOS_RESULTS_DIR_NAME.tgz $RUBBOS_RESULTS_HOST:$RUBBOS_RESULTS_DIR_BASE/
"

echo "Finish Experiment RUBBoS"

sleep 10

echo "Start processing RUBBoS experimental results in Bonn"

#ssh $BONN_HOST "
  
  cd $BONN_RUBBOS_RESULTS_DIR_BASE
  scp $BENCHMARK_HOST:$TMP_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME.tgz .
  tar -xzvf $RUBBOS_RESULTS_DIR_NAME.tgz

  cd $RUBBOS_RESULTS_DIR_NAME
  cp $BONN_SCRIPTS_BASE/generateResult.sh ./
  cp $BONN_SCRIPTS_BASE/transferScripts.sh ./
  cp $BONN_SCRIPTS_BASE/data*.py ./

  cp $BONN_SCRIPTS_BASE/hshan_debug.sh ./

  cp $BONN_SCRIPTS_BASE/aggregate*.py ./

#temp
# cp /sshfsmount/elba_script/set_elba_env.sh ./

  ./generateResult.sh
  sleep 2
#  ./transferScripts.sh
#"
echo "Finish processing RUBBoS Result in Bonn"


#sleep 10
#echo "start processing RUBBoS experimental SysViz result"
#ssh $SYSVIZ_HOST "
cd $SYSVIZ_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME
cp $BONN_SCRIPTS_BASE/resultAnalysis.sh ./
#cp $BONN_SCRIPTS_BASE/rubbosAnalyze10_linux_4tier_middleTwoTier.py ./

cp $BONN_SCRIPTS_BASE/gen_*.sh ./
cp $BONN_SCRIPTS_BASE/Pre_*.py ./

chmod 777 $SYSVIZ_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/*.sh
chmod 777 $SYSVIZ_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME/*.py

cd $SYSVIZ_RUBBOS_RESULTS_DIR_BASE/$RUBBOS_RESULTS_DIR_NAME
./protoTimeWindows.sh
./resultAnalysis.sh
#pwd
./gen_graph_main.sh
./hshan_debug.sh

#"

echo "Finish RUBBoS"



<xsl:for-each select="//params/workloads/param[@name='workload']">
<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>rubbos.properties_<xsl:value-of select="./@value"/><xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/rubbos_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
#n HTTP server information
httpd_hostname = <xsl:value-of select="//instances/instance[@type='web_server']/target"/>
httpd_port = 8000

# C/JDBC server to monitor (if any)
<xsl:choose>
  <xsl:when test="//instances/instance[@type='cjdbc_server']"><!--
    -->cjdbc_hostname = <xsl:value-of select="//instances/instance[@type='cjdbc_server']/target"/></xsl:when>
  <xsl:when test="//instances/instance[@type='sequoia_server']"><!--
    -->cjdbc_hostname = <xsl:value-of select="//instances/instance[@type='sequoia_server']/target"/></xsl:when>
  <xsl:otherwise>cjdbc_hostname =</xsl:otherwise>
</xsl:choose>

# Precise which version to use. Valid options are : PHP, Servlets, EJB
httpd_use_version = Servlets

# EJB server information
ejb_server =
ejb_html_path =
ejb_script_path =

# Servlets server information
servlets_server = <xsl:value-of select="//instances/instance[@type='app_server']/target"/>
servlets_html_path = /rubbos
<xsl:variable name="first" select="//instances/instance[@type='app_server'][1]/target"/>
servlets_servers = <xsl:for-each select="//instances/instance[@type='app_server']"><xsl:variable name="name" select="./target"/><xsl:if test="$name != $first">,</xsl:if><xsl:value-of select="$name"/></xsl:for-each>
servlets_script_path = /rubbos/servlet
servlets_singleServlet_path = /rubbos/servlet/edu.rice.rubbos.servlets.StoriesOfTheDay

# PHP information
php_html_path = /PHP
php_script_path = /PHP

#Database information
database_master_server = <xsl:value-of select="//instances/instance[@type='db_server']/target"/>
<xsl:variable name="first" select="//instances/instance[@type='db_server'][1]/target"/>
database_servers = <xsl:for-each select="//instances/instance[@type='db_server']"
  ><xsl:variable name="name" select="./target"
  /><xsl:if test="$name != $first">,</xsl:if><xsl:value-of select="$name"/></xsl:for-each>

<!--database_slave_servers = 
<xsl:variable name="first" select="//instances/instance[@type='client_server'][1]/target"/>
workload_remote_client_nodes = <xsl:for-each select="//instances/instance[@type='client_server']"><xsl:variable name="name" select="./target"/><xsl:if test="$name != $first">,</xsl:if><xsl:value-of select="$name"/></xsl:for-each>
-->

database_slave_servers =
<xsl:variable name="first" select="//instances/instance[@type='client_server'][1]/target"
/>workload_remote_client_nodes = <xsl:for-each select="//instances/instance[@type='client_server']"
  ><xsl:variable name="name" select="./target"
  /><xsl:if test="$name != $first">,</xsl:if><xsl:value-of select="$name"/></xsl:for-each>



workload_benchmark_node = <xsl:value-of select="//instances/instance[@type='benchmark_server']/target"/>

workload_remote_client_command = <xsl:value-of select="//params/env/param[@name='JAVA_HOME']/@value"/>/bin/java -classpath .:<xsl:value-of select="//params/env/param[@name='RUBBOS_HOME']/@value"
  />/Client/:<xsl:value-of select="//params/env/param[@name='RUBBOS_HOME']/@value"
  />/Client/rubbos_client.jar <xsl:value-of select="//params/env/param[@name='JAVA_OPTS']/@value"
  /> -Dhttp.keepAlive=true -Dhttp.maxConnections=1000000 edu.rice.rubbos.client.ClientEmulator

<xsl:variable name="client_num" select="count(//instances/instance[@type='client_server']) + 1"/>
workload_number_of_clients_per_node = <xsl:value-of select="./@value div $client_num"/>

# Workload: precise which transition table to use
workload_user_transition_table = <xsl:value-of select="//params/env/param[@name='RUBBOS_HOME']/@value"
  />/workload/user_transitions.txt
workload_author_transition_table = <xsl:value-of select="//params/env/param[@name='RUBBOS_HOME']/@value"
  />/workload/author_transitions.txt
workload_number_of_columns = 24
workload_number_of_rows = 26
workload_maximum_number_of_transitions = 1000
workload_use_tpcw_think_time = yes
workload_tpcw_think_time = 7000
workload_number_of_stories_per_page = 20
<xsl:choose>
  <xsl:when test="//params/rubbos-conf/param[@name='upRampTime']">
workload_up_ramp_time_in_ms = <xsl:value-of select="//params/rubbos-conf/param[@name='upRampTime']/@value"/>
  </xsl:when>
  <xsl:otherwise>
workload_up_ramp_time_in_ms = 180000
  </xsl:otherwise>
</xsl:choose>
workload_up_ramp_slowdown_factor = 2
<xsl:choose>
  <xsl:when test="//params/rubbos-conf/param[@name='runTime']">
workload_session_run_time_in_ms = <xsl:value-of select="//params/rubbos-conf/param[@name='runTime']/@value"/>
  </xsl:when>
  <xsl:otherwise>
workload_session_run_time_in_ms = 720000
  </xsl:otherwise>
</xsl:choose>
<xsl:choose>
  <xsl:when test="//params/rubbos-conf/param[@name='downRampTime']">
workload_down_ramp_time_in_ms = <xsl:value-of select="//params/rubbos-conf/param[@name='downRampTime']/@value"/>
  </xsl:when>
  <xsl:otherwise>
workload_down_ramp_time_in_ms = 30000
  </xsl:otherwise>
</xsl:choose>
workload_down_ramp_slowdown_factor = 3
workload_percentage_of_author = 10

# Users policy
database_number_of_authors = 50
database_number_of_users = 500000

# Stories policy
database_story_dictionnary = <xsl:value-of select="//params/env/param[@name='RUBBOS_HOME']/@value"
  />/database/dictionary
database_story_maximum_length = 1024
database_oldest_story_year = 1998
database_oldest_story_month = 1

# Comments policy
database_comment_max_length = 1024


# Monitoring Information
monitoring_debug_level = 1
#monitoring_program = <xsl:value-of select="//params/env/param[@name='SYSSTAT_HOME']/@value" />/sar
monitoring_program = /usr/bin/sar
monitoring_options = -n DEV -n SOCK -rubw
monitoring_sampling_in_seconds = 1
monitoring_rsh = /usr/bin/ssh
monitoring_scp = /usr/bin/scp
monitoring_gnuplot_terminal = png

</content>
</file>
</xsl:for-each>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>start_all.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/scripts<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

<xsl:apply-templates select="//instances/instance/action[contains(@type,'ignition')]">
  <xsl:sort select="./@seq" data-type="number"/>
</xsl:apply-templates>

</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>stop_all.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/scripts<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

<xsl:apply-templates select="//instances/instance/action[@type='stop']">
  <xsl:sort select="./@seq" data-type="number"/>
</xsl:apply-templates>

</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>kill_all.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/scripts<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

$OUTPUT_HOME/scripts/stop_all.sh

for i in<xsl:for-each select="//instances/instance[contains(@type, '_server') and @type!='control_server']"
> "$<xsl:value-of select="./@name"/>_HOST"</xsl:for-each>
do
  ssh $i "
        kill -9 -1
    "
done

</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>reset_all.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/scripts<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

<xsl:apply-templates select="//instances/instance/action[@type='reset']">
  <xsl:sort select="./@seq" data-type="number"/>
</xsl:apply-templates>

sleep 120

</content>
</file>


</xsl:template>


<xsl:template match="//instances/instance/action">
<xsl:text disable-output-escaping="yes">&lt;argshere type=&quot;pre-action&quot; id=&quot;</xsl:text><xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh<xsl:text disable-output-escaping="yes">&quot; idtype=&quot;</xsl:text><xsl:value-of select="../@type"/><xsl:text disable-output-escaping="yes">&quot; actype=&quot;</xsl:text><xsl:value-of select="./@type"/><xsl:text disable-output-escaping="yes">&quot; instname=&quot;</xsl:text><xsl:value-of select="../@name"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
ssh $<xsl:value-of select="../@name"/>_HOST <xsl:value-of select="./@nice"/> /tmp/<xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh <xsl:text disable-output-escaping="yes">&lt;argshere type=&quot;current&quot; id=&quot;</xsl:text><xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh<xsl:text disable-output-escaping="yes">&quot; idtype=&quot;</xsl:text><xsl:value-of select="../@type"/><xsl:text disable-output-escaping="yes">&quot; actype=&quot;</xsl:text><xsl:value-of select="./@type"/><xsl:text disable-output-escaping="yes">&quot; instname=&quot;</xsl:text><xsl:value-of select="../@name"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<xsl:text disable-output-escaping="yes">&lt;argshere type=&quot;post-action&quot; id=&quot;</xsl:text><xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh<xsl:text disable-output-escaping="yes">&quot; idtype=&quot;</xsl:text><xsl:value-of select="../@type"/><xsl:text disable-output-escaping="yes">&quot; actype=&quot;</xsl:text><xsl:value-of select="./@type"/><xsl:text disable-output-escaping="yes">&quot; instname=&quot;</xsl:text><xsl:value-of select="../@name"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
</xsl:template>
<!--
<xsl:template match="//instances/instance/action">
ssh $<xsl:value-of select="../@name"/>_HOST /tmp/<xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh
sleep 5
</xsl:template>
-->
</xsl:stylesheet>
