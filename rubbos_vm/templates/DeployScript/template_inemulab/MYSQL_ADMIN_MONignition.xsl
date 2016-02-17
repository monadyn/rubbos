<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='mon_ignition' and @type='current']"> &amp;</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='mon_ignition' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='mon_ignition' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/MYSQL_ADMIN_MONignition.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

<xsl:choose>
  <xsl:when test="//instances/params/rubbos-conf[@name='MON_FREQUENCY']/@value">
FREQUENCY=<xsl:value-of select="//instances/params/rubbos-conf[@name='MON_FREQUENCY']/@value"/>
  </xsl:when>
  <xsl:otherwise>
FREQUENCY=1
  </xsl:otherwise>
</xsl:choose>

# data filename suffix
data_filename_suffix="`hostname`.data"

# sar filename
mon_filename=$RUBBOS_TOP/mysql_mon-${data_filename_suffix}

# run test until mysqld will be stoped
cd $MYSQL_HOME
mysql_alive=`ps aux|grep mysql|grep -v grep|wc -l`
while [ $mysql_alive -gt 0 ]; do
        echo "========" >> ${mon_filename}
        date "+%Y/%m/%d %H:%M:%S" >> ${mon_filename}
        bin/mysqladmin --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD extended-status >> ${mon_filename}
        sleep $FREQUENCY
        mysql_alive=`ps aux|grep mysql|grep -v grep|wc -l`
done
echo

# chmod
chmod g+w ${mon_filename}
chmod o+r ${mon_filename}

</xsl:template>

</xsl:stylesheet>

