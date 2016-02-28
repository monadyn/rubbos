<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@id='DB_sysMonIgnition.sh' and @type='current']"> $SMI $EMI &amp; </xsl:template>

<xsl:template match="//argshere[@id='DB_sysMonIgnition.sh' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@id='DB_sysMonIgnition.sh' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/SYS_MON_DBignition.xsl']">
#!/bin/bash

FREQUENCY=<xsl:value-of select="//instances/params/param[@name='MONFREQUENCY']/@value"/>
ANAL_HOST=<xsl:value-of select="//instances/instance[@name='ANAL']/target"/>
SMI=$1
EMI=$2

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $RUBIS_TOP
./cpu_mem.sh $FREQUENCY $ANAL_HOST $SMI $EMI &amp;

</xsl:template>

</xsl:stylesheet>

