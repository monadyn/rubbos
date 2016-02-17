<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='ignition' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='ignition' and @type='pre-action']"></xsl:template>


<xsl:template match="//argshere[@idtype='web_server' and @actype='ignition' and @type='post-action']">sleep 5</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/WEBignition.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  STARTING APACHE on $HOSTNAME"

$HTTPD_HOME/bin/apachectl -f $HTTPD_HOME/conf/httpd.conf -k start

echo "  APACHE IS RUNNING on $HOSTNAME"
</xsl:template>

</xsl:stylesheet>

