<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[contains(@idtype, '_server') and  @actype='rubbos_install' and @type='current']"></xsl:template>

<xsl:template match="//argshere[contains(@idtype, '_server') and  @actype='rubbos_install' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[contains(@idtype, '_server') and  @actype='rubbos_install' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/RUBBOSinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  INSTALLING RUBBOS/SYSSTAT on $HOSTNAME"

mkdir -p $RUBBOS_TOP

# install RUBBoS
tar xzf $SOFTWARE_HOME/$RUBBOS_TARBALL --directory=$RUBBOS_TOP
#tar xzf $SOFTWARE_HOME/rubbos_html.tar.gz --directory=$RUBBOS_HOME/Servlet_HTML/
cp $SOFTWARE_HOME/flush_cache $RUBBOS_HOME/bench/.

# install sysstat
tar xzf $SOFTWARE_HOME/$SYSSTAT_TARBALL --directory=$RUBBOS_TOP
cp $OUTPUT_HOME/sysstat_conf/CONFIG $SYSSTAT_HOME/build/
cd $SYSSTAT_HOME
make
sudo make install

# install a script to collect statistics data
cp $OUTPUT_HOME/rubbos_conf/cpu_mem.sh $RUBBOS_TOP/.
chmod 755 $RUBBOS_TOP/cpu_mem.sh

# install dstat
mkdir -p $RUBBOS_TOP/dstat
tar xvf $DSTAT_TARBALL --directory=$RUBBOS_TOP
echo "  DONE INSTALLING DSTAT on $HOSTNAME"
echo "  DONE INSTALLING RUBBOS/SYSSTAT on $HOSTNAME"

<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>CONFIG<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/sysstat_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
# Configuration file for sysstat
# (C) 2000-2006 Sebastien GODARD (sysstat &lt;at&gt; wanadoo.fr)

# Directories
PREFIX = <xsl:value-of select="//params/env/param[@name='SYSSTAT_HOME']/@value"/>
SA_LIB_DIR = <xsl:value-of select="//params/env/param[@name='SYSSTAT_HOME']/@value"/>/lib/sa
SADC_PATH = ${SA_LIB_DIR}/sadc
SA_DIR = <xsl:value-of select="//params/env/param[@name='SYSSTAT_HOME']/@value"/>/var/log/sa
MAN_DIR = <xsl:value-of select="//params/env/param[@name='SYSSTAT_HOME']/@value"/>/man
CLEAN_SA_DIR = n
YESTERDAY = 
HISTORY = 7

DFLAGS =
SAS_DFLAGS =

ENABLE_NLS = y
ENABLE_SMP_WRKARD = n

ifeq ($(ENABLE_NLS),y)
# NLS (National Language Support)
REQUIRE_NLS = -DUSE_NLS -DPACKAGE=\"$(PACKAGE)\" -DLOCALEDIR=\"$(PREFIX)/share/locale\"
endif
ifdef REQUIRE_NLS
   DFLAGS += $(REQUIRE_NLS)
endif

ifeq ($(ENABLE_SMP_WRKARD),y)
# Uncomment this to enable workaround for Linux kernel SMP race condition
SAS_DFLAGS += -DSMP_RACE
endif

# Man page group
MAN_GROUP = man

# Crontab owner
CRON_OWNER = adm

# Run-command directories
RC_DIR = /etc
INIT_DIR = /etc/init.d
INITD_DIR = init.d

INSTALL_CRON = n

</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>cpu_mem.sh<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/rubbos_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh
cd -

# delay inbetween snapshots
<xsl:choose>
  <xsl:when test="//params/rubbos-conf/param[@name='MON_FREQUENCY']">
delay=<xsl:value-of select="//params/rubbos-conf/param[@name='MON_FREQUENCY']/@value"/>
  </xsl:when>
  <xsl:otherwise>
delay=1
  </xsl:otherwise>
</xsl:choose>

# central host to send results to
analysis_host=$BENCHMARK_HOST

# monitoring start/end time in format YYYYmmddHHMMSS (20050920152059)
start_time=$1
end_time=$2

# data filename suffix
data_filename_suffix="`hostname`-${start_time}.data"

# sar filename
sar_filename=$RUBBOS_TOP/sar-${data_filename_suffix}

# iostat filename
iostat_filename=$RUBBOS_TOP/iostat-${data_filename_suffix}

# ps filename
ps_filename=$RUBBOS_TOP/ps-${data_filename_suffix}

# date command in predefined format
date_cmd="date +%Y%m%d%H%M%S"
date=`$date_cmd`

# TEST MODE: start_time will be 2 seconds from launch, end time 5 seconds
#start_time=`expr $date \+ 2`
#end_time=`expr $date \+ 5`

#echo
#echo Current timestamp:  $date
#echo Start timestamp:  $start_time
#echo End timestamp:  $end_time
#echo

# make sure they have all arguments
if [ "$end_time" = "" ]; then
  echo usage: $0 \&lt;delay\&gt; \&lt;analysis host\&gt; \&lt;start time\&gt; \&lt;end time\&gt;
  echo start_time and end_time are in YYYYmmddHHMMSS format
  echo ie: 9/30/2005, 2:31:54pm = 20050930143154
  echo
  exit
fi

# wait until start time
#echo -n Waiting until start time \(${start_time}\)..
date=`$date_cmd`
while [ $date -lt $start_time ]; do
  sleep 1
  date=`$date_cmd`
done
#echo

<xsl:if test="//params/rubbos-conf/param[@name='sarMonitor']/@value='true'">
# launch sar
sudo nice -n -1 $SYSSTAT_HOME/bin/sar -Bru -b -d -R -w -W -x ALL -n ALL $delay 0 &gt; ${sar_filename} &amp;
sar_pid=$!
</xsl:if>
<xsl:if test="//params/rubbos-conf/param[@name='iostatMonitor']/@value='true'">
# launch iostat
sudo nice -n -1 $SYSSTAT_HOME/bin/iostat -dxtk $delay &gt; ${iostat_filename} &amp;
iostat_pid=$!
</xsl:if>

# run test until end time
#echo -n Running test until end time \(${end_time}\)..
while [ $date -lt $end_time ]; do
<xsl:if test="//params/rubbos-conf/param[@name='psMonitor']/@value='true'">
  echo PS_START $date &gt;&gt; ${ps_filename}
  ps -eo user,pcpu,pmem,rss,size,vsize,pid,ppid,comm &gt;&gt; ${ps_filename}
  echo PS_END $date &gt;&gt; ${ps_filename}
</xsl:if>
  sleep $delay
  date=`$date_cmd`
done
#echo

<xsl:if test="//params/rubbos-conf/param[@name='sarMonitor']/@value='true'">
# kill SAR
#echo Killing sar \(${sar_pid}\)
sudo kill -9 $sar_pid
</xsl:if>
<xsl:if test="//params/rubbos-conf/param[@name='iostatMonitor']/@value='true'">
# kill iostat
sudo kill -9 $iostat_pid
</xsl:if>

# chmod
<xsl:if test="//params/rubbos-conf/param[@name='psMonitor']/@value='true'">
chmod g+w ${ps_filename}
</xsl:if>
<xsl:if test="//params/rubbos-conf/param[@name='sarMonitor']/@value='true'">
sudo chmod g+w ${sar_filename}
sudo chmod o+r ${sar_filename}
</xsl:if>
<xsl:if test="//params/rubbos-conf/param[@name='iostatMonitor']/@value='true'">
sudo chmod g+w ${iostat_filename}
sudo chmod o+r ${iostat_filename}
</xsl:if>

# send data to analysis host
#echo Sending data to analysis host.. 
#scp -o StrictHostKeyChecking=no -o BatchMode=yes ${sar_filename} ${analysis_host}:/tmp/elba/rubbos
#scp -o StrictHostKeyChecking=no -o BatchMode=yes ${ps_filename} ${analysis_host}:/tmp/elba/rubbos

</content>
</file>

</xsl:template>

</xsl:stylesheet>

