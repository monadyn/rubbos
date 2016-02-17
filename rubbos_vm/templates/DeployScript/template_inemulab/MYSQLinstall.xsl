<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and  @actype='install' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='install' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='install' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/MYSQLinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh
<xsl:if test="//params/env/param[@name='JAVA_OPTS_DB']">
export JAVA_OPTS=<xsl:value-of select="//params/env/param[@name='JAVA_OPTS_DB']/@value"/>
</xsl:if>

echo "  INSTALLING MYSQL on $HOSTNAME"

mkdir -p $ELBA_TOP
chmod 755 $ELBA_TOP
mkdir -p $RUBBOS_TOP
chmod 755 $RUBBOS_TOP

<xsl:choose>
  <xsl:when test="//params/logging/param[@name='mysqlResponseTime']/@value='true'">
    <xsl:if test="//params/logging/param[@name='mysqlResponseTime' and @value='true']/sampling">
cd $SOFTWARE_HOME
rm $MYSQL_TARBALL_RT
ln -s $MYSQL_TARBALL_RT-sampling<xsl:value-of select="//params/logging/param[@name='mysqlResponseTime' and @value='true']/sampling/@ratio"/> $MYSQL_TARBALL_RT
    </xsl:if>
tar xzf $SOFTWARE_HOME/$MYSQL_TARBALL_RT --directory=$RUBBOS_TOP 
  </xsl:when>
  <xsl:otherwise>
tar xzf $SOFTWARE_HOME/$MYSQL_TARBALL --directory=$RUBBOS_TOP 
  </xsl:otherwise>
</xsl:choose>
cd $MYSQL_HOME 
scripts/mysql_install_db --no-defaults --basedir=$MYSQL_HOME --port=$MYSQL_PORT --datadir=$MYSQL_DATA_DIR --log=$MYSQL_ERR_LOG --pid-file=$MYSQL_PID_FILE --socket=$MYSQL_SOCKET

echo "  DONE INSTALLING MYSQL on $HOSTNAME"


</xsl:template>

</xsl:stylesheet>
