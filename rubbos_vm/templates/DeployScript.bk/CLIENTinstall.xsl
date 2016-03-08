<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@id='CLIENT_install.sh' and @type='current']"> 
<xsl:text> 
</xsl:text>
</xsl:template>

<xsl:template match="//argshere[@id='CLIENT_install.sh' and @type='pre-action']">
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//argshere[@id='CLIENT_install.sh' and @type='post-action']"> 
<xsl:text> 
</xsl:text>
</xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/CLIENTinstall.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
./set_elba_env.sh
source set_elba_env.sh
mkdir <xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
chmod 775 <xsl:value-of select="//params/env/param[@name='ELBA_TOP']/@value"/>
mkdir <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>
chmod 775 <xsl:value-of select="//params/env/param[@name='RUBIS_TOP']/@value"/>
cd $WORK_HOME
cp -R $RUBISWORK_HOME/softwares/nClient $RUBIS_TOP/.
cd $RUBIS_TOP/nClient
javac -deprecation *.java



<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>rubis.properties<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='RUBISWORK_HOME']/@value"/>/softwares/nClient<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>

httpd_hostname = <xsl:value-of select="//instances/instance[@type='web_server']/target"/>
httpd_port = 8000

httpd_use_version = EJB
#httpd_use_version = Servlets

ejb_server = merry.cc.gatech.edu
ejb_html_path = /ejb_rubis_web
ejb_script_path = /ejb_rubis_web/servlet

#servlets_server = demeter.cc.gatech.edu
#servlets_html_path = /Servlet_HTML
#servlets_html_path = /rubis_servlets
#servlets_script_path = /servlet

#php_html_path = /PHP
#php_script_path = /PHP

workload_remote_client_nodes =
workload_remote_client_command = java ClientEmulator

workload_number_of_clients_per_node = 200

workload_transition_table = workload/<xsl:value-of select="//instances/params/param[@name='TRANSITION_FILE_NAME']/@value"/>
workload_number_of_columns = 27
workload_number_of_rows = 28
workload_maximum_number_of_transitions = 1000000
workload_number_of_items_per_page = 20
#workload_number_of_items_per_page = 5
workload_use_tpcw_think_time = yes
workload_up_ramp_time_in_ms = 120000
workload_up_ramp_slowdown_factor = 1
workload_session_run_time_in_ms = 900000
workload_down_ramp_time_in_ms = 60000
workload_down_ramp_slowdown_factor = 1

database_server = gimli.cc.gatech.edu
database_number_of_users = 1000
database_regions_file = database/ebay_regions.txt
database_categories_file = database/ebay_categories.txt

# Items policy
database_number_of_old_items = 0
database_percentage_of_unique_items = 80
database_percentage_of_items_with_reserve_price = 40
database_percentage_of_buy_now_items = 10
database_max_quantity_for_multiple_items = 10
database_item_description_length = 800

# Bids policy
database_max_bids_per_item = 20

# Comments policy
database_max_comments_per_user = 20
database_comment_max_length = 200


# Monitoring Information
#monitoring_debug_level = 0
#monitoring_program = /usr/bin/sar
#monitoring_options = -n DEV -n SOCK -rubcw
#monitoring_sampling_in_seconds = 1
#monitoring_rsh = /usr/bin/ssh
#monitoring_gnuplot_terminal = jpeg


</content>
</file>

</xsl:template>

</xsl:stylesheet>

