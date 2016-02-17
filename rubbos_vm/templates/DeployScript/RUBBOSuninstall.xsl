<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[contains(@idtype, '_server') and  @actype='rubbos_uninstall' and @type='current']"></xsl:template>

<xsl:template match="//argshere[contains(@idtype, '_server') and  @actype='rubbos_uninstall' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[contains(@idtype, '_server') and  @actype='rubbos_uninstall' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/RUBBOSuninstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

cd $SYSSTAT_HOME
sudo make uninstall
sudo rm -rf $SYSSTAT_HOME
rm -rf $RUBBOS_HOME
rm -rf $ELBA_TOP

</xsl:template>

</xsl:stylesheet>

