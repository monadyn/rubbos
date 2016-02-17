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

<xsl:template match="//argshere[@idtype='db_server' and @actype='configure' and @type='post-action']">sleep 60</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/MYSQLconfigure.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh
<xsl:if test="//params/env/param[@name='JAVA_OPTS_DB']">
export JAVA_OPTS=<xsl:value-of select="//params/env/param[@name='JAVA_OPTS_DB']/@value"/>
</xsl:if>

echo "  CONFIGURING MYSQL on $HOSTNAME"

#start mysql
  mkdir -p $MYSQL_HOME/run
  cp $OUTPUT_HOME/mysql_conf/my.cnf $MYSQL_HOME/my.cnf

  cd $MYSQL_HOME
  bin/safe_mysqld --no-defaults --port=$MYSQL_PORT --datadir=$MYSQL_DATA_DIR --log=$MYSQL_ERR_LOG --pid-file=$MYSQL_PID_FILE --socket=$MYSQL_SOCKET --user=root &amp;
  sleep 3

#set password
  bin/mysqladmin --socket=$MYSQL_SOCKET --user=root password "$ROOT_PASSWORD"

#create database &amp; set privileges
  ssh localhost "
    cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
    source set_elba_env.sh
    cd $MYSQL_HOME
    echo 'CREATE DATABASE opentaps;'  | bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD mysql

    echo 'GRANT ALL PRIVILEGES ON opentaps.* TO \"$ELBA_USER\"@\"%\" IDENTIFIED BY \"$ELBA_PASSWORD\", \"root\"@\"%\" IDENTIFIED BY \"$ROOT_PASSWORD\"; flush privileges; GRANT ALL PRIVILEGES ON opentaps.* TO \"$ELBA_USER\"@\"localhost\" IDENTIFIED BY \"$ELBA_PASSWORD\", \"root\"@\"localhost\" IDENTIFIED BY \"$ROOT_PASSWORD\"; flush privileges;' | bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD mysql

    echo 'CREATE DATABASE rubbos;'  | bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD mysql

    echo 'GRANT ALL PRIVILEGES ON rubbos.* TO \"$ELBA_USER\"@\"%\" IDENTIFIED BY \"$ELBA_PASSWORD\", \"root\"@\"%\" IDENTIFIED BY \"$ROOT_PASSWORD\"; flush privileges; GRANT ALL PRIVILEGES ON rubbos.* TO \"$ELBA_USER\"@\"localhost\" IDENTIFIED BY \"$ELBA_PASSWORD\", \"root\"@\"localhost\" IDENTIFIED BY \"$ROOT_PASSWORD\"; flush privileges;' | bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD mysql
  "

#stop mysql
  bin/mysqladmin --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD shutdown

# copy rubbos data files
  tar xzvf /mnt/softwares/$OPENTAPS_RUBBOS_DATA_TARBALL --directory=$MYSQL_HOME/data/opentaps
  sleep 5

  tar xzf $SOFTWARE_HOME/$RUBBOS_DATA_TARBALL --directory=$MYSQL_HOME/data/rubbos
  sleep 5

echo "  DONE CONFIGURING MYSQL on $HOSTNAME"

<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>my.cnf<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/mysql_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
[client]
port = 3306

[mysqld]
server-id=1
</content>
</file>

</xsl:template>

</xsl:stylesheet>

