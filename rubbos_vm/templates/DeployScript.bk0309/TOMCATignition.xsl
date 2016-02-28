<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='ignition' and @type='current']"> &amp; </xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='ignition' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='app_server' and @actype='ignition' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/TOMCATignition.xsl']">
#!/bin/sh

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh

cd $RUBIS_TOP/jakarta-tomcat-5.0.28/bin
#export CATALINA_OPTS="-Xmx512m -Xss96k -Djava.naming.factory.initial=com.sun.jndi.rmi.registry.RegistryContextFactory -Djava.naming.provider.url=rmi://localhost:1099 -Djava.naming.factory.url.pkgs=org.objectweb.jonas.naming"

export CATALINA_OPTS=" -Djava.naming.factory.initial=com.sun.jndi.rmi.registry.RegistryContextFactory -Djava.naming.provider.url=rmi://localhost:1099 -Djava.naming.factory.url.pkgs=org.objectweb.jonas.naming"

./startup.sh

</xsl:template>

</xsl:stylesheet>

