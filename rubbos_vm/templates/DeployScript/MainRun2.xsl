<?xml version="1.0" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:datetime="http://exslt.org/dates-and-times">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/" >
<whatever>
<xsl:copy-of select="."/> <xsl:text>  

</xsl:text>
  <xsl:apply-templates select="/xtbl/instances" /> <xsl:text> 
</xsl:text>
</whatever>
</xsl:template>



<xsl:template match="/xtbl/instances">


<!--CREATING THE run.sh FILE-->
<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>run.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/scripts<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/scripts


# Transfer all sub scripts to target hosts
echo "*** scp scripts *************************************************"
<xsl:for-each select="//instances/instance">
ssh $<xsl:value-of select="./@name"/>_HOST rm /tmp/*.sh -rf
scp -o StrictHostKeyChecking=no -o BatchMode=yes ../set_elba_env.sh  $<xsl:value-of select="./@name"/>_HOST:/tmp
scp -o StrictHostKeyChecking=no -o BatchMode=yes ../endCollectl.sh  $<xsl:value-of select="./@name"/>_HOST:/tmp
scp -o StrictHostKeyChecking=no -o BatchMode=yes ../collectlMonitor.sh  $<xsl:value-of select="./@name"/>_HOST:/tmp
#scp -o StrictHostKeyChecking=no -o BatchMode=yes ../cpu_mem.sh  $<xsl:value-of select="./@name"/>_HOST:/tmp

</xsl:for-each>
<xsl:for-each select="//instances/instance/action">
scp -o StrictHostKeyChecking=no -o BatchMode=yes <xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh  $<xsl:value-of select="../@name"/>_HOST:/tmp
</xsl:for-each>

# Install and Configure and run Apache, Tomcat, CJDBC, and MySQL
echo "*** install scripts &amp; configure &amp; execute ***********************"
<xsl:apply-templates select="/xtbl/instances/instance/action[contains(@type,'install') and not(contains(@type,'uninstall')) or contains(@type,'configure') or contains(@type,'_exec')]">
  <xsl:sort select="./@seq" data-type="number"/>
</xsl:apply-templates>


<!--
# Uninstall all
<xsl:apply-templates select="/xtbl/instances/instance/action[contains(@type,'uninstall')]">
  <xsl:sort select="./@seq" data-type="number"/>
</xsl:apply-templates>


# cleanup after experiments
echo "Cleaning up ...."
<xsl:for-each select="//instances/instance/action">
ssh $<xsl:value-of select="../@name"/>_HOST  rm -f /tmp/<xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh
</xsl:for-each>
-->

</content>
</file>


<xsl:text> 
</xsl:text>
<xsl:for-each select="/xtbl/instances/instance/action">
<xsl:text>
</xsl:text>

<file>

<xsl:text> 
</xsl:text>

<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text><xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/scripts<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>

<xsl:text> 
</xsl:text>

<content>

<xsl:text> 
</xsl:text>

<xsl:text disable-output-escaping="yes">&lt;pastehere id=&quot;</xsl:text><xsl:value-of select="./@template"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<xsl:text> 
</xsl:text>

</content>
</file>

<xsl:text>
</xsl:text>
</xsl:for-each>
<xsl:text>
</xsl:text>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>set_elba_env.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
#!/bin/bash

set -o allexport

# HOSTS
<xsl:for-each select="//instances/instance[@type='control_server']">
  <xsl:value-of select="./@name"/>_HOST=<xsl:value-of select="./target"/><br></br>
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='benchmark_server']">
  <xsl:value-of select="./@name"/>_HOST=<xsl:value-of select="./target"/><br></br>
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='client_server']">
  <xsl:value-of select="./@name"/>_HOST=<xsl:value-of select="./target"/><br></br>
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='web_server']">
  <xsl:value-of select="./@name"/>_HOST=<xsl:value-of select="./target"/><br></br>
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='app_server']">
  <xsl:value-of select="./@name"/>_HOST=<xsl:value-of select="./target"/><br></br>
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='cjdbc_server']">
  <xsl:value-of select="./@name"/>_HOST=<xsl:value-of select="./target"/><br></br>
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='sequoia_server']">
  <xsl:value-of select="./@name"/>_HOST=<xsl:value-of select="./target"/><br></br>
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='db_server']">
  <xsl:value-of select="./@name"/>_HOST=<xsl:value-of select="./target"/><br></br>
</xsl:for-each>


# Experiment name on Emulab
EMULAB_EXPERIMENT_NAME=<xsl:value-of select="//params/env/param[@name='EMULAB_EXPERIMENT_NAME']/@value"/>
EXPERIMENT_CONFIG=<xsl:value-of select="//params/env/param[@name='EXPERIMENT_CONFIG']/@value"/>
EXPERIMENT_CONFIG_TIERS=<xsl:value-of select="//params/env/param[@name='EXPERIMENT_CONFIG_TIERS']/@value"/>

# Directories from which files are copied
WORK_HOME=<xsl:value-of select="//params/env/param[@name='WORK_HOME']/@value"/>
OUTPUT_HOME=<xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
SOFTWARE_HOME=<xsl:value-of select="//params/env/param[@name='SOFTWARE_HOME']/@value"/>

# Output directory for results of RUBBoS benchmark
RUBBOS_RESULTS_HOST=<xsl:value-of select="//params/env/param[@name='RUBBOS_RESULTS_HOST']/@value"/>
RUBBOS_RESULTS_DIR_BASE=<xsl:value-of select="//params/env/param[@name='RUBBOS_RESULTS_DIR_BASE']/@value"/>
RUBBOS_RESULTS_DIR_NAME=<xsl:value-of select="translate(datetime:dateTime(),':','')"/>_<xsl:value-of select="//params/env/param[@name='EXPERIMENT_CONFIG']/@value"/>

# Output directory for results of RUBBoS benchmark on Bonn and SysViz servers
BONN_HOST=<xsl:value-of select="//params/env/param[@name='RUBBOS_RESULTS_HOST']/@value"/>
BONN_RUBBOS_RESULTS_DIR_BASE=<xsl:value-of select="//params/env/param[@name='RUBBOS_RESULTS_DIR_BASE']/@value"/>
BONN_SCRIPTS_BASE=<xsl:value-of select="//params/env/param[@name='BONN_SCRIPTS_BASE']/@value"/>


SYSVIZ_HOST=hdp1
SYSVIZ_RUBBOS_RESULTS_DIR_BASE=/home/hshan/rubbos/results





# Target directories
ELBA_TOP=<xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
RUBBOS_TOP=<xsl:value-of select="//params/env/param[@name='RUBBOS_TOP']/@value"/>
TMP_RESULTS_DIR_BASE=<xsl:value-of select="//params/env/param[@name='TMP_RESULTS_DIR_BASE']/@value"/>
RUBBOS_HOME=<xsl:value-of select="//params/env/param[@name='RUBBOS_HOME']/@value"/>
SYSSTAT_HOME=<xsl:value-of select="//params/env/param[@name='SYSSTAT_HOME']/@value"/>
HTTPD_HOME=<xsl:value-of select="//params/env/param[@name='HTTPD_HOME']/@value"/>
HTTPD_INSTALL_FILES=<xsl:value-of select="//params/env/param[@name='HTTPD_INSTALL_FILES']/@value"/>
MOD_JK_INSTALL_FILES=<xsl:value-of select="//params/env/param[@name='MOD_JK_INSTALL_FILES']/@value"/>
CATALINA_HOME=<xsl:value-of select="//params/env/param[@name='CATALINA_HOME']/@value"/>
CATALINA_BASE=<xsl:value-of select="//params/env/param[@name='CATALINA_BASE']/@value"/>
CJDBC_HOME=<xsl:value-of select="//params/env/param[@name='CJDBC_HOME']/@value"/>
<xsl:if test="//params/env/param[@name='SEQUOIA_HOME']">
SEQUOIA_HOME=<xsl:value-of select="//params/env/param[@name='SEQUOIA_HOME']/@value"/>
</xsl:if>
<xsl:if test="//params/env/param[@name='MYSQL_HOME']">
MYSQL_HOME=<xsl:value-of select="//params/env/param[@name='MYSQL_HOME']/@value"/>
</xsl:if>
<xsl:if test="//params/env/param[@name='POSTGRES_HOME']">
POSTGRES_HOME=<xsl:value-of select="//params/env/param[@name='POSTGRES_HOME']/@value"/>
POSTGRES_INSTALL_FILES=<xsl:value-of select="//params/env/param[@name='POSTGRES_INSTALL_FILES']/@value"/>
</xsl:if>
JONAS_ROOT=<xsl:value-of select="//params/env/param[@name='JONAS_ROOT']/@value"/>

# Java &amp; Ant
JAVA_HOME=<xsl:value-of select="//params/env/param[@name='JAVA_HOME']/@value"/>
JAVA_OPTS="<xsl:value-of select="//params/env/param[@name='JAVA_OPTS']/@value"/>"
J2EE_HOME=<xsl:value-of select="//params/env/param[@name='J2EE_HOME']/@value"/>
ANT_HOME=<xsl:value-of select="//params/env/param[@name='ANT_HOME']/@value"/>

# Tarballs
JAVA_TARBALL=<xsl:value-of select="//params/env/param[@name='JAVA_TARBALL']/@value"/>
J2EE_TARBALL=<xsl:value-of select="//params/env/param[@name='J2EE_TARBALL']/@value"/>
ANT_TARBALL=<xsl:value-of select="//params/env/param[@name='ANT_TARBALL']/@value"/>
SYSSTAT_TARBALL=<xsl:value-of select="//params/env/param[@name='SYSSTAT_TARBALL']/@value"/>
HTTPD_TARBALL=<xsl:value-of select="//params/env/param[@name='HTTPD_TARBALL']/@value"/>
MOD_JK_TARBALL=<xsl:value-of select="//params/env/param[@name='MOD_JK_TARBALL']/@value"/>
TOMCAT_TARBALL=<xsl:value-of select="//params/env/param[@name='TOMCAT_TARBALL']/@value"/>
CJDBC_TARBALL=<xsl:value-of select="//params/env/param[@name='CJDBC_TARBALL']/@value"/>
<xsl:if test="//params/env/param[@name='SEQUOIA_HOME']">
SEQUOIA_TARBALL=<xsl:value-of select="//params/env/param[@name='SEQUOIA_TARBALL']/@value"/>
</xsl:if>
<xsl:if test="//params/env/param[@name='MYSQL_HOME']">
<xsl:choose>
  <xsl:when test="//params/logging/param[@name='mysqlResponseTime']/@value='true'">
MYSQL_TARBALL_RT=<xsl:value-of select="//params/env/param[@name='MYSQL_TARBALL_RT']/@value"/>
  </xsl:when>
  <xsl:otherwise>
MYSQL_TARBALL=<xsl:value-of select="//params/env/param[@name='MYSQL_TARBALL']/@value"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="//params/env/param[@name='POSTGRES_HOME']">
POSTGRES_TARBALL=<xsl:value-of select="//params/env/param[@name='POSTGRES_TARBALL']/@value"/>
</xsl:if>
RUBBOS_TARBALL=<xsl:value-of select="//params/env/param[@name='RUBBOS_TARBALL']/@value"/>
RUBBOS_DATA_TARBALL=<xsl:value-of select="//params/env/param[@name='RUBBOS_DATA_TARBALL']/@value"/>
RUBBOS_DATA_TEXTFILES_TARBALL=<xsl:value-of select="//params/env/param[@name='RUBBOS_DATA_TEXTFILES_TARBALL']/@value"/>

<xsl:if test="//params/env/param[@name='MYSQL_HOME']">

# for MySQL
MYSQL_CONNECTOR=<xsl:value-of select="//params/env/param[@name='MYSQL_CONNECTOR']/@value"/>
MYSQL_PORT=<xsl:value-of select="//params/env/param[@name='MYSQL_PORT']/@value"/>
MYSQL_SOCKET=<xsl:value-of select="//params/env/param[@name='MYSQL_SOCKET']/@value"/>
MYSQL_DATA_DIR=<xsl:value-of select="//params/env/param[@name='MYSQL_DATA_DIR']/@value"/>
MYSQL_ERR_LOG=<xsl:value-of select="//params/env/param[@name='MYSQL_ERR_LOG']/@value"/>
MYSQL_PID_FILE=<xsl:value-of select="//params/env/param[@name='MYSQL_PID_FILE']/@value"/>
</xsl:if>

<xsl:if test="//params/env/param[@name='POSTGRES_HOME']">

# for PostgreSQL
POSTGRES_CONNECTOR=<xsl:value-of select="//params/env/param[@name='POSTGRES_CONNECTOR']/@value"/>
POSTGRES_DATA_DIR=<xsl:value-of select="//params/env/param[@name='POSTGRES_DATA_DIR']/@value"/>
</xsl:if>

# for DBs &amp; C-JDBC
ROOT_PASSWORD=<xsl:value-of select="//params/env/param[@name='ROOT_PASSWORD']/@value"/>
ELBA_USER=<xsl:value-of select="//params/env/param[@name='ELBA_USER']/@value"/>
ELBA_PASSWORD=<xsl:value-of select="//params/env/param[@name='ELBA_PASSWORD']/@value"/>


CLASSPATH=$CLASSPATH:$JONAS_ROOT/bin/unix/registry:$JAVA_HOME:$JAVA_HOME/lib/tools.jar:$CATALINA_HOME/lib/servlet-api.jar:$CATALINA_HOME/common/lib/servlet-api.jar:.:$RUBBOS_HOME/Servlet_HTML/WEB-INF/lib/log4j.jar

PATH=$JAVA_HOME/bin:$JONAS_ROOT/bin/unix:$ANT_HOME/bin:$CATALINA_HOME/bin:$PATH
set +o allexport

</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>nsFile.txt<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
set ns [new Simulator]
source tb_compat.tcl

<xsl:for-each select="//instances/instance[contains(@type,'_server')]">
set <xsl:value-of select="./target"/> [$ns node]
tb-set-node-os $<xsl:value-of select="./target"/> FC4-RUBBoS
tb-set-hardware $<xsl:value-of select="./target"/> pc3000
</xsl:for-each>
set lan1 [$ns make-lan "<xsl:for-each select="//instances/instance[@type='control_server']"
>$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>
<xsl:for-each select="//instances/instance[@type='benchmark_server']"
>$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>
<xsl:for-each select="//instances/instance[@type='client_server']"
>$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>
<xsl:for-each select="//instances/instance[@type='web_server']"
>$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>" 1000Mb 0ms]
set lan2 [$ns make-lan "<xsl:for-each select="//instances/instance[@type='web_server']"
>$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>
<xsl:for-each select="//instances/instance[@type='app_server']"
>$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>" 1000Mb 0ms]
<xsl:choose>
<xsl:when test="//instances/instance[@type='cjdbc_server']"
>set lan3 [$ns make-lan "<xsl:for-each select="//instances/instance[@type='app_server']"
  >$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>
  <xsl:for-each select="//instances/instance[@type='cjdbc_server']"
  >$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>" 1000Mb 0ms]
set lan4 [$ns make-lan "<xsl:for-each select="//instances/instance[@type='cjdbc_server']"
  >$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>
  <xsl:for-each select="//instances/instance[@type='db_server']"
  >$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>" 1000Mb 0ms]
</xsl:when>
<xsl:when test="//instances/instance[@type='sequoia_server']"
>set lan3 [$ns make-lan "<xsl:for-each select="//instances/instance[@type='app_server']"
  >$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>
  <xsl:for-each select="//instances/instance[@type='sequoia_server']"
  >$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>" 1000Mb 0ms]
set lan4 [$ns make-lan "<xsl:for-each select="//instances/instance[@type='sequoia_server']"
  >$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>
  <xsl:for-each select="//instances/instance[@type='db_server']"
  >$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>" 1000Mb 0ms]
</xsl:when>
<xsl:otherwise
>set lan4 [$ns make-lan "<xsl:for-each select="//instances/instance[@type='app_server']"
  >$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>
  <xsl:for-each select="//instances/instance[@type='db_server']"
  >$<xsl:value-of select="./target"/><xsl:text> </xsl:text></xsl:for-each>" 1000Mb 0ms]
</xsl:otherwise>
</xsl:choose>

$ns rtproto Static
$ns run
</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>manualCleanup.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/scripts<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "Uninstalling ...."
<xsl:for-each select="//instances/instance/action[@type='uninstall']">
ssh $<xsl:value-of select="../@name"/>_HOST /tmp/<xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh</xsl:for-each>

echo "Cleaning up ...."
for i in<xsl:for-each select="//instances/instance[contains(@type, '_server') and @type!='control_server']"
> "$<xsl:value-of select="./@name"/>_HOST"</xsl:for-each>
do
  ssh $i "
    sudo \rm -r $RUBBOS_TOP
    "
done

<xsl:for-each select="//instances/instance/action">
ssh $<xsl:value-of select="../@name"/>_HOST  rm -f /tmp/<xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh</xsl:for-each>

</content>
</file>

</xsl:template>


<xsl:template match="/xtbl/instances/instance/action">
<xsl:text disable-output-escaping="yes">&lt;argshere type=&quot;pre-action&quot; id=&quot;</xsl:text><xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh<xsl:text disable-output-escaping="yes">&quot; idtype=&quot;</xsl:text><xsl:value-of select="../@type"/><xsl:text disable-output-escaping="yes">&quot; actype=&quot;</xsl:text><xsl:value-of select="./@type"/><xsl:text disable-output-escaping="yes">&quot; instname=&quot;</xsl:text><xsl:value-of select="../@name"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
ssh $<xsl:value-of select="../@name"/>_HOST /tmp/<xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh <xsl:text disable-output-escaping="yes">&lt;argshere type=&quot;current&quot; id=&quot;</xsl:text><xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh<xsl:text disable-output-escaping="yes">&quot; idtype=&quot;</xsl:text><xsl:value-of select="../@type"/><xsl:text disable-output-escaping="yes">&quot; actype=&quot;</xsl:text><xsl:value-of select="./@type"/><xsl:text disable-output-escaping="yes">&quot; instname=&quot;</xsl:text><xsl:value-of select="../@name"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<xsl:text disable-output-escaping="yes">&lt;argshere type=&quot;post-action&quot; id=&quot;</xsl:text><xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh<xsl:text disable-output-escaping="yes">&quot; idtype=&quot;</xsl:text><xsl:value-of select="../@type"/><xsl:text disable-output-escaping="yes">&quot; actype=&quot;</xsl:text><xsl:value-of select="./@type"/><xsl:text disable-output-escaping="yes">&quot; instname=&quot;</xsl:text><xsl:value-of select="../@name"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
</xsl:template>


</xsl:stylesheet>









