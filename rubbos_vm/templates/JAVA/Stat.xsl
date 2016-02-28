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

<xsl:variable name="main_name" select="//class/@name" />
<xsl:variable name="target_name" select="//aspect[@name=$aspect_name]/@target" />
<xsl:variable name="target_thread_name" select="//class/params/param[@name='thread']/@value" />

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:variables[@point=$target_name]">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
	//weave from Stat
	public static Stat stat = null;  		
</xsl:template> 

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:function.ready[@point='main']">  
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>	
		//weave from Stat
		stat = new Stat(args[0]);
		System.out.println("Test synchronized!");
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:function.start[@point='main']">  
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>	
		//weave from stat
		stat.waitForTest();
		System.out.println("Main thread wake up");
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:function.print[@point='main']">
		//weave from stat
		stat.printHeader(startTime.toString(), endTime.toString());
		stat.printMeasurement();
		System.out.println("Print ended");
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:function.body[@point='check_response_time']">
					//weave from Stat
					appClient.stat.interaction(nextState, start, System.currentTimeMillis());
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:function.body[@point='sleep_think_time']">
					//weave from Stat
					try {
						sleep(thinkTime);
					} catch (InterruptedException inte) {
						System.out.println("ERROR:InterruptedException:" + inte.toString());
						return;
					}			
</xsl:template>

<xsl:template match="//class//aspect[@name=$aspect_name]">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>

<xsl:variable name="value_num_threads" select="./params/param[@name='numThreads']/@value" />
<xsl:variable name="value_max_errors" select="./params/param[@name='maxErrors']/@value" />

<xsl:variable name="wsml" select="document('../../wsml/TPCW-WSML.xml')"/>

<xsl:variable name="maptables" select="document('JAVA_maptable.xml')/maptables"/>
<xsl:variable name="types" select="$maptables/maptable[@to='type']"/>
<xsl:variable name="inits" select="$maptables/maptable[@to='init']"/>

<filledTemplate name="{$aspect_name}"><xsl:text>
  </xsl:text>
<file><xsl:text>
    </xsl:text>
<name loc="{$main_name}" id="{$aspect_name}.java"/><xsl:text>
      </xsl:text>
<content><xsl:text>
</xsl:text>
<wpt:header>
import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.io.PrintStream;
import java.io.FileOutputStream;
import java.io.IOException;
</wpt:header>

public class <xsl:value-of select="$aspect_name"/> {
<wpt:variables point="{$aspect_name}">
	private long startTest;
	private long endTest;
	private long startMeasurement;  
	private long endMeasurement; 
	private long rampup;
	private long rampdown;

	private long waitStart;
	private long measurementInterval;	

	SimpleDateFormat simpleDateFormat = new SimpleDateFormat ("MM/dd/yyyy HH:mm:ss");
	Date startTestDate = null;
	Date startMeasurementDate = null;
	Date endMeasurementDate = null;
	Date endTestDate = null;

	private static int errorCnt = 0;

	private PrintStream outputs;	
</wpt:variables>
	public <xsl:value-of select="$aspect_name"/>(String outputFile) {	
<wpt:function point="container">
		try{
			outputs = new PrintStream(new FileOutputStream(outputFile)); 
		} catch (IOException ioe) {
			System.out.println("ERROR:stat:IOException:" + ioe.toString());
			return;
		}

		try {
			startTestDate = simpleDateFormat.parse("<xsl:value-of select='$wsml/WSML/testTime/startTest'/>"); 
			startMeasurementDate = simpleDateFormat.parse("<xsl:value-of select='$wsml/WSML/testTime/startMeasurement'/>");
			endMeasurementDate = simpleDateFormat.parse("<xsl:value-of select='$wsml/WSML/testTime/endMeasurement'/>");
			endTestDate = simpleDateFormat.parse("<xsl:value-of select='$wsml/WSML/testTime/endTest'/>");
		} catch(ParseException pe) {
			System.out.println("ERROR:ParseException:stat:" + pe.toString());
			return;
		}

		startTest = startTestDate.getTime();
		waitStart = startTest - System.currentTimeMillis();
		
		if (waitStart &lt; 0L) {
			System.out.println("WARNING:stat:Late to start test!");
			startTest = System.currentTimeMillis();
		} else {
			System.out.println("Waiting " + (waitStart / 1000L));
			try {
				Thread.currentThread().sleep(waitStart);
			} catch (InterruptedException ie) {
				System.out.println("ERROR:stat:InterruptedException:" + ie.toString());
				return;
			}
		}
		
		startMeasurement = startMeasurementDate.getTime();
		endMeasurement = endMeasurementDate.getTime();
		
		rampup = startMeasurement - startTest; 
		System.out.println("Rampup:" + rampup/1000L);
		if (rampup &lt; 0L) {
			System.out.println("WARNING:stat:Late to start measurement!");
			rampup = 0L;
		}	
		
		measurementInterval = endMeasurement - startMeasurement;
		System.out.println("MeasurementInterval:" + measurementInterval/1000L);
		if ( measurementInterval &lt;= 0 )	{
			System.out.println("ERROR:stat:Wrong measurement interval!");
			return;
		}
		
		endTest = endTestDate.getTime();

		rampdown = endTest - endMeasurement;
		System.out.println("Rampdown:" + rampdown/1000L);
		if (rampdown &lt; 0L) {
			System.out.println("WARNING:stat:Late to start rampdown!");
			rampdown = 0L;
		}		

</wpt:function>
	}

	public synchronized void interaction(int state, long start, long end)  {
<wpt:function point="interaction">
		int b;  

		if (end &lt; startTest) 
			return;
		
</wpt:function>
	}

	public void waitForTest() {
		try {
			Thread.currentThread().sleep(rampup);
		} catch (InterruptedException ie) {
			System.out.println("ERROR:stat:InterruptedException" + ie.toString());
		}

		try {
			Thread.currentThread().sleep(measurementInterval);
		} catch (InterruptedException ie) {
			System.out.println("ERROR:stat:InterruptedException" + ie.toString());
		}
  
		try {
			Thread.currentThread().sleep(rampdown);
		} catch (InterruptedException ie) {
			System.out.println("ERROR:stat:InterruptedException" + ie.toString());
		}
	}

	public synchronized void error(String message) {
		System.out.println("" + errorCnt + " " + message);
		errorCnt++;
		if ((errorCnt >= <xsl:value-of select="$value_max_errors"/>) &amp;&amp; (<xsl:value-of select="$value_max_errors"/> > 0)) {
			System.out.println("WARNNING: Number of Errors reaches maximum!");
			System.exit(-1);
		}
	}

	public void printHeader(String startTime, String endTime) {
		outputs.println("**************************************************");
		outputs.println("StartTime : " + startTime);
		outputs.println("EndTime : " + startTime);
		outputs.println("NumBrowsers : <xsl:value-of select='$value_num_threads'/>");
		outputs.println("**************************************************");
		outputs.println();
		outputs.println();
	}

	public void printMeasurement() {
<wpt:function point="printMeasurement">
		//weave printing
</wpt:function>
	}
}
</content><xsl:text>
  </xsl:text></file>
</filledTemplate>
</xsl:template>

</xsl:stylesheet>