<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='stop' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='stop' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='stop' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/MYSQLstop.xsl']">

#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh
<xsl:if test="//params/env/param[@name='JAVA_OPTS_DB']">
export JAVA_OPTS=<xsl:value-of select="//params/env/param[@name='JAVA_OPTS_DB']/@value"/>
</xsl:if>

echo "  STOPPING MYSQL on $HOSTNAME"

cd $MYSQL_HOME
bin/mysqladmin --socket=$MYSQL_SOCKET  --user=root --password=$ROOT_PASSWORD shutdown

echo "  MYSQL IS STOPPED on $HOSTNAME"

</xsl:template>

</xsl:stylesheet>

