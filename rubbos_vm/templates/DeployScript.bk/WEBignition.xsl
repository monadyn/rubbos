<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='ignition' and @type='current']"> 
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='ignition' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='web_server' and @actype='ignition' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/WEBignition.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $RUBIS_TOP/apache2
bin/apachectl start

</xsl:template>

</xsl:stylesheet>

