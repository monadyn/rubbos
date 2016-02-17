<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='ignition' and @type='current']"> &amp;</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='ignition' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='ignition' and @type='post-action']">sleep 10</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/POSTGRESignition.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh
<xsl:if test="//params/env/param[@name='JAVA_OPTS_DB']">
export JAVA_OPTS=<xsl:value-of select="//params/env/param[@name='JAVA_OPTS_DB']/@value"/>
</xsl:if>

echo "  STARTING POSTGRES on $HOSTNAME"

rm -f $POSTGRES_DATA_DIR/postmaster.pid

cd $POSTGRES_HOME/bin
./postgres -i -D $POSTGRES_DATA_DIR &amp;

echo "  POSTGRES IS RUNNING on $HOSTNAME"

</xsl:template>

</xsl:stylesheet>
