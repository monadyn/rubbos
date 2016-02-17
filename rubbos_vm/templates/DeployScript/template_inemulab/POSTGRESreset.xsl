<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='reset' and @type='current']"> &amp; sleep 180; </xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='reset' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='db_server' and @actype='reset' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//pastehere[@id='../templates/DeployScript/POSTGRESreset.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh
<xsl:if test="//params/env/param[@name='JAVA_OPTS_DB']">
export JAVA_OPTS=<xsl:value-of select="//params/env/param[@name='JAVA_OPTS_DB']/@value"/>
</xsl:if>

echo "  RESETING POSTGRES on $HOSTNAME"

#start postgres
cd $POSTGRES_HOME/bin
./postgres -i -D $POSTGRES_DATA_DIR &amp;
sleep 5

#drop database
./dropdb rubbos

#create database &amp; user
./createdb rubbos

#load RUBBoS data
./psql -h localhost rubbos &lt; $RUBBOS_HOME/database/rubbos.sql
./psql -h localhost rubbos &lt; $RUBBOS_HOME/database/test.sql
./psql -h localhost rubbos &lt; $RUBBOS_HOME/database/load.sql
sleep 30
./psql -h localhost rubbos &lt; $RUBBOS_HOME/database/rubbos_index.sql
sleep 30

#stop postgres
./pg_ctl stop -D $POSTGRES_DATA_DIR
sleep 5

echo "  DONE RESETING POSTGRES on $HOSTNAME"

</xsl:template>

</xsl:stylesheet>














