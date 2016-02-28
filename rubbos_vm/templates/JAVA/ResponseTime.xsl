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

<xsl:variable name="target_name" select="//aspect[@name=$aspect_name]/@target"/>
<xsl:variable name="target_thread_name" select="//class/params/param[@name='thread']/@value"/>

<xsl:variable name="wsml" select="document('../../wsml/TPCW-WSML.xml')"/>

<xsl:variable name="maptables" select="document('JAVA_maptable.xml')/maptables"/>
<xsl:variable name="types" select="$maptables/maptable[@to='type']"/>
<xsl:variable name="inits" select="$maptables/maptable[@to='init']"/>

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:function.variables[@point='run']">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>  
  </xsl:copy>
		//weave from rt
		long start;  
		long end;  
		long thinkTime = 0L;
		
		start = System.currentTimeMillis();
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:function.body[@point='check_start_time']">
					//weave from rt
					thinkTime = getThinkTime();					
					start = end + thinkTime;
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:header">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
//weave from rt
import java.util.Vector;  	
</xsl:template> 

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:variables[@point=$target_name]">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
	//weave from rt
<xsl:for-each select="$wsml/WSML/SLO[@type='ResponseTime']/clause/evalOn">
<xsl:variable name="val_name" select="./@id" />
<xsl:variable name="test_type" select="./@recordtype" />
<xsl:if test="$test_type='runtime_stat'">
<xsl:if test="$val_name!='COMMON'">
<xsl:variable name="val_type" select="./expression/value/@type" />
<xsl:variable name="val_init" select="./expression/value/@init" />		
	private static <xsl:value-of select="$types/mapping[@from=$val_type]/@to"/><xsl:text> </xsl:text><xsl:value-of select="$val_name"/> = <xsl:value-of select="$inits/mapping[@from=$val_init]/@to"/>;
</xsl:if>
</xsl:if>
</xsl:for-each>
	private long startRT = 0L;
	private long endRT = 0L;  		
</xsl:template> 

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:function[@point='container']">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
		//weave from rt
<xsl:for-each select="$wsml/WSML/SLO[@type='ResponseTime']/clause/evalOn">
<xsl:variable name="val_name" select="./@id" />
<xsl:variable name="test_type" select="./@recordtype" />
<xsl:if test="$test_type='runtime_stat'">	
<xsl:if test="$val_name='COMMON'">
<xsl:variable name="start_time" select="./startTime" />
<xsl:variable name="end_time" select="./endTime" />
<xsl:choose>
<xsl:when test="$start_time='testTime.startTest'">
		startRT = startTest;
</xsl:when>
<xsl:when test="$start_time='testTime.startMeasurement'">
		startRT = startMeasurement;
</xsl:when>
<xsl:otherwise>
		try {
			startRT = simpleDateFormat.parse("<xsl:value-of select='$start_time'/>"); 
		} catch(ParseException pe) {
			System.out.println("ERROR:ParseException:stat:" + pe.toString());
			return;
		}
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="$end_time='testTime.endTest'">
		endRT = endTest;
</xsl:when>
<xsl:when test="$end_time='testTime.endMeasurement'">
		endRT = endMeasurement;
</xsl:when>
<xsl:otherwise>
		try {
			endRT = simpleDateFormat.parse("<xsl:value-of select='$end_time'/>"); 
		} catch(ParseException pe) {
			System.out.println("ERROR:ParseException:stat:" + pe.toString());
			return;
		}
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</xsl:for-each>	
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:function[@point='interaction']">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
		//weave from rt
		if ( (end >= startRT) &amp;&amp; (end &lt;= endRT) ) {
<xsl:for-each select="$wsml/WSML/SLO[@type='ResponseTime']/clause/evalOn">
<xsl:variable name="val_name" select="./@id" />
<xsl:variable name="test_type" select="./@recordtype" />
<xsl:variable name="test_constraint" select="./@constraint" />
<xsl:if test="$test_type='runtime_stat'">
<xsl:if test="$val_name='COMMON'">
<xsl:if test="$test_constraint='YES'">
<xsl:variable name="test_constraint_name" select="./constraints/constraint/@name" />
			switch (<xsl:value-of select="$test_constraint_name"/>) {
<xsl:for-each select="$wsml/WSML/SLO[@type='ResponseTime']/clause/evalOn">
<xsl:variable name="ival_name" select="./@id" />
<xsl:variable name="itest_type" select="./@recordtype" />
<xsl:variable name="itest_constraint" select="./@constraint" />
<xsl:if test="$itest_type='runtime_stat'">
<xsl:if test="$ival_name!='COMMON'">
<xsl:if test="$itest_constraint='YES'">
<xsl:variable name="itest_constraint_name" select="./constraints/constraint/@name" />
<xsl:variable name="itest_constraint_type" select="./constraints/constraint/@type" />
<xsl:variable name="itest_constraint_threshold" select="./constraints/constraint/threshold" />
<xsl:if test="$itest_constraint_name=$test_constraint_name">
<xsl:if test="$itest_constraint_type='='">
<xsl:variable name="ifunc" select="./expression/value/function" />
				case <xsl:value-of select="$itest_constraint_threshold"/>:
				{
<xsl:if test="$ifunc='RESPONSE_TIME'">
<xsl:text>					</xsl:text><xsl:value-of select="$ival_name"/>.add(new Long(end - start));
					break;					
</xsl:if>
				}
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:for-each>
			}
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:for-each>			
		}		
</xsl:template>


<xsl:template match="//filledTemplate[@name=$target_name]//wpt:function[@point='printMeasurement']">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
		//weave from rt
<xsl:for-each select="$wsml/WSML/SLO[@type='ResponseTime']/clause/evalOn">
<xsl:variable name="val_name" select="./@id" />
<xsl:variable name="test_type" select="./@recordtype" />
<xsl:if test="$test_type='static'">
<xsl:if test="$val_name!='COMMON'">
<xsl:variable name="val_type" select="./expression/value/@type" />
<xsl:variable name="val_init" select="./expression/value/@init" />	
<xsl:variable name="func" select="./expression/value/function" />	
<xsl:text>		</xsl:text><xsl:value-of select="$types/mapping[@from=$val_type]/@to"/><xsl:text> </xsl:text><xsl:value-of select="$val_name"/> = <xsl:value-of select="$inits/mapping[@from=$val_init]/@to"/>;
<xsl:if test="$func='AVG'">
<xsl:variable name="arg" select="./expression/value/params/param/value" />
		long sum_<xsl:value-of select="$arg"/> = 0L;
		for (int i = 0 ; i &lt; <xsl:value-of select="$arg"/>.size(); i++) {
			Long value = (Long) <xsl:value-of select="$arg"/>.elementAt(i);
			sum_<xsl:value-of select="$arg"/> = sum_<xsl:value-of select="$arg"/> + value.longValue();
		}
		if (<xsl:value-of select="$arg"/>.size() > 0) 
			<xsl:value-of select="$val_name"/> = (<xsl:value-of select="$types/mapping[@from=$val_type]/@to"/>)sum_<xsl:value-of select="$arg"/> / (<xsl:value-of select="$types/mapping[@from=$val_type]/@to"/>)<xsl:value-of select="$arg"/>.size();
		
		System.out.println("<xsl:value-of select='$val_name'/>:" + <xsl:value-of select="$val_name"/>);

</xsl:if>

<xsl:if test="$func='NON_VIO_PERCENTAGE'">
<xsl:variable name="arg" select="./expression/value/params/param/value" />
<xsl:variable name="constraint_threshold" select="./constraints/constraint/threshold" />
<xsl:variable name="constraint_type" select="./constraints/constraint/@type" />
		int cnt_<xsl:value-of select="$arg"/> = 0;
		for (int i = 0 ; i &lt; <xsl:value-of select="$arg"/>.size(); i++) {
			Long value = (Long) <xsl:value-of select="$arg"/>.elementAt(i);
			if ( ((float)value.longValue()/1000L) <xsl:value-of select="$constraint_type"/><xsl:text> </xsl:text><xsl:value-of select="$constraint_threshold"/>) 
				cnt_<xsl:value-of select="$arg"/>++;
		}
		if (<xsl:value-of select="$arg"/>.size() > 0)
			<xsl:value-of select="$val_name"/> = (<xsl:value-of select="$types/mapping[@from=$val_type]/@to"/>)cnt_<xsl:value-of select="$arg"/> / (<xsl:value-of select="$types/mapping[@from=$val_type]/@to"/>)<xsl:value-of select="$arg"/>.size() * 100;
		
		System.out.println("<xsl:value-of select='$val_name'/>:" + <xsl:value-of select="$val_name"/>);

</xsl:if>
</xsl:if>
</xsl:if>
</xsl:for-each>

<xsl:for-each select="$wsml/WSML/SLO[@type='ResponseTime']/clause/evalFunc">
<xsl:variable name="val_name" select="./@id" />
<xsl:variable name="test_type" select="./@recordtype" />
<xsl:if test="$test_type='static'">	
<xsl:variable name="func" select="./expression/function" />
<xsl:variable name="predicate_type" select="./expression/predicates/predicate/@type" />
<xsl:variable name="predicate_threshold" select="./expression/predicates/predicate/threshold" />
		boolean <xsl:value-of select="$val_name"/> = false;

		if ( <xsl:value-of select="$func"/><xsl:text> </xsl:text><xsl:value-of select="$predicate_type"/><xsl:text> </xsl:text><xsl:value-of select="$predicate_threshold"/>) 
			<xsl:value-of select="$val_name"/> = true;

		System.out.println("<xsl:value-of select='$val_name'/>:" + <xsl:value-of select="$val_name"/>);

</xsl:if>
</xsl:for-each>	
</xsl:template>

</xsl:stylesheet>