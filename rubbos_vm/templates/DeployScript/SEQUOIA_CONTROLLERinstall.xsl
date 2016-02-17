<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='sequoia_server' and @actype='install' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='sequoia_server' and @actype='install' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='sequoia_server' and @actype='install' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/SEQUOIA_CONTROLLERinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  INSTALLING &amp; CONFIGURING SEQUOIA"

mkdir -p $ELBA_TOP
chmod 755 $ELBA_TOP
mkdir -p $RUBBOS_TOP
chmod 755 $RUBBOS_TOP

tar xfz $SOFTWARE_HOME/$SEQUOIA_TARBALL -C $RUBBOS_TOP
tar xzf $SOFTWARE_HOME/$JAVA_TARBALL   --directory=$RUBBOS_TOP

cp $OUTPUT_HOME/sequoia_conf/controller-raidb1-elba.xml $SEQUOIA_HOME/config/controller/
cp $OUTPUT_HOME/sequoia_conf/mysqldb-raidb1-elba.xml $SEQUOIA_HOME/config/virtualdatabase/
cp $SOFTWARE_HOME/$MYSQL_CONNECTOR $SEQUOIA_HOME/drivers/

echo "  DONE INSTALLING &amp; CONFIGURING SEQUOIA"


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>controller-raidb1-elba.xml<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/sequoia_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>

&lt;?xml version="1.0" encoding="ISO-8859-1" ?&gt;
&lt;!DOCTYPE SEQUOIA-CONTROLLER PUBLIC "-//Continuent//DTD SEQUOIA-CONTROLLER 2.10.9//EN"  "http://sequoia.continuent.org/dtds/sequoia-controller-2.10.9.dtd"&gt;
&lt;SEQUOIA-CONTROLLER&gt;
  &lt;Controller port="<xsl:value-of select="//params/env/param[@name='SEQUOIA_PORT']/@value"/>"&gt;
    &lt;Report/&gt;
    &lt;JmxSettings>
      &lt;RmiJmxAdaptor/&gt;
    &lt;/JmxSettings&gt;
<!--    &lt;VirtualDatabase configFile="mysqldb-raidb1-elba.xml" virtualDatabaseName="rubbos" autoEnableBackends="force" checkpointName="Initial_empty_recovery_log"/&gt;
-->
  &lt;VirtualDatabase configFile="mysqldb-raidb1-elba.xml" virtualDatabaseName="rubbos" autoEnableBackends="true"/&gt;
  &lt;/Controller&gt;
&lt;/SEQUOIA-CONTROLLER&gt;


</content>
</file>



<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>mysqldb-raidb1-elba.xml<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/sequoia_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>


&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;!DOCTYPE SEQUOIA PUBLIC "-//Continuent//DTD SEQUOIA 2.10.9//EN" "http://sequoia.continuent.org/dtds/sequoia-2.10.9.dtd"&gt;

&lt;SEQUOIA&gt;

  &lt;VirtualDatabase name="rubbos"&gt;

    &lt;Monitoring>
      &lt;SQLMonitoring defaultMonitoring="off"&gt;
         &lt;SQLMonitoringRule queryPattern="^select" caseSensitive="false" applyToSkeleton ="false" monitoring="on"/&gt;
      &lt;/SQLMonitoring&gt;
   &lt;/Monitoring&gt;

    &lt;Backup&gt;
      &lt;Backuper backuperName="Octopus"
        className="org.continuent.sequoia.controller.backup.backupers.OctopusBackuper"
        options="zip=true"/&gt;
    &lt;/Backup&gt;
    
    &lt;AuthenticationManager&gt;
      &lt;Admin&gt;
       	&lt;User username="admin" password="<xsl:value-of select="//params/env/param[@name='ROOT_PASSWORD']/@value"/>"/>
     &lt;/Admin&gt; 
      &lt;VirtualUsers>
        &lt;VirtualLogin vLogin="<xsl:value-of select="//params/env/param[@name='ELBA_USER']/@value"/>"<!--
            --> vPassword="<xsl:value-of select="//params/env/param[@name='ELBA_PASSWORD']/@value"/>"/&gt;
      &lt;/VirtualUsers&gt;
    &lt;/AuthenticationManager&gt;

<xsl:for-each select="//instances/instance[@type='db_server']">
    &lt;DatabaseBackend name="<xsl:value-of select="./@name"/>" driver="com.mysql.jdbc.Driver"
      url="jdbc:mysql://<xsl:value-of select="./target"/>-lan4:<xsl:value-of select="//instances/params/env/param[@name='MYSQL_PORT']/@value"/>/rubbos"
      connectionTestStatement="select 1"&gt;
      &lt;ConnectionManager<!--
        --> vLogin="<xsl:value-of select="//params/env/param[@name='ELBA_USER']/@value"/>"<!--
        --> rLogin="<xsl:value-of select="//params/env/param[@name='ELBA_USER']/@value"/>"<!--
        --> rPassword="<xsl:value-of select="//params/env/param[@name='ELBA_PASSWORD']/@value"/>"&gt;
        &lt;VariablePoolConnectionManager<!--
	--> initPoolSize="<xsl:value-of select="//params/sequoia-conf/param[@name='initPoolSize']/@value"/>"<!--
	--> minPoolSize="<xsl:value-of select="//params/sequoia-conf/param[@name='minPoolSize']/@value"/>"
          maxPoolSize="<xsl:value-of select="//params/sequoia-conf/param[@name='maxPoolSize']/@value"/>"<!--
	--> idleTimeout="<xsl:value-of select="//params/sequoia-conf/param[@name='idleTimeout']/@value"/>"<!--
	--> waitTimeout="<xsl:value-of select="//params/sequoia-conf/param[@name='waitTimeout']/@value"/>"/&gt;
      &lt;/ConnectionManager&gt;
    &lt;/DatabaseBackend&gt;
</xsl:for-each>

    &lt;RequestManager&gt;
      &lt;RequestScheduler&gt;
         &lt;RAIDb-1Scheduler level="passThrough"/&gt;
      &lt;/RequestScheduler&gt;

      &lt;RequestCache&gt;
         &lt;MetadataCache/&gt;
         &lt;ParsingCache/>		 
<!--       &lt;ResultCache granularity="table"/&gt; -->
      &lt;/RequestCache&gt;

      &lt;LoadBalancer&gt;
         &lt;RAIDb-1&gt;
            &lt;WaitForCompletion policy="first"/&gt;
            &lt;RAIDb-1-LeastPendingRequestsFirst/&gt;
         &lt;/RAIDb-1&gt;
      &lt;/LoadBalancer&gt;

     <!-- &lt;RecoveryLog driver="org.hsqldb.jdbcDriver"
        url="jdbc:mysql://localhost:9003" login="TEST" password=""&gt;
       &lt;RecoveryLogTable tableName="RECOVERY" logIdColumnType="BIGINT NOT NULL"
          vloginColumnType="VARCHAR NOT NULL" sqlColumnType="VARCHAR NOT NULL"
          extraStatementDefinition=",PRIMARY KEY (log_id)"/&gt;
        &lt;CheckpointTable tableName="CHECKPOINT"
          checkpointNameColumnType="VARCHAR NOT NULL"/&gt;
       &lt;BackendTable tableName="BACKEND"
          databaseNameColumnType="VARCHAR NOT NULL"
          backendNameColumnType="VARCHAR NOT NULL"
          checkpointNameColumnType="VARCHAR NOT NULL"/&gt;
        &lt;DumpTable tableName="DUMP" dumpNameColumnType="VARCHAR NOT NULL"
          dumpDateColumnType="TIMESTAMP"
          dumpPathColumnType="VARCHAR NOT NULL"
          dumpFormatColumnType="VARCHAR NOT NULL"
          checkpointNameColumnType="VARCHAR NOT NULL"
          backendNameColumnType="VARCHAR NOT NULL"
          tablesColumnType="VARCHAR NOT NULL"/&gt;
      &lt;/RecoveryLog&gt; -->
    &lt;/RequestManager&gt;

  &lt;/VirtualDatabase&gt;

&lt;/SEQUOIA&gt;



</content>
</file>



</xsl:template>

</xsl:stylesheet>
