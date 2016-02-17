<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='install' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='install' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and @actype='install' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/TOMCATinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  INSTALLING TOMCAT on $HOSTNAME"

mkdir -p $ELBA_TOP
sudo chmod 755 $ELBA_TOP
mkdir -p $RUBBOS_TOP
chmod 755 $RUBBOS_TOP

unzip -u -q /mnt/softwares/$OPENTAPS_RUBBOS_ZIP -d $RUBBOS_TOP
sleep 10
cp -r /mnt/softwares/c-jdbc-driver.jar $OPENTAPS_HOME/framework/entity/lib/jdbc/
cp -r $OUTPUT_HOME/tomcat_conf/entityengine.xml $OPENTAPS_HOME/framework/entity/config/entityengine.xml
cp -r $OUTPUT_HOME/tomcat_conf/cache.properties $OPENTAPS_HOME/framework/base/config/cache.properties
cp -r $OUTPUT_HOME/tomcat_conf/debug.properties $OPENTAPS_HOME/framework/base/config/debug.properties
cp -r $OUTPUT_HOME/tomcat_conf/ofbiz-containers.xml $OPENTAPS_HOME/framework/base/config/ofbiz-containers.xml
cp -r $OUTPUT_HOME/tomcat_conf/component-load.xml $OPENTAPS_HOME/hot-deploy/component-load.xml
cp -r $OUTPUT_HOME/tomcat_conf/startofbiz.sh $OPENTAPS_HOME/
cp -rf $OUTPUT_HOME/tomcat_conf/mysql.properties /mnt/elba/rubbos/RUBBoS/Servlets/mysql.properties

rm -rf $OPENTAPS_HOME/hot-deploy/rubbos
cp -rf $OUTPUT_HOME/tomcat_conf/rubbos $OPENTAPS_HOME/hot-deploy/
cp -r $OUTPUT_HOME/tomcat_conf/ofbiz-entity.jar $OPENTAPS_HOME/framework/entity/build/lib/ofbiz-entity.jar
cp -r $OUTPUT_HOME/tomcat_conf/ofbiz-webapp.jar $OPENTAPS_HOME/framework/webapp/build/lib/ofbiz-webapp.jar


tar xzf $SOFTWARE_HOME/$TOMCAT_TARBALL --directory=$RUBBOS_TOP
tar xzf $SOFTWARE_HOME/$JAVA_TARBALL   --directory=$RUBBOS_TOP
tar xzf $SOFTWARE_HOME/$J2EE_TARBALL   --directory=$RUBBOS_TOP
tar xzf $SOFTWARE_HOME/$ANT_TARBALL    --directory=$RUBBOS_TOP

echo "  DONE INSTALLING TOMCAT on $HOSTNAME"

</xsl:template>
</xsl:stylesheet>











