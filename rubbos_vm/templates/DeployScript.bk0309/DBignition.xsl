<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='ignition' and @type='current']"> &amp; sleep 5; </xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='ignition' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='db_server' and @actype='ignition' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/DBignition.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $RUBIS_TOP/mysql-max-3.23.58-pc-linux-i686
#ulimit -n 50000
bin/safe_mysqld --defaults-file="../master.cnf" --user=root --set-variable max_connections=1600 &amp; sleep 5;
#bin/safe_mysqld &amp; sleep 5;

</xsl:template>

</xsl:stylesheet>

