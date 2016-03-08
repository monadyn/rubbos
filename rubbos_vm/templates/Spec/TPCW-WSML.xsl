<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:param name="doc_name"/>
<xsl:param name="doc_loc"/>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:variable name="wsml" select="document('{$doc_loc}')"/>

<xsl:template match="//class[@name='ClientWorkloadDriver']/aspects/aspect[@name='Stat']">  
        <aspect name="Stat" template="Stat.xsl" target="ClientWorkloadDriver">
	  <params>
<xsl:for-each select="/tbl/params/param">
<xsl:if test="./@name='concurrentUsers'">
<xsl:variable name="param_type" select="./@type" />
<xsl:variable name="param_value" select="./value" />
<xsl:text>            </xsl:text><param value="{$param_value}" type="{$param_type}" name="concurrentUsers"/><xsl:text>
</xsl:text>
</xsl:if>
<xsl:if test="./@name='maxErrors'">
<xsl:variable name="param_type" select="./@type" />
<xsl:variable name="param_value" select="./value" />
<xsl:text>            </xsl:text><param value="{$param_value}" type="{$param_type}" name="maxErrors"/><xsl:text>
</xsl:text>
</xsl:if>
</xsl:for-each>
          </params>
          <docs>
	    <doc name="{$doc_name}" loc="{$doc_loc}"/>
          </docs>   
          <aspects>
<xsl:for-each select="$wsml/WSML/SLO">
<xsl:variable name="type" select="./@type" />
<xsl:variable name="loc" select="./clause/measuredAt" />
<xsl:if test="$loc='ClientWorkloadDriver'">
            <aspect name="{$type}" template="{$type}.xsl" target="Stat">
              <docs>
	        <doc name="{$doc_name}" loc="{$doc_loc}"/>
              </docs>
            </aspect>
</xsl:if>
</xsl:for-each>
          </aspects>
        </aspect>
</xsl:template>

<xsl:template match="//class[@name='TPCW_Database']/aspects/aspect[@name='DBLatency']">  
        <aspect name="DBLatency" template="DBLatency.xsl" target="TPCW_Database">
          <docs>
            <doc name="{$doc_name}" loc="{$doc_loc}"/>
          </docs>
        </aspect>
</xsl:template>

<xsl:template match="//class[@name='ServerMonitor']/aspects/aspect[@name='CPUUtilization']">  
        <aspect name="CPUUtilization" template="CPUUtilization.xsl" target="ServerMonitor">
          <docs>
            <doc name="{$doc_name}" loc="{$doc_loc}"/>
          </docs>
        </aspect>
</xsl:template>

<xsl:template match="//class[@name='ServerMonitor']/aspects/aspect[@name='MemoryUtilization']">  
        <aspect name="MemoryUtilization" template="MemoryUtilization.xsl" target="ServerMonitor">
          <docs>
            <doc name="{$doc_name}" loc="{$doc_loc}"/>
          </docs>
        </aspect>
</xsl:template>

<xsl:template match="//class[@name='Analyzer']/aspects/aspect[@name='SLAAnalysis']">  
        <aspect name="SLAAnalysis" template="SLAAnalysis.xsl" target="Analyzer">
          <docs>
            <doc name="{$doc_name}" loc="{$doc_loc}"/>
          </docs>
        </aspect>
</xsl:template>

</xsl:stylesheet>