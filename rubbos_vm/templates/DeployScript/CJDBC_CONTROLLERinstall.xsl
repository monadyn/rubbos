<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_server' and @actype='install' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_server' and @actype='install' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_server' and @actype='install' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/CJDBC_CONTROLLERinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  INSTALLING &amp; CONFIGURING CJDBC"

mkdir -p $ELBA_TOP
chmod 755 $ELBA_TOP
mkdir -p $RUBBOS_TOP
chmod 755 $RUBBOS_TOP

<xsl:if test="//params/logging/param[@name='cjdbcResponseTime' and @value='true']/sampling">
cd $SOFTWARE_HOME
rm $CJDBC_TARBALL
ln -s $CJDBC_TARBALL-sampling<xsl:value-of select="//params/logging/param[@name='cjdbcResponseTime' and @value='true']/sampling/@ratio"/> $CJDBC_TARBALL
</xsl:if>
#Extract tar-ball
tar xfz $SOFTWARE_HOME/$CJDBC_TARBALL -C $RUBBOS_TOP
#Copy a jar-file of JDBC driver into the C-JDBC directory
<xsl:if test="//instances/instance[@type='db_server' and swname='postgres']"
>cp $SOFTWARE_HOME/$POSTGRES_CONNECTOR $CJDBC_HOME/drivers/
</xsl:if>
<xsl:if test="//instances/instance[@type='db_server' and not(swname='postgres')]"
>cp $SOFTWARE_HOME/$MYSQL_CONNECTOR $CJDBC_HOME/drivers/
</xsl:if>

cp $OUTPUT_HOME/cjdbc_conf/controller-raidb1-elba.xml $CJDBC_HOME/config/controller/
cp $OUTPUT_HOME/cjdbc_conf/mysqldb-raidb1-elba.xml $CJDBC_HOME/config/virtualdatabase/
cp $OUTPUT_HOME/cjdbc_conf/log4j.properties $CJDBC_HOME/config/
cp $OUTPUT_HOME/../cjdbc_files/controller.sh $CJDBC_HOME/bin/
tar xzf $SOFTWARE_HOME/$JAVA_TARBALL   --directory=$RUBBOS_TOP

echo "  DONE INSTALLING &amp; CONFIGURING CJDBC"


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>controller-raidb1-elba.xml<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/cjdbc_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>

&lt;?xml version="1.0" encoding="ISO-8859-1" ?&gt;
&lt;!DOCTYPE C-JDBC-CONTROLLER PUBLIC "-//ObjectWeb//DTD C-JDBC-CONTROLLER latest//EN"  "http://c-jdbc.objectweb.org/dtds/c-jdbc-controller-latest.dtd"&gt;
&lt;C-JDBC-CONTROLLER&gt;
  &lt;Controller port="<xsl:value-of select="//params/env/param[@name='CJDBC_PORT']/@value"/>"&gt;
    &lt;Report/&gt;
    &lt;JmxSettings&gt;
      &lt;RmiJmxAdaptor/&gt;
    &lt;/JmxSettings&gt;
<!--
    &lt;VirtualDatabase configFile="mysqldb-raidb1-elba.xml" virtualDatabaseName="rubbos" autoEnableBackends="true" checkpointName="Initial_empty_recovery_log"/&gt;
-->
    &lt;VirtualDatabase configFile="mysqldb-raidb1-elba.xml" virtualDatabaseName="rubbos" autoEnableBackends="true"/&gt;
  &lt;/Controller&gt;
&lt;/C-JDBC-CONTROLLER&gt;


</content>
</file>



<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>mysqldb-raidb1-elba.xml<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/cjdbc_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>


&lt;?xml version="1.0" encoding="UTF8"?&gt;
&lt;!DOCTYPE C-JDBC PUBLIC "-//ObjectWeb//DTD C-JDBC latest//EN" "http://c-jdbc.objectweb.org/dtds/c-jdbc-latest.dtd"&gt;

&lt;C-JDBC&gt;

  &lt;VirtualDatabase name="rubbos"&gt;

    &lt;Monitoring&gt;
      &lt;SQLMonitoring defaultMonitoring="off"&gt;
         &lt;SQLMonitoringRule queryPattern="^select" caseSensitive="false" applyToSkeleton ="false" monitoring="on"/&gt;
      &lt;/SQLMonitoring&gt;
    &lt;/Monitoring&gt;

    &lt;Backup&gt;
      &lt;Backuper backuperName="Octopus"
        className="org.objectweb.cjdbc.controller.backup.OctopusBackuper"
        options="zip=true"/&gt;
    &lt;/Backup&gt;

    &lt;AuthenticationManager&gt;
      &lt;Admin&gt;
        &lt;User username="root"<!--
          --> password="<xsl:value-of select="//params/env/param[@name='ROOT_PASSWORD']/@value"/>"/&gt;
      &lt;/Admin&gt;
      &lt;VirtualUsers&gt;
        &lt;VirtualLogin<!--
          --> vLogin="<xsl:value-of select="//params/env/param[@name='ELBA_USER']/@value"/>"<!--
          --> vPassword="<xsl:value-of select="//params/env/param[@name='ELBA_PASSWORD']/@value"/>"/&gt;
      &lt;/VirtualUsers&gt;
    &lt;/AuthenticationManager&gt;
<xsl:for-each select="//instances/instance[@type='db_server']">
  <xsl:choose>
    <xsl:when test="swname[text()='postgres']">
    &lt;DatabaseBackend name="<xsl:value-of select="./@name"/>" driver="org.postgresql.Driver"
      url="jdbc:postgresql://<xsl:value-of select="./target"/>:5432/rubbos"
      connectionTestStatement="select now()"&gt;
    </xsl:when>
    <xsl:otherwise>
    &lt;DatabaseBackend name="<xsl:value-of select="./@name"/>" driver="com.mysql.jdbc.Driver"
      url="jdbc:mysql://<xsl:value-of select="./target"/>:<xsl:value-of select="//instances/params/env/param[@name='MYSQL_PORT']/@value"/>/rubbos"
      connectionTestStatement="select 1"&gt;
    </xsl:otherwise>
  </xsl:choose
>      &lt;ConnectionManager<!--
        --> vLogin="<xsl:value-of select="//params/env/param[@name='ELBA_USER']/@value"/>"<!--
        --> rLogin="<xsl:value-of select="//params/env/param[@name='ELBA_USER']/@value"/>"<!--
        --> rPassword="<xsl:value-of select="//params/env/param[@name='ELBA_PASSWORD']/@value"/>"&gt;
        &lt;VariablePoolConnectionManager<!--
	--> initPoolSize="<xsl:value-of select="//params/cjdbc-conf/param[@name='initPoolSize']/@value"/>"<!--
	--> minPoolSize="<xsl:value-of select="//params/cjdbc-conf/param[@name='minPoolSize']/@value"/>"
          maxPoolSize="<xsl:value-of select="//params/cjdbc-conf/param[@name='maxPoolSize']/@value"/>"<!--
	--> idleTimeout="<xsl:value-of select="//params/cjdbc-conf/param[@name='idleTimeout']/@value"/>"<!--
	--> waitTimeout="<xsl:value-of select="//params/cjdbc-conf/param[@name='waitTimeout']/@value"/>"/&gt;
      &lt;/ConnectionManager&gt;
    &lt;/DatabaseBackend&gt;
</xsl:for-each>
    &lt;RequestManager&gt;
      &lt;RequestScheduler&gt;
         &lt;RAIDb-1Scheduler level="pessimisticTransaction"/&gt;
      &lt;/RequestScheduler&gt;

      &lt;RequestCache&gt;
         &lt;MetadataCache/&gt;
         &lt;ParsingCache/&gt;
&lt;!--       &lt;ResultCache granularity="table"/&gt; --&gt;
      &lt;/RequestCache&gt;

      &lt;LoadBalancer&gt;
         &lt;RAIDb-1&gt;
<xsl:choose>
  <xsl:when test="//params/cjdbc-conf/param[@name='waitForCompletion']">
            &lt;WaitForCompletion policy="<xsl:value-of select="//params/cjdbc-conf/param[@name='waitForCompletion']/@value"/>"/&gt;
  </xsl:when>
  <xsl:otherwise>
            &lt;WaitForCompletion policy="first"/&gt;
  </xsl:otherwise>
</xsl:choose>
<xsl:choose>
  <xsl:when test="//params/cjdbc-conf/param[@name='loadBalancing']">
            &lt;RAIDb-1-<xsl:value-of select="//params/cjdbc-conf/param[@name='loadBalancing']/@value"/>/&gt;
  </xsl:when>
  <xsl:otherwise>
            &lt;RAIDb-1-LeastPendingRequestsFirst/&gt;
  </xsl:otherwise>
</xsl:choose>
         &lt;/RAIDb-1&gt;
      &lt;/LoadBalancer&gt;

    &lt;/RequestManager&gt;

  &lt;/VirtualDatabase&gt;

&lt;/C-JDBC&gt;


</content>
</file>



<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>log4j.properties<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/cjdbc_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
# Set the options for the Console appender.
# Console's layout is a PatternLayout, using the conversion pattern
# %d: current date in ISO8601 format
# %p: priority of the logging event
# %c: category name
# %m: the message
log4j.appender.Console=org.apache.log4j.ConsoleAppender
log4j.appender.Console.layout=org.apache.log4j.PatternLayout
log4j.appender.Console.layout.ConversionPattern=%d %-5p %c{3} %m\n

# Requests appender is used to log requests received by the controller.
# These log can be automatically replayed using the request player.
log4j.appender.Requests=org.apache.log4j.RollingFileAppender
log4j.appender.Requests.File=${cjdbc.log}/request.log
log4j.appender.Requests.MaxFileSize=100MB
log4j.appender.Requests.MaxBackupIndex=5
log4j.appender.Requests.layout=org.apache.log4j.PatternLayout
log4j.appender.Requests.layout.ConversionPattern=%d{ABSOLUTE} %c{1} %m\n

# YASU: A log for response time
log4j.appender.ResponseTime=org.apache.log4j.RollingFileAppender
log4j.appender.ResponseTime.File=${cjdbc.log}/response_time.log
log4j.appender.ResponseTime.MaxFileSize=5000MB
log4j.appender.ResponseTime.MaxBackupIndex=1
log4j.appender.ResponseTime.layout=org.apache.log4j.PatternLayout
log4j.appender.ResponseTime.layout.ConversionPattern=%d{ABSOLUTE} %c{1} %m\n

# DistributedRequests appender is used to log distributed request execution at
# each controller. This can be used to track if queries are properly executed
# at all controllers.
log4j.appender.DistributedRequests=org.apache.log4j.RollingFileAppender
log4j.appender.DistributedRequests.File=${cjdbc.log}/distributed_request.log
log4j.appender.DistributedRequests.MaxFileSize=100MB
log4j.appender.DistributedRequests.MaxBackupIndex=5
log4j.appender.DistributedRequests.layout=org.apache.log4j.PatternLayout
log4j.appender.DistributedRequests.layout.ConversionPattern=%d{ABSOLUTE} %c{1} %m\n

# This is for example only, and will send an email if there is '1' message sent to the log4j
#  system with a FATAL level.
# This needs the mail.jar and the activation.jar to be in the classpath, included in the
# C-JDBC binary distribution ...
log4j.appender.email=org.apache.log4j.net.SMTPAppender
log4j.appender.email.BufferSize=1
log4j.appender.email.Threshold=FATAL
log4j.appender.email.From=from@from
log4j.appender.email.To=to@to
log4j.appender.email.SMTPHost=smtp@smtp
log4j.appender.email.Subject=CJDBC
log4j.appender.email.layout=org.apache.log4j.PatternLayout
log4j.appender.email.layout.conversionPattern=%-4r %-5p [%t] %37c %3x
# Additional mail appender configuration
log4j.appender.email.UserName=username
#log4j.appender.email.Password=
#log4j.appender.email.Authenticate= &lt;true&gt; ignore case, if something else than true, no authentication will be done&gt;

# Filetrace is used for C-JDBC log files, this appender is removed from the log4j system
# if the parameter setFileLogging is set to false in the controller xml configuration file.
log4j.appender.Filetrace=org.apache.log4j.RollingFileAppender
log4j.appender.Filetrace.File=${cjdbc.log}/cjdbc.log
log4j.appender.Filetrace.MaxFileSize=10MB
log4j.appender.Filetrace.MaxBackupIndex=5
log4j.appender.Filetrace.layout=org.apache.log4j.PatternLayout
log4j.appender.Filetrace.layout.ConversionPattern=%d %-5p %c{3} %m\n
log4j.appender.Filetrace.immediateFlush=true

# For remote display of log entries.
log4j.appender.server = org.apache.log4j.net.SocketHubAppender
log4j.appender.server.Port = 9010

# Root logger set to INFO using the Console appender defined above.
log4j.rootLogger=WARN, Console,Filetrace

######################
# Logger definitions #
######################

# Controller #
log4j.logger.org.objectweb.cjdbc.controller.core.Controller=INFO, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.core.Controller=false

# XML Parsing #
log4j.logger.org.objectweb.cjdbc.controller.xml=WARN, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.xml=false

# Virtual Database #
# to debug a specific virtual database append the virtual database name. #
# example: log4j.logger.org.objectweb.cjdbc.controller.virtualdatabase.mydb=DEBUG, Console #
log4j.logger.org.objectweb.cjdbc.controller.virtualdatabase=INFO, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.virtualdatabase=false
log4j.logger.org.objectweb.cjdbc.controller.virtualdatabase.VirtualDatabaseWorkerThread=INFO, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.virtualdatabase.VirtualDatabaseWorkerThread=false

# Request Manager #
log4j.logger.org.objectweb.cjdbc.controller.RequestManager=INFO, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.RequestManager=false

# To trace requests #
log4j.logger.org.objectweb.cjdbc.controller.virtualdatabase.request=OFF, Requests
log4j.additivity.org.objectweb.cjdbc.controller.virtualdatabase.request=false

# YASU: To measure response time
<xsl:choose>
  <xsl:when test="//params/logging/param[@name='cjdbcResponseTime']/@value='true'"
    >log4j.logger.org.objectweb.cjdbc.controller.virtualdatabase.responseTime=ON, ResponseTime</xsl:when>
  <xsl:otherwise
    >log4j.logger.org.objectweb.cjdbc.controller.virtualdatabase.responseTime=OFF, ResponseTime</xsl:otherwise>
</xsl:choose>
log4j.additivity.org.objectweb.cjdbc.controller.virtualdatabase.responseTime=true

# To trace distributed requests #
log4j.logger.org.objectweb.cjdbc.controller.distributedvirtualdatabase.request=OFF, DistributedRequests
log4j.additivity.org.objectweb.cjdbc.controller.distributedvirtualdatabase.request=false

# Backup #
log4j.logger.org.objectweb.cjdbc.controller.backup=INFO, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.backup=false

# Scheduler #
log4j.logger.org.objectweb.cjdbc.controller.scheduler=INFO, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.scheduler=false

# Cache #
log4j.logger.org.objectweb.cjdbc.controller.cache=INFO, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.cache=false

# Load Balancer #
log4j.logger.org.objectweb.cjdbc.controller.loadbalancer=INFO, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.loadbalancer=false

# Connection #
log4j.logger.org.objectweb.cjdbc.controller.connection=INFO, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.connection=false

# Database backend #
log4j.logger.org.objectweb.cjdbc.controller.backend.DatabaseBackend=INFO, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.backend.DatabaseBackend=false

# Recovery Log #
log4j.logger.org.objectweb.cjdbc.controller.recoverylog=WARN, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.recoverylog=false

# JMX #
log4j.logger.org.objectweb.cjdbc.controller.jmx=WARN, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.jmx=false

# Utils #
log4j.logger.org.objectweb.cjdbc.common.util.Zipper=OFF, Console
log4j.additivity.org.objectweb.cjdbc.common.util.Zipper=false

# Tests #
log4j.logger.org.objectweb.cjdbc.controller.connection.test=INFO, Console,Filetrace
log4j.additivity.org.objectweb.cjdbc.controller.connection.test=false


#####################################
# Tribe group communication loggers #
#####################################

# Tribe channels #
log4j.logger.org.objectweb.tribe.channels=INFO, Console
log4j.additivity.org.objectweb.tribe.channels=false

# Tribe Group Membership Service (GMS) #
log4j.logger.org.objectweb.tribe.gms=INFO, Console
log4j.additivity.org.objectweb.tribe.gms=false

# Tribe Discovery Service (used by GMS) #
log4j.logger.org.objectweb.tribe.discovery=INFO, Console
log4j.additivity.org.objectweb.tribe.discovery=false

# Tribe Multicast Dispatcher building block #
log4j.logger.org.objectweb.tribe.blocks.multicastadapter=INFO, Console
log4j.additivity.org.objectweb.tribe.blocks.multicastadapter=false
</content>
</file>



</xsl:template>

</xsl:stylesheet>


