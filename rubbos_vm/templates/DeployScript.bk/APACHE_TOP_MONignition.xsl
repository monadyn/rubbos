<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_monitor' and @actype='ignition' and @type='current']"> $SMI $WORKLOAD &amp; </xsl:template>

<xsl:template match="//argshere[@idtype='web_monitor' and @actype='ignition' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='web_monitor' and @actype='ignition' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/APACHE_TOP_MONignition.xsl']">
#!/bin/bash

FREQUENCY=<xsl:value-of select="//instances/params/param[@name='MONFREQUENCY']/@value"/>
SMI=$1
CONFIG=<xsl:value-of select="//instances/params/param[@name='CONFIG']/@value"/>
WORKLOAD=$2

HOSTNAME="`hostname`"

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $RUBIS_TOP

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

./apachetop -d $FREQUENCY -T $FREQUENCY -f $RUBIS_TOP/apache2/logs/access_log >> apache-$HOSTNAME-$CONFIG-$WORKLOAD.data

</xsl:template>

</xsl:stylesheet>

