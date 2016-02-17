<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='reset' and @type='current']"> &amp; sleep 180; </xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='reset' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='db_server' and @actype='reset' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//pastehere[@id='../templates/DeployScript/MYSQLreset2.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh
<xsl:if test="//params/env/param[@name='JAVA_OPTS_DB']">
export JAVA_OPTS=<xsl:value-of select="//params/env/param[@name='JAVA_OPTS_DB']/@value"/>
</xsl:if>

echo "  RESETING MYSQL on $HOSTNAME"

#start mysql
cd $MYSQL_HOME
bin/safe_mysqld --defaults-file="$MYSQL_HOME/my.cnf" --datadir=$MYSQL_DATA_DIR --pid-file=$MYSQL_PID_FILE --socket=$MYSQL_SOCKET --port=$MYSQL_PORT --user=root --log-bin=rubbos-bin --max_connections=1000 --log-slow-queries &amp;
sleep 5

#drop database
echo 'DROP DATABASE rubbos;' | bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD mysql

#create database &amp; set privileges
ssh localhost "
  cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
  source set_elba_env.sh

  # create database &amp; tables for RUBBoS
  cd $MYSQL_HOME
  bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD mysql &lt; $RUBBOS_HOME/database/rubbos.sql

  #set privileges
  echo 'GRANT ALL PRIVILEGES ON rubbos.* TO \"$ELBA_USER\"@\"%\" IDENTIFIED BY \"$ELBA_PASSWORD\", \"root\"@\"%\" IDENTIFIED BY \"$ROOT_PASSWORD\"; flush privileges; GRANT ALL PRIVILEGES ON rubbos.* TO \"$ELBA_USER\"@\"localhost\" IDENTIFIED BY \"$ELBA_PASSWORD\", \"root\"@\"localhost\" IDENTIFIED BY \"$ROOT_PASSWORD\"; flush privileges;' | bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD mysql
"

#insert RUBBoS data into tables
bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD rubbos &lt; $RUBBOS_HOME/database/test.sql
bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD rubbos &lt; $RUBBOS_HOME/database/load.sql

#stop mysql
bin/mysqladmin --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD shutdown
sleep 5

echo "  DONE RESETING MYSQL on $HOSTNAME"

</xsl:template>

</xsl:stylesheet>














