<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[(@idtype='benchmark_server' or @idtype='client_server') and  @actype='install' and @type='current']"></xsl:template>

<xsl:template match="//argshere[(@idtype='benchmark_server' or @idtype='client_server') and  @actype='install' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[(@idtype='benchmark_server' or @idtype='client_server') and  @actype='install' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/RUBBOS_CLIENTinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  INSTALLING RUBBOS CLIENT on $HOSTNAME"

tar xzf $SOFTWARE_HOME/$JAVA_TARBALL --directory=$RUBBOS_TOP

echo "  DONE INSTALLING RUBBOS CLIENT on $HOSTNAME"

</xsl:template>

</xsl:stylesheet>

