<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='install' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='install' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='install' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/WEBinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  INSTALLING APACHE on $HOSTNAME"

mkdir -p $ELBA_TOP
chmod 755 $ELBA_TOP
mkdir -p $RUBBOS_TOP
chmod 755 $RUBBOS_TOP

# apache
tar zxf $SOFTWARE_HOME/$HTTPD_TARBALL --directory=$RUBBOS_TOP 
cd $HTTPD_INSTALL_FILES 
#./configure --prefix=$HTTPD_HOME --enable-module=so --enable-so
# --enable-mods-shared=all 
export LDFLAGS="-L/lib64 -L/usr/lib64"
./configure --prefix=$HTTPD_HOME --enable-module=so --enable-so --with-mpm=worker 
make 
make install 

# mod jk
tar zxf $SOFTWARE_HOME/$MOD_JK_TARBALL --directory=$RUBBOS_TOP 
tar zxf $SOFTWARE_HOME/$JAVA_TARBALL --directory=$RUBBOS_TOP
#cd $MOD_JK_INSTALL_FILES/jk/native2
#./configure --with-apxs2=$HTTPD_HOME/bin/apxs --enable-jni --with-java-home=$JAVA_HOME
#make
#make install-apxs 
#cd $MOD_JK_INSTALL_FILES/jk/native
cd $MOD_JK_INSTALL_FILES/native
#./configure --with-apxs=$HTTPD_HOME/bin/apxs --enable-jni --with-java-home=$JAVA_HOME
./configure --with-apxs=$HTTPD_HOME/bin/apxs
make
make install 

echo "  APACHE IS INSTALLED on $HOSTNAME"
</xsl:template>

</xsl:stylesheet>
