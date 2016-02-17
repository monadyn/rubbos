<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='install' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='install' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='install' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/TOMCATinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  INSTALLING TOMCAT on $HOSTNAME"

mkdir -p $ELBA_TOP
chmod 755 $ELBA_TOP
mkdir -p $RUBBOS_TOP
chmod 755 $RUBBOS_TOP

tar xzf $SOFTWARE_HOME/$TOMCAT_TARBALL --directory=$RUBBOS_TOP
tar xzf $SOFTWARE_HOME/$JAVA_TARBALL   --directory=$RUBBOS_TOP
tar xzf $SOFTWARE_HOME/$J2EE_TARBALL   --directory=$RUBBOS_TOP
tar xzf $SOFTWARE_HOME/$ANT_TARBALL    --directory=$RUBBOS_TOP

echo "  DONE INSTALLING TOMCAT on $HOSTNAME"

</xsl:template>
</xsl:stylesheet>











