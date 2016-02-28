<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='install' and @type='current']">
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='install' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='app_server' and @actype='install' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/TOMCATinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
mkdir <xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
chmod 775 <xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
mkdir <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>
chmod 775 <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>

cd $WORK_HOME
cp softwares/jonas4.6.6-bin.tgz $RUBIS_TOP/.
#cp softwares/jonas3.3.6-bin.tgz $RUBIS_TOP/.
cd $RUBIS_TOP
chmod 755 jonas4.6.6-bin.tgz
#chmod 755 jonas3.3.6-bin.tgz
tar -xzvf jonas4.6.6-bin.tgz
#tar -xzvf jonas3.3.6-bin.tgz
rm jonas4.6.6-bin.tgz
#rm jonas3.3.6-bin.tgz
cd $WORK_HOME
#cp softwares/apache-tomcat-5.5.16.tar.gz $RUBIS_TOP/.
cp softwares/jakarta-tomcat-5.0.28.tar.gz $RUBIS_TOP/.
cd $RUBIS_TOP
#chmod 755 apache-tomcat-5.5.16.tar.gz
#tar -xzvf apache-tomcat-5.5.16.tar.gz
#rm apache-tomcat-5.5.16.tar.gz
chmod 755 jakarta-tomcat-5.0.28.tar.gz
tar -xzvf jakarta-tomcat-5.0.28.tar.gz
rm jakarta-tomcat-5.0.28.tar.gz

</xsl:template>

</xsl:stylesheet>
