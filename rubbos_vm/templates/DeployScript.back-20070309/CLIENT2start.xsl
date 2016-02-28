<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@id='CLIENT2_ignition.sh' and @type='current']"> $WORKLOAD $ST $SMI $EMI $ET  &amp; </xsl:template>

<xsl:template match="//argshere[@id='CLIENT2_ignition.sh' and @type='pre-action']">
<xsl:text>
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@id='CLIENT2_ignition.sh' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/CLIENT2start.xsl']">
#!/bin/bash

#CLIENT_HOST=<xsl:value-of select="//instances/instance[@name='CLIENT2']/target"/>
CLIENT_HOST="`hostname`"
CLIENT_NAME=2
WORKLOAD=$1
ST=$2
SMI=$3
EMI=$4
ET=$5
CONFIG=<xsl:value-of select="//instances/params/param[@name='CONFIG']/@value"/>
ANAL_HOST=<xsl:value-of select="//instances/instance[@name='ANAL']/target"/>

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $RUBIS_TOP
chmod -R 755 nClient
cd $RUBIS_TOP/nClient

java -Xms128m -Xmx768m -Xss192k -Dhttp.keepAlive=true -Dhttp.maxConnections=1000000 ClientEmulator $CLIENT_HOST $CLIENT_NAME $WORKLOAD $ST $SMI $EMI $ET $CONFIG $ANAL_HOST

</xsl:template>

</xsl:stylesheet>

