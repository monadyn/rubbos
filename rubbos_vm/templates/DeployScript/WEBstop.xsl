<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='stop' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='stop' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='stop' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/WEBstop.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  STOPPING APACHE on $HOSTNAME"

$HTTPD_HOME/bin/apachectl -f $HTTPD_HOME/conf/httpd.conf -k stop

echo "  APACHE IS STOPPED on $HOSTNAME"

</xsl:template>

</xsl:stylesheet>

