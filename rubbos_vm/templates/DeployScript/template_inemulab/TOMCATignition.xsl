<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='ignition' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='ignition' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='ignition' and @type='post-action']">sleep 10</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/TOMCATignition.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  STARTING opentaps on $HOSTNAME"

cd $OPENTAPS_HOME
sudo chmod +x startofbiz.sh
./startofbiz.sh

echo "  opentaps IS RUNNING on $HOSTNAME"

</xsl:template>

</xsl:stylesheet>

