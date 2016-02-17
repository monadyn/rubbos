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


<xsl:template match="//pastehere[@id='../templates/DeployScript/MYSQLignition.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh
<xsl:if test="//params/env/param[@name='JAVA_OPTS_DB']">
export JAVA_OPTS=<xsl:value-of select="//params/env/param[@name='JAVA_OPTS_DB']/@value"/>
</xsl:if>

echo "  STARTING MYSQL on $HOSTNAME"

cd $MYSQL_HOME
bin/mysqld_safe --defaults-file="$MYSQL_HOME/my.cnf" --datadir=$MYSQL_DATA_DIR --pid-file=$MYSQL_PID_FILE --socket=$MYSQL_SOCKET --port=$MYSQL_PORT --user=root --log-bin=rubbos-bin --max_connections=500 --log-slow-queries 	--long_query_time=1 &amp;
#bin/safe_mysqld --defaults-file="$MYSQL_HOME/my.cnf" --datadir=$MYSQL_DATA_DIR --log=$MYSQL_ERR_LOG --pid-file=$MYSQL_PID_FILE --socket=$MYSQL_SOCKET --port=$MYSQL_PORT --user=root &amp;#--log-bin=rubbos-bin

echo "  MYSQL IS RUNNING on $HOSTNAME"

</xsl:template>

</xsl:stylesheet>
