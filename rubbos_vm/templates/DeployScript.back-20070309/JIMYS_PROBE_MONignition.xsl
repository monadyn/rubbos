<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='ejb_probe_monitor' and @actype='ignition' and @type='current']"> &amp; sleep 3; </xsl:template>

<xsl:template match="//argshere[@idtype='ejb_probe_monitor' and @actype='ignition' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='ejb_probe_monitor' and @actype='ignition' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/JIMYS_PROBE_MONignition.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $RUBISWORK_HOME/softwares/jimys_probe/JimysProbes

./startProbes.sh &amp;



<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>monitorLocal.properties<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>/softwares/jimys_probe/JimysProbes/conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>


mlet.file = file:<xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>/softwares/jimys_probe/JimysProbes/conf/mlet.xml.local
mlet.name = jimys:mbean=mlet

org.objectweb.jimys.monitoredSystem.pump.name = jimys:mbean=org.objectweb.jimys.monitoredSystem.pump
org.objectweb.jimys.monitoredSystem.pump.sampletime = 7000
org.objectweb.jimys.monitoredSystem.pump.compress = false

org.objectweb.jimys.monitoredSystem.admin.name = jimys:mbean=org.objectweb.jimys.monitoredSystem.admin

#probes = cpu;network;memory;fileSystem;cjdbc;jonas;cartography;log;genericJmx
#probes = cpu;network;memory;fileSystem;cartography;log;genericJmx;
#probes = cpu;network;memory;fileSystem;cartography;log;jonasJmx;joramJmx;genericJmx
#probes = cpu;network;memory;fileSystem;cartography;log;jonasJmx;joramJmx
#probes = genericJmx;jonasJmx
probes = jonasJmx
#probes = cpu;joramJmx;

#org.objectweb.jimys.monitoredSystem.probe.genericJmx.name = jimys:mbean=genericJmx
#org.objectweb.jimys.monitoredSystem.probe.genericJmx.attributes = Data
#org.objectweb.jimys.monitoredSystem.probe.genericJmx.sampleTime = 5000
##org.objectweb.jimys.monitoredSystem.probe.genericJmx.init = service:jmx:rmi://saruman.cc.gatech.edu/jndi/rmi://saruman.cc.gatech.edu:1099/jrmpconnector_jonas;<xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>/softwares/jimys_probe/JimysProbes/conf/probes/probeconfig-414.xml;Jonas
#org.objectweb.jimys.monitoredSystem.probe.genericJmx.init = service:jmx:rmi://localhost/jndi/rmi://localhost:1099/jrmpconnector_jonas;<xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>/softwares/jimys_probe/JimysProbes/conf/probes/jvm15.xml;Jonas

org.objectweb.jimys.monitoredSystem.probe.jonasJmx.name = jimys:mbean=jonasJmx
org.objectweb.jimys.monitoredSystem.probe.jonasJmx.attributes = Data
org.objectweb.jimys.monitoredSystem.probe.jonasJmx.sampleTime = 5000
#org.objectweb.jimys.monitoredSystem.probe.jonasJmx.init = service:jmx:rmi://localhost/jndi/rmi://localhost:1099/jrmpconnector_jonas;/home/goebelg/IntelliSVN/JimysProbes/conf/probes/probeconfig-414.xml;Jonas
org.objectweb.jimys.monitoredSystem.probe.jonasJmx.init = service:jmx:rmi://localhost/jndi/rmi://localhost:1099/jrmpconnector_jonas;<xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>/softwares/jimys_probe/JimysProbes/conf/probes/probeconfig-414.xml;Jonas

#org.objectweb.jimys.monitoredSystem.probe.joramJmx.name = jimys:mbean=joramJmx
#org.objectweb.jimys.monitoredSystem.probe.joramJmx.attributes = Data
#org.objectweb.jimys.monitoredSystem.probe.joramJmx.sampleTime = 5000
##org.objectweb.jimys.monitoredSystem.probe.joramJmx.init = service:jmx:rmi://localhost/jndi/rmi://localhost:1099/jrmpconnector_jonas;/home/goebelg/IntelliSVN/JimysProbes/conf/probes/joramProbeConfig.xml;Joram
#org.objectweb.jimys.monitoredSystem.probe.joramJmx.init = service:jmx:rmi://saruman.cc.gatech.edu/jndi/rmi://saruman.cc.gatech.edu:1099/jrmpconnector_jonas;<xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>/softwares/jimys_probe/JimysProbes/conf/probes/joramProbeConfig.xml;Joram


mx4j.config = <xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>/softwares/jimys_probe/JimysProbes/conf/config.xml



</content>
</file>

</xsl:template>

</xsl:stylesheet>

