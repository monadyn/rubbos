<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_server' and @actype='ignition' and @type='current']"> &amp;</xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_server' and @actype='ignition' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_server' and @actype='ignition' and @type='post-action']">sleep 30</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/CJDBC_CONTROLLERignition.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  STARTING CJDBC"

cd $CJDBC_HOME/bin/
./controller.sh -f ../config/controller/controller-raidb1-elba.xml &amp;

echo "  CJDBC IS RUNNING"
</xsl:template>

</xsl:stylesheet>


