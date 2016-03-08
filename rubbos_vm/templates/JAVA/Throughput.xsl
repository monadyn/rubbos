<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:wpt="http://www.cc.gatech.edu/projects/infosphere/aspect/v0.3" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:param name="aspect_name"/>

<xsl:variable name="target_name" select="//aspect[@name=$aspect_name]/@target" />

<xsl:variable name="wsml" select="document('../../wsml/TPCW-WSML.xml')"/>

<xsl:variable name="maptables" select="document('JAVA_maptable.xml')/maptables"/>
<xsl:variable name="types" select="$maptables/maptable[@to='type']"/>
<xsl:variable name="inits" select="$maptables/maptable[@to='init']"/>

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:variables[@point=$target_name]">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
	//weave from throughput
<xsl:for-each select="$wsml/WSML/SLO[@type='Throughput']/clause/evalOn">
<xsl:variable name="val_name" select="./@id"/>
<xsl:variable name="test_type" select="./@recordtype"/>
<xsl:if test="$test_type='runtime_stat'">
<xsl:variable name="val_type" select="./expression/value/@type"/>
<xsl:variable name="val_init" select="./expression/value/@init"/>
	private static <xsl:value-of select="$types/mapping[@from=$val_type]/@to"/><xsl:text> </xsl:text><xsl:value-of select="$val_name"/> = <xsl:value-of select="$inits/mapping[@from=$val_init]/@to"/>;
</xsl:if>
</xsl:for-each>
	private long startThroughput = 0L;
	private long endThroughput = 0L;
	private long throughputInterval = 0L;  		
</xsl:template> 

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:function[@point='container']">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
		//weave from throughput
<xsl:for-each select="$wsml/WSML/SLO[@type='Throughput']/clause/evalOn">
<xsl:variable name="test_type" select="./@recordtype" />
<xsl:if test="$test_type='runtime_stat'">	
<xsl:variable name="start_time" select="./startTime" />
<xsl:variable name="end_time" select="./endTime" />
<xsl:choose>
<xsl:when test="$start_time='testTime.startTest'">
		startThroughput = startTest;
</xsl:when>
<xsl:when test="$start_time='testTime.startMeasurement'">
		startThroughput = startMeasurement;
</xsl:when>
<xsl:otherwise>
		try {
			startThroughput = simpleDateFormat.parse("<xsl:value-of select='$start_time'/>"); 
		} catch(ParseException pe) {
			System.out.println("ERROR:ParseException:stat:" + pe.toString());
			return;
		}
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="$end_time='testTime.endTest'">
		endThroughput = endTest;
</xsl:when>
<xsl:when test="$end_time='testTime.endMeasurement'">
		endThroughput = endMeasurement;
</xsl:when>
<xsl:otherwise>
		try {
			endThroughput = simpleDateFormat.parse("<xsl:value-of select='$end_time'/>"); 
		} catch(ParseException pe) {
			System.out.println("ERROR:ParseException:stat:" + pe.toString());
			return;
		}
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:for-each>
		throughputInterval = endThroughput - startThroughput;
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:function[@point='interaction']">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
		//weave from Throughput
		if ( (end >= startThroughput) &amp;&amp; (end &lt;= endThroughput) ) {
<xsl:for-each select="$wsml/WSML/SLO[@type='Throughput']/clause/evalOn">
<xsl:variable name="val_name" select="./@id" />
<xsl:variable name="test_type" select="./@recordtype" />
<xsl:if test="$test_type='runtime_stat'">
<xsl:variable name="func" select="./expression/value/function" />
<xsl:if test="$func='COUNT'">
<xsl:text>			</xsl:text><xsl:value-of select="$val_name"/>++;
</xsl:if>
</xsl:if>
</xsl:for-each>
		}		
</xsl:template>


<xsl:template match="//filledTemplate[@name=$target_name]//wpt:function[@point='printMeasurement']">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
		//weave from throughput
<xsl:for-each select="$wsml/WSML/SLO[@type='Throughput']/clause/evalOn">
<xsl:variable name="val_name" select="./@id" />
<xsl:variable name="test_type" select="./@recordtype" />
<xsl:if test="$test_type='static'">
<xsl:variable name="val_type" select="./expression/value/@type" />
<xsl:variable name="val_init" select="./expression/value/@init" />	
<xsl:variable name="func" select="./expression/value/function" />	
<xsl:text>		</xsl:text><xsl:value-of select="$types/mapping[@from=$val_type]/@to"/><xsl:text> </xsl:text><xsl:value-of select="$val_name"/> = <xsl:value-of select="$inits/mapping[@from=$val_init]/@to"/>;
<xsl:if test="$func='AVG'">
<xsl:variable name="arg" select="./expression/value/params/param/value" />
<xsl:text>		</xsl:text><xsl:value-of select="$val_name"/> = (<xsl:value-of select="$types/mapping[@from=$val_type]/@to"/>)<xsl:value-of select="$arg"/> / (<xsl:value-of select="$types/mapping[@from=$val_type]/@to"/>)(throughputInterval / 1000);
		System.out.println("Throughput" + <xsl:value-of select="$val_name"/>);
</xsl:if>
</xsl:if>
</xsl:for-each>

<xsl:for-each select="$wsml/WSML/SLO[@type='Throughput']/clause/evalFunc">
<xsl:variable name="val_name" select="./@id" />
<xsl:variable name="test_type" select="./@recordtype" />
<xsl:if test="$test_type='static'">	
<xsl:variable name="func" select="./expression/function" />
<xsl:variable name="predicate_type" select="./expression/predicates/predicate/@type" />
<xsl:variable name="predicate_threshold" select="./expression/predicates/predicate/threshold" />
		boolean <xsl:value-of select="$val_name"/> = false;

		if ( <xsl:value-of select="$func"/><xsl:text> </xsl:text><xsl:value-of select="$predicate_type"/><xsl:text> </xsl:text>(<xsl:value-of select="$predicate_threshold"/>) ) 
			<xsl:value-of select="$val_name"/> = true;

		System.out.println("<xsl:value-of select="$val_name"/>:" + <xsl:value-of select="$val_name"/>);

</xsl:if>
</xsl:for-each>			
</xsl:template>

</xsl:stylesheet>