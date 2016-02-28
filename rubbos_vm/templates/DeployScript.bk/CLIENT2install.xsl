<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@id='CLIENT2_install.sh' and @type='current']"> 
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//argshere[@id='CLIENT2_install.sh' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@id='CLIENT2_install.sh' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/CLIENT2install.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
mkdir <xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
chmod 775 <xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
mkdir <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>
chmod 775 <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>
cd $WORK_HOME
cp -R $RUBISWORK_HOME/softwares/nClient $RUBIS_TOP/.
cd $RUBIS_TOP/nClient
javac -deprecation *.java

./replaceTextWith.sh rubis.properties <xsl:value-of select="//instances/instance[@name='WEB1']/target"/> <xsl:text>  </xsl:text>  <xsl:value-of select="//instances/instance[@name='WEB2']/target"/>

#cd /tmp/
#/tmp/elba/rubis/nClient/replaceTextWith.sh CLIENT2_ignition.sh "CLIENT_NAME=1" "CLIENT_NAME=2"

chmod 775 CLIENT2_ignition.sh



</xsl:template>

</xsl:stylesheet>

