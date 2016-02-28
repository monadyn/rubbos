<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='configure' and @type='current']">  &amp;  </xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='configure' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='app_server' and @actype='configure' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/TOMCATconfigure.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh

#cd $RUBIS_TOP/jonas-3-3-6
cd $RUBIS_TOP/JONAS_4_6_6
ant install

cd $WORK_HOME
cp softwares/mysql-connector-java-3.0.11-stable-bin.jar $RUBIS_TOP/JONAS_4_6_6/lib/ext/.
#cp softwares/mysql-connector-java-3.0.11-stable-bin.jar $RUBIS_TOP/jonas-3-3-6/lib/ext/.
cp $RUBISWORK_HOME/softwares/c-jdbc-latest-bin/drivers/c-jdbc-driver.jar $RUBIS_TOP/JONAS_4_6_6/lib/ext/.

cp $RUBISWORK_HOME/jonas_conf/jonas.properties $RUBIS_TOP/JONAS_4_6_6/conf/jonas.properties
#cp $RUBISWORK_HOME/jonas_conf/jonas.properties $RUBIS_TOP/jonas-3-3-6/conf/jonas.properties
cp $RUBISWORK_HOME/jonas_conf/MySQL.properties $RUBIS_TOP/JONAS_4_6_6/conf/MySQL.properties
#cp $RUBISWORK_HOME/jonas_conf/MySQL.properties $RUBIS_TOP/jonas-3-3-6/conf/MySQL.properties
cp $RUBISWORK_HOME/jonas_conf/jonas $RUBIS_TOP/JONAS_4_6_6/bin/unix/.
#cp $RUBISWORK_HOME/jonas_conf/jonas $RUBIS_TOP/jonas-3-3-6/bin/unix/.
#need to change rubis.jar to share in cluster
cp $RUBISWORK_HOME/softwares/non_instrument_ver/rubis.jar $RUBIS_TOP/JONAS_4_6_6/ejbjars/autoload/.
#cp $RUBISWORK_HOME/softwares/non_instrument_ver/rubis.jar $RUBIS_TOP/jonas-3-3-6/ejbjars/autoload/.

#cd $RUBIS_TOP/apache-tomcat-5.5.16
cd $RUBIS_TOP/jakarta-tomcat-5.0.28
cp $RUBISWORK_HOME/tomcat_conf/server.xml conf/.
#cp $RUBISWORK_HOME/softwares/non_instrument_ver/ejb_rubis_web.war $RUBIS_TOP/apache-tomcat-5.5.16/webapps/.
cp $RUBISWORK_HOME/softwares/non_instrument_ver/ejb_rubis_web.war $RUBIS_TOP/jakarta-tomcat-5.0.28/webapps/.
cp -R $RUBISWORK_HOME/softwares/RUBiS/ejb_rubis_web $RUBIS_TOP/.
#cp $WORK_HOME/softwares/mysql-connector-java-3.0.11-stable-bin.jar $RUBIS_TOP/apache-tomcat-5.5.16/common/lib/.
cp $WORK_HOME/softwares/mysql-connector-java-3.0.11-stable-bin.jar $RUBIS_TOP/jakarta-tomcat-5.0.28/common/lib/.
cp $RUBISWORK_HOME/softwares/c-jdbc-latest-bin/drivers/c-jdbc-driver.jar $RUBIS_TOP/jakarta-tomcat-5.0.28/common/lib/.

cp $RUBISWORK_HOME/tomcat_conf/carol-all-2.0.5.jar $RUBIS_TOP/.
cp $RUBISWORK_HOME/tomcat_conf/client.jar $RUBIS_TOP/.
cp $RUBISWORK_HOME/tomcat_conf/rubis.jar $RUBIS_TOP/.
cp $RUBISWORK_HOME/tomcat_conf/catalina.sh $RUBIS_TOP/jakarta-tomcat-5.0.28/bin/.


chmod -R 777 $ELBA_TOP



<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>MySQL.properties<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>/jonas_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>

###################### MySQL DataSource configuration example
#

datasource.name                 mysql
datasource.url                  jdbc:cjdbc://<xsl:value-of select="//instances/instance[@type='cjdbc_controller']/target"/>/rubis
datasource.classname            org.objectweb.cjdbc.driver.Driver
datasource.username             root
datasource.password             rubis
#datasource.mapper               rdb.mysql

#####
#  ConnectionManager configuration
#

#  JDBC connection checking level.
#     0 = no special checking
#     1 = check physical connection is still open before reusing it
#     2 = try every connection before reusing it
jdbc.connchecklevel	0

#  Max age for jdbc connections
#  nb of minutes a connection can be kept in the pool
# By default mySQL has a timeout every 8 hours, use a value of 7h
jdbc.connmaxage		420

# Maximum time (in mn) a connection can be left busy.
# If the caller has not issued a close() during this time, the connection
# will be closed automatically.
jdbc.maxopentime	60

#  Test statement
jdbc.connteststmt	select 1

# JDBC Connection Pool size.
# Limiting the max pool size avoids errors from database.
#jdbc.minconpool		10
#jdbc.maxconpool		30
jdbc.minconpool		100
jdbc.maxconpool		300

# Sampling period for JDBC monitoring :
# nb of seconds between 2 measures.
jdbc.samplingperiod	30

# Maximum time (in seconds) to wait for a connection in case of shortage.
# This may occur only when maxconpool is reached.
jdbc.maxwaittime	5

# Maximum of concurrent waiters for a JDBC Connection
# This may occur only when maxconpool is reached.
jdbc.maxwaiters		100


</content>
</file>


</xsl:template>

</xsl:stylesheet>

