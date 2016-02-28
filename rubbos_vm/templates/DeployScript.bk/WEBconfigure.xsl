<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='configure' and @type='current']">
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='configure' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='web_server' and @actype='configure' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/WEBconfigure.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $RUBIS_TOP/apache2
cp $RUBISWORK_HOME/apache_conf/httpd.conf conf/.
cp $RUBISWORK_HOME/apache_conf/workers2.properties conf/.
cp -R $RUBISWORK_HOME/softwares/ejb_rubis_web htdocs/.

cp $RUBISWORK_HOME/softwares/jakarta-tomcat-connectors-jk2-src-current.tar.gz  $RUBIS_TOP/.
cd $RUBIS_TOP
tar -xvzf jakarta-tomcat-connectors-jk2-src-current.tar.gz
cd jakarta-tomcat-connectors-jk2-2.0.4-src/jk/native2
./configure --with-apxs2=$RUBIS_TOP/apache2/bin/apxs
make
cd ../build/jk2/apache2
cp mod_jk2.so $RUBIS_TOP/apache2/modules
chmod 777 $RUBIS_TOP/apache2/modules/mod_jk2.so
cd $RUBIS_TOP/apache2



<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>workers2.properties<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>/apache_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>

[logger]
level=DEBUG

[config:]
file=${serverRoot}/conf/workers2.properties
debug=0
debugEnv=0

[uriMap:]
info=Maps the requests. Options: debug
debug=0

[shm:]
info=Scoreboard. Required for reconfiguration and status with multiprocess servers
file=anonymous

[workerEnv:]
info=Global server options
timing=1
debug=0

[lb:lb]
noErrorHeader=1
stickySession=1
recovery=60

<xsl:for-each select="//instances/instance[@type='app_server']">
[channel.socket:<xsl:value-of select="./target"/>:8009]
port=8009
host=<xsl:value-of select="./target"/>
graceful=0
tomcatId=tomcat1
group=lb

[ajp13:<xsl:value-of select="./target"/>:8009]
tomcatId=tomcat1
max_connections=2048
channel=channel.socket:<xsl:value-of select="./target"/>:8009
group=lb
</xsl:for-each>

#[channel.socket:awing9.cc.gatech.edu:8009]
#port=8009
#host=awing9.cc.gatech.edu
#graceful=0
#tomcatId=tomcat1
#group=lb

#[ajp13:awing9.cc.gatech.edu:8009]
#tomcatId=tomcat1
##max_connections=1024
#max_connections=4096
#channel=channel.socket:awing9.cc.gatech.edu:8009
#group=lb

#[channel.socket:awing12.cc.gatech.edu:8009]
#port=8009
#host=awing12.cc.gatech.edu
#graceful=0
#tomcatId=tomcat1
#group=lb

#[ajp13:awing12.cc.gatech.edu:8009]
#tomcatId=tomcat1
#max_connections=512
#channel=channel.socket:awing12.cc.gatech.edu:8009
#group=lb

#[channel.socket:awing9.cc.gatech.edu:8009]
#port=8009
#host=awing9.cc.gatech.edu
#graceful=0
#tomcatId=tomcat1
#group=lb

#[ajp13:awing9.cc.gatech.edu:8009]
#tomcatId=tomcat1
#max_connections=512
#channel=channel.socket:awing9.cc.gatech.edu:8009
#group=lb

[channel.jni:jni]
info=The jni channel, used if tomcat is started inprocess

[status:]
info=Status worker, displays runtime informations

[vm:]
info=Parameters used to load a JVM in the server process

[worker.jni:onStartup]
info=Command to be executed by the VM on startup. This one will start tomcat.
class=org/apache/jk/apr/TomcatStarter
ARG=start
disabled=1
stdout=${serverRoot}/logs/stdout.log
stderr=${serverRoot}/logs/stderr.log

[worker.jni:onShutdown]
info=Command to be executed by the VM on shutdown. This one will stop tomcat.
class=org/apache/jk/apr/TomcatStarter
ARG=stop
disabled=1

[uri:/jkstatus/*]
info=Display status information and checks the config file for changes.
group=status:

[uri:127.0.0.1:8003]
info=Example virtual host. Make sure myVirtualHost is in /etc/hosts to test it
alias=myVirtualHost:8003

[uri:127.0.0.1:8003/ex]
info=Example webapp in the virtual host. It'll go to lb_1 ( i.e. localhost:8019 )
context=/ex
group=lb_1

[uri:/examples]
info=Example webapp in the default context. 
context=/examples
debug=0

[uri:/examples1/*]
info=A second webapp, this time going to the second tomcat only.
group=lb_1
debug=0

[uri:/examples/servlet/*]
info=Prefix mapping

[uri:/examples/*]
info=Map the whole webapp

[uri:/examples/servlet/HelloW]
info=Example with debug enabled.
debug=10

#[uri:/rubis_servlets/servlet/*]
#group=lb

[uri:/ejb_rubis_web/servlet/*]
group=lb

#[uri:/servlet/*]
#group=lb

#[uri:/*.jsp]
#group=lb

#[uri:/jsp-examples/*]
#group=lb


</content>
</file>

</xsl:template>

</xsl:stylesheet>

