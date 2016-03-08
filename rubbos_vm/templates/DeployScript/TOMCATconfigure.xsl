<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='configure' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='configure' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='configure' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/TOMCATconfigure.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  CONFIGURING TOMCAT on $HOSTNAME"

#cp $WORK_HOME/tomcat_files/startup.sh $CATALINA_HOME/bin/
#cp $WORK_HOME/tomcat_files/shutdown.sh $CATALINA_HOME/bin/
\cp $WORK_HOME/tomcat_files/catalina.sh $CATALINA_HOME/bin/
\cp $OUTPUT_HOME/tomcat_conf/server.xml-$HOSTNAME $CATALINA_HOME/conf/server.xml
\cp $OUTPUT_HOME/tomcat_conf/server.xml- $CATALINA_HOME/conf/server.xml
\cp $OUTPUT_HOME/tomcat_conf/server.xml- $CATALINA_HOME/conf/server.xml
\cp $OUTPUT_HOME/tomcat_conf/server.xml.tomcat-7.0.55 $CATALINA_HOME/conf/server.xml

echo "  DONE CONFIGURING TOMCAT on $HOSTNAME"


<xsl:for-each select="//instances/instance[@type='app_server']">
<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>server.xml-<xsl:value-of select="./swname"/><xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/tomcat_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
&lt;Server port="8005" shutdown="SHUTDOWN"&gt;

  &lt;Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener"/&gt;
  &lt;Listener className="org.apache.catalina.storeconfig.StoreConfigLifecycleListener"/&gt; 
 
  &lt;!-- Global JNDI resources --&gt;
  &lt;GlobalNamingResources&gt;
 
    &lt;!-- Test entry for demonstration purposes --&gt;
    &lt;Environment name="simpleValue" type="java.lang.Integer" value="30"/&gt;
 
    &lt;!-- Editable user database that can also be used by
         UserDatabaseRealm to authenticate users --&gt;
    &lt;Resource name="UserDatabase" auth="Container"
              type="org.apache.catalina.UserDatabase"
       description="User database that can be updated and saved"
           factory="org.apache.catalina.users.MemoryUserDatabaseFactory"
          pathname="conf/tomcat-users.xml" /&gt;
 
  &lt;/GlobalNamingResources&gt;
 
 
  &lt;!-- Define the Tomcat Stand-Alone Service --&gt;
  &lt;Service name="Catalina"&gt;
 
    &lt;!-- A "Connector" represents an endpoint by which requests are received
         and responses are returned.  Each Connector passes requests on to the
         associated "Container" (normally an Engine) for processing.
    --&gt;
 
    &lt;!-- Define a non-SSL HTTP/1.1 Connector on port 2117 (default 8080) --&gt;
    &lt;Connector port="8080" maxHttpHeaderSize="8192"
               maxThreads="<xsl:value-of select="//params/tomcat-conf/param[@name='maxThreads']/@value"/>"<!--
           --> minSpareThreads="<xsl:value-of select="//params/tomcat-conf/param[@name='minSpareThreads']/@value"/>"<!--
           --> maxSpareThreads="<xsl:value-of select="//params/tomcat-conf/param[@name='maxSpareThreads']/@value"/>"
               enableLookups="false" redirectPort="8443"<!--
           --> acceptCount="<xsl:value-of select="//params/tomcat-conf/param[@name='acceptCount']/@value"/>"
               connectionTimeout="20000" disableUploadTimeout="true" /&gt;
 
    &lt;!-- Define an AJP 1.3 Connector on port 8009 --&gt;
    &lt;Connector port="8009"
               maxThreads="<xsl:value-of select="//params/tomcat-conf/param[@name='maxThreads']/@value"/>"<!--
           --> minSpareThreads="<xsl:value-of select="//params/tomcat-conf/param[@name='minSpareThreads']/@value"/>"<!--
           --> maxSpareThreads="<xsl:value-of select="//params/tomcat-conf/param[@name='maxSpareThreads']/@value"/>"
               acceptCount="<xsl:value-of select="//params/tomcat-conf/param[@name='acceptCount']/@value"/>"<!--
           --> redirectPort="8443" protocol="AJP/1.3" /&gt;
 
    &lt;!-- Define a Proxied HTTP/1.1 Connector on port 8082 --&gt;
    &lt;!-- See proxy documentation for more information about using this. --&gt;
    &lt;!--
    &lt;Connector port="8082"
               maxThreads="150" minSpareThreads="25" maxSpareThreads="75"
               enableLookups="false" acceptCount="100" connectionTimeout="20000"
               proxyPort="80" disableUploadTimeout="true" /&gt;
    --&gt;
 
    &lt;!-- An Engine represents the entry point (within Catalina) that processes
         every request.  The Engine implementation for Tomcat stand alone
         analyzes the HTTP headers included with the request, and passes them
         on to the appropriate Host (virtual host). --&gt;
      
    &lt;!-- Define the top level container in our container hierarchy --&gt;
    &lt;Engine jvmRoute="<xsl:value-of select="./@name"/>" name="Catalina" defaultHost="localhost"&gt;
 
      &lt;Realm className="org.apache.catalina.realm.UserDatabaseRealm"
             resourceName="UserDatabase"/&gt;
 
      &lt;!-- Define the default virtual host --&gt;
 
      &lt;Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="true"&gt;

   &lt;!--    &lt;Context path="" docBase="webapps" debug="0" reloadable="true"/&gt; --&gt;
 
        &lt;Valve className="org.apache.catalina.valves.AccessLogValve"
                 directory="logs" prefix="localhost_access_log." suffix=".txt"
                 pattern="%h %t %r %s %b %D" resolveHosts="false"/&gt;
      &lt;/Host&gt;
 
 
    &lt;/Engine&gt;
 
  &lt;/Service&gt;
 
&lt;/Server&gt;



</content>
</file>
</xsl:for-each>


</xsl:template>

</xsl:stylesheet>

