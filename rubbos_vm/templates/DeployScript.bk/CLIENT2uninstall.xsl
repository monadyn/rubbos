<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@id='CLIENT2_uninstall.sh' and @type='current']">
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//argshere[@id='CLIENT2_uninstall.sh' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@id='CLIENT2_uninstall.sh' and @type='post-action']"> 

ssh <xsl:value-of select="//instances/instance[@name='CLIENT2']/target"/> rm -rf /tmp/elba
#sleep 60;

</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/CLIENT2uninstall.xsl']">

#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $RUBIS_TOP
rm -R nClient


</xsl:template>

</xsl:stylesheet>

