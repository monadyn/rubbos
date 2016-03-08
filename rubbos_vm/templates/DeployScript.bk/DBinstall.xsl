<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@id='DB_install.sh' and @type='current']">
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//argshere[@id='DB_install.sh' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@id='DB_install.sh' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/DBinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
mkdir <xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
chmod 775 <xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
mkdir <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>
chmod 775 <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>
mkdir <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>/lib
mkdir <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>/log
mkdir <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>/run
mkdir <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>/run/mysqld
cp $RUBISWORK_HOME/mysql_conf/master.cnf $RUBIS_TOP/.
cp $WORK_HOME/softwares/mysql-server_v4.tgz $RUBIS_TOP/.
cd $RUBIS_TOP
chmod 755 mysql-server_v4.tgz
tar xvzf mysql-server_v4.tgz
cd mysql-max-3.23.58-pc-linux-i686
scripts/mysql_install_db --defaults-file="../master.cnf"
#cd $RUBIS_TOP/mysql-max-3.23.58-pc-linux-i686/data
cd $RUBIS_TOP/lib/mysql
cp $RUBISWORK_HOME/data/rubis.tar.gz .
chmod 755 rubis.tar.gz
tar xvzf rubis.tar.gz
cd $RUBIS_TOP
rm mysql-server_v4.tgz
#cd mysql-max-3.23.58-pc-linux-i686/data
cd $RUBIS_TOP/lib/mysql
rm rubis.tar.gz

</xsl:template>

</xsl:stylesheet>
