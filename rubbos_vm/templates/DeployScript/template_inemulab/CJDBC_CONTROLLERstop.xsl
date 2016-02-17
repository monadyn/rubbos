<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_server' and @actype='stop' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_server' and @actype='stop' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='cjdbc_server' and @actype='stop' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/CJDBC_CONTROLLERstop.xsl']">

#!/bin/bash

echo "  STOPPING CJDBC"

kill -9 -1

echo "  CJDBC IS STOPPED"

</xsl:template>

</xsl:stylesheet>

