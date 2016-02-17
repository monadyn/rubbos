<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='configure' and @type='current']"> &amp;</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='configure' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='configure' and @type='post-action']">sleep 300</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/POSTGRESconfigure.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh
<xsl:if test="//params/env/param[@name='JAVA_OPTS_DB']">
export JAVA_OPTS=<xsl:value-of select="//params/env/param[@name='JAVA_OPTS_DB']/@value"/>
</xsl:if>

echo "  CONFIGURING POSTGRES on $HOSTNAME"

#extract RUBBoS data files tar-ball
cd $RUBBOS_HOME/database
tar xzf $SOFTWARE_HOME/$RUBBOS_DATA_TEXTFILES_TARBALL
#copying sql files over
cp $WORK_HOME/postgres_files/rubbos.sql ./
cp $WORK_HOME/postgres_files/load.sql ./
cp $WORK_HOME/postgres_files/rubbos_index.sql ./
sed s%/home/cecchet/RUBBoS%$RUBBOS_HOME%g load.sql &gt; load.sql.tmp
mv load.sql.tmp load.sql

#copy configuration files
cp $WORK_HOME/postgres_files/pg_hba.conf $POSTGRES_DATA_DIR/
chmod 600 $POSTGRES_DATA_DIR/pg_hba.conf
cp $OUTPUT_HOME/postgres_conf/postgresql.conf $POSTGRES_DATA_DIR/

<xsl:if test="//params/logging/param[@name='postgresResponseTime']/@value='true'"
>#create a log directory
mkdir $POSTGRES_HOME/logs/
</xsl:if>

#start postgres
cd $POSTGRES_HOME/bin
./postgres -i -D $POSTGRES_DATA_DIR &amp;
sleep 3

#create database &amp; user
./createdb rubbos
echo -e "$ELBA_PASSWORD\n$ELBA_PASSWORD\ny\n" | ./createuser -P $ELBA_USER

#load RUBBoS data
./psql -h localhost rubbos &lt; $RUBBOS_HOME/database/rubbos.sql
./psql -h localhost rubbos &lt; $RUBBOS_HOME/database/test.sql
./psql -h localhost rubbos &lt; $RUBBOS_HOME/database/load.sql
sleep 30
./psql -h localhost rubbos &lt; $RUBBOS_HOME/database/rubbos_index.sql
sleep 30

#stop postgres
./pg_ctl stop -D $POSTGRES_DATA_DIR
sleep 5

echo "  DONE CONFIGURING POSTGRES on $HOSTNAME"

<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>postgresql.conf<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/postgres_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
#------------------------------------------------------------------------------
# CONNECTIONS AND AUTHENTICATION
#------------------------------------------------------------------------------

# - Connection Settings -
<xsl:if test="//params/postgres-conf/param[@name='max_connections']"
>max_connections = <xsl:value-of select="//params/postgres-conf/param[@name='max_connections']/@value"/>                   # (change requires restart)
</xsl:if>

#------------------------------------------------------------------------------
# RESOURCE USAGE (except WAL)
#------------------------------------------------------------------------------

# - Memory -
<xsl:if test="//params/postgres-conf/param[@name='shared_buffers']"
>shared_buffers = <xsl:value-of select="//params/postgres-conf/param[@name='shared_buffers']/@value"/>                   # min 128kB or max_connections*16kB
</xsl:if>
# - Free Space Map -
<xsl:if test="//params/postgres-conf/param[@name='max_fsm_pages']"
>max_fsm_pages = <xsl:value-of select="//params/postgres-conf/param[@name='max_fsm_pages']/@value"/>                  # min max_fsm_relations*16, 6 bytes each
</xsl:if>

#------------------------------------------------------------------------------
# WRITE AHEAD LOG
#------------------------------------------------------------------------------

# - Checkpoints -
<xsl:if test="//params/postgres-conf/param[@name='checkpoint_segments']"
>checkpoint_segments = <xsl:value-of select="//params/postgres-conf/param[@name='checkpoint_segments']/@value"/>                # in logfile segments, min 1, 16MB each
</xsl:if>

#------------------------------------------------------------------------------
# CLIENT CONNECTION DEFAULTS
#------------------------------------------------------------------------------

# - Locale and Formatting -
datestyle = 'iso, mdy'

# These settings are initialized by initdb, but they can be changed.
lc_messages = 'C'                       # locale for system error message
                                        # strings
lc_monetary = 'C'                       # locale for monetary formatting
lc_numeric = 'C'                        # locale for number formatting
lc_time = 'C'                           # locale for time formatting

# default configuration for text search
default_text_search_config = 'pg_catalog.english'

#------------------------------------------------------------------------------
# SQL logging
#------------------------------------------------------------------------------
<xsl:if test="//params/logging/param[@name='postgresResponseTime']/@value='true'">
logging_collector = on
log_directory = 'logs'
log_filename = 'pg.log'
log_rotation_age = 0
log_rotation_size = 0
log_statement = 'all'
log_duration = on
log_line_prefix = '%m [%i] %v %p '
</xsl:if>

</content>
</file>


</xsl:template>

</xsl:stylesheet>

