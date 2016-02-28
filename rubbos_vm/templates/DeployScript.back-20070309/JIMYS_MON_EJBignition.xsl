<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@id='JIMYS_MON_EJB_ignition.sh' and @type='current']"> $SMI $WORKLOAD &amp; </xsl:template>

<xsl:template match="//argshere[@id='JIMYS_MON_EJB_ignition.sh' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@id='JIMYS_MON_EJB_ignition.sh' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/JIMYS_MON_EJBignition.xsl']">
#!/bin/bash

SMI=$1
EJB_ID=<xsl:value-of select="//instances/params/param[@name='EJB_ID']/@value"/>
EJB_HOST=<xsl:value-of select="//instances/instance[@type='ejb_container']/target"/>
CONFIG=<xsl:value-of select="//instances/params/param[@name='CONFIG']/@value"/>
WORKLOAD=$2

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $RUBISWORK_HOME/softwares/jimys_probe/JimysProbes

# date command in predefined format
date_cmd="date +%Y%m%d%H%M%S"
date=`$date_cmd`

echo "JKY: wait for rampup......"
# wait until start time
date=`$date_cmd`
while [ $date -lt $SMI ]; do
  sleep 1
  date=`$date_cmd`
done
echo

<xsl:for-each select="//instances/instance[@type='ejb_container']">
./start_probe_client.sh <xsl:value-of select="./@name"/><xsl:text> </xsl:text><xsl:value-of select="./target"/>  $CONFIG $WORKLOAD &amp;
</xsl:for-each>

</xsl:template>

</xsl:stylesheet>

