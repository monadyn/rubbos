<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/" >
<whatever>
<xsl:copy-of select="."/> <xsl:text>  

</xsl:text>
  <xsl:apply-templates select="/xtbl/instances" /> <xsl:text> 
</xsl:text>
</whatever>
</xsl:template>



<xsl:template match="/xtbl/instances">

<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>set_elba_env.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>

set -o allexport
OUTPUT_HOME=<xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
WORK_HOME=<xsl:value-of select="//params/env/param[@name='WORK_HOME']/@value"/>
RUBISWORK_HOME=<xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>
JAVA_HOME=<xsl:value-of select="//params/env/param[@name='JAVA_HOME']/@value"/>
J2EE_HOME=<xsl:value-of select="//params/env/param[@name='J2EE_HOME']/@value"/>
ANT_HOME=<xsl:value-of select="//params/env/param[@name='ANT_HOME']/@value"/>
ELBA_TOP=<xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
TPCW_TOP=<xsl:value-of select="//params/env/param[@name='TPCW_TOP']/@value"/>
RUBIS_TOP=<xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>
JONAS_ROOT=<xsl:value-of select="//params/env/param[@name='JONAS_ROOT']/@value"/>
CATALINA_HOME=<xsl:value-of select="//params/env/param[@name='CATALINA_HOME']/@value"/>
CATALINA_BASE=<xsl:value-of select="//params/env/param[@name='CATALINA_BASE']/@value"/>

CJDBC_HOME=<xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>/c-jdbc-latest-bin

CLASSPATH=$CLASSPATH:$JONAS_ROOT/bin/unix/registry:$JAVA_HOME:$JAVA_HOME/lib/tools.jar:$CATALINA_HOME/common/lib/servlet-api.jar:.

PATH=$JAVA_HOME/bin:$JONAS_ROOT/bin/unix:$ANT_HOME/bin:$CATALINA_HOME/bin:$PATH
set +o allexport

</content>
</file>

<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>manualCleanup.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>


<xsl:for-each select="//instances/instance/action[@type='stop']">
ssh <xsl:value-of select="../target"/> /tmp/<xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh 
</xsl:for-each>

<xsl:for-each select="//instances/instance/action[@type='uninstall']">
ssh <xsl:value-of select="../target"/> /tmp/<xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh
</xsl:for-each>


echo "Cleaning up ...."
<xsl:for-each select="//instances/instance/action">
ssh <xsl:value-of select="../target"/>  rm -f /tmp/<xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh
ssh <xsl:value-of select="../target"/>  kill -9 -1
</xsl:for-each>

</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>run.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>

#!/bin/bash

<xsl:for-each select="//instances/instance">

#Host for <xsl:value-of select="./@name"/> <xsl:text>
</xsl:text>
<xsl:value-of select="./@name"/>_HOST=<xsl:value-of select="./target"/> <xsl:text>
</xsl:text>

</xsl:for-each>


#Experiment running time for a single iteration.(in msec).
RAMPUP=<xsl:value-of select="//instances/params/param[@name='RAMPUP']/@value"/>
MI=<xsl:value-of select="//instances/params/param[@name='MI']/@value"/>
RAMPDOWN=<xsl:value-of select="//instances/params/param[@name='RAMPDOWN']/@value"/>

#Monitoring frequency
FREQUENCY=<xsl:value-of select="//instances/params/param[@name='MONFREQUENCY']/@value"/>

#Move to output scripts home
cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh

#Transfer all sub scripts to target hosts
echo "***install scripts 0000000000000000000000000000000000000000000000"

<xsl:for-each select="//instances/instance/action">
scp <xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh  $<xsl:value-of select="../@name"/>_HOST:/tmp
</xsl:for-each>

#Set experiment start time, used configuration, workload
ST_STAGING=`date +%Y%m%d%H%M%S`
CONFIG=<xsl:value-of select="//instances/params/param[@name='CONFIG']/@value"/>
WORKLOAD=<xsl:value-of select="//instances/params/param[@name='WORKLOAD-START']/@value"/>
echo "JKY:staging with date:" $ST_STAGING
echo "JKY:config:" $CONFIG

#Start loop. Each loop means an iteration
while [ "$WORKLOAD" -lt "<xsl:value-of select="//instances/params/param[@name='WORKLOAD-END']/@value"/>" ]; do
echo "Start of one iteration ...."

#Set how much workload increase per each iteration
WORKLOAD=`expr $WORKLOAD \+ <xsl:value-of select="//instances/params/param[@name='WORKLOAD-STEP']/@value"/>`
echo "JKY:workload:" $WORKLOAD

#Install and Configure and run Apache, Tomcat, JOnAS, and MySQL

<xsl:apply-templates select="/xtbl/instances/instance/action">
  <xsl:sort select="./@seq" data-type="number"/>
</xsl:apply-templates>

echo "End of one iteration....sleep...."
sleep 60;
done
#end of one iteration

#cleanup after experiments
echo "Cleaning up ...."
<xsl:for-each select="//instances/instance/action">
ssh $<xsl:value-of select="../@name"/>_HOST  rm -f /tmp/<xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh
</xsl:for-each>

</content>
</file>
<xsl:text> 
</xsl:text>

<xsl:for-each select="/xtbl/instances/instance/action">

<xsl:text>
</xsl:text>

<file>

<xsl:text> 
</xsl:text>

<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text><xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>

<xsl:text> 
</xsl:text>

<content>

<xsl:text> 
</xsl:text>

<xsl:text disable-output-escaping="yes">&lt;pastehere id=&quot;</xsl:text><xsl:value-of select="./@template"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<xsl:text> 
</xsl:text>

</content>
</file>

<xsl:text>
</xsl:text>

</xsl:for-each>
</xsl:template>


<xsl:template match="/xtbl/instances/instance/action">
<xsl:text> 
</xsl:text>
<xsl:text disable-output-escaping="yes">&lt;argshere type=&quot;pre-action&quot; id=&quot;</xsl:text><xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh<xsl:text disable-output-escaping="yes">&quot; idtype=&quot;</xsl:text><xsl:value-of select="../@type"/><xsl:text disable-output-escaping="yes">&quot; actype=&quot;</xsl:text><xsl:value-of select="./@type"/><xsl:text disable-output-escaping="yes">&quot; instname=&quot;</xsl:text><xsl:value-of select="../@name"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
ssh $<xsl:value-of select="../@name"/>_HOST /tmp/<xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh <xsl:text disable-output-escaping="yes">&lt;argshere type=&quot;current&quot; id=&quot;</xsl:text><xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh<xsl:text disable-output-escaping="yes">&quot; idtype=&quot;</xsl:text><xsl:value-of select="../@type"/><xsl:text disable-output-escaping="yes">&quot; actype=&quot;</xsl:text><xsl:value-of select="./@type"/><xsl:text disable-output-escaping="yes">&quot; instname=&quot;</xsl:text><xsl:value-of select="../@name"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<xsl:text> 
</xsl:text>
<xsl:text disable-output-escaping="yes">&lt;argshere type=&quot;post-action&quot; id=&quot;</xsl:text><xsl:value-of select="../@name"/>_<xsl:value-of select="./@type"/>.sh<xsl:text disable-output-escaping="yes">&quot; idtype=&quot;</xsl:text><xsl:value-of select="../@type"/><xsl:text disable-output-escaping="yes">&quot; actype=&quot;</xsl:text><xsl:value-of select="./@type"/><xsl:text disable-output-escaping="yes">&quot; instname=&quot;</xsl:text><xsl:value-of select="../@name"/><xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<xsl:text> 
</xsl:text>

</xsl:template>



</xsl:stylesheet>


