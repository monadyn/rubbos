<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='db_monitor' and @actype='ignition' and @type='current']"> $SMI $EMI $WORKLOAD &amp; </xsl:template>

<xsl:template match="//argshere[@idtype='db_monitor' and @actype='ignition' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='db_monitor' and @actype='ignition' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/MYSQL_ADMIN_MONignition.xsl']">
#!/bin/bash

FREQUENCY=<xsl:value-of select="//instances/params/param[@name='MONFREQUENCY']/@value"/>
ANAL_HOST=<xsl:value-of select="//instances/instance[@name='ANAL']/target"/>
SMI=$1
EMI=$2
CONFIG=<xsl:value-of select="//instances/params/param[@name='CONFIG']/@value"/>
WORKLOAD=$3

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $RUBIS_TOP/mysql-max-3.23.58-pc-linux-i686

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

# run test until end time
while [ $date -lt $EMI ]; do
        TIME=`date +%Y-%m-%d_%H-%M-%S`
        echo $TIME >> mysql-$CONFIG-$WORKLOAD.data
        bin/mysqladmin -uroot -prubis extended-status >> mysql-$CONFIG-$WORKLOAD.data
        sleep $FREQUENCY
        date=`$date_cmd`
done
echo

# chmod
chmod g+w mysql-$CONFIG-$WORKLOAD.data

# send data to analysis host
scp -o StrictHostKeyChecking=false -C mysql-$CONFIG-$WORKLOAD.data $ANAL_HOST:$RUBIS_TOP

</xsl:template>

</xsl:stylesheet>

