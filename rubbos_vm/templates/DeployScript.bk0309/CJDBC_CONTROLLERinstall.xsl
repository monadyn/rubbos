<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_controller' and @actype='install' and @type='current']">
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_controller' and @actype='install' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='cjdbc_controller' and @actype='install' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/CJDBC_CONTROLLERinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
mkdir <xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
chmod 775 <xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
mkdir <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>
chmod 775 <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>

cd $RUBISWORK_HOME/softwares
cp -r c-jdbc-latest-bin $RUBIS_TOP/.



<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>controller-raidb1-elba.xml<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>/softwares/c-jdbc-latest-bin/config/controller<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>

&lt;?xml version="1.0" encoding="ISO-8859-1" ?&gt;
&lt;!DOCTYPE C-JDBC-CONTROLLER PUBLIC "-//ObjectWeb//DTD C-JDBC-CONTROLLER latest//EN"  "http://c-jdbc.objectweb.org/dtds/c-jdbc-controller-latest.dtd"&gt;
&lt;C-JDBC-CONTROLLER&gt;
  &lt;Controller port="25322"&gt;
    &lt;Report/&gt;
    &lt;JmxSettings&gt;
      &lt;RmiJmxAdaptor/&gt;
    &lt;/JmxSettings&gt;
    &lt;VirtualDatabase configFile="mysqldb-raidb1-elba.xml" virtualDatabaseName="rubis" autoEnableBackends="true" checkpointName="Initial_empty_recovery_log"/&gt;
  &lt;/Controller&gt;
&lt;/C-JDBC-CONTROLLER&gt;


</content>
</file>



<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>mysqldb-raidb1-elba.xml<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>/softwares/c-jdbc-latest-bin/config/virtualdatabase<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>


&lt;?xml version="1.0" encoding="UTF8"?&gt;
&lt;!DOCTYPE C-JDBC PUBLIC "-//ObjectWeb//DTD C-JDBC latest//EN" "http://c-jdbc.objectweb.org/dtds/c-jdbc-latest.dtd"&gt;

&lt;C-JDBC&gt;

  &lt;VirtualDatabase name="rubis"&gt;

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
        &lt;User username="admin" password=""/&gt;
      &lt;/Admin&gt;
      &lt;VirtualUsers&gt;
        &lt;VirtualLogin vLogin="root" vPassword="rubis"/&gt;
      &lt;/VirtualUsers&gt;
    &lt;/AuthenticationManager&gt;

<xsl:for-each select="//instances/instance[@type='db_server']">

    &lt;DatabaseBackend name="<xsl:value-of select="./@name"/>" driver="com.mysql.jdbc.Driver"
      url="jdbc:mysql://<xsl:value-of select="./target"/>/rubis"
      connectionTestStatement="select 1"&gt;
      &lt;ConnectionManager vLogin="root" rLogin="root" rPassword="rubis"&gt;
        &lt;VariablePoolConnectionManager initPoolSize="200" minPoolSize="100"
          maxPoolSize="300" idleTimeout="30" waitTimeout="10"/&gt;
      &lt;/ConnectionManager&gt;
    &lt;/DatabaseBackend&gt;

</xsl:for-each>

    &lt;RequestManager&gt;
      &lt;RequestScheduler&gt;
         &lt;RAIDb-1Scheduler level="passThrough"/&gt;
      &lt;/RequestScheduler&gt;

      &lt;RequestCache&gt;
         &lt;MetadataCache/&gt;
         &lt;ParsingCache/&gt;
&lt;!--       &lt;ResultCache granularity="table"/&gt; --&gt;
      &lt;/RequestCache&gt;

      &lt;LoadBalancer&gt;
         &lt;RAIDb-1&gt;
            &lt;WaitForCompletion policy="first"/&gt;
            &lt;RAIDb-1-LeastPendingRequestsFirst/&gt;
         &lt;/RAIDb-1&gt;
      &lt;/LoadBalancer&gt;

    &lt;/RequestManager&gt;

  &lt;/VirtualDatabase&gt;

&lt;/C-JDBC&gt;


</content>
</file>



</xsl:template>

</xsl:stylesheet>


