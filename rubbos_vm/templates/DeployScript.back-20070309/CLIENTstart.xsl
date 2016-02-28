<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@id='CLIENT_ignition.sh' and @type='current']"> $WORKLOAD $ST $SMI $EMI $ET  &amp; </xsl:template>

<xsl:template match="//argshere[@id='CLIENT_ignition.sh' and @type='pre-action']">

#Compute start/end time, and measurement start/end time
echo "JKY:compute SMI, EMI, and ET......"
ST=`date +%Y%m%d%H%M%S`
current_seconds=`date +%s`
end_seconds=`echo \( <xsl:value-of select="//instances/params/param[@name='RAMPUP']/@value"/> / 1000 \) + $current_seconds | bc`
SMI=`date -d "1970-01-01 $end_seconds secs UTC" +%Y%m%d%H%M%S`
end_seconds=`echo \( <xsl:value-of select="//instances/params/param[@name='RAMPUP']/@value"/> / 1000 + <xsl:value-of select="//instances/params/param[@name='MI']/@value"/> / 1000 \) + $current_seconds | bc`
EMI=`date -d "1970-01-01 $end_seconds secs UTC" +%Y%m%d%H%M%S`
end_seconds=`echo \( <xsl:value-of select="//instances/params/param[@name='RAMPUP']/@value"/> / 1000 + <xsl:value-of select="//instances/params/param[@name='MI']/@value"/> / 1000 + <xsl:value-of select="//instances/params/param[@name='RAMPDOWN']/@value"/> / 1000 \) + $current_seconds | bc`
ET=`date -d "1970-01-01 $end_seconds secs UTC" +%Y%m%d%H%M%S`

#ST_MS=`date +%s`000
ST_MS=`echo \(60000 / 1000 \) + $current_seconds | bc`000

echo "JKY:start test: " $ST
echo "JKY:start mi  : " $SMI
echo "JKY:end   mi  : " $EMI
echo "JKY:end   test: " $ET

sleep_seconds=`echo \( <xsl:value-of select="//instances/params/param[@name='RAMPUP']/@value"/> / 1000 + <xsl:value-of select="//instances/params/param[@name='MI']/@value"/> / 1000 + <xsl:value-of select="//instances/params/param[@name='RAMPDOWN']/@value"/> / 1000 + 100 \) | bc`
echo "JKY:sleep for " $sleep_seconds " while staging.........................."

#Create "rubis_exp_to_db.conf" file to be stored in the experiment result DB
touch rubis_exp_to_db-$SMI.conf
echo "[experiment]" >> rubis_exp_to_db-$SMI.conf
echo "person run by: " `whoami` >> rubis_exp_to_db-$SMI.conf
echo "num users: " $WORKLOAD >> rubis_exp_to_db-$SMI.conf
echo "ramp up time: " `expr $RAMPUP / 1000` >> rubis_exp_to_db-$SMI.conf
echo "ramp down time: " `expr $RAMPDOWN / 1000` >> rubis_exp_to_db-$SMI.conf
echo "run time: " `expr $MI / 1000` >> rubis_exp_to_db-$SMI.conf
echo "start since epoch in ms: " $ST_MS >> rubis_exp_to_db-$SMI.conf
echo "data hostname: " "<xsl:value-of select="//instances/params/param[@name='DATA_HOSTNAME']/@value"/>" >> rubis_exp_to_db-$SMI.conf
echo "data dir: " "<xsl:value-of select="//instances/params/param[@name='DATA_DIR']/@value"/>" >> rubis_exp_to_db-$SMI.conf
echo "notes: " "<xsl:value-of select="//instances/params/param[@name='NOTE']/@value"/>" >> rubis_exp_to_db-$SMI.conf
echo "predicted write ratio: " "<xsl:value-of select="//instances/params/param[@name='WRITE_RATIO']/@value"/>" >> rubis_exp_to_db-$SMI.conf

<xsl:for-each select="//instances/instance/swname">

echo "[host: <xsl:value-of select="../target"/>]" >> rubis_exp_to_db-$SMI.conf
echo "software name: <xsl:value-of select="."/>" >> rubis_exp_to_db-$SMI.conf
echo "hostname: <xsl:value-of select="../target"/>" >> rubis_exp_to_db-$SMI.conf
echo "machine type: <xsl:value-of select="../target/@type"/>"  >> rubis_exp_to_db-$SMI.conf
echo " "  >> rubis_exp_to_db-$SMI.conf
</xsl:for-each>

#Send this conf file to the data-DB
scp rubis_exp_to_db-$SMI.conf  <xsl:value-of select="//instances/params/param[@name='DATA_HOSTNAME']/@value"/>:<xsl:value-of select="//instances/params/param[@name='DATA_DIR']/@value"/>


</xsl:template>


<xsl:template match="//argshere[@id='CLIENT_ignition.sh' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/CLIENTstart.xsl']">
#!/bin/bash

#CLIENT_HOST=<xsl:value-of select="//instances/instance[@name='CLIENT']/target"/>
CLIENT_HOST="`hostname`"
CLIENT_NAME=1
WORKLOAD=$1
ST=$2
SMI=$3
EMI=$4
ET=$5
CONFIG=<xsl:value-of select="//instances/params/param[@name='CONFIG']/@value"/>
ANAL_HOST=<xsl:value-of select="//instances/instance[@name='ANAL']/target"/>

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $RUBIS_TOP
chmod -R 755 nClient
cd $RUBIS_TOP/nClient

java -Xms128m -Xmx768m -Xss192k -Dhttp.keepAlive=true -Dhttp.maxConnections=1000000 ClientEmulator $CLIENT_HOST $CLIENT_NAME $WORKLOAD $ST $SMI $EMI $ET $CONFIG $ANAL_HOST

</xsl:template>

</xsl:stylesheet>
