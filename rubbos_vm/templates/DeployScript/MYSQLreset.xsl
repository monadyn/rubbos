<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='reset' and @type='current']"> &amp;</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='reset' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='db_server' and @actype='reset' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//pastehere[@id='../templates/DeployScript/MYSQLreset.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh
<xsl:if test="//params/env/param[@name='JAVA_OPTS_DB']">
export JAVA_OPTS=<xsl:value-of select="//params/env/param[@name='JAVA_OPTS_DB']/@value"/>
</xsl:if>

echo "  RESETING MYSQL on $HOSTNAME"
# copy rubbos data files
tar xzf $SOFTWARE_HOME/$RUBBOS_DATA_TARBALL --directory=$MYSQL_HOME/data/rubbos

echo "  DONE RESETING MYSQL on $HOSTNAME"
sleep 5

</xsl:template>

</xsl:stylesheet>














