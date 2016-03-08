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

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:header">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
//weave from tran
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Random;  	
</xsl:template> 

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:variables[@point=$target_name]">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
	//weave from tran
	private static Transition tran = new Transition();  		
</xsl:template> 

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:functions[@point=$target_name]">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
	//weave from tran
	public static int nextInt(Random rand, int range) {
		int i = Math.abs(rand.nextInt());
		return (i % (range));
	}

	public static final int NURand(Random rand, int A, int x, int y) {
		return((( (nextInt(rand, A+1)) | (nextInt(rand, y-x+1)+x)) % (y-x+1)) +x);
	}

	public final long negExp(Random rand, long min, double lMin, long max, double lMax, double mu) {
		double r = rand.nextDouble();
    
		if (r &lt; lMax) {
			return(max);
		}
		return((long) (-mu*Math.log(r)));
	}

	private static final String [] digS = {
		"BA","OG","AL","RI","RE","SE","AT","UL","IN","NG"
	};
  
	public static String digSyl(int d, int n) {
		String s = "";

		if (n == 0) 
			return (digSyl(d));

		for (; n > 0; n--) {
			int c = d % 10;
			s = digS[c] + s;
			d = d / 10;
		}

		return(s);
	}

	public static String digSyl(int d) {
		String s = "";

		for (; d != 0; d = d/10) {
			int c = d % 10;
			s = digS[c]+s;      
		}

		return(s);
	}

	public static String unameAndPass(int cid) {
		String un = digSyl(cid);
		return un;		
	}

	public static final String [] subjects = {
		"ARTS",
		"BIOGRAPHIES",
		"BUSINESS",
		"CHILDREN",
		"COMPUTERS",
		"COOKING",
		"HEALTH",
		"HISTORY",
		"HOME",
		"HUMOR",
		"LITERATURE",
		"MYSTERY",
		"NON-FICTION",
		"PARENTING",
		"POLITICS",
		"REFERENCE",
		"RELIGION",
		"ROMANCE",
		"SELF-HELP",
		"SCIENCE-NATURE",
		"SCIENCE-FICTION",
		"SPORTS",
		"YOUTH",
		"TRAVEL"
	};

	public static String unifSubject(Random rand) { 
	  return(subjects[nextInt(rand, subjects.length)]); 
	}	  

	public static final String [] countries = {
		"United+States",                    "United+Kingdom",
		"Canada",                           "Germany",
		"France",                           "Japan",
		"Netherlands",                      "Italy",
		"Switzerland",                      "Australia",
		"Algeria",                          "Argentina",
		"Armenia",                          "Austria",
		"Azerbaijan",                       "Bahamas",
		"Bahrain",                          "Bangla+Desh",
		"Barbados",                         "Belarus",
		"Belgium",                          "Bermuda",
		"Bolivia",                          "Botswana",
		"Brazil",                           "Bulgaria",
		"Cayman+Islands",                   "Chad",
		"Chile",                            "China",
		"Christmas+Island",                 "Colombia",
		"Croatia",                          "Cuba",
		"Cyprus",                           "Czech+Republic",
		"Denmark",                          "Dominican+Republic",
		"Eastern+Caribbean",                "Ecuador",
		"Egypt",                            "El+Salvador",
		"Estonia",                          "Ethiopia",
		"Falkland+Island",                  "Faroe+Island",
		"Fiji",                             "Finland",
		"Gabon",                            "Gibraltar",
		"Greece",                           "Guam",
		"Hong+Kong",                        "Hungary",
		"Iceland",                          "India",
		"Indonesia",                        "Iran",
		"Iraq",                             "Ireland",
		"Israel",                           "Jamaica",
		"Jordan",                           "Kazakhstan",
		"Kuwait",                           "Lebanon",
		"Luxembourg",                       "Malaysia",
		"Mexico",                           "Mauritius",
		"New+Zealand",                      "Norway",
		"Pakistan",                         "Philippines",
		"Poland",                           "Portugal",
		"Romania",                          "Russia",
		"Saudi+Arabia",                     "Singapore",
		"Slovakia",                         "South+Africa",
		"South+Korea",                      "Spain",
		"Sudan",                            "Sweden",
		"Taiwan",                           "Thailand",
		"Trinidad",                         "Turkey",
		"Venezuela",                        "Zambia",
	};

	public static String unifCountry(Random rand) {
		return(countries[nextInt(rand, countries.length)]);
	}

	public static final Calendar c = new GregorianCalendar(1880,1,1);
	public static final long dobStart = c.getTime().getTime();
	public static final long dobEnd =  System.currentTimeMillis();

	public static String unifDOB(Random rand) {
		long t = ((long) (rand.nextDouble()*(dobEnd-dobStart)))+dobStart;
		Date d = new Date(t);
	 
		Calendar c = new GregorianCalendar();
		c.setTime(d);

		return("" + c.get(Calendar.DAY_OF_MONTH) + "%2f" + c.get(Calendar.DAY_OF_WEEK) + "%2f" + c.get(Calendar.YEAR));
	}

	public static String unifDate(Random rand) {
		Date d = new Date(System.currentTimeMillis() + ((long) (nextInt(rand, 730))+1)*24L*60L*60L*1000L);
		
		Calendar c = new GregorianCalendar();
		c.setTime(d);

		return("" + c.get(Calendar.DAY_OF_MONTH) + "%2f" + c.get(Calendar.DAY_OF_WEEK) + "%2f" + c.get(Calendar.YEAR));
	}

	public static final String [] ccTypes = {
		"VISA", "MASTERCARD", "DISCOVER", "DINERS", "AMEX"
	};

	public static String unifCCType(Random rand) {
		return(ccTypes[nextInt(rand, ccTypes.length)]);
	}

	public static String unifDollars(Random rand) {
		String dollars = null;

		int d = nextInt(rand, 9999)+1;
		String c = "" + nextInt(rand, 100);

		if (c.length() == 2) {
			dollars = d + "." + c;
		} else if (c.length() == 1) {
			dollars = d + "." + "0" + c;
		} else {
			dollars = d + "." + "00";
		}
		
		return dollars;
	}

	public static final String [] shipTypes = {
		"AIR",
		"UPS",
		"FEDEX",
		"SHIP",
		"COURIER",
		"MAIL"
	};

	public static String unifShipping(Random rand) {
		int i = nextInt(rand, shipTypes.length);
		return(shipTypes[i]);
	}

	public static String unifImage(Random rand) {
		int i = nextInt(rand, 10000)+1; //here num of items
		int grp = i % 100;
		return("img" + grp + "/image_" + i + ".gif");
	}

	public static String unifThumbnail(Random rand) {
		int i = nextInt(rand, 10000)+1; //here num of items
		int grp = i % 100;
		return("img" + grp + "/thumb_" + i + ".gif");
	}

	public static final String [] nchars = { 
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
	};

	public static final String [] achars = { 
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
		"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", 
		"k", "l", "m", "n", "o", "p", "q", "r", "s", "t", 
		"u", "v", "w", "x", "y", "z", 
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", 
		"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", 
		"U", "V", "W", "X", "Y", "Z", 
		"%21",  // "!"
		"%40",  // "@"
		"%23",  // "#"
		"%24",  // "$"
		"%25",  // "%"
		"%5E",  // "^"
		"%26",  // "&amp;"
		"*",    // "*"
		"%28",  // "("
		"%29",  // ")"
		//	 "_",    // "_"
		"%5F", 
		"-",    // "-"
		"%3D",  // "="
		"%2B",  // "+"
		"%7B",  // "{"
		"%7D",  // "}"
		"%5B",  // "["
		"%5D",  // "]"
		"%7C",  // "|"
		"%3A",  // ":"
		"%3B",  // ";"
		"%2C",  // ","
		".",    // "."
		"%3F",  // "?"
		"%2F",  // "/"
		"%7E",  // "~"
		"+"     // " "
	};

	public static String astring(Random rand, int min, int max){
		return(rstring(rand, min, max, achars));
	}

	public static String nstring(Random rand, int min, int max){
		return(rstring(rand, min, max, nchars));
	}

	public static String rstring(Random rand, int min, int max, String [] cset) {
		int l = cset.length;
		int r = nextInt(rand, max-min+1)+min;
		String s;

		for (s=""; s.length() &lt; r; s = s + cset[nextInt(rand, l)]);

		return(s);
	}  
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_name]//wpt:function.ready[@point='main']">  
		//weave from tran
		tran.initialize();    
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>	
</xsl:template> 

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:header">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/> 
  </xsl:copy>
//weave from tran
import java.util.Vector;
import java.util.Random;
import java.util.Date;
import java.util.Calendar;
import java.util.GregorianCalendar;  
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:variables[@point=$target_thread_name]">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
  	//weave from tran
	private Transition tran = null;
	private int [][] transProb;
	private int currState;
	
	private Random rand = new Random();		
	private boolean toHome;	
	private int cID;
	private String sessionID; 
	private int shopID;
	private String firstName = null; 
	private String lastName = null;	 

	public static final int MIN_PROB = 1;
	public static final int MAX_PROB = 9999;
	public static final int ID_UNKNOWN = -1;
	public static final int NO_TRANS = 0;
	
	private final String authorType = "author";
	private final String subjectType = "subject";
	private final String titleType = "title";

	private final String pattern_iID = "I_ID\" TYPE=\"hidden\" VALUE=\"";
	private final String pattern_iIDr = "I_ID=";
	private final String pattern_firstName = "Firstname:&lt;/TD>&lt;TD>";
	private final String pattern_lastName = "Lastname: &lt;/TD>&lt;TD>";  
	private final String pattern_lt = "&lt;";
	private final String pattern_qty = "NAME=\"QTY";
	private final String pattern_value = "VALUE=\"";
	private final String pattern_cID = "C_ID=";
	private final String pattern_sessionID = ";jsessionid=";
	private final String pattern_endSessionID = "?";
	private final String pattern_shopID = "SHOPPING_ID=";
	private final String pattern_img = "&lt;IMG";
	private final String pattern_inputImage = "&lt;INPUT TYPE=\"IMAGE\"";
	private final String pattern_src = "SRC=\"";
	private final String pattern_quote = "\"";

	private long usmd; 
</xsl:template> 

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:functions[@point=$target_thread_name]">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
  	//weave from tran
	private String computeNextReqFromState(int nextState) {
		toHome = false;
		
		switch (nextState) {
			case 0: //init
			case 1: //admc
			{
				String imageName = null;
				String thumbnailName = null;
				String cost = null;
				int iiID = ID_UNKNOWN;

				imageName = fixToURLable(appClient.unifImage(rand));
				
				thumbnailName = fixToURLable(appClient.unifThumbnail(rand));				
				
				cost = appClient.unifDollars(rand);				
				
				iiID = findINTValue(pattern_iID, html);
				if (iiID == ID_UNKNOWN){
					appClient.stat.error("ERROR:computeNextReqFromState:Unable to find I_ID in AdminConf");
					return "";
				}
			
				return(tran.getAdminConfURL(sessionID, cID, shopID, imageName, thumbnailName, cost, iiID));				
			}
			case 2: //admr
			{
				int iiID = ID_UNKNOWN;

				iiID = findINTValue(pattern_iIDr, html);
				if (iiID == ID_UNKNOWN){
					appClient.stat.error("ERROR:computeNextReqFromState:Unable to find I_ID in AdminReq");
					return "";
				}

				return(tran.getAdminReqURL(sessionID, cID, shopID, iiID));
			}
			case 3: //bess
			{
				String subject = null;

				subject = appClient.unifSubject(rand);

				return(tran.getBestSellURL(sessionID, cID, shopID, subject));
			}
			case 4: //buyc
			{
				String ccType = null;
				String ccNumber = null;
				String name = null;
				String expDate = null;
				String street1 = null;
				String street2 = null;
				String city = null;
				String state = null;
				String zip = null;
				String country = null;
				String shipping = null;

				ccType = appClient.unifCCType(rand);
				
				ccNumber = appClient.nstring(rand, 16,16);
				
				name = findStringValue(pattern_firstName, pattern_lt, html);
				name = fixToURLable(name);
				if (name == null){
					appClient.stat.error("ERROR:computeNextReqFromState:Unable to find first name in BuyCon");
					return "";
				}
				if ((firstName != null) &amp;&amp; (!firstName.equals(name))) {
					appClient.stat.error("ERROR:computeNextReqFromState:Different first name in BuyCon");
					return "";
				}
				if (firstName == null) {
					firstName = name;
				}
				
				name = findStringValue(pattern_lastName, pattern_lt, html);
				name = fixToURLable(name);
				if (name == null){
					appClient.stat.error("ERROR:computeNextReqFromState:Unable to last name in BuyCon");
					return "";
				}
				if ((lastName != null) &amp;&amp; (!lastName.equals(name))) {
					appClient.stat.error("ERROR:computeNextReqFromState:Different last name in BuyCon");
					return "";
				}
				if (lastName == null) {
					lastName = name;
				}

				if (cID == ID_UNKNOWN) {
					appClient.stat.error("ERROR:computeNextReqFromState:CID not known in BuyCon");
					return "";
				}				
				
				expDate = appClient.unifDate(rand);
				
				if (nextInt(100) &lt; 5) {
					street1 = appClient.astring(rand, 15, 40);
					street2 = appClient.astring(rand, 15, 40);
					city = appClient.astring(rand, 4, 30);
					state = appClient.astring(rand, 2, 20);
					zip = appClient.astring(rand, 5, 10);
					country = appClient.unifCountry(rand);
				} else {
					street1 = "";
					street2 = "";
					city = "";
					state = "";
					zip = "";
					country = "";
				}
				
				shipping = appClient.unifShipping(rand);

				return(tran.getBuyConfURL(sessionID, cID, shopID, ccType, ccNumber, firstName + lastName, expDate, street1, street2, city, state, zip, country, shipping));
			}
			case 5: //buyr
			{
				String ret = null;
				String name = null;
				String password = null;
				String firstName = null;
				String lastName = null;				
				String street1 = null;
				String street2 = null;
				String city = null;
				String state = null;
				String zip = null;
				String country = null;
				String phone = null;
				String email = null;
				String birthDate = null;
				String data = null;

				if (cID != ID_UNKNOWN) {
					ret = "Y";
					name = appClient.unameAndPass(cID);
					password = name.toLowerCase();
					return(tran.getBuyReqURL(sessionID, cID, shopID, ret, name, password));
				} else {
					ret = "N";
					firstName = appClient.astring(rand, 8, 15);
					lastName = appClient.astring(rand, 8, 15);
					street1 = appClient.astring(rand, 15, 40);
					street2 = appClient.astring(rand, 15, 40);
					city = appClient.astring(rand, 10, 30);
					state = appClient.astring(rand, 2, 20);
					zip = appClient.astring(rand, 5, 10);
					country = appClient.unifCountry(rand);
					phone = appClient.nstring(rand, 9, 16);
					email = appClient.astring(rand, 8, 15) + "%40" + appClient.astring(rand, 2,9) + ".com";
					birthDate = appClient.unifDOB(rand);
					data = appClient.astring(rand, 100, 500);	

					return(tran.getBuyReqURL(sessionID, cID, shopID, ret, firstName, lastName, street1, street2, city, state, zip, country, phone, email, birthDate, data));
				}						
			}
			case 6: //creg
			{
				return(tran.getCustRegURL(sessionID, cID, shopID));
			}
			case 7: //home
			{
				if (currState == 0) { //init
					if (nextInt(10) &lt; 8) {
						cID = appClient.NURand(rand, 65535, 1, 576000); //here cid and num of cust
						sessionID = null;
						return (tran.getHomeURL(cID));
					} else {
						cID = ID_UNKNOWN;
						sessionID = null;
						return (tran.getHomeURL(cID));
					}
				} else {
					toHome = true;
					return(tran.getHomeURL(sessionID, cID, shopID));
				}
			}
			case 8: //newp
			{
				String subject = null;

				subject = appClient.unifSubject(rand);

    			return(tran.getNewProdURL(sessionID, cID, shopID, subject));
			}
			case 9: //ordd
			{
				String name = null;
				String password = null;

				if (cID == ID_UNKNOWN) {
					cID = appClient.NURand(rand, 65535, 1, 576000); //here cid and num of cust
				}
				name = appClient.unameAndPass(cID);
				password = name.toLowerCase();

    			return(tran.getOrderDispURL(sessionID, cID, shopID, name, password));
			}
			case 10: //ordi
			{
    			return(tran.getOrderInqURL(sessionID, cID, shopID));
			}
			case 11: //prod
			{
    			if (currState == 11) { //prod
					Vector iIDs = new Vector(0);	
					
					int iiID = 0;
					int i = findString(pattern_iIDr, prevHtml);;
					String subHtml = prevHtml;

					while (i != -1) {
						iiID = findNextINTValue(pattern_iIDr, subHtml);
						if (iiID != ID_UNKNOWN){
							iIDs.addElement(new Integer(iiID));
						}
						
						i = i + pattern_iIDr.length();
						subHtml = subHtml.substring(i);
						i = findString(pattern_iIDr, subHtml);
					}	

					if (iIDs.size()==0) {
						appClient.stat.error("ERROR:computeNextReqFromState:Unable to find any items in ProdDet");
						return "";
					}

					i = nextInt(iIDs.size());
					iiID = ((Integer) iIDs.elementAt(i)).intValue();

					return (tran.getProdDetURL(sessionID, cID, shopID, iiID));
				} else {
					Vector iIDs = new Vector(0);	

					int iiID = 0;
					int i = findString(pattern_iIDr, html);
					String subHtml = html;

					while (i != -1) {
						iiID = findNextINTValue(pattern_iIDr, subHtml);
						if (iiID != ID_UNKNOWN){
							iIDs.addElement(new Integer(iiID));
						}
						
						i = i + pattern_iIDr.length();
						subHtml = subHtml.substring(i);
						i = findString(pattern_iIDr, subHtml);
					}				
					
					prevHtml = html;

					if (iIDs.size()==0) {
						appClient.stat.error("ERROR:computeNextReqFromState:Unable to find any items in ProdDet");
						return "";
					}

					i = nextInt(iIDs.size());
					iiID = ((Integer) iIDs.elementAt(i)).intValue();

					return (tran.getProdDetURL(sessionID, cID, shopID, iiID));
				}
			}
			case 12: //sreq
			{
    			return(tran.getSearchReqURL(sessionID, cID, shopID));
			}
			case 13: //sres
			{
				String searchType = null;
				String searchString = null;

				int srchType = nextInt(3);
				switch(srchType) {
					case 0:
					{
						searchType = authorType;
						//searchString = appClient.digSyl(appClient.NURand(rand, 511, 0, 10000/10), 7); //here iid and num of items
						searchString = appClient.digSyl(appClient.NURand(rand, 511, 0, 1000), 7); 
						break;
					}
					case 1:
					{
						searchType = titleType;
						//searchString = appClient.digSyl(appClient.NURand(rand, 511, 0, 10000/5), 7); //here iid and num of items
						searchString = appClient.digSyl(appClient.NURand(rand, 511, 0, 2000), 7);
						break;
					}
					case 2:
					{
						searchType = subjectType;
						searchString = appClient.unifSubject(rand);
						break;
					}
				}
    			return(tran.getSearchResultURL(sessionID, cID, shopID, searchType, searchString));
			}
			case 14: //shop
			{
    			if (currState == 11) { //prod
					String addFlag = "Y";
					int iiID = ID_UNKNOWN;

					iiID = findINTValue(pattern_iIDr, html);
					if (iiID == ID_UNKNOWN){
						appClient.stat.error("ERROR:computeNextReqFromState:Unable to find I_ID in ShopCart");
						return "";
					}

					return (tran.getShopCartURL(sessionID, cID, shopID, addFlag, iiID));
				} else if (currState == 14) {//shop
					String addFlag = "N";
						
					int c = 0;					
					int i = findString(pattern_qty, html);
					String subHtml = html;					 
					while (i != -1) {
						i = i + pattern_qty.length();
						subHtml = subHtml.substring(i);
						i = findString(pattern_qty, subHtml);
						c++;
					}	
					if (c==0) {
						appClient.stat.error("ERROR:computeNextReqFromState:Unable to find QTY in ShopCart");
						return "";
					}
					int [] qty = new int[c];
					c = 0;					
					i = findString(pattern_qty, html);
					subHtml = html;					 
					while (i != -1) {
						i = i + pattern_qty.length();
						subHtml = subHtml.substring(i);

						qty[c] = findINTValue(pattern_value, subHtml);

						i = findString(pattern_qty, subHtml);
						c++;
					}	
					int [] qtyNew = new int[c];
					if (c==1) {
						qtyNew[0] = nextInt(10) + 1;
					} else {
						int r= nextInt(c)+1;
						int [] idx = new int[c];						
						for (i = 0; i &lt; c; idx[i]=i,i++);
						for (i = 0;i &lt; (c-1); i++) {
							int d = nextInt(c-i)+i;
							int a= idx[d];
							idx[d] = idx[i];
							idx[i] = a;
						}
						for (i = 0; i &lt; r; i++) {
							qtyNew[idx[i]] = nextInt(9);
							if (qtyNew[idx[i]] >= qty[idx[i]]) {
								qtyNew[idx[i]]++;
							}
						}
					}
					
					return ( tran.getShopCartURL(sessionID, cID, shopID, addFlag, c, qtyNew) );
				} else {
					String addFlag = "N";

					return (tran.getShopCartURL(sessionID, cID, shopID, addFlag));
				}
			}
			default:
				return "";
		}
	}

	private void computePostProcess(int state) {
		switch (state) {
			case 5: //buyr
			{
				if (cID == ID_UNKNOWN) {
					cID = findNextINTValue(pattern_cID, html);
					if (cID == ID_UNKNOWN) {
						appClient.stat.error("ERROR:computePostProcess:Unable to find C_ID in BuyReq");
					}
				}
				break;
			}
			case 7: //home
			{
				if (currState == 0) { //init
					if (sessionID == null) {
						sessionID = findStringValue(pattern_sessionID, pattern_endSessionID, html);
						if (sessionID==null) {
							appClient.stat.error("ERROR:computePostProcess:Unable to find session ID in Home");
						}
					}
				} else {
				}
				break;
			}
			case 14: //shop
			{
				if (cID == ID_UNKNOWN) {
					cID = findNextINTValue(pattern_cID, html);					
				}

				if (sessionID == null) {
					sessionID = findStringValue(pattern_sessionID, pattern_endSessionID, html);
					if (sessionID==null) {
						appClient.stat.error("ERROR:computePostProcess:Unable to find session ID in ShopCart");
					}
				}

				if (shopID == ID_UNKNOWN) {
					shopID = findNextINTValue(pattern_shopID, html);
					if (shopID == ID_UNKNOWN) {
						appClient.stat.error("ERROR:computePostProcess:Unable to find shop ID in ShopCart");
					}
				}				  
				break;
			}
			default:
				break;
		}		
	}	

	private int getNextState() {
		int prob = nextInt(MAX_PROB - MIN_PROB + 1) + MIN_PROB;
		int nextState;

		for (nextState = 0; nextState &lt; transProb[currState].length; nextState++) {
			if (transProb[currState][nextState] >= prob) {
				break;				
			}
		}

		return nextState;
	}

	private long getThinkTime() {
		long r = appClient.negExp(rand, 7000L, 0.36788, 70000L, 4.54e-5, 7000.0);
		
		return((long)r);
	}

	private long getUsmd(){
		long r = appClient.negExp(rand, 0L, 1.0, 3600000L /*60 minutes*/, 0.0183156, 900000.0 /* 15 minutes */);
		
		return((long)r);
	}	
  
	private int nextInt(int range) {
		int i = Math.abs(rand.nextInt());
		return (i % (range));
	}  
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:function[@point='container']">  
		//weave from tran
		int prev;
		int s = prob.length;

		Debug.myassert(tran != null, "Transition is null!");
	
		Debug.myassert(s>0, "No states in prob.");
		
		for (int j = 0; j &lt; s; j++) {
			Debug.myassert(prob[j].length==s, "Transition matrix is not square.");

			prev = 0;
			for (int i = 0; i &lt; s; i++) {
				if (prob[j][i] != NO_TRANS) {
					Debug.myassert(prob[j][i] &lt;= MAX_PROB, "Transition probability for prob[" + j + "][" + i + "] (" + prob[j][i] + ") is larger than " + MAX_PROB);
					Debug.myassert(prob[j][i] >= MIN_PROB, "Transition probability for prob[" + j + "][" + i + "] (" + prob[j][i] + ") is less than " + MIN_PROB);
					Debug.myassert(prob[j][i] > prev, "Transition [" + j + "][" + i + "] has probability (" + prob[j][i] + " not greater than previous " + "probability (" + prev + ")");
	      
					prev = prob[j][i];
				}
			}
			Debug.myassert(prev==MAX_PROB, "Final probability for state [" + j + "] ( " + prev + ") is not " + MAX_PROB);
		}

		this.tran = tran;
		this.transProb = prob;  
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:function[@point='initialize']">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
  		//weave from tran
		currState = 0;			
		cID    = ID_UNKNOWN;
		sessionID = null;
		shopID = ID_UNKNOWN;
		firstName = null;
		lastName = null;			
		usmd = System.currentTimeMillis() + getUsmd();  
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:function.variables[@point='run']">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>  
  </xsl:copy>
		//weave from tran
		int nextState = 0;	  
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:function.body[@point='check_usmd']">
					//weave from tran
					if ( (start >= usmd) &amp;&amp; (toHome) ) {
						System.out.println("INFORM:USMD is expired!");
						initialize(); 
						continue;
					}
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:function.body[@point='post_process']">
					//weave from tran
					computePostProcess(nextState);
					currState = nextState;
</xsl:template>

<xsl:template match="//filledTemplate[@name=$target_thread_name]//wpt:function.body[@point='next_process']">
				//weave from tran
				nextState = getNextState();
				nextReq = computeNextReqFromState(nextState);
</xsl:template>


<xsl:template match="//class//aspect[@name=$aspect_name]">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>  
  </xsl:copy>
<filledTemplate name="{$aspect_name}"><xsl:text>
  </xsl:text>
<file><xsl:text>
    </xsl:text>
<name loc="{$main_name}" id="{$aspect_name}.java"/><xsl:text>
      </xsl:text>
<content><xsl:text>
</xsl:text>
import java.util.StringTokenizer;
import java.util.NoSuchElementException;

public class <xsl:value-of select="$aspect_name"/> {
	
	private static final int ID_UNKNOWN = -1;

	//shopping model
	private static final int [][] transProb = {
		{    0,    0,    0,    0,    0,    0,    0, 9999,    0,    0,    0,    0,    0,    0,    0},
		{    0,    0,    0,    0,    0,    0,    0, 9952,    0,    0,    0,    0, 9999,    0,    0},
		{    0, 8999,    0,    0,    0,    0,    0, 9999,    0,    0,    0,    0,    0,    0,    0},
		{    0,    0,    0,    0,    0,    0,    0,  167,    0,    0,    0,  472, 9927,    0, 9999},
		{    0,    0,    0,    0,    0,    0,    0,   84,    0,    0,    0,    0, 9999,    0,    0},
		{    0,    0,    0,    0, 4614,    0,    0, 6546,    0,    0,    0,    0,    0,    0, 9999},
		{    0,    0,    0,    0,    0, 8666,    0, 8760,    0,    0,    0,    0, 9999,    0,    0},
		{    0,    0,    0, 3124,    0,    0,    0,    0, 6249,    0, 6718,    0, 7026,    0, 9999},
		{    0,    0,    0,    0,    0,    0,    0,  156,    0,    0,    0, 9735, 9784,    0, 9999},
		{    0,    0,    0,    0,    0,    0,    0,   69,    0,    0,    0,    0, 9999,    0,    0},
		{    0,    0,    0,    0,    0,    0,    0,   72,    0, 8872,    0,    0, 9999,    0,    0},
		{    0,    0,   58,    0,    0,    0,    0,  832,    0,    0,    0, 1288, 8603,    0, 9999},
		{    0,    0,    0,    0,    0,    0,    0,  635,    0,    0,    0,    0,    0, 9135, 9999},
		{    0,    0,    0,    0,    0,    0,    0, 2657,    0,    0,    0, 9294, 9304,    0, 9999},
		{    0,    0,    0,    0,    0,    0, 2585, 9992,    0,    0,    0,    0,    0,    0, 9999}
	};
		
	public final int [][] cTransProb = new int[transProb.length][transProb.length];

	public void initialize () {
		int max, maxCol;

		for (int i = 0; i &lt; transProb.length; i++) {
			for (int j = 0; j &lt; transProb.length; j++) {
				cTransProb[i][j] = transProb[i][j];
			}
		}

		for (int i = 0; i &lt; transProb.length; i++) {
			max = cTransProb[i][0];
			maxCol = 0;
			for (int j = 1; j &lt; transProb.length; j++) {
				if (cTransProb[i][j] > max) {
					max = cTransProb[i][j];
					maxCol = j;
				}
			}
			if (max &lt; 9999) {
				cTransProb[i][maxCol] = 9999;
			}
		}
	}

	public String getHomeURL(int cID) {
		String rURL = "/TPCW_home_interaction";
		String field_cID = "C_ID";		

		if (cID != ID_UNKNOWN) {
			rURL = addField(rURL, field_cID, "" + cID);
		}

		return rURL;
	}

	public String getHomeURL(String sessionID, int cID, int shopID) {
		String rURL = "/TPCW_home_interaction";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		return rURL;
	}

	public String getAdminConfURL(String sessionID, int cID, int shopID, String imageName, String thumbnailName, String cost, int iiID) {
		String rURL = "/TPCW_admin_response_servlet";
		String field_newImage = "I_NEW_IMAGE";
		String field_newThumb = "I_NEW_THUMBNAIL";
		String field_newCost = "I_NEW_COST";
		String field_iID = "I_ID";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (imageName != null) {
			rURL = addField(rURL, field_newImage, imageName);
		}

		if (thumbnailName != null) {
			rURL = addField(rURL, field_newThumb, thumbnailName);
		}

		if (cost != null) {
			rURL = addField(rURL, field_newCost, cost);
		}

		if (iiID != ID_UNKNOWN) {
			rURL = addField(rURL, field_iID, "" + iiID);
		}	

		return rURL;
	}

	public String getAdminReqURL(String sessionID, int cID, int shopID, int iiID) {
		String rURL = "/TPCW_admin_request_servlet";
		String field_iID = "I_ID";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (iiID != ID_UNKNOWN) {
			rURL = addField(rURL, field_iID, "" + iiID);
		}	

		return rURL;
	}

	public String getBestSellURL(String sessionID, int cID, int shopID, String subject) {
		String rURL = "/TPCW_best_sellers_servlet";
		String field_subject = "subject";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (subject != null) {
			rURL = addField(rURL, field_subject, subject);
		}

		return rURL;
	}

	public String getBuyConfURL(String sessionID, int cID, int shopID, String ccType, String ccNumber, String ccName, String expDate, String street1, String street2, String city, String state, String zip, String country, String shipping) {
		String rURL = "/TPCW_buy_confirm_servlet";
		String field_cctype = "CC_TYPE";
		String field_ccnumber = "CC_NUMBER";
		String field_ccname = "CC_NAME";
		String field_ccexp = "CC_EXPIRY";
		String field_street1 = "STREET_1";
		String field_street2 = "STREET_2";
		String field_city = "CITY";
		String field_state = "STATE";
		String field_zip = "ZIP";
		String field_country = "COUNTRY";
		String field_shipping = "SHIPPING";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (ccType != null) {
			rURL = addField(rURL, field_cctype, ccType);
		}

		if (ccNumber != null) {
			rURL = addField(rURL, field_ccnumber, ccNumber);
		}

		if (ccName != null) {
			rURL = addField(rURL, field_ccname, ccName);
		}

		if (expDate != null) {
			rURL = addField(rURL, field_ccexp, expDate);
		}

		rURL = addField(rURL, field_street1, street1);
		rURL = addField(rURL, field_street2, street2);
		rURL = addField(rURL, field_city, city);
		rURL = addField(rURL, field_state, state);
		rURL = addField(rURL, field_zip, zip);
		rURL = addField(rURL, field_country, country);
			
		if (shipping != null) {
			rURL = addField(rURL, field_shipping, shipping);
		}

		return rURL;
	}

	public String getBuyReqURL(String sessionID, int cID, int shopID, String ret, String name, String password) {
		String rURL = "/TPCW_buy_request_servlet";
		String field_retFlag = "RETURNING_FLAG";
		String field_userName = "UNAME";
		String field_password = "PASSWD";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (ret != null) {
			rURL = addField(rURL, field_retFlag, ret);
		}

		if (name != null) {
			rURL = addField(rURL, field_userName, name);
		}

		if (password != null) {
			rURL = addField(rURL, field_password, password);
		}

		return rURL;
	}

	public String getBuyReqURL(String sessionID, int cID, int shopID, String ret, String firstName, String lastName, String street1, String street2, String city, String state, String zip, String country, String phone, String email, String birthDate, String data) {
		String rURL = "/TPCW_buy_request_servlet";
		String field_retFlag = "RETURNING_FLAG";
		String field_firstName = "FNAME";
		String field_lastName = "LNAME";
		String field_street1 = "STREET_1";
		String field_street2 = "STREET_2";
		String field_city = "CITY";
		String field_state = "STATE";
		String field_zip = "ZIP";
		String field_country = "COUNTRY";
		String field_phone = "PHONE";
		String field_email = "EMAIL";
		String field_birthDate = "BIRTHDATE";
		String field_data = "DATA";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (ret != null) {
			rURL = addField(rURL, field_retFlag, ret);
		}

		if (firstName != null) {
			rURL = addField(rURL, field_firstName, firstName);
		}

		if (lastName != null) {
			rURL = addField(rURL, field_lastName, lastName);
		}

		if (street1 != null) {
			rURL = addField(rURL, field_street1, street1);
		}

		if (street2 != null) {
			rURL = addField(rURL, field_street2, street2);
		}

		if (city != null) {
			rURL = addField(rURL, field_city, city);
		}

		if (state != null) {
			rURL = addField(rURL, field_state, state);
		}

		if (zip != null) {
			rURL = addField(rURL, field_zip, zip);
		}

		if (country != null) {
			rURL = addField(rURL, field_country, country);
		}

		if (phone != null) {
			rURL = addField(rURL, field_phone, phone);
		}

		if (email != null) {
			rURL = addField(rURL, field_email, email);
		}

		if (birthDate != null) {
			rURL = addField(rURL, field_birthDate, birthDate);
		}

		if (data != null) {
			rURL = addField(rURL, field_data, data);
		}

		return rURL;
	}

	public String getCustRegURL(String sessionID, int cID, int shopID) {
		String rURL = "/TPCW_customer_registration_servlet";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		return rURL;
	}

	public String getNewProdURL(String sessionID, int cID, int shopID, String subject) {
		String rURL = "/TPCW_new_products_servlet";
		String field_subject = "subject";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (subject != null) {
			rURL = addField(rURL, field_subject, subject);
		}

		return rURL;
	}

	public String getOrderDispURL(String sessionID, int cID, int shopID, String name, String password) {
		String rURL = "/TPCW_order_display_servlet";
		String field_userName = "UNAME";
		String field_password = "PASSWD";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (name != null) {
			rURL = addField(rURL, field_userName, name);
		}

		if (password != null) {
			rURL = addField(rURL, field_password, password);
		}
		return rURL;
	}

	public String getOrderInqURL(String sessionID, int cID, int shopID) {
		String rURL = "/TPCW_order_inquiry_servlet";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		return rURL;
	}

	public String getProdDetURL(String sessionID, int cID, int shopID, int iiID) {
		String rURL = "/TPCW_product_detail_servlet";
		String field_iID = "I_ID";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (iiID != ID_UNKNOWN) {
			rURL = addField(rURL, field_iID, "" + iiID);
		}	

		return rURL;
	}

	public String getSearchReqURL(String sessionID, int cID, int shopID) {
		String rURL = "/TPCW_search_request_servlet";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		return rURL;
	}

	public String getSearchResultURL(String sessionID, int cID, int shopID, String searchType, String searchString) {
		String rURL = "/TPCW_execute_search";
		String field_searchType = "search_type";
		String field_searchString = "search_string";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (searchType != null) {
			rURL = addField(rURL, field_searchType, searchType);
		}

		if (searchString != null) {
			rURL = addField(rURL, field_searchString, searchString);
		}
	
		return rURL;
	}

	public String getShopCartURL(String sessionID, int cID, int shopID, String addFlag, int iiID) {
		String rURL = "/TPCW_shopping_cart_interaction";
		String field_addFlag = "ADD_FLAG";
		String field_iID = "I_ID";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (addFlag != null) {
			rURL = addField(rURL, field_addFlag, addFlag);
		}

		if (iiID != ID_UNKNOWN) {
			rURL = addField(rURL, field_iID, "" + iiID);
		}

		return rURL;
	}

	public String getShopCartURL(String sessionID, int cID, int shopID, String addFlag, int c, int [] qty) {
		String rURL = "/TPCW_shopping_cart_interaction";
		String field_addFlag = "ADD_FLAG";
		String field_qty = "qty";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (addFlag != null) {
			rURL = addField(rURL, field_addFlag, addFlag);
		}

		for (int i = 0; i &lt; c; i++) {
			rURL = addField(rURL, field_qty, "" + qty[i]);
		}

		return rURL;
	}

	public String getShopCartURL(String sessionID, int cID, int shopID, String addFlag) {
		String rURL = "/TPCW_shopping_cart_interaction";
		String field_addFlag = "ADD_FLAG";

		rURL = addIDs(rURL, sessionID, cID, shopID);

		if (addFlag != null) {
			rURL = addField(rURL, field_addFlag, addFlag);
		}

		return rURL;
	}	

	private String addField(String i, String f, String v) {
		if (i.indexOf((int) '?')==-1) {
			i = i + '?';
		}else {
			i = i + '&amp;';
		}
		i = i + f + "=" + v;

		return(i);
	}

	private String addSession(String i, String f, String v){
		StringTokenizer tok = new StringTokenizer(i, "?");
		String return_val = null;
		try {
			return_val = tok.nextToken();
			return_val = return_val + f + v;
			return_val = return_val + "?" + tok.nextToken();
		} catch (NoSuchElementException e) { 
		}

		return(return_val);
	}

	private String addIDs(String i, String sessionID, int cID, int shopID) {

		if (sessionID != null) {
			i = addSession(i, ";jsessionid=", ""+sessionID);
		}
    
		if (cID != ID_UNKNOWN) {
			i = addField(i,"C_ID", "" + cID);
		}

		if (shopID != ID_UNKNOWN) {
			i = addField(i,"SHOPPING_ID", ""+shopID);
		}

		return(i);
	}

}
</content><xsl:text>
  </xsl:text></file>
</filledTemplate>

</xsl:template>

</xsl:stylesheet>