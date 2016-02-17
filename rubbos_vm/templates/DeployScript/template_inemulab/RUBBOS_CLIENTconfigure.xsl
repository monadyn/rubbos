<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[(@idtype='benchmark_server' or @idtype='client_server') and  @actype='configure' and @type='current']"></xsl:template>

<xsl:template match="//argshere[(@idtype='benchmark_server' or @idtype='client_server') and  @actype='configure' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[(@idtype='benchmark_server' or @idtype='client_server') and  @actype='configure' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/RUBBOS_CLIENTconfigure.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  CONFIGURING RUBBOS CLIENT on $HOSTNAME"

cp -r $WORK_HOME/rubbos_files/Client $RUBBOS_HOME/
cp -r $WORK_HOME/rubbos_files/bench $RUBBOS_HOME/

cp $OUTPUT_HOME/rubbos_conf/build.properties $RUBBOS_HOME/
cp $OUTPUT_HOME/rubbos_conf/config.mk $RUBBOS_HOME/
cp $OUTPUT_HOME/rubbos_conf/Makefile $RUBBOS_HOME/

cp $OUTPUT_HOME/rubbos_conf/rubbos-servletsBO.sh $RUBBOS_HOME/bench/
cp $OUTPUT_HOME/rubbos_conf/rubbos-servletsRW.sh $RUBBOS_HOME/bench/

chmod ug+x $RUBBOS_HOME/bench/*.sh

#build clients
echo "  COMPILING RUBBOS CLIENT on $HOSTNAME"
cd $RUBBOS_HOME/Client
make clean
make

echo "  DONE CONFIGURING RUBBOS CLIENT on $HOSTNAME"

<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>build.properties<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/rubbos_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
src = .
dist =.
classes.dir = ./build
web.dir = ../Servlet_HTML

j2ee = <xsl:value-of select="//params/env/param[@name='J2EE_HOME']/@value"/>
<xsl:choose>
  <xsl:when test="//instances/instance[@type='cjdbc_server']">
cjdbc_driver = ./<xsl:value-of select="//params/env/param[@name='CJDBC_DRIVER']/@value"/>
cjdbc_controller = ./<xsl:value-of select="//params/env/param[@name='CJDBC_CONTROLLER']/@value"/>
  </xsl:when>
  <xsl:when test="//instances/instance[@type='sequoia_server']">
sequoia_driver = ./<xsl:value-of select="//params/env/param[@name='SEQUOIA_DRIVER']/@value"/>
  </xsl:when>
  <xsl:when test="//instances/instance[@type='db_server' and swname='postgres']">
postgres_connector = ./<xsl:value-of select="//params/env/param[@name='POSTGRES_CONNECTOR']/@value"/>
  </xsl:when>
  <xsl:otherwise>
mysql_connector = ./<xsl:value-of select="//params/env/param[@name='MYSQL_CONNECTOR']/@value"/>
  </xsl:otherwise>
</xsl:choose>
</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>config.mk<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/rubbos_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
##############################
#    Environment variables   #
##############################

JAVA  = $(JAVA_HOME)/bin/java
JAVAC = $(JAVA_HOME)/bin/javac
JAVACOPTS = -deprecation
JAVACC = $(JAVAC) $(JAVACOPTS)
RMIC = $(JAVA_HOME)/bin/rmic
RMIREGISTRY= $(JAVA_HOME)/bin/rmiregistry
CLASSPATH = .:$(J2EE_HOME)/lib/j2ee.jar:$(JAVA_HOME)/jre/lib/rt.jar:$(CATALINA_HOME)/common/lib/servlet-api.jar
JAVADOC = $(JAVA_HOME)/bin/javadoc
JAR = $(JAVA_HOME)/bin/jar

GENIC = ${JONAS_ROOT}/bin/unix/GenIC

MAKE = gmake
CP = /bin/cp
RM = /bin/rm
MKDIR = /bin/mkdir


# EJB server: supported values are jonas or jboss
EJB_SERVER = jonas

# DB server: supported values are MySQL or PostgreSQL
DB_SERVER = MySQL

%.class: %.java
	${JAVACC} -classpath ${CLASSPATH} $&lt;

</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>Makefile<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/rubbos_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>

###########################
#    RUBBoS Makefile      #
###########################

include config.mk

##############################
#    Environment variables   #
##############################

JAVA  = $(JAVA_HOME)/bin/java
JAVAC = $(JAVA_HOME)/bin/javac
JAVACOPTS = -deprecation
JAVACC = $(JAVAC) $(JAVACOPTS)
RMIC = $(JAVA_HOME)/bin/rmic
RMIREGISTRY= $(JAVA_HOME)/bin/rmiregistry 
#CLASSPATH = .:$(J2EE_HOME)/lib/j2ee.jar:$(JAVA_HOME)/jre/lib/rt.jar:$TOMCATservlet.jar
CLASSPATH = .:$(J2EE_HOME)/lib/j2ee.jar:$(JAVA_HOME)/jre/lib/rt.jar
JAVADOC = $(JAVA_HOME)/javadoc


#########################
#    Servlets version   #
#########################
#ServletPrinter 
Servlets = Config TimeManagement BrowseCategories Auth RegisterUser RubbosHttpServlet BrowseRegions SearchItemsByCategory SearchItemsByRegion ViewItem ViewBidHistory ViewUserInfo SellItemForm RegisterItem PutCommentAuth PutComment StoreComment BuyNowAuth BuyNow StoreBuyNow PutBidAuth PutBid StoreBid AboutMe

all_servlets_sources =  $(addprefix edu/rice/rubbos/servlets/, $(addsuffix .java, $(Servlets)))
all_servlets_obj = $(addprefix edu/rice/rubbos/servlets/, $(addsuffix .class, $(Servlets)))

servlets: $(all_servlets_obj)

clean_servlets:
	rm -f edu/rice/rubbos/servlets/*.class

####################
#       Client     #
####################

ClientFiles = URLGenerator URLGeneratorPHP RUBBoSProperties Stats \
	      TransitionTable ClientEmulator UserSession 

all_client_sources =  $(addprefix edu/rice/rubbos/client/, $(addsuffix .java, $(ClientFiles)))
all_client_obj = $(addprefix edu/rice/rubbos/client/, $(addsuffix .class, $(ClientFiles))) edu/rice/rubbos/beans/TimeManagement.class

client: $(all_client_obj)

initDB:
	${JAVA} -classpath .:./database edu.rice.rubbos.client.InitDB ${PARAM}

emulator:
	${JAVA} -classpath Client:Client/rubbos_client.jar:. <xsl:value-of select="//params/env/param[@name='JAVA_OPTS']/@value"/> -Dhttp.keepAlive=true -Dhttp.maxConnections=1000000 edu.rice.rubbos.client.ClientEmulator

emulatorDebug:
	${JAVA} -classpath Client:Client/rubbos_client.jar:. -Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n <xsl:value-of select="//params/env/param[@name='JAVA_OPTS']/@value"/> -Dhttp.keepAlive=true -Dhttp.maxConnections=1000000 edu.rice.rubbos.client.ClientEmulator


############################
#       Global rules       #
############################


all: beans ejb_servlets client javadoc flush_cache

world: all servlets

javadoc :
	${JAVADOC} -d ./doc/api -bootclasspath ${CLASSPATH} -version -author -windowtitle "RUBBoS API" -header "&lt;b&gt;RUBBoS (C)2001 Rice University/INRIA&lt;/b&gt;&lt;br&gt;" edu.rice.rubbos.beans edu.rice.rubbos.beans.servlets edu.rice.rubbos.client

clean:
	rm -f core edu/rice/rubbos/beans/*.class edu/rice/rubbos/beans/JOnAS* edu/rice/rubbos/beans/servlets/*.class edu/rice/rubbos/client/*.class edu/rice/rubbos/servlets/*.class

%.class: %.java
	${JAVACC} -classpath ${CLASSPATH} $&lt;

flush_cache: bench/flush_cache.c
	gcc bench/flush_cache.c -o bench/flush_cache

</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>rubbos-servletsBO.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/rubbos_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content><!--

-->#!/bin/bash

###############################################################################
#
# This script runs first the RUBBoS browsing mix, then the read/write mix 
# for each rubbos.properties_XX specified where XX is the number of emulated
# clients. Note that the rubbos.properties_XX files must be configured
# with the corresponding number of clients.
# In particular set the following variables in rubis.properties_XX:
# httpd_use_version = Servlets
# workload_number_of_clients_per_node = XX/number of client machines
# workload_transition_table = yourPath/RUBBoS/workload/transitions.txt 
#
# This script should be run from the RUBBoS/bench directory on the local 
# client machine. 
# Results will be generated in the RUBBoS/bench directory.
#
################################################################################

#setenv SERVLETDIR $RUBBOS_HOME/Servlets

# Go back to RUBBoS root directory
cd ..

# Browse only

cp --reply=yes ./workload/browse_only_transitions.txt ./workload/user_transitions.txt
cp --reply=yes ./workload/browse_only_transitions.txt ./workload/author_transitions.txt
<xsl:for-each select="//instances/instance[@type='client_server']">
scp ./workload/browse_only_transitions.txt ${<xsl:value-of select="./@name"/>_HOST}:${RUBBOS_HOME}/workload/user_transitions.txt
scp ./workload/browse_only_transitions.txt ${<xsl:value-of select="./@name"/>_HOST}:${RUBBOS_HOME}/workload/author_transitions.txt
</xsl:for-each>

<xsl:for-each select="//instances/instance[@type='client_server']">
scp Client/rubbos.properties ${<xsl:value-of select="./@name"/>_HOST}:${RUBBOS_HOME}/Client/rubbos.properties<!--
--></xsl:for-each>


bench/flush_cache 490000
<xsl:for-each select="//instances/instance[@type='web_server']"
>ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 880000"       # web server
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='db_server']">
<xsl:choose>
<xsl:when test="./target[@type='pc600']"
  >ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 160000"       # database server
</xsl:when>
<xsl:otherwise
  >ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 880000"       # database server
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='app_server']"
>ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 780000"       # servlet server
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='cjdbc_server']"
>ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 880000"       # c-jdbc
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='sequoia_server']"
>ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 880000"       # sequoia
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='client_server']"
>ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 490000"       # remote client
</xsl:for-each>

<xsl:if test="//params/rubbos-conf/param[contains(@name,'Monitor') and @value='true']">
<xsl:choose>
  <xsl:when test="//params/rubbos-conf/param[@name='upRampTime']">
RAMPUP=<xsl:value-of select="//params/rubbos-conf/param[@name='upRampTime']/@value"/>
  </xsl:when>
  <xsl:otherwise>
RAMPUP=180000
  </xsl:otherwise>
</xsl:choose>
<xsl:choose>
  <xsl:when test="//params/rubbos-conf/param[@name='runTime']">
MI=<xsl:value-of select="//params/rubbos-conf/param[@name='runTime']/@value"/>
  </xsl:when>
  <xsl:otherwise>
MI=720000
  </xsl:otherwise>
</xsl:choose>
current_seconds=`date +%s`
start_seconds=`echo \( $RAMPUP / 1000 \) + $current_seconds - 60 | bc`
SMI=`date -d "1970-01-01 $start_seconds secs UTC" +%Y%m%d%H%M%S`
end_seconds=`echo \( $RAMPUP / 1000 + $MI / 1000 + 30 \) + $current_seconds | bc`
EMI=`date -d "1970-01-01 $end_seconds secs UTC" +%Y%m%d%H%M%S`
<xsl:for-each select="//instances/instance[contains(@type, '_server') and @type!='control_server']"
>ssh $<xsl:value-of select="./@name"/>_HOST "sudo nice -n -1 $RUBBOS_TOP/cpu_mem.sh $SMI $EMI" &amp;
</xsl:for-each>
</xsl:if>

make emulator

</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>rubbos-servletsRW.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/rubbos_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content><!--

-->#!/bin/bash

###############################################################################
#
# This script runs first the RUBBoS browsing mix, then the read/write mix 
# for each rubbos.properties_XX specified where XX is the number of emulated
# clients. Note that the rubbos.properties_XX files must be configured
# with the corresponding number of clients.
# In particular set the following variables in rubis.properties_XX:
# httpd_use_version = Servlets
# workload_number_of_clients_per_node = XX/number of client machines
# workload_transition_table = yourPath/RUBBoS/workload/transitions.txt 
#
# This script should be run from the RUBBoS/bench directory on the local 
# client machine. 
# Results will be generated in the RUBBoS/bench directory.
#
################################################################################

#setenv SERVLETDIR $RUBBOS_HOME/Servlets

# Go back to RUBBoS root directory
cd ..

# Read/write mix

cp --reply=yes ./workload/user_default_transitions.txt ./workload/user_transitions.txt
cp --reply=yes ./workload/author_default_transitions.txt ./workload/author_transitions.txt
<xsl:for-each select="//instances/instance[@type='client_server']">
scp ./workload/user_default_transitions.txt ${<xsl:value-of select="./@name"/>_HOST}:${RUBBOS_HOME}/workload/user_transitions.txt
scp ./workload/author_default_transitions.txt ${<xsl:value-of select="./@name"/>_HOST}:${RUBBOS_HOME}/workload/author_transitions.txt
</xsl:for-each>

<xsl:for-each select="//instances/instance[@type='client_server']">
scp Client/rubbos.properties ${<xsl:value-of select="./@name"/>_HOST}:${RUBBOS_HOME}/Client/rubbos.properties<!--
--></xsl:for-each>


bench/flush_cache 490000
<xsl:for-each select="//instances/instance[@type='web_server']"
>ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 880000"       # web server
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='db_server']">
<xsl:choose>
  <xsl:when test="./target[@type='pc600']"
    >ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 160000"       # database server
  </xsl:when>
  <xsl:otherwise
    >ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 880000"       # database server
  </xsl:otherwise>
</xsl:choose>
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='app_server']"
>ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 780000"       # servlet server
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='cjdbc_server']"
>ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 880000"       # c-jdbc
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='sequoia_server']"
>ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 880000"       # sequoia
</xsl:for-each>
<xsl:for-each select="//instances/instance[@type='client_server']"
>ssh $<xsl:value-of select="./@name"/>_HOST "$RUBBOS_HOME/bench/flush_cache 490000"       # remote client
</xsl:for-each>

<xsl:choose>
  <xsl:when test="//params/rubbos-conf/param[@name='upRampTime']">
RAMPUP=<xsl:value-of select="//params/rubbos-conf/param[@name='upRampTime']/@value"/>
  </xsl:when>
  <xsl:otherwise>
RAMPUP=180000
  </xsl:otherwise>
</xsl:choose>
<xsl:choose>
  <xsl:when test="//params/rubbos-conf/param[@name='runTime']">
MI=<xsl:value-of select="//params/rubbos-conf/param[@name='runTime']/@value"/>
  </xsl:when>
  <xsl:otherwise>
MI=720000
  </xsl:otherwise>
</xsl:choose>
current_seconds=`date +%s`
start_seconds=`echo \( $RAMPUP / 1000 \) + $current_seconds - 60 | bc`
SMI=`date -d "1970-01-01 $start_seconds secs UTC" +%Y%m%d%H%M%S`
end_seconds=`echo \( $RAMPUP / 1000 + $MI / 1000 + 30 \) + $current_seconds | bc`
EMI=`date -d "1970-01-01 $end_seconds secs UTC" +%Y%m%d%H%M%S`
<xsl:for-each select="//instances/instance[contains(@type, '_server') and @type!='control_server']"
>ssh $<xsl:value-of select="./@name"/>_HOST "sudo nice -n -1 $RUBBOS_TOP/cpu_mem.sh $SMI $EMI" &amp;
</xsl:for-each>

make emulator

</content>
</file>


</xsl:template>

</xsl:stylesheet>
