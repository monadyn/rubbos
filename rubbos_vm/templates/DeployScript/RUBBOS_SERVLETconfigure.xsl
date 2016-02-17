<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and  @actype='rubbosSL_configure' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and  @actype='rubbosSL_configure' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='app_server' and  @actype='rubbosSL_configure' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/RUBBOS_SERVLETconfigure.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  CONFIGURING RUBBOS SERVLET on $HOSTNAME"

\cp $OUTPUT_HOME/rubbos_conf/build.properties $RUBBOS_HOME/

\rm -rf $RUBBOS_HOME/Servlets
\cp -r $WORK_HOME/rubbos_files/Servlets $RUBBOS_HOME/
#\mv $RUBBOS_HOME/Servlets $RUBBOS_HOME/Servlets



\cp $SOFTWARE_HOME/<xsl:value-of select="//params/env/param[@name='MYSQL_CONNECTOR']/@value"/> $RUBBOS_HOME/Servlets/
\cp $OUTPUT_HOME/rubbos_conf/mysql.properties $RUBBOS_HOME/Servlets/
\cp $OUTPUT_HOME/rubbos_conf/build.xml $RUBBOS_HOME/Servlets/
\cp $OUTPUT_HOME/rubbos_conf/Config.java <xsl:value-of select="//params/env/param[@name='RUBBOS_HOME']/@value"/>/Servlets/edu/rice/rubbos/servlets/
\cp $OUTPUT_HOME/rubbos_conf/web.xml $RUBBOS_HOME/Servlet_HTML/WEB-INF/

cp $OUTPUT_HOME/rubbos_conf/TOMCAT_log4j.properties $RUBBOS_HOME/Servlet_HTML/WEB-INF/log4j.properties

<xsl:if test="//params/logging/param[@name='tomcatResponseTime' and @value='true']/sampling">
cd $RUBBOS_HOME/Servlets/edu/rice/rubbos/servlets
sed 's/private final int SAMPLING_RATIO = 10;/private final int SAMPLING_RATIO = <xsl:value-of select="//params/logging/param[@name='tomcatResponseTime' and @value='true']/sampling/@ratio"/>;/g' ReqListener.java > ReqListener.java.tmp
mv ReqListener.java.tmp ReqListener.java
</xsl:if>

<xsl:if test="//params/rubbos-conf/param[@name='connectionPoolSize']">
cd $RUBBOS_HOME/Servlets/edu/rice/rubbos/servlets
sed 's/public static final int    BrowseCategoriesPoolSize      = 6;/public static final int    BrowseCategoriesPoolSize      = <xsl:value-of select="//params/rubbos-conf/param[@name='connectionPoolSize']/@value"/>;/g' Config.java > Config.java.tmp
mv Config.java.tmp Config.java
</xsl:if>

cd $RUBBOS_HOME/Servlets
ant clean
ant dist
make
rm -rf $CATALINA_HOME/webapps/rubbos*
cp rubbos.war $CATALINA_HOME/webapps/

echo "  DONE CONFIGURING RUBBOS SERVLET on $HOSTNAME"

<xsl:if test="//params/logging/param[@name='tomcatResponseTime']/@value='true'">
<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>TOMCAT_log4j.properties<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/rubbos_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>

log4j.rootCategory=DEBUG, dest1
log4j.appender.dest1=org.apache.log4j.RollingFileAppender
log4j.appender.dest1.file=<xsl:value-of select="//params/env/param[@name='CATALINA_HOME']/@value"/>/logs/servlets.log
log4j.appender.dest1.MaxFileSize=500MB
log4j.appender.dest1.layout=org.apache.log4j.PatternLayout
log4j.appender.dest1.layout.ConversionPattern=%d{ABSOLUTE} %c{1} %m\n

</content>
</file>
</xsl:if>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>mysql.properties<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/rubbos_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
###################### PostgreSQL DataSource configuration example
#


#####
#  DataSource configuration
#
datasource.name         mysql
<xsl:choose>
  <xsl:when test="//instances/instance[@type='cjdbc_server']">
datasource.url          jdbc:cjdbc://<xsl:value-of select="//instances/instance[@type='cjdbc_server']/target"/>:<xsl:value-of select="//params/env/param[@name='CJDBC_PORT']/@value"/>/rubbos
datasource.classname    org.objectweb.cjdbc.driver.Driver
  </xsl:when>
  <xsl:when test="//instances/instance[@type='sequoia_server']">
datasource.url          jdbc:sequoia://<xsl:value-of select="//instances/instance[@type='sequoia_server']/target"/>:<xsl:value-of select="//params/env/param[@name='SEQUOIA_PORT']/@value"/>/rubbos
datasource.classname    org.continuent.sequoia.driver.Driver
  </xsl:when>
  <xsl:when test="//instances/instance[@type='db_server' and swname='postgres']">
datasource.url          jdbc:postgresql://<xsl:value-of select="//instances/instance[@type='db_server']/target"/>:5432/rubbos
datasource.classname    org.postgresql.Driver
  </xsl:when>
  <xsl:otherwise>
datasource.url          jdbc:mysql://<xsl:value-of select="//instances/instance[@type='db_server']/target"/>:<xsl:value-of select="//params/env/param[@name='MYSQL_PORT']/@value"/>/rubbos
datasource.classname    com.mysql.jdbc.Driver
  </xsl:otherwise>
</xsl:choose>
datasource.username     elba
datasource.password     elba


#####
#  ConnectionManager configuration
#

#  JDBC connection checking level.
#     0 = no special checking
#     1 = check physical connection is still open before reusing it
#     2 = try every connection before reusing it
jdbc.connchecklevel     1

#  Max age for jdbc connections
#     nb of minutes a connection can be kept in the pool
jdbc.connmaxage         30

#  Max concurrent threads on same tx/connection
#  (not used with a customized jdbc datasource)
jdbc.connmaxthreads     4

#  Max wait time if more than connmaxthreads threads request conn
#     value is in seconds
#  (not used with a customized jdbc datasource)
jdbc.connexcltimeout    30

#  Test statement
jdbc.connteststmt       select 1


######
#  Customizing JDBC DataSource configuration
#

#  Name of the class implementing the XADataSource
#datasource.factory     org.objectweb.jonas.dbm.JonasStandardXADataSource

#  JNDI name use to bind the XADataSource
#datasource.xadataname  postgre1_xa

#  Minimum number of physical connection used by  the XADataSource
#datasource.mincon      5

#  Maximum number of physical connection used by the XADataSource
#datasource.maxcon      10

#  Minimum number of XAConnection used by the pool
#jdbc.minconpool        10

#  Maximum number of XAConnection used by the pool
#jdbc.maxconpool        20

#  Time between two clean-up of old unused connection
#  (value is in millisecond)
#jdbc.sleeptimepool     300000

#  Force the gc to be launched when cleaning up
#jdbc.gcpool            false

#  In case of no connection in the pool,
#  deadlockpool is the global time to re-try before throwing an exception
#  (value is in millisecond)
#jdbc.deadlockpool      300000

#  In case of no connection in the pool,
#  loopwaitpool is the unit time to re-try
#  (value is in millisecond)
#jdbc.loopwaitpool      10000

</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>build.xml<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/rubbos_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>

&lt;project name="RUBBoS Servlets" default="dist" basedir="."&gt;
  &lt;!-- RUBBoS Servlets Ant build file --&gt;

  &lt;!-- set global properties for this build --&gt;
  &lt;property file="../build.properties" /&gt;
  &lt;property name="servlets.html" value="../Servlet_HTML" /&gt;
  
&lt;!-- ====================================================================== --&gt;
&lt;!-- Init --&gt;
&lt;!-- ====================================================================== --&gt;

  &lt;!-- init rule creates build directory --&gt;
  &lt;target name="init"&gt;
    &lt;!-- Create the time stamp --&gt;
    &lt;tstamp/&gt;
    &lt;!-- Create the build directory structure used by compile --&gt;
    &lt;mkdir dir="${classes.dir}"/&gt;
  &lt;/target&gt;
  
&lt;!-- ====================================================================== --&gt;
&lt;!-- Servlets --&gt;
&lt;!-- ====================================================================== --&gt;
  
   &lt;!-- The classpath to be used to compile  --&gt;
  &lt;path id="base.classpath"&gt;
    &lt;pathelement location="${classes.dir}" /&gt;
    &lt;fileset dir="${j2ee}/lib"&gt;
      &lt;include name="j2ee.jar"/&gt;
    &lt;/fileset&gt;
  &lt;/path&gt;

  &lt;!-- Creates a jar file containing the servlets --&gt;
  &lt;target name="jar" depends="init, compile"&gt;
     &lt;jar destfile="${dist}/rubbos_servlets.jar"&gt;
        &lt;fileset dir="${classes.dir}"
                 includes="edu/rice/rubbos/servlets/*.class"/&gt;
    &lt;/jar&gt;
  &lt;/target&gt;

  &lt;!-- Create a war file--&gt;
  &lt;target name="war" depends="init, compile, jar"&gt;
    &lt;copy file="${dist}/rubbos_servlets.jar" todir="${servlets.html}/WEB-INF/lib"/&gt;
    &lt;copy file="${j2ee}/lib/j2ee.jar" todir="${servlets.html}/WEB-INF/lib"/&gt;
<xsl:choose>
  <xsl:when test="//instances/instance[@type='cjdbc_server']">
    &lt;copy file="${cjdbc_driver}" todir="${servlets.html}/WEB-INF/lib"/&gt;
    &lt;copy file="${cjdbc_controller}" todir="${servlets.html}/WEB-INF/lib"/&gt;
  </xsl:when>
  <xsl:when test="//instances/instance[@type='sequoia_server']">
    &lt;copy file="${sequoia_driver}" todir="${servlets.html}/WEB-INF/lib"/&gt;
  </xsl:when>
  <xsl:when test="//instances/instance[@type='db_server' and swname='postgres']">
    &lt;copy file="${postgres_connector}" todir="${servlets.html}/WEB-INF/lib"/&gt;
  </xsl:when>
  <xsl:otherwise>
    &lt;copy file="${mysql_connector}" todir="${servlets.html}/WEB-INF/lib"/&gt;
  </xsl:otherwise>
</xsl:choose>
     &lt;war destfile="${dist}/rubbos.war" webxml="${servlets.html}/WEB-INF/web.xml" basedir="${web.dir}"&gt;
        &lt;fileset dir="${classes.dir}"
                 includes="*" excludes="**/web.xml" /&gt;
    &lt;/war&gt;
  &lt;/target&gt;
  
    &lt;!-- Dist rule --&gt;
  &lt;target name="dist" depends="init, compile, jar, war"&gt;
  &lt;/target&gt;
  
  &lt;!-- compile rule: Compile the beans and the servlets --&gt;
  &lt;target name="compile" depends="init"&gt;
    &lt;javac srcdir="${src}"
           includes="edu/rice/rubbos/servlets/*"
           destdir="${classes.dir}"
           classpath="${build.classpath}"
           depend="yes"
           deprecation="yes"&gt;
    &lt;classpath refid="base.classpath" /&gt;
    &lt;/javac&gt;
  &lt;/target&gt;

&lt;!-- ====================================================================== --&gt;
&lt;!-- Javadoc --&gt;
&lt;!-- ====================================================================== --&gt;

  &lt;!-- Generate Javadoc documentation --&gt;
  &lt;target name="doc"&gt;
     &lt;mkdir dir="docs/api"/&gt;
     &lt;javadoc classpathref="base.classpath"
           packagenames="edu.rice.rubbos.*.*"
           sourcepath="."
           defaultexcludes="yes"
           destdir="docs/api"
           author="true"
           version="true"
           use="true"
           windowtitle="RUBBoS API"&gt;
       &lt;doctitle&gt;&lt;![CDATA[&lt;h1&gt;RUBBoS API&lt;/h1&gt;]]&gt;&lt;/doctitle&gt;
       &lt;bottom&gt;&lt;![CDATA[&lt;i&gt;Copyright &amp;#169; 2004 - ObjectWeb Consortium - All Rights Reserved.&lt;/i&gt;]]&gt;&lt;/bottom&gt;
     &lt;/javadoc&gt;
  &lt;/target&gt;
  
&lt;!-- ====================================================================== --&gt;
&lt;!-- Clean --&gt;
&lt;!-- ====================================================================== --&gt;

  &lt;target name="clean"&gt;
    &lt;!-- Delete the ${classes.dir} and ${dist} directory trees --&gt;
    &lt;delete dir="${classes.dir}"/&gt;
    &lt;delete&gt;
      &lt;fileset dir="${dist}" includes="rubbos_servlets.jar"/&gt;
    &lt;/delete&gt;
    &lt;delete&gt;
      &lt;fileset dir="${dist}" includes="rubbos.war"/&gt;
    &lt;/delete&gt;
    &lt;delete&gt;
      &lt;fileset dir="edu" includes="**/*.class"/&gt;
    &lt;/delete&gt;
  &lt;/target&gt;
  
  &lt;target name="clean-doc"&gt;
    &lt;delete dir="docs/api"/&gt;
  &lt;/target&gt;
&lt;/project&gt;

</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>Config.java<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/rubbos_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
/**
 * RUBBoS: Rice University Bulletin Board System.
 * Copyright (C) 2001-2004 Rice University and French National Institute For 
 * Research In Computer Science And Control (INRIA).
 * Contact: jmob@objectweb.org
 * 
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by the
 * Free Software Foundation; either version 2.1 of the License, or any later
 * version.
 * 
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
 * for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation,
 * Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
 *
 * Initial developer(s): Emmanuel Cecchet.
 * Contributor(s): ______________________.
 */

package edu.rice.rubbos.servlets;

/**
 * This class contains the configuration for the servlets like the path of HTML
 * files, etc ...
 * 
 * @author &lt;a href="mailto:cecchet@rice.edu"&gt;Emmanuel Cecchet &lt;/a&gt; and &lt;a
 *         href="mailto:julie.marguerite@inrialpes.fr"&gt;Julie Marguerite &lt;/a&gt;
 * @version 1.0
 */

public class Config
{

  /**
   * Creates a new &lt;code&gt;Config&lt;/code&gt; instance.
   */
  Config()
  {
  }


  public static final String HTMLFilesPath                 = "<xsl:value-of select="//params/env/param[@name='RUBBOS_HOME']/@value"/>/Servlet_HTML";
  //public static final String[] DatabaseProperties          = {"<xsl:value-of select="//params/env/param[@name='RUBBOS_HOME']/@value"/>/Servlets/mysql.properties"};
  public static final String DatabaseProperties          = "<xsl:value-of select="//params/env/param[@name='RUBBOS_HOME']/@value"/>/Servlets/mysql.properties";
  public static final int DatabasePropertiesSize = 1;

  public static final int    AboutMePoolSize               = 10;
  public static final int    BrowseCategoriesPoolSize      = 6;
  public static final int    BrowseRegionsPoolSize         = 6;
  public static final int    BuyNowPoolSize                = 4;
  public static final int    PutBidPoolSize                = 8;
  public static final int    PutCommentPoolSize            = 2;
  public static final int    RegisterItemPoolSize          = 2;
  public static final int    RegisterUserPoolSize          = 2;
  public static final int    SearchItemsByCategoryPoolSize = 15;
  public static final int    SearchItemsByRegionPoolSize   = 20;
  public static final int    StoreBidPoolSize              = 8;
  public static final int    StoreBuyNowPoolSize           = 4;
  public static final int    StoreCommentPoolSize          = 2;
  public static final int    ViewBidHistoryPoolSize        = 4;
  public static final int    ViewItemPoolSize              = 20;
  public static final int    ViewUserInfoPoolSize          = 4;
}
</content>
</file>


<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>web.xml<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/rubbos_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>&lt;?xml version="1.0" encoding="ISO-8859-1"?&gt;

&lt;!--
&lt;!DOCTYPE web-app PUBLIC '-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN' 'http://java.sun.com/dtd/web-app_2_3.dtd'&gt;
--&gt;
&lt;!DOCTYPE web-app PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.2//EN" "http://java.sun.com/j2ee/dtds/web-app_2_2.dtd"&gt;

&lt;web-app&gt;

    &lt;display-name&gt;RUBBos&lt;/display-name&gt;
	&lt;description&gt;
	Rice University Bulletin Board System
	&lt;/description&gt;

<xsl:if test="//params/logging/param[@name='tomcatResponseTime']/@value='true'">
    &lt;listener&gt;
      &lt;listener-class&gt;edu.rice.rubbos.servlets.ReqListener&lt;/listener-class&gt;
    &lt;/listener&gt;

    &lt;!-- ChienAn --&gt;
    &lt;servlet&gt;
      &lt;servlet-name&gt;log4jinit&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.Log4jInit&lt;/servlet-class&gt;
      &lt;init-param&gt;
        &lt;param-name&gt;log4j-init-file&lt;/param-name&gt;
        &lt;param-value&gt;/WEB-INF/log4j.properties&lt;/param-value&gt;
      &lt;/init-param&gt;
      &lt;load-on-startup&gt;1&lt;/load-on-startup&gt;
    &lt;/servlet&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;log4jinit&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/log4jinit&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

</xsl:if>
    &lt;servlet&gt;
      &lt;servlet-name&gt;BrowseCategories&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.BrowseCategories&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;BrowseStoriesByCategory&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.BrowseStoriesByCategory&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;ViewComment&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.ViewComment&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;ModerateComment&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.ModerateComment&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;PostComment&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.PostComment&lt;/servlet-class&gt;
    &lt;/servlet&gt;

   &lt;servlet&gt;
      &lt;servlet-name&gt;StoreComment&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.StoreComment&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;SubmitStory&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.SubmitStory&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;AcceptStory&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.AcceptStory&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;RejectStory&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.RejectStory&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;ReviewStories&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.ReviewStories&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;StoreStory&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.StoreStory&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;ViewStory&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.ViewStory&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;StoriesOfTheDay&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.StoriesOfTheDay&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;Search&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.Search&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;StoreModeratorLog&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.StoreModeratorLog&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;RegisterUser&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.RegisterUser&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;Author&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.Author&lt;/servlet-class&gt;
    &lt;/servlet&gt;

    &lt;servlet&gt;
      &lt;servlet-name&gt;OlderStories&lt;/servlet-name&gt;
      &lt;servlet-class&gt;edu.rice.rubbos.servlets.OlderStories&lt;/servlet-class&gt;
    &lt;/servlet&gt;

 
    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;BrowseCategories&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.BrowseCategories&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;BrowseStoriesByCategory&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.BrowseStoriesByCategory&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;ViewComment&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.ViewComment&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;ModerateComment&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.ModerateComment&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;PostComment&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.PostComment&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;StoreComment&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.StoreComment&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;SubmitStory&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.SubmitStory&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;AcceptStory&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.AcceptStory&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;RejectStory&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.RejectStory&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;ReviewStories&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.ReviewStories&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;StoreStory&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.StoreStory&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;ViewStory&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.ViewStory&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;StoriesOfTheDay&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.StoriesOfTheDay&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;


    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;Search&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.Search&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
      &lt;servlet-name&gt;StoreModeratorLog&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.StoreModeratorLog&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
       &lt;servlet-name&gt;RegisterUser&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.RegisterUser&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
       &lt;servlet-name&gt;Author&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.Author&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;

    &lt;servlet-mapping&gt;
       &lt;servlet-name&gt;OlderStories&lt;/servlet-name&gt;
      &lt;url-pattern&gt;/servlet/edu.rice.rubbos.servlets.OlderStories&lt;/url-pattern&gt;
    &lt;/servlet-mapping&gt;


    &lt;session-config&gt;
      &lt;session-timeout&gt;30&lt;/session-timeout&gt;    &lt;!-- 30 minutes --&gt;
    &lt;/session-config&gt;

&lt;/web-app&gt;
</content>
</file>


</xsl:template>

</xsl:stylesheet>





