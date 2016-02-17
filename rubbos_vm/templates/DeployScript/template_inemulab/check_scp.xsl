<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='control_server' and @actype='checkScp_exec' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='control_server' and @actype='checkScp_exec' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='control_server' and @actype='checkScp_exec' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/check_scp.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

# Check scp to all servers
echo "*** checking scp to all servers *********************************"
<xsl:for-each select="//instances/instance[contains(@type,'_server')]">
ssh -o StrictHostKeyChecking=no -o BatchMode=yes $<xsl:value-of select="@name"/>_HOST "hostname"</xsl:for-each>

ssh -o StrictHostKeyChecking=no -o BatchMode=yes <xsl:value-of select="//params/env/param[@name='RUBBOS_RESULTS_HOST']/@value"/> "hostname"
ssh -o StrictHostKeyChecking=no -o BatchMode=yes localhost "hostname"

</xsl:template>
</xsl:stylesheet>















