<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='configure' and @type='current']"> &amp; sleep 20; </xsl:template>

<xsl:template match="//argshere[@idtype='db_server' and @actype='configure' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@idtype='db_server' and @actype='configure' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/DBconfigure.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
cd $RUBIS_TOP/mysql-max-3.23.58-pc-linux-i686
bin/safe_mysqld --defaults-file="../master.cnf" &amp; sleep 5;
bin/mysqladmin -S /tmp/mysql.sock -uroot password 'rubis'

echo "GRANT ALL PRIVILEGES ON rubis.* TO 'root'@'<xsl:value-of select="//instances/instance[@type='cjdbc_controller']/target"/>' IDENTIFIED BY 'rubis'; " | bin/mysql -S /tmp/mysql.sock -uroot -prubis mysql

bin/mysql -S /tmp/mysql.sock -uroot -prubis &lt; $OUTPUT_HOME/gen_data/refresh_items_date.sql
bin/mysqladmin --defaults-file=../master.cnf -uroot -prubis shutdown &amp;

</xsl:template>

</xsl:stylesheet>

