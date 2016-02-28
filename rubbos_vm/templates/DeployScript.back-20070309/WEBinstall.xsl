<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='install' and @type='current']">
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='install' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='web_server' and @actype='install' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/WEBinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh

if [ -e $RUBIS_TOP/rubis-deploy-log.txt ] &amp;&amp; grep -q "Apache installed successfully" $RUBIS_TOP/rubis-deploy-log.txt
then

echo " "
echo "***** Previously installed Apache detected!!! *******"
echo "***** skipping Apache installation ******************"
echo " "


else

mkdir <xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
chmod 775 <xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
mkdir <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>
chmod 775 <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>

cd $WORK_HOME
cp softwares/httpd-2.0.54.tar.gz $RUBIS_TOP/.
cd $RUBIS_TOP
chmod 755 httpd-2.0.54.tar.gz
tar -xzvf httpd-2.0.54.tar.gz
rm httpd-2.0.54.tar.gz
cd httpd-2.0.54
./configure --prefix=/tmp/elba/rubis/apache2  --enable-so --enable-cgi --enable-mods-shared=all --with-mpm=worker
make
make install

fi


touch $RUBIS_TOP/rubis-deploy-log-tmp.txt
echo "[STATUS]: Apache installed successfully" >> $RUBIS_TOP/rubis-deploy-log-tmp.txt


</xsl:template>

</xsl:stylesheet>
