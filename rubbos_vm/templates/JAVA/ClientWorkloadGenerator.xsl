<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:wpt="http://www.cc.gatech.edu/projects/infosphere/aspect/v0.3" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="/" >
<xtbl>
  <xsl:copy-of select="."/><xsl:text>
</xsl:text>
  <xsl:apply-templates select="/class"></xsl:apply-templates>
</xtbl> 
</xsl:template>

<xsl:template match="/class">

<xsl:variable name="main_name" select="./@name" />
<xsl:variable name="value_num_threads" select="./params/param[@name='numThreads']/@value" />
<xsl:variable name="value_target" select="./params/param[@name='target']/@value" />
<xsl:variable name="value_max_interactions" select="./params/param[@name='maxInteractions']/@value" />
<xsl:variable name="thread" select="./params/param[@name='thread']/@value" />

<filledTemplate name="{$main_name}"><xsl:text>
  </xsl:text>
<file><xsl:text>
    </xsl:text>
<name loc="{$main_name}" id="{$main_name}.java"/><xsl:text>
      </xsl:text>
<content><xsl:text>
</xsl:text>
<wpt:header>
import java.util.Vector;
import java.util.Date;
</wpt:header>

public class <xsl:value-of select="$main_name"/> {

<wpt:variables point="{$main_name}">
	//weave variables		
</wpt:variables>
<wpt:functions point="{$main_name}">
	public static void main(String [] args) {
		<xsl:value-of select="$main_name"/> appClient = new <xsl:value-of select="$main_name"/>();

		Date startTime;
		Date endTime;
		Vector appThreads = new Vector(0);

		System.out.println("Start!");
		startTime = new Date();

<wpt:function.ready point="main">				
		for (int i = 0; i &lt; <xsl:value-of select="$value_num_threads"/>; i++) {
			<xsl:value-of select="$thread"/> t = new <xsl:value-of select="$thread"/>("Thread " + i, appClient, tran, tran.cTransProb);
			appThreads.add(t);
		}
		System.out.println("Threads created!");		
</wpt:function.ready>		
		for (int i = 0; i &lt; appThreads.size(); i++) {
			<xsl:value-of select="$thread"/> t = (<xsl:value-of select="$thread"/>) appThreads.elementAt(i);
			t.initialize();
			t.setDaemon(true);
		}
		
<wpt:function.start point="main">
		for (int i = 0; i &lt; appThreads.size(); i++) {
			<xsl:value-of select="$thread"/> t = (<xsl:value-of select="$thread"/>) appThreads.elementAt(i);
			t.start();
		}
		System.out.println("<xsl:value-of select="$value_num_threads"/> starts!"); 		
</wpt:function.start>

<xsl:text>		</xsl:text><xsl:value-of select="$thread"/>.terminate = true;
		try {
			Thread.currentThread().sleep(10000L);
		} catch (InterruptedException ie) { 
			System.out.println("ERROR:main:InterruptedException" + ie.toString());
		}

		for(int i = 0; i &lt; appThreads.size(); i++) {
			<xsl:value-of select="$thread"/> t = (<xsl:value-of select="$thread"/>) appThreads.elementAt(i);
			System.out.println("INFORM:main:Thread " + t.getThreadName() + " is alive!");
		}

		for (int i = 0; i &lt; appThreads.size(); i++) {
			<xsl:value-of select="$thread"/> t = (<xsl:value-of select="$thread"/>) appThreads.elementAt(i);
			try {
				t.join();
			}catch (InterruptedException inte) {
				System.out.println("ERROR:main:InterruptedException:" + inte.toString());
				return;
			}
		}
		System.out.println("All Threads finished.");		
		endTime = new Date();

<wpt:function.print point="main"/>	

		System.out.println("Test finished");
	} 	
</wpt:functions>
}
</content><xsl:text>
  </xsl:text></file>
</filledTemplate>

<filledTemplate name="{$thread}"><xsl:text>
  </xsl:text>
<file><xsl:text>
    </xsl:text>
<name loc="{$main_name}" id="{$thread}.java"/><xsl:text>
      </xsl:text>
<content><xsl:text>
</xsl:text>
<wpt:header>
import java.net.*;
import java.io.*;
</wpt:header>

public class <xsl:value-of select="$thread"/> extends Thread {
<wpt:variables point="{$thread}">
	private String threadName = null;
	private <xsl:value-of select="$main_name"/> appClient = null;	
	
	public static volatile boolean terminate = false;
	byte [] buffer = new byte[4096];

	private String html;
	private String prevHtml;	
	private String nextReq;	
</wpt:variables>
<wpt:functions point="{$thread}">
        //jky:move tran and prob to init
	public <xsl:value-of select="$thread"/>(String threadName,  <xsl:value-of select="$main_name"/> appClient, Transition tran, int [][] prob) {
<wpt:function point="container">
		this.threadName = threadName;
		this.appClient = appClient;

		initialize();
</wpt:function>
	}

	public void initialize() {
<wpt:function point="initialize">
		nextReq = null;
		html = null;
		prevHtml = null;		
</wpt:function>
	}		

	public String getThreadName() {
		return threadName;
	}
	
	public void run() {
<wpt:function.variables point="run">
		int numRuns = <xsl:value-of select="$value_max_interactions"/>; 			
</wpt:function.variables>
		try {
			while ( (numRuns == -1) || (numRuns > 0) ) { 
				if (terminate) {
					System.out.println(threadName + " ended!");
					return;
				}

				if (nextReq != null) {
<wpt:function.body point="check_usmd"/>		
					if (nextReq == "") { 
						System.out.println("INFORM:NextReq is wrong!");
						initialize(); 
						continue;
					}

					nextReq = "<xsl:value-of select="$value_target"/>" + nextReq; 

					URL httpReq = new URL(nextReq);

					getHTML(httpReq);	
<wpt:function.body point="check_response_time"/>
										
<wpt:function.body point="post_process"/>					
				} else {
					html = null;
					end = start;
				}				
<wpt:function.body point="next_process"/>
								
				if (nextReq != null) {
<wpt:function.body point="check_start_time"/>					
					
					if (terminate) {
						System.out.println(threadName + " ended!");
						return;
					}

<wpt:function.body point="sleep_think_time"/>						
					
					if (numRuns > 0) numRuns--;
				} else {
					System.out.println("ERROR: nextReq == null!");
				}
			} //end of while				
		} catch (MalformedURLException murl) {
			System.out.println("ERROR:MalformedURLException:" + murl.toString());
			return;
		} catch (IOException ioe) {
			System.out.println("ERROR:IOException:" + ioe.toString());
			return;
		}

		System.out.println(threadName + " ends!");
	}

	void getHTML (URL url) {
		html = "";
		int r;
		BufferedInputStream in = null;
		BufferedInputStream imgIn = null;
		boolean retry = false;

		Vector imageRd = new Vector(0);

		do {
			if (retry) {
				try {
					sleep(500L);
				} catch (InterruptedException inte) {
					System.out.println("ERROR:In getHTML, caught interrupted exception!");
					return;
				}
				retry = false;
			}

      			try {
				in = new BufferedInputStream(url.openStream(), 4096);
			} catch (IOException ioe) {
				appClient.stat.error("ERROR:Unable to open URL in " + url.toExternalForm());
				ioe.printStackTrace();
				retry=true;
				continue;
			}
      
			try {
				while ((r = in.read(buffer, 0, buffer.length))!=-1) {
					if (r>0) {
						html = html + new String(buffer, 0, r);
					}
				}
			} catch (IOException ioe) {
				appClient.stat.error("ERROR:Unable to read HTML from URL in " + url.toExternalForm());
				retry = true;
				continue;
			}			
		} while (retry);

		try {
			in.close();
		} catch (IOException ioe) {
			appClient.stat.error("ERROR:Unable to close URL in " + url.toExternalForm());
		}    

		int cur = 0;

		findImg(html, url, pattern_img, pattern_src, pattern_quote,  imageRd);
		findImg(html, url, pattern_inputImage, pattern_src, pattern_quote, imageRd); 

		while (imageRd.size() > 0) {
			int max = imageRd.size();
			int min = 0;

			try {
				for (int i = min; i &lt; max; i++) {
					ImageReader rd = (ImageReader) imageRd.elementAt(i);
					if (!rd.readImage()) {
						imageRd.removeElementAt(i);
						i--;
						max--;
					}
				}
			} catch (InterruptedException inte) {
				System.out.println("ERROR:In getHTML, caught interrupted exception!");
				return;
			}
		}
	}
				       
	private void findImg(String src, URL url, String imgPat, String srcPat, String quotePat,  Vector imageRd) {
		int cur = findString(imgPat, src);
		String subSrc = src;
		int start = 0;
		int end = 0;
		int i = 0;

		while (cur != -1) {
			subSrc = subSrc.substring(end + cur + imgPat.length());
			i = findString(srcPat, subSrc);
			start = i + srcPat.length();
			i = findString(quotePat, subSrc.substring(start));
			end = start + i;

			String imgLoc = subSrc.substring(start, end);						
			imageRd.addElement( new ImageReader(url, imgLoc, buffer) );

			end = end + quotePat.length();
			cur = findString(imgPat, subSrc.substring(end));
		}
	}
	
	private int findINTValue(String p, String s) {
		int ret_val;
		int i,e;

		i = findString(p, s);
		if (i == -1) {			
			return -1;
		}
		i = i + p.length();

		e = findNotDigit(s.substring(i));
		if ( (e==-1) || (e==0) ) {
			return -1;
		}
		e=e+i;
	 
		ret_val = Integer.parseInt(s.substring(i, e));

		return ret_val;
	}

	private int findNextINTValue(String p, String s) {
		int ret_val;
		int i,st,en;

		i = findString(p, s);
		if (i == -1) {			
			return -1;
		}
		i = i + p.length();

		st = findDigit(s.substring(i));
		if ( (st==-1) ) {
			return -1;
		}

		st=st+i;
		en = findNotDigit(s.substring(st));
		if ( (en==-1) ) {
			en = s.length();
		} else {
			en=en+st;
		}
	 
		ret_val = Integer.parseInt(s.substring(st, en));

		return ret_val;
	}

	private int findString(String t, String s) {
		return(findString(t, s, 0, s.length()-1));
	}

	private int findString(String t, String s, int start, int end) {
		int i = s.indexOf(t, start);
		if (i == -1) {
			return(-1);
		} else if ( i >= (end + t.length()) ) {
			return(-1);
		} else {
			return(i);
		}
	}

	private int findDigit(String s) {
		int i;

		for (i = 0; i &lt;= (s.length() - 1); i++) {
			if ((s.charAt(i)>='0') &amp;&amp; (s.charAt(i) &lt;= '9')) {
				return(i);
			}
		}

		return(-1);
	}

	private int findNotDigit(String s) {
		int i;

		for (i = 0; i &lt;= (s.length() - 1); i++) {
			if (notDigitCharMatch(s.charAt(i))) {
				return(i);
			}
		}

		return(-1);
	}

	private boolean notDigitCharMatch(char c) {
		//set 
		byte [] mask = new byte[32];
		char s = (char) 0;
		char e = (char) 255;
	
		int si = s>>3;
		int ei = e>>3;

		int b;

		if (si == ei) {
			mask[si] |= ((1 &lt;&lt; ((e &amp; 7)-(s &amp; 7)+1))-1) &lt;&lt; (s &amp; 7);
		} else {
			for (b = si + 1; b &lt; ei; b++) {
				mask[b] = (byte) 0xff;
			}
      
			mask[si] |= 0xff &lt;&lt; (s &amp; 7);
			mask[ei] |= (1 &lt;&lt; ((e &amp; 7)+1)) -1;
		}

		//clear
		char cs = '0';
		char ce = '9';

		int csi = cs>>3;
		int cei = ce>>3;

		int cb;

		if (csi == cei) {
			mask[csi] &amp;= 0xff ^ ((1 &lt;&lt; ((ce &amp; 7)-(cs &amp; 7)+1))-1) &lt;&lt; (cs &amp; 7);
		} else {
			for (cb = csi + 1; cb &lt; cei; cb++) {
				mask[cb] = (byte) 0;
			}
      
			mask[csi] &amp;= 0xff>>(8-(cs &amp; 7));
			mask[cei] &amp;= 0xfe &lt;&lt; (ce &amp; 7);
		}

		//match
		int i = c>>3;
		int bit = 1 &lt;&lt; (c &amp; 7);

		return((mask[i] &amp; bit) != 0);
	}

	private String findStringValue(String p, String lp, String s) {
		String ret_val;
		int i,e;

		i = findString(p, s);
		if (i == -1) {			
			return null;
		}
		i = i + p.length();

		e = findString(lp, s.substring(i));
		if ( (e==-1) || (e==0) ) {
			return null;
		}
		e=e+i;
	 
		ret_val = s.substring(i, e);

		return ret_val;
	} 

	private String fixToURLable(String url) {
		int i;
		String fURL = "";

		for (i = 0; i &lt; url.length(); i++) {
			char ch = url.charAt(i);
			if ( ((ch >= '0') &amp;&amp; (ch &lt;= '9')) ||
				 ((ch >= 'a') &amp;&amp; (ch &lt;= 'z')) ||
				 ((ch >= 'A') &amp;&amp; (ch &lt;= 'Z')) || 
				 ((ch == '.') || (ch =='/')) ) {
				fURL = fURL + ch;
			} else if ( ch == ' ') {
				fURL = fURL + '+';
			} else {
				int d = ch;
				int d1 = d>>4;
				int d2 = d &amp; 0xf;
				char c1 = (char) ( (d1 > 9) ? ( 'A'+d1-10 ) : '0'+d1);
				char c2 = (char) ( (d2 > 9) ? ( 'A'+d2-10 ) : '0'+d2);
				fURL = fURL + "%" + c1 + c2;
			}
		}
	 
		return(fURL);
	}  	
</wpt:functions>
}
</content><xsl:text>
  </xsl:text></file>

<file><xsl:text>
    </xsl:text>
<name loc="{$main_name}" id="Debug.java"/><xsl:text>
      </xsl:text>
<content><xsl:text>
</xsl:text>
public class Debug {
	public static void myassert(boolean assertCond, String message){
		if (!assertCond) {
			throw new DebugError("Assert failed:  " + message);
		}
	}

	public static void fail(String message) {
		throw new DebugError("Assert failed:  " + message);
	}
}

class DebugError extends Error {
	String message;

	public DebugError(String message) {
		this.message = message;
	}

	public String toString() {
		return ("DebugError:  " + message);
	}
}
</content><xsl:text>
  </xsl:text></file>

<file><xsl:text>
    </xsl:text>
<name loc="{$main_name}" id="ImageReader.java"/><xsl:text>
      </xsl:text>
<content><xsl:text>
</xsl:text>
import java.net.*;
import java.io.*;

public class ImageReader {
	protected String imgURLStr;
	protected URL srcURL;
	protected URL imgURL;
	protected byte [] buffer;
	protected BufferedInputStream imgIn=null;
	protected int tot;

	public ImageReader(URL srcURL, String url, byte [] buffer) {
		imgURLStr = url;
		this.buffer = buffer;
		imgURL = null;
		this.srcURL = srcURL;
	}

	public boolean readImage() throws InterruptedException {
		int r;

		if (imgURL == null) {
			try {
				int idx, idxDot;
				int num;
				String iType = null;
				if ( ( idx = imgURLStr.indexOf("image_") ) != -1 ) {
					iType = "image_";
				} else if ( ( idx = imgURLStr.indexOf("thumb_") ) != -1) {
					iType = "thumb_";
				}

				if (idx != -1) {
					idxDot = imgURLStr.lastIndexOf('.');
					num = Integer.parseInt(imgURLStr.substring(idx+6, idxDot));
					int dNum = num % 100; //here num of images
					//int dNum = num % 10;
					num = num - dNum;
					imgURLStr = imgURLStr.substring(0, imgURLStr.indexOf("/img")) + "/img" + dNum + "/" + iType + (num+dNum) + ".gif";
				}

				imgURL = new URL(srcURL, imgURLStr);
			} catch(MalformedURLException mue) {
				System.out.println("ERROR:Malformed image URL in " + imgURLStr);
				return(false);
			} catch (NullPointerException e){
				System.out.println("ERROR:NPE in readImage 1 in " + imgURLStr);
				return(true);
			}

			try {
				imgIn = new BufferedInputStream(imgURL.openStream());
			} catch (IOException ioe) {
				try {
					Thread.currentThread().sleep(5000L);
				} catch (InterruptedException intE) {
					System.out.println("ERROR:In readImage, caught interrupted exception!"); 
				} catch (NullPointerException e){
					System.out.println("ERROR:NPE in readImage 2 in " + imgURLStr);
					return(true);
				}
				return(true);
			}
			tot = 0;
		}
    
		try {
			r = imgIn.read(buffer, 0, buffer.length);
		} catch (IOException ioe) {
			System.out.println("ERROR:Unable to read complete image in " + imgURLStr);
			try {
				imgIn.close();
			} catch (IOException cioe) {
				System.out.println("ERROR:Unable to close image in " + imgURLStr);
			}
    
			imgIn = null;
			imgURL = null;
			
			return(true);
		} catch (NullPointerException e){
			return(false);
		}
    
		if (r==-1) {
			try {
				imgIn.close();
			} catch (IOException ioe) {
				System.out.println("ERROR:Unable to close image in " + imgURLStr);
			}
    
			imgIn = null;
			imgURL = null;
			
			return(false);
		} else {
			tot+=r;
		}	

		return(true);
	}
}
</content><xsl:text>
  </xsl:text></file>

</filledTemplate>

</xsl:template>

</xsl:stylesheet>