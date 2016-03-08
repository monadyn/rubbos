<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_monitor' and @actype='install' and @type='current']"> 
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_monitor' and @actype='install' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='web_monitor' and @actype='install' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/APACHE_TOP_MONinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $WORK_HOME
cp $RUBISWORK_HOME/softwares/apachetop/apachetop-0.12.6/src/apachetop $RUBIS_TOP/.

</xsl:template>

</xsl:stylesheet>

