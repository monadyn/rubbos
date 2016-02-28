<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/" >
<xsl:variable name="tbl_name" select="/tbl/@name" />
<xtbl name="{$tbl_name}"><xsl:text>
  </xsl:text><xsl:copy-of select="/tbl/testTime"/><xsl:text>
</xsl:text>
<xsl:text>  </xsl:text><xsl:copy-of select="/tbl/params"/><xsl:text>
</xsl:text>
  <xsl:apply-templates select="/tbl/outputs"></xsl:apply-templates>
  <xsl:apply-templates select="/tbl/classes"></xsl:apply-templates>
</xtbl> 
</xsl:template>

<xsl:template match="/tbl/outputs">

<xsl:text>  </xsl:text><activities><xsl:text>
</xsl:text>
<xsl:for-each select="./output">
<xsl:variable name="tname" select="./@name" />
<xsl:variable name="ttype" select="./@type" />
<xsl:variable name="tloc" select="./@loc" />

<xsl:choose>
<xsl:when test="$ttype='build'">
<xsl:text>    </xsl:text><activity target="classes/class" type="{$ttype}"><xsl:text>
      </xsl:text><build loc="{$tloc}" class="{$tname}"/><xsl:text>
    </xsl:text></activity><xsl:text>
</xsl:text>
</xsl:when>
<xsl:when test="$ttype='compile'">
<xsl:text>    </xsl:text><activity target="classes/class" type="{$ttype}"><xsl:text>
      </xsl:text><compile loc="{$tloc}" class="{$tname}"/><xsl:text>
    </xsl:text></activity><xsl:text>
</xsl:text>
</xsl:when>
<xsl:when test="$ttype='deploy'">
<xsl:text>    </xsl:text><activity target="instances" type="{$ttype}"><xsl:text>
      </xsl:text><deploy loc="{$tloc}" class="{$tname}"/><xsl:text>
    </xsl:text></activity><xsl:text>
</xsl:text>
</xsl:when>
</xsl:choose>
</xsl:for-each>
<xsl:text>  </xsl:text></activities><xsl:text>
</xsl:text>

</xsl:template>

<xsl:template match="/tbl/classes">

<xsl:text>  </xsl:text><classes><xsl:text>
</xsl:text>
<xsl:for-each select="./class">
<xsl:variable name="tname" select="./@name" />
<xsl:variable name="tlang" select="./@lang" />
<xsl:text>    </xsl:text><class lang="{$tlang}" template="{$tname}.xsl" name="{$tname}"><xsl:text>
</xsl:text>
<xsl:text>      </xsl:text><params><xsl:text>
</xsl:text>
<xsl:for-each select="./params/param">
<xsl:variable name="param_name" select="./@name" /> 
<xsl:for-each select="/tbl/params/param">
<xsl:if test="$param_name=./@name">
<xsl:variable name="param_type" select="./@type" />
<xsl:variable name="param_value" select="./value" />
<xsl:text>        </xsl:text><param value="{$param_value}" type="{$param_type}" name="{$param_name}"/><xsl:text>
</xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:for-each>
<xsl:text>      </xsl:text></params><xsl:text>
</xsl:text>
<xsl:text>      </xsl:text><xsl:copy-of select="./aspects"/><xsl:text>
</xsl:text>  
<xsl:text>    </xsl:text></class><xsl:text>
</xsl:text>
</xsl:for-each>
<xsl:text>  </xsl:text></classes><xsl:text>
</xsl:text>    

</xsl:template>

</xsl:stylesheet>