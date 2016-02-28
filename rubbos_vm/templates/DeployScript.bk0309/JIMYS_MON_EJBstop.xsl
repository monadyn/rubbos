<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@id='JIMYS_MON_EJB_stop.sh' and @type='current']"> $EMI $WORKLOAD &amp; </xsl:template>

<xsl:template match="//argshere[@id='JIMYS_MON_EJB_stop.sh' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@id='JIMYS_MON_EJB_stop.sh' and @type='post-action']"> 

sleep $sleep_seconds;

</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/JIMYS_MON_EJBstop.xsl']">

#!/bin/bash

ANAL_HOST=<xsl:value-of select="//instances/instance[@name='ANAL']/target"/>
EMI=$1
CONFIG=<xsl:value-of select="//instances/params/param[@name='CONFIG']/@value"/>
WORKLOAD=$2
EJB_ID=<xsl:value-of select="//instances/params/param[@name='EJB_ID']/@value"/>
EJB_HOST=<xsl:value-of select="//instances/instance[@type='ejb_container']/target"/>


cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh

# date command in predefined format
date_cmd="date +%Y%m%d%H%M%S"
date=`$date_cmd`

# wait until end time
date=`$date_cmd`
while [ $date -lt $EMI ]; do
  sleep 1
  date=`$date_cmd`
done
echo

killall java

# chmod
cd $RUBISWORK_HOME/softwares/jimys_probe/JimysProbes

<xsl:for-each select="//instances/instance[@type='ejb_container']">
chmod g+w app-<xsl:value-of select="./@name"/>-$CONFIG-$WORKLOAD.data

# send data to analysis host
scp -o StrictHostKeyChecking=false -C app-<xsl:value-of select="./@name"/>-$CONFIG-$WORKLOAD.data $ANAL_HOST:$RUBIS_TOP
</xsl:for-each>

</xsl:template>

</xsl:stylesheet>

