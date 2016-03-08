<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='sysMonInstall' and @type='current']"> 
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='sysMonInstall' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='web_server' and @actype='sysMonInstall' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/SYS_MON_WEBinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $WORK_HOME
cp $RUBISWORK_HOME/softwares/cpu_mem.sh $RUBIS_TOP/.

</xsl:template>

</xsl:stylesheet>

