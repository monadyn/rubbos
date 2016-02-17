<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_server' and @actype='uninstall' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_server' and @actype='uninstall' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_server' and @actype='uninstall' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/CJDBC_CONTROLLERuninstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

rm -rf $CJDBC_HOME
rm -rf $ELBA_TOP
kill -9 -1

</xsl:template>

</xsl:stylesheet>

