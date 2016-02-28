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

<xsl:variable name="flow_model" select="document('{$doc_loc}')"/>

<xsl:template match="//class[@name='ClientWorkloadDriver']/aspects/aspect[@name='Transition']">  
        <aspect name="Transition" template="Transition.xsl" target="ClientWorkloadDriver">
          <docs>
	    <doc name="{$doc_name}" loc="{$doc_loc}"/>
          </docs>            
        </aspect>
</xsl:template>

</xsl:stylesheet>