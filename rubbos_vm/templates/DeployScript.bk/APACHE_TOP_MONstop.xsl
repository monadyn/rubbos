<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_monitor' and @actype='stop' and @type='current']"> $EMI $WORKLOAD &amp; </xsl:template>

<xsl:template match="//argshere[@idtype='web_monitor' and @actype='stop' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='web_monitor' and @actype='stop' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/APACHE_TOP_MONstop.xsl']">
#!/bin/bash

ANAL_HOST=<xsl:value-of select="//instances/instance[@name='ANAL']/target"/>
EMI=$1
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

# wait until end time
date=`$date_cmd`
while [ $date -lt $EMI ]; do
  sleep 1
  date=`$date_cmd`
done
echo

killall apachetop

# chmod
chmod g+w apache-$HOSTNAME-$CONFIG-$WORKLOAD.data

# send data to analysis host
scp -o StrictHostKeyChecking=false -C apache-$HOSTNAME-$CONFIG-$WORKLOAD.data $ANAL_HOST:$RUBIS_TOP

</xsl:template>

</xsl:stylesheet>

