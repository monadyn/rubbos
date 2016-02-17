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


<xsl:template match="//pastehere[@id='../templates/DeployScript/POSTGRESinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh
<xsl:if test="//params/env/param[@name='JAVA_OPTS_DB']">
export JAVA_OPTS=<xsl:value-of select="//params/env/param[@name='JAVA_OPTS_DB']/@value"/>
</xsl:if>

echo "  INSTALLING POSTGRES on $HOSTNAME"

mkdir -p $ELBA_TOP
chmod 755 $ELBA_TOP
mkdir -p $RUBBOS_TOP
chmod 755 $RUBBOS_TOP

tar xzf $SOFTWARE_HOME/$POSTGRES_TARBALL --directory=$RUBBOS_TOP 

cd $POSTGRES_INSTALL_FILES

./configure --prefix=$POSTGRES_HOME
make
make install

#creating a database cluster
$POSTGRES_HOME/bin/initdb -D $POSTGRES_DATA_DIR

echo "  DONE INSTALLING POSTGRES on $HOSTNAME"
</xsl:template>

</xsl:stylesheet>
