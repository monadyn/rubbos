<?xml version="1.0" ?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:output method="xml" indent="yes"/>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='configure' and @type='current']"></xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='configure' and @type='pre-action']"></xsl:template>

<xsl:template match="//argshere[@idtype='web_server' and @actype='configure' and @type='post-action']"></xsl:template>


<xsl:template match="//pastehere[@id='../templates/DeployScript/WEBconfigure.xsl']">
#!/bin/bash

cd <xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>
source set_elba_env.sh

echo "  CONFIGURING APACHE on $HOSTNAME"

cp $OUTPUT_HOME/apache_conf/httpd.conf $HTTPD_HOME/conf/
cp $OUTPUT_HOME/apache_conf/workers.properties $HTTPD_HOME/conf/
cp -r $WORK_HOME/apache_files/rubbos_html $HTTPD_HOME/htdocs/rubbos

#cp -r $WORK_HOME/apache_files/rubbos_html $HTTPD_HOME/htdocs/rubbos
unzip -o /mnt/softwares/Servlet_HTML.zip -d $HTTPD_HOME/htdocs/rubbos
mkdir $HTTPD_HOME/htdocs/opentaps_images
cp $OUTPUT_HOME/apache_conf/opentaps_logo.png $HTTPD_HOME/htdocs/opentaps_images/
cp $OUTPUT_HOME/apache_conf/RUBBoS_logo.jpg $HTTPD_HOME/htdocs/opentaps_images/

echo "  APACHE CONFIGURED SUCCESSFULLY on $HOSTNAME"

<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>httpd.conf<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/apache_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
#
# Based upon the NCSA server configuration files originally by Rob McCool.
#
# This is the main Apache server configuration file.  It contains the
# configuration directives that give the server its instructions.
# See &lt;URL:http://httpd.apache.org/docs-2.0/&gt; for detailed information about
# the directives.
#
# Do NOT simply read the instructions in here without understanding
# what they do.  They're here only as hints or reminders.  If you are unsure
# consult the online docs. You have been warned.  
#
# The configuration directives are grouped into three basic sections:
#  1. Directives that control the operation of the Apache server process as a
#     whole (the 'global environment').
#  2. Directives that define the parameters of the 'main' or 'default' server,
#     which responds to requests that aren't handled by a virtual host.
#     These directives also provide default values for the settings
#     of all virtual hosts.
#  3. Settings for virtual hosts, which allow Web requests to be sent to
#     different IP addresses or hostnames and have them handled by the
#     same Apache server process.
#
# Configuration and logfile names: If the filenames you specify for many
# of the server's control files begin with "/" (or "drive:/" for Win32), the
# server will use that explicit path.  If the filenames do *not* begin
# with "/", the value of ServerRoot is prepended -- so "logs/foo.log"
# with ServerRoot set to "/mnt/elba/rubbos/apache2" will be interpreted by the
# server as "/mnt/elba/rubbos/apache2/logs/foo.log".
#

### Section 1: Global Environment
#
# The directives in this section affect the overall operation of Apache,
# such as the number of concurrent requests it can handle or where it
# can find its configuration files.
#

#
# ServerRoot: The top of the directory tree under which the server's
# configuration, error, and log files are kept.
#
# NOTE!  If you intend to place this on an NFS (or otherwise network)
# mounted filesystem then please read the LockFile documentation (available
# at &lt;URL:http://httpd.apache.org/docs-2.0/mod/mpm_common.html#lockfile&gt;);
# you will save yourself a lot of trouble.
#
# Do NOT add a slash at the end of the directory path.
#
ServerRoot "<xsl:value-of select="//instances/params/env/param[@name='HTTPD_HOME']/@value"/>"

#
# The accept serialization lock file MUST BE STORED ON A LOCAL DISK.
#
&lt;IfModule !mpm_winnt.c&gt;
&lt;IfModule !mpm_netware.c&gt;
#LockFile logs/accept.lock
&lt;/IfModule&gt;
&lt;/IfModule&gt;

#
# ScoreBoardFile: File used to store internal server process information.
# If unspecified (the default), the scoreboard will be stored in an
# anonymous shared memory segment, and will be unavailable to third-party
# applications.
# If specified, ensure that no two invocations of Apache share the same
# scoreboard file. The scoreboard file MUST BE STORED ON A LOCAL DISK.
#
&lt;IfModule !mpm_netware.c&gt;
&lt;IfModule !perchild.c&gt;
#ScoreBoardFile logs/apache_runtime_status
&lt;/IfModule&gt;
&lt;/IfModule&gt;


#
# PidFile: The file in which the server should record its process
# identification number when it starts.
#
&lt;IfModule !mpm_netware.c&gt;
PidFile logs/httpd.pid
&lt;/IfModule&gt;

#
# Timeout: The number of seconds before receives and sends time out.
#
Timeout <xsl:value-of select="//instances/params/apache-conf/param[@name='Timeout']/@value"/>

#
# KeepAlive: Whether or not to allow persistent connections (more than
# one request per connection). Set to "Off" to deactivate.
#
#KeepAlive On
KeepAlive <xsl:value-of select="//instances/params/apache-conf/param[@name='KeepAlive']/@value"/>

#
# MaxKeepAliveRequests: The maximum number of requests to allow
# during a persistent connection. Set to 0 to allow an unlimited amount.
# We recommend you leave this number high, for maximum performance.
#
MaxKeepAliveRequests <xsl:value-of select="//instances/params/apache-conf/param[@name='MaxKeepAliveRequests']/@value"/>

#
# KeepAliveTimeout: Number of seconds to wait for the next request from the
# same client on the same connection.
#
KeepAliveTimeout 15

##
## Server-Pool Size Regulation (MPM specific)
## 

# prefork MPM
# StartServers: number of server processes to start
# MinSpareServers: minimum number of server processes which are kept spare
# MaxSpareServers: maximum number of server processes which are kept spare
# MaxClients: maximum number of server processes allowed to start
# MaxRequestsPerChild: maximum number of requests a server process serves
&lt;IfModule prefork.c&gt;
StartServers         5
MinSpareServers      5
MaxSpareServers     10
ServerLimit       4000
MaxClients        4000
MaxRequestsPerChild  0
&lt;/IfModule&gt;

# worker MPM
# StartServers: initial number of server processes to start
# MaxClients: maximum number of simultaneous client connections
# MinSpareThreads: minimum number of worker threads which are kept spare
# MaxSpareThreads: maximum number of worker threads which are kept spare
# ThreadsPerChild: constant number of worker threads in each server process
# MaxRequestsPerChild: maximum number of requests a server process serves
&lt;IfModule worker.c&gt;
ServerLimit         <xsl:value-of select="//instances/params/apache-conf/param[@name='ServerLimit']/@value"/>
ThreadLimit         <xsl:value-of select="//instances/params/apache-conf/param[@name='ThreadLimit']/@value"/>
StartServers        <xsl:value-of select="//instances/params/apache-conf/param[@name='StartServers']/@value"/>
MaxClients          <xsl:value-of select="//instances/params/apache-conf/param[@name='MaxClients']/@value"/>
MinSpareThreads     <xsl:value-of select="//instances/params/apache-conf/param[@name='MinSpareThreads']/@value"/>
MaxSpareThreads     <xsl:value-of select="//instances/params/apache-conf/param[@name='MaxSpareThreads']/@value"/>
ThreadsPerChild     <xsl:value-of select="//instances/params/apache-conf/param[@name='ThreadsPerChild']/@value"/>
MaxRequestsPerChild <xsl:value-of select="//instances/params/apache-conf/param[@name='MaxRequestsPerChild']/@value"/>
&lt;/IfModule&gt;

# perchild MPM
# NumServers: constant number of server processes
# StartThreads: initial number of worker threads in each server process
# MinSpareThreads: minimum number of worker threads which are kept spare
# MaxSpareThreads: maximum number of worker threads which are kept spare
# MaxThreadsPerChild: maximum number of worker threads in each server process
# MaxRequestsPerChild: maximum number of connections per server process
&lt;IfModule perchild.c&gt;
NumServers           5
StartThreads         5
MinSpareThreads      5
MaxSpareThreads     10
MaxThreadsPerChild  20
MaxRequestsPerChild  0
&lt;/IfModule&gt;

# WinNT MPM
# ThreadsPerChild: constant number of worker threads in the server process
# MaxRequestsPerChild: maximum  number of requests a server process serves
&lt;IfModule mpm_winnt.c&gt;
ThreadsPerChild 250
MaxRequestsPerChild  0
&lt;/IfModule&gt;

# BeOS MPM
# StartThreads: how many threads do we initially spawn?
# MaxClients:   max number of threads we can have (1 thread == 1 client)
# MaxRequestsPerThread: maximum number of requests each thread will process
&lt;IfModule beos.c&gt;
StartThreads               10
MaxClients                 50
MaxRequestsPerThread       10000
&lt;/IfModule&gt;    

# NetWare MPM
# ThreadStackSize: Stack size allocated for each worker thread
# StartThreads: Number of worker threads launched at server startup
# MinSpareThreads: Minimum number of idle threads, to handle request spikes
# MaxSpareThreads: Maximum number of idle threads
# MaxThreads: Maximum number of worker threads alive at the same time
# MaxRequestsPerChild: Maximum  number of requests a thread serves. It is 
#                      recommended that the default value of 0 be set for this
#                      directive on NetWare.  This will allow the thread to 
#                      continue to service requests indefinitely.                          
&lt;IfModule mpm_netware.c&gt;
ThreadStackSize      65536
StartThreads           250
MinSpareThreads         25
MaxSpareThreads        250
MaxThreads            1000
MaxRequestsPerChild      0
MaxMemFree             100
&lt;/IfModule&gt;

# OS/2 MPM
# StartServers: Number of server processes to maintain
# MinSpareThreads: Minimum number of idle threads per process, 
#                  to handle request spikes
# MaxSpareThreads: Maximum number of idle threads per process
# MaxRequestsPerChild: Maximum number of connections per server process
&lt;IfModule mpmt_os2.c&gt;
StartServers           2
MinSpareThreads        5
MaxSpareThreads       10
MaxRequestsPerChild    0
&lt;/IfModule&gt;

#
# Listen: Allows you to bind Apache to specific IP addresses and/or
# ports, instead of the default. See also the &lt;VirtualHost&gt;
# directive.
#
# Change this to Listen on specific IP addresses as shown below to 
# prevent Apache from glomming onto all bound IP addresses (0.0.0.0)
#
#Listen 12.34.56.78:80

Listen 8000

#
# Dynamic Shared Object (DSO) Support
#
# To be able to use the functionality of a module which was built as a DSO you
# have to place corresponding `LoadModule' lines at this location so the
# directives contained in it are actually available _before_ they are used.
# Statically compiled modules (those listed by `httpd -l') do not need
# to be loaded here.
#
# Example:
# LoadModule foo_module modules/mod_foo.so
#

#
# ExtendedStatus controls whether Apache will generate "full" status
# information (ExtendedStatus On) or just basic information (ExtendedStatus
# Off) when the "server-status" handler is called. The default is Off.
#
#ExtendedStatus On

### Section 2: 'Main' server configuration
#
# The directives in this section set up the values used by the 'main'
# server, which responds to any requests that aren't handled by a
# &lt;VirtualHost&gt; definition.  These values also provide defaults for
# any &lt;VirtualHost&gt; containers you may define later in the file.
#
# All of these directives may appear inside &lt;VirtualHost&gt; containers,
# in which case these default settings will be overridden for the
# virtual host being defined.
#

&lt;IfModule !mpm_winnt.c&gt;
&lt;IfModule !mpm_netware.c&gt;
#
# If you wish httpd to run as a different user or group, you must run
# httpd as root initially and it will switch.  
#
# User/Group: The name (or #number) of the user/group to run httpd as.
#  . On SCO (ODT 3) use "User nouser" and "Group nogroup".
#  . On HPUX you may not be able to use shared memory as nobody, and the
#    suggested workaround is to create a user www and use that user.
#  NOTE that some kernels refuse to setgid(Group) or semctl(IPC_SET)
#  when the value of (unsigned)Group is above 60000; 
#  don't use Group #-1 on these systems!
#
User nobody
Group #-1
&lt;/IfModule&gt;
&lt;/IfModule&gt;

#
# ServerAdmin: Your address, where problems with the server should be
# e-mailed.  This address appears on some server-generated pages, such
# as error documents.  e.g. admin@your-domain.com
#
ServerAdmin you@example.com

#
# ServerName gives the name and port that the server uses to identify itself.
# This can often be determined automatically, but we recommend you specify
# it explicitly to prevent problems during startup.
#
# If this is not set to valid DNS name for your host, server-generated
# redirections will not work.  See also the UseCanonicalName directive.
#
# If your host doesn't have a registered DNS name, enter its IP address here.
# You will have to access it by its address anyway, and this will make 
# redirections work in a sensible way.
#
#ServerName www.example.com:80

#
# UseCanonicalName: Determines how Apache constructs self-referencing 
# URLs and the SERVER_NAME and SERVER_PORT variables.
# When set "Off", Apache will use the Hostname and Port supplied
# by the client.  When set "On", Apache will use the value of the
# ServerName directive.
#
UseCanonicalName Off

#
# DocumentRoot: The directory out of which you will serve your
# documents. By default, all requests are taken from this directory, but
# symbolic links and aliases may be used to point to other locations.
#
DocumentRoot "<xsl:value-of select="//instances/params/env/param[@name='HTTPD_HOME']/@value"/>/htdocs"

#
# Each directory to which Apache has access can be configured with respect
# to which services and features are allowed and/or disabled in that
# directory (and its subdirectories). 
#
# First, we configure the "default" to be a very restrictive set of 
# features.  
#
&lt;Directory /&gt;
    Options FollowSymLinks
    AllowOverride None
&lt;/Directory&gt;

#
# Note that from this point forward you must specifically allow
# particular features to be enabled - so if something's not working as
# you might expect, make sure that you have specifically enabled it
# below.
#

#
# This should be changed to whatever you set DocumentRoot to.
#
&lt;Directory "<xsl:value-of select="//instances/params/env/param[@name='HTTPD_HOME']/@value"/>/htdocs"&gt;

#
# Possible values for the Options directive are "None", "All",
# or any combination of:
#   Indexes Includes FollowSymLinks SymLinksifOwnerMatch ExecCGI MultiViews
#
# Note that "MultiViews" must be named *explicitly* --- "Options All"
# doesn't give it to you.
#
# The Options directive is both complicated and important.  Please see
# http://httpd.apache.org/docs-2.0/mod/core.html#options
# for more information.
#
    Options Indexes FollowSymLinks

#
# AllowOverride controls what directives may be placed in .htaccess files.
# It can be "All", "None", or any combination of the keywords:
#   Options FileInfo AuthConfig Limit
#
    AllowOverride None

#
# Controls who can get stuff from this server.
#
    Order allow,deny
    Allow from all

&lt;/Directory&gt;

#
# UserDir: The name of the directory that is appended onto a user's home
# directory if a ~user request is received.
#
UserDir public_html

#
# Control access to UserDir directories.  The following is an example
# for a site where these directories are restricted to read-only.
#
#&lt;Directory /home/*/public_html&gt;
#    AllowOverride FileInfo AuthConfig Limit Indexes
#    Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
#    &lt;Limit GET POST OPTIONS PROPFIND&gt;
#        Order allow,deny
#        Allow from all
#    &lt;/Limit&gt;
#    &lt;LimitExcept GET POST OPTIONS PROPFIND&gt;
#        Order deny,allow
#        Deny from all
#    &lt;/LimitExcept&gt;
#&lt;/Directory&gt;

#
# DirectoryIndex: sets the file that Apache will serve if a directory
# is requested.
#
# The index.html.var file (a type-map) is used to deliver content-
# negotiated documents.  The MultiViews Option can be used for the 
# same purpose, but it is much slower.
#
DirectoryIndex index.html index.html.var

#
# AccessFileName: The name of the file to look for in each directory
# for additional configuration directives.  See also the AllowOverride 
# directive.
#
AccessFileName .htaccess

#
# The following lines prevent .htaccess and .htpasswd files from being 
# viewed by Web clients. 
#
&lt;Files ~ "^\.ht"&gt;
    Order allow,deny
    Deny from all
&lt;/Files&gt;

#
# TypesConfig describes where the mime.types file (or equivalent) is
# to be found.
#
TypesConfig conf/mime.types

#
# DefaultType is the default MIME type the server will use for a document
# if it cannot otherwise determine one, such as from filename extensions.
# If your server contains mostly text or HTML documents, "text/plain" is
# a good value.  If most of your content is binary, such as applications
# or images, you may want to use "application/octet-stream" instead to
# keep browsers from trying to display binary files as though they are
# text.
#
DefaultType text/plain

#
# The mod_mime_magic module allows the server to use various hints from the
# contents of the file itself to determine its type.  The MIMEMagicFile
# directive tells the module where the hint definitions are located.
#
&lt;IfModule mod_mime_magic.c&gt;
    MIMEMagicFile conf/magic
&lt;/IfModule&gt;

#
# HostnameLookups: Log the names of clients or just their IP addresses
# e.g., www.apache.org (on) or 204.62.129.132 (off).
# The default is off because it'd be overall better for the net if people
# had to knowingly turn this feature on, since enabling it means that
# each client request will result in AT LEAST one lookup request to the
# nameserver.
#
HostnameLookups Off

#
# EnableMMAP: Control whether memory-mapping is used to deliver
# files (assuming that the underlying OS supports it).
# The default is on; turn this off if you serve from NFS-mounted 
# filesystems.  On some systems, turning it off (regardless of
# filesystem) can improve performance; for details, please see
# http://httpd.apache.org/docs-2.0/mod/core.html#enablemmap
#
#EnableMMAP off

#
# EnableSendfile: Control whether the sendfile kernel support is 
# used  to deliver files (assuming that the OS supports it).
# The default is on; turn this off if you serve from NFS-mounted 
# filesystems.  Please see
# http://httpd.apache.org/docs-2.0/mod/core.html#enablesendfile
#
#EnableSendfile off

#
# ErrorLog: The location of the error log file.
# If you do not specify an ErrorLog directive within a &lt;VirtualHost&gt;
# container, error messages relating to that virtual host will be
# logged here.  If you *do* define an error logfile for a &lt;VirtualHost&gt;
# container, that host's errors will be logged there and not here.
#
ErrorLog logs/error_log

#
# LogLevel: Control the number of messages logged to the error_log.
# Possible values include: debug, info, notice, warn, error, crit,
# alert, emerg.
#
LogLevel warn

#
# The following directives define some format nicknames for use with
# a CustomLog directive (see below).
#
LogFormat "%h %l %u %t \"%r\" %&gt;s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "%h %l %u %t \"%r\" %&gt;s %b<xsl:if test="//params/logging/param[@name='apacheResponseTime']/@value='true'"> %D</xsl:if>" common
LogFormat "%{Referer}i -&gt; %U" referer
LogFormat "%{User-agent}i" agent

# You need to enable mod_logio.c to use %I and %O
#LogFormat "%h %l %u %t \"%r\" %&gt;s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio

#
# The location and format of the access logfile (Common Logfile Format).
# If you do not define any access logfiles within a &lt;VirtualHost&gt;
# container, they will be logged here.  Contrariwise, if you *do*
# define per-&lt;VirtualHost&gt; access logfiles, transactions will be
# logged therein and *not* in this file.
#
CustomLog logs/access_log common

#
# If you would like to have agent and referer logfiles, uncomment the
# following directives.
#
#CustomLog logs/referer_log referer
#CustomLog logs/agent_log agent

#
# If you prefer a single logfile with access, agent, and referer information
# (Combined Logfile Format) you can use the following directive.
#
#CustomLog logs/access_log combined

#
# ServerTokens
# This directive configures what you return as the Server HTTP response
# Header. The default is 'Full' which sends information about the OS-Type
# and compiled in modules.
# Set to one of:  Full | OS | Minor | Minimal | Major | Prod
# where Full conveys the most information, and Prod the least.
#
ServerTokens Full

#
# Optionally add a line containing the server version and virtual host
# name to server-generated pages (internal error documents, FTP directory 
# listings, mod_status and mod_info output etc., but not CGI generated 
# documents or custom error documents).
# Set to "EMail" to also include a mailto: link to the ServerAdmin.
# Set to one of:  On | Off | EMail
#
ServerSignature On

#
# Aliases: Add here as many aliases as you need (with no limit). The format is 
# Alias fakename realname
#
# Note that if you include a trailing / on fakename then the server will
# require it to be present in the URL.  So "/icons" isn't aliased in this
# example, only "/icons/".  If the fakename is slash-terminated, then the 
# realname must also be slash terminated, and if the fakename omits the 
# trailing slash, the realname must also omit it.
#
# We include the /icons/ alias for FancyIndexed directory listings.  If you
# do not use FancyIndexing, you may comment this out.
#
Alias /icons/ "<xsl:value-of select="//instances/params/env/param[@name='HTTPD_HOME']/@value"/>/icons/"

&lt;Directory "<xsl:value-of select="//instances/params/env/param[@name='HTTPD_HOME']/@value"/>/icons"&gt;
    Options Indexes MultiViews
    AllowOverride None
    Order allow,deny
    Allow from all
&lt;/Directory&gt;

#
# This should be changed to the ServerRoot/manual/.  The alias provides
# the manual, even if you choose to move your DocumentRoot.  You may comment
# this out if you do not care for the documentation.
#
AliasMatch ^/manual(?:/(?:de|en|es|fr|ja|ko|ru))?(/.*)?$ "<xsl:value-of select="//instances/params/env/param[@name='HTTPD_HOME']/@value"/>/manual$1"

&lt;Directory "<xsl:value-of select="//instances/params/env/param[@name='HTTPD_HOME']/@value"/>/manual"&gt;
    Options Indexes
    AllowOverride None
    Order allow,deny
    Allow from all

    &lt;Files *.html&gt;
        SetHandler type-map
    &lt;/Files&gt;

    SetEnvIf Request_URI ^/manual/(de|en|es|fr|ja|ko|ru)/ prefer-language=$1
    RedirectMatch 301 ^/manual(?:/(de|en|es|fr|ja|ko|ru)){2,}(/.*)?$ /manual/$1$2
&lt;/Directory&gt;

#
# ScriptAlias: This controls which directories contain server scripts.
# ScriptAliases are essentially the same as Aliases, except that
# documents in the realname directory are treated as applications and
# run by the server when requested rather than as documents sent to the client.
# The same rules about trailing "/" apply to ScriptAlias directives as to
# Alias.
#
ScriptAlias /cgi-bin/ "<xsl:value-of select="//instances/params/env/param[@name='HTTPD_HOME']/@value"/>/cgi-bin/"

&lt;IfModule mod_cgid.c&gt;
#
# Additional to mod_cgid.c settings, mod_cgid has Scriptsock &lt;path&gt;
# for setting UNIX socket for communicating with cgid.
#
#Scriptsock            logs/cgisock
&lt;/IfModule&gt;

#
# "/mnt/elba/rubbos/apache2/cgi-bin" should be changed to whatever your ScriptAliased
# CGI directory exists, if you have that configured.
#
&lt;Directory "<xsl:value-of select="//instances/params/env/param[@name='HTTPD_HOME']/@value"/>/cgi-bin"&gt;
    AllowOverride None
    Options None
    Order allow,deny
    Allow from all
&lt;/Directory&gt;

#
# Redirect allows you to tell clients about documents which used to exist in
# your server's namespace, but do not anymore. This allows you to tell the
# clients where to look for the relocated document.
# Example:
# Redirect permanent /foo http://www.example.com/bar

#
# Directives controlling the display of server-generated directory listings.
#

#
# IndexOptions: Controls the appearance of server-generated directory
# listings.
#
IndexOptions FancyIndexing VersionSort

#
# AddIcon* directives tell the server which icon to show for different
# files or filename extensions.  These are only displayed for
# FancyIndexed directories.
#
AddIconByEncoding (CMP,/icons/compressed.gif) x-compress x-gzip

AddIconByType (TXT,/icons/text.gif) text/*
AddIconByType (IMG,/icons/image2.gif) image/*
AddIconByType (SND,/icons/sound2.gif) audio/*
AddIconByType (VID,/icons/movie.gif) video/*

AddIcon /icons/binary.gif .bin .exe
AddIcon /icons/binhex.gif .hqx
AddIcon /icons/tar.gif .tar
AddIcon /icons/world2.gif .wrl .wrl.gz .vrml .vrm .iv
AddIcon /icons/compressed.gif .Z .z .tgz .gz .zip
AddIcon /icons/a.gif .ps .ai .eps
AddIcon /icons/layout.gif .html .shtml .htm .pdf
AddIcon /icons/text.gif .txt
AddIcon /icons/c.gif .c
AddIcon /icons/p.gif .pl .py
AddIcon /icons/f.gif .for
AddIcon /icons/dvi.gif .dvi
AddIcon /icons/uuencoded.gif .uu
AddIcon /icons/script.gif .conf .sh .shar .csh .ksh .tcl
AddIcon /icons/tex.gif .tex
AddIcon /icons/bomb.gif core

AddIcon /icons/back.gif ..
AddIcon /icons/hand.right.gif README
AddIcon /icons/folder.gif ^^DIRECTORY^^
AddIcon /icons/blank.gif ^^BLANKICON^^

#
# DefaultIcon is which icon to show for files which do not have an icon
# explicitly set.
#
DefaultIcon /icons/unknown.gif

#
# AddDescription allows you to place a short description after a file in
# server-generated indexes.  These are only displayed for FancyIndexed
# directories.
# Format: AddDescription "description" filename
#
#AddDescription "GZIP compressed document" .gz
#AddDescription "tar archive" .tar
#AddDescription "GZIP compressed tar archive" .tgz

#
# ReadmeName is the name of the README file the server will look for by
# default, and append to directory listings.
#
# HeaderName is the name of a file which should be prepended to
# directory indexes. 
ReadmeName README.html
HeaderName HEADER.html

#
# IndexIgnore is a set of filenames which directory indexing should ignore
# and not include in the listing.  Shell-style wildcarding is permitted.
#
IndexIgnore .??* *~ *# HEADER* README* RCS CVS *,v *,t

#
# DefaultLanguage and AddLanguage allows you to specify the language of 
# a document. You can then use content negotiation to give a browser a 
# file in a language the user can understand.
#
# Specify a default language. This means that all data
# going out without a specific language tag (see below) will 
# be marked with this one. You probably do NOT want to set
# this unless you are sure it is correct for all cases.
#
# * It is generally better to not mark a page as 
# * being a certain language than marking it with the wrong
# * language!
#
# DefaultLanguage nl
#
# Note 1: The suffix does not have to be the same as the language
# keyword --- those with documents in Polish (whose net-standard
# language code is pl) may wish to use "AddLanguage pl .po" to
# avoid the ambiguity with the common suffix for perl scripts.
#
# Note 2: The example entries below illustrate that in some cases 
# the two character 'Language' abbreviation is not identical to 
# the two character 'Country' code for its country,
# E.g. 'Danmark/dk' versus 'Danish/da'.
#
# Note 3: In the case of 'ltz' we violate the RFC by using a three char
# specifier. There is 'work in progress' to fix this and get
# the reference data for rfc1766 cleaned up.
#
# Catalan (ca) - Croatian (hr) - Czech (cs) - Danish (da) - Dutch (nl)
# English (en) - Esperanto (eo) - Estonian (et) - French (fr) - German (de)
# Greek-Modern (el) - Hebrew (he) - Italian (it) - Japanese (ja)
# Korean (ko) - Luxembourgeois* (ltz) - Norwegian Nynorsk (nn)
# Norwegian (no) - Polish (pl) - Portugese (pt)
# Brazilian Portuguese (pt-BR) - Russian (ru) - Swedish (sv)
# Simplified Chinese (zh-CN) - Spanish (es) - Traditional Chinese (zh-TW)
#
AddLanguage ca .ca
AddLanguage cs .cz .cs
AddLanguage da .dk
AddLanguage de .de
AddLanguage el .el
AddLanguage en .en
AddLanguage eo .eo
AddLanguage es .es
AddLanguage et .et
AddLanguage fr .fr
AddLanguage he .he
AddLanguage hr .hr
AddLanguage it .it
AddLanguage ja .ja
AddLanguage ko .ko
AddLanguage ltz .ltz
AddLanguage nl .nl
AddLanguage nn .nn
AddLanguage no .no
AddLanguage pl .po
AddLanguage pt .pt
AddLanguage pt-BR .pt-br
AddLanguage ru .ru
AddLanguage sv .sv
AddLanguage zh-CN .zh-cn
AddLanguage zh-TW .zh-tw

#
# LanguagePriority allows you to give precedence to some languages
# in case of a tie during content negotiation.
#
# Just list the languages in decreasing order of preference. We have
# more or less alphabetized them here. You probably want to change this.
#
LanguagePriority en ca cs da de el eo es et fr he hr it ja ko ltz nl nn no pl pt pt-BR ru sv zh-CN zh-TW

#
# ForceLanguagePriority allows you to serve a result page rather than
# MULTIPLE CHOICES (Prefer) [in case of a tie] or NOT ACCEPTABLE (Fallback)
# [in case no accepted languages matched the available variants]
#
ForceLanguagePriority Prefer Fallback

#
# Commonly used filename extensions to character sets. You probably
# want to avoid clashes with the language extensions, unless you
# are good at carefully testing your setup after each change.
# See http://www.iana.org/assignments/character-sets for the
# official list of charset names and their respective RFCs.
#
AddCharset ISO-8859-1  .iso8859-1  .latin1
AddCharset ISO-8859-2  .iso8859-2  .latin2 .cen
AddCharset ISO-8859-3  .iso8859-3  .latin3
AddCharset ISO-8859-4  .iso8859-4  .latin4
AddCharset ISO-8859-5  .iso8859-5  .latin5 .cyr .iso-ru
AddCharset ISO-8859-6  .iso8859-6  .latin6 .arb
AddCharset ISO-8859-7  .iso8859-7  .latin7 .grk
AddCharset ISO-8859-8  .iso8859-8  .latin8 .heb
AddCharset ISO-8859-9  .iso8859-9  .latin9 .trk
AddCharset ISO-2022-JP .iso2022-jp .jis
AddCharset ISO-2022-KR .iso2022-kr .kis
AddCharset ISO-2022-CN .iso2022-cn .cis
AddCharset Big5        .Big5       .big5
# For russian, more than one charset is used (depends on client, mostly):
AddCharset WINDOWS-1251 .cp-1251   .win-1251
AddCharset CP866       .cp866
AddCharset KOI8-r      .koi8-r .koi8-ru
AddCharset KOI8-ru     .koi8-uk .ua
AddCharset ISO-10646-UCS-2 .ucs2
AddCharset ISO-10646-UCS-4 .ucs4
AddCharset UTF-8       .utf8

# The set below does not map to a specific (iso) standard
# but works on a fairly wide range of browsers. Note that
# capitalization actually matters (it should not, but it
# does for some browsers).
#
# See http://www.iana.org/assignments/character-sets
# for a list of sorts. But browsers support few.
#
AddCharset GB2312      .gb2312 .gb 
AddCharset utf-7       .utf7
AddCharset utf-8       .utf8
AddCharset big5        .big5 .b5
AddCharset EUC-TW      .euc-tw
AddCharset EUC-JP      .euc-jp
AddCharset EUC-KR      .euc-kr
AddCharset shift_jis   .sjis

#
# AddType allows you to add to or override the MIME configuration
# file mime.types for specific file types.
#
#AddType application/x-tar .tgz
#
# AddEncoding allows you to have certain browsers uncompress
# information on the fly. Note: Not all browsers support this.
# Despite the name similarity, the following Add* directives have nothing
# to do with the FancyIndexing customization directives above.
#
#AddEncoding x-compress .Z
#AddEncoding x-gzip .gz .tgz
#
# If the AddEncoding directives above are commented-out, then you
# probably should define those extensions to indicate media types:
#
AddType application/x-compress .Z
AddType application/x-gzip .gz .tgz

#
# AddHandler allows you to map certain file extensions to "handlers":
# actions unrelated to filetype. These can be either built into the server
# or added with the Action directive (see below)
#
# To use CGI scripts outside of ScriptAliased directories:
# (You will also need to add "ExecCGI" to the "Options" directive.)
#
#AddHandler cgi-script .cgi

#
# For files that include their own HTTP headers:
#
#AddHandler send-as-is asis

#
# For server-parsed imagemap files:
#
#AddHandler imap-file map

#
# For type maps (negotiated resources):
# (This is enabled by default to allow the Apache "It Worked" page
#  to be distributed in multiple languages.)
#
AddHandler type-map var

#
# Filters allow you to process content before it is sent to the client.
#
# To parse .shtml files for server-side includes (SSI):
# (You will also need to add "Includes" to the "Options" directive.)
#
#AddType text/html .shtml
#AddOutputFilter INCLUDES .shtml

#
# Action lets you define media types that will execute a script whenever
# a matching file is called. This eliminates the need for repeated URL
# pathnames for oft-used CGI file processors.
# Format: Action media/type /cgi-script/location
# Format: Action handler-name /cgi-script/location
#

#
# Customizable error responses come in three flavors:
# 1) plain text 2) local redirects 3) external redirects
#
# Some examples:
#ErrorDocument 500 "The server made a boo boo."
#ErrorDocument 404 /missing.html
#ErrorDocument 404 "/cgi-bin/missing_handler.pl"
#ErrorDocument 402 http://www.example.com/subscription_info.html
#

#
# Putting this all together, we can internationalize error responses.
#
# We use Alias to redirect any /error/HTTP_&lt;error&gt;.html.var response to
# our collection of by-error message multi-language collections.  We use 
# includes to substitute the appropriate text.
#
# You can modify the messages' appearance without changing any of the
# default HTTP_&lt;error&gt;.html.var files by adding the line:
#
#   Alias /error/include/ "/your/include/path/"
#
# which allows you to create your own set of files by starting with the
# /mnt/elba/rubbos/apache2/error/include/ files and copying them to /your/include/path/, 
# even on a per-VirtualHost basis.  The default include files will display
# your Apache version number and your ServerAdmin email address regardless
# of the setting of ServerSignature.
#
# The internationalized error documents require mod_alias, mod_include
# and mod_negotiation.  To activate them, uncomment the following 30 lines.

#    Alias /error/ "/mnt/elba/rubbos/apache2/error/"
#
#    &lt;Directory "/mnt/elba/rubbos/apache2/error"&gt;
#        AllowOverride None
#        Options IncludesNoExec
#        AddOutputFilter Includes html
#        AddHandler type-map var
#        Order allow,deny
#        Allow from all
#        LanguagePriority en cs de es fr it ja ko nl pl pt-br ro sv tr
#        ForceLanguagePriority Prefer Fallback
#    &lt;/Directory&gt;
#
#    ErrorDocument 400 /error/HTTP_BAD_REQUEST.html.var
#    ErrorDocument 401 /error/HTTP_UNAUTHORIZED.html.var
#    ErrorDocument 403 /error/HTTP_FORBIDDEN.html.var
#    ErrorDocument 404 /error/HTTP_NOT_FOUND.html.var
#    ErrorDocument 405 /error/HTTP_METHOD_NOT_ALLOWED.html.var
#    ErrorDocument 408 /error/HTTP_REQUEST_TIME_OUT.html.var
#    ErrorDocument 410 /error/HTTP_GONE.html.var
#    ErrorDocument 411 /error/HTTP_LENGTH_REQUIRED.html.var
#    ErrorDocument 412 /error/HTTP_PRECONDITION_FAILED.html.var
#    ErrorDocument 413 /error/HTTP_REQUEST_ENTITY_TOO_LARGE.html.var
#    ErrorDocument 414 /error/HTTP_REQUEST_URI_TOO_LARGE.html.var
#    ErrorDocument 415 /error/HTTP_UNSUPPORTED_MEDIA_TYPE.html.var
#    ErrorDocument 500 /error/HTTP_INTERNAL_SERVER_ERROR.html.var
#    ErrorDocument 501 /error/HTTP_NOT_IMPLEMENTED.html.var
#    ErrorDocument 502 /error/HTTP_BAD_GATEWAY.html.var
#    ErrorDocument 503 /error/HTTP_SERVICE_UNAVAILABLE.html.var
#    ErrorDocument 506 /error/HTTP_VARIANT_ALSO_VARIES.html.var


#
# The following directives modify normal HTTP response behavior to
# handle known problems with browser implementations.
#
BrowserMatch "Mozilla/2" nokeepalive
BrowserMatch "MSIE 4\.0b2;" nokeepalive downgrade-1.0 force-response-1.0
BrowserMatch "RealPlayer 4\.0" force-response-1.0
BrowserMatch "Java/1\.0" force-response-1.0
BrowserMatch "JDK/1\.0" force-response-1.0

#
# The following directive disables redirects on non-GET requests for
# a directory that does not include the trailing slash.  This fixes a 
# problem with Microsoft WebFolders which does not appropriately handle 
# redirects for folders with DAV methods.
# Same deal with Apple's DAV filesystem and Gnome VFS support for DAV.
#
BrowserMatch "Microsoft Data Access Internet Publishing Provider" redirect-carefully
BrowserMatch "^WebDrive" redirect-carefully
BrowserMatch "^WebDAVFS/1.[012]" redirect-carefully
BrowserMatch "^gnome-vfs" redirect-carefully

#
# Allow server status reports generated by mod_status,
# with the URL of http://servername/server-status
# Change the ".example.com" to match your domain to enable.
#
#&lt;Location /server-status&gt;
#    SetHandler server-status
#    Order deny,allow
#    Deny from all
#    Allow from .example.com
#&lt;/Location&gt;

#
# Allow remote server configuration reports, with the URL of
#  http://servername/server-info (requires that mod_info.c be loaded).
# Change the ".example.com" to match your domain to enable.
#
#&lt;Location /server-info&gt;
#    SetHandler server-info
#    Order deny,allow
#    Deny from all
#    Allow from .example.com
#&lt;/Location&gt;


#
# Bring in additional module-specific configurations
#
&lt;IfModule mod_ssl.c&gt;
    Include conf/ssl.conf
&lt;/IfModule&gt;


### Section 3: Virtual Hosts
#
# VirtualHost: If you want to maintain multiple domains/hostnames on your
# machine you can setup VirtualHost containers for them. Most configurations
# use only name-based virtual hosts so the server doesn't need to worry about
# IP addresses. This is indicated by the asterisks in the directives below.
#
# Please see the documentation at 
# &lt;URL:http://httpd.apache.org/docs-2.0/vhosts/&gt;
# for further details before you try to setup virtual hosts.
#
# You may use the command line option '-S' to verify your virtual host
# configuration.

#
# Use name-based virtual hosting.
#
#NameVirtualHost *:80

#
# VirtualHost example:
# Almost any Apache directive may go into a VirtualHost container.
# The first VirtualHost section is used for requests without a known
# server name.
#
#&lt;VirtualHost *:80&gt;
#    ServerAdmin webmaster@dummy-host.example.com
#    DocumentRoot /www/docs/dummy-host.example.com
#    ServerName dummy-host.example.com
#    ErrorLog logs/dummy-host.example.com-error_log
#    CustomLog logs/dummy-host.example.com-access_log common
#&lt;/VirtualHost&gt;



LoadModule jk_module "<xsl:value-of select="//instances/params/env/param[@name='HTTPD_HOME']/@value"/>/modules/mod_jk.so"

# Where to find workers.properties
JkWorkersFile <xsl:value-of select="//instances/params/env/param[@name='HTTPD_HOME']/@value"/>/conf/workers.properties
 
# Where to put jk logs
JkLogFile     <xsl:value-of select="//instances/params/env/param[@name='HTTPD_HOME']/@value"/>/logs/mod_jk.log
 
# Set the jk log level [debug/error/info]
JkLogLevel    info
 
# Select the log format
JkLogStampFormat "[%a %b %d %H:%M:%S %Y] "
 
# JkOptions indicate to send SSL KEY SIZE,
JkOptions     +ForwardKeySize +ForwardURICompat -ForwardDirectories
 
# JkRequestLogFormat set the request format
JkRequestLogFormat     "%w %V %T"
 
# Globally deny access to the WEB-INF directory
&lt;LocationMatch '.*WEB-INF.*'&gt;
       AllowOverride None
       deny from all
&lt;/LocationMatch&gt;


JkMount     /*/control/* worker1
JkMount     /*.jsp worker1
#JkMount     /rubbos worker1
#JkMount     /rubbos/* worker1
</content>
</file>



<file>
<xsl:text disable-output-escaping="yes">&lt;name id=&quot;</xsl:text>workers.properties<xsl:text disable-output-escaping="yes">&quot; loc=&quot;</xsl:text><xsl:value-of select="//params/env/param[@name='OUTPUT_HOME']/@value"/>/apache_conf<xsl:text disable-output-escaping="yes">&quot;/&gt;</xsl:text>
<content>
# workers.properties -
#
# This file provides jk derived plugins with the needed information to
# connect to the different tomcat workers.  Note that the distributed
# version of this file requires modification before it is usable by a
# plugin.
#
# As a general note, the characters $( and ) are used internally to define
# macros. Do not use them in your own configuration!!!
#
# Whenever you see a set of lines such as:
# x=value
# y=$(x)\something
#
# the final value for y will be value\something
#
# Normaly all you will need to do is un-comment and modify the first three
# properties, i.e. workers.tomcat_home, workers.java_home and ps.
# Most of the configuration is derived from these.
#
# When you are done updating workers.tomcat_home, workers.java_home and ps
# you should have 3 workers configured:
#
# - An ajp12 worker that connects to localhost:8007
# - An ajp13 worker that connects to localhost:8009
# - A jni inprocess worker.
# - A load balancer worker
#
# However by default the plugins will only use the ajp12 worker. To have
# the plugins use other workers you should modify the worker.list property.
#
#

# OPTIONS ( very important for jni mode ) 

#
# workers.tomcat_home should point to the location where you
# installed tomcat. This is where you have your conf, webapps and lib
# directories.
#
workers.tomcat_home=<xsl:value-of select="//instances/params/env/param[@name='CATALINA_HOME']/@value"/>

#
# workers.java_home should point to your Java installation. Normally
# you should have a bin and lib directories beneath it.
#
workers.java_home=<xsl:value-of select="//instances/params/env/param[@name='JAVA_HOME']/@value"/>

#
# You should configure your environment slash... ps=\ on NT and / on UNIX
# and maybe something different elsewhere.
#
ps=/

#
#------ ADVANCED MODE ------------------------------------------------
#---------------------------------------------------------------------
#

#
#------ DEFAULT worket list ------------------------------------------
#---------------------------------------------------------------------
#
#
# The workers that your plugins should create and work with
#
# Add 'inprocess' if you want JNI connector 
worker.list=worker1
# , inprocess

<xsl:for-each select="//instances/instance[@type='app_server']">
worker.<xsl:value-of select="./@name"/>.port=8009
worker.<xsl:value-of select="./@name"/>.host=<xsl:value-of select="./target"/>-lan2
worker.<xsl:value-of select="./@name"/>.type=ajp13
worker.<xsl:value-of select="./@name"/>.lbfactor=1
</xsl:for-each>

#
#------ DEFAULT ajp12 WORKER DEFINITION ------------------------------
#---------------------------------------------------------------------
#

#
# Defining a worker named ajp12 and of type ajp12
# Note that the name and the type do not have to match.
#
#worker.ajp12.port=8007
#worker.ajp12.host=localhost
#worker.ajp12.type=ajp12
#
# Specifies the load balance factor when used with
# a load balancing worker.
# Note:
#  ----&gt; lbfactor must be &gt; 0
#  ----&gt; Low lbfactor means less work done by the worker.
#worker.ajp12.lbfactor=1

#
#------ DEFAULT ajp13 WORKER DEFINITION ------------------------------
#---------------------------------------------------------------------
#

#
# Defining a worker named ajp13 and of type ajp13
# Note that the name and the type do not have to match.
#
#worker.ajp13.port=8009
#worker.ajp13.host=node60.rubbostest.Infosphere.emulab.net
#worker.ajp13.type=ajp13
#
# Specifies the load balance factor when used with
# a load balancing worker.
# Note:
#  ----&gt; lbfactor must be &gt; 0
#  ----&gt; Low lbfactor means less work done by the worker.
#worker.ajp13.lbfactor=1

#
# Specify the size of the open connection cache.
#worker.ajp13.cachesize

#
#------ DEFAULT LOAD BALANCER WORKER DEFINITION ----------------------
#---------------------------------------------------------------------
#

#
# The router (type lb) workers perform wighted round-robin
# load balancing with sticky sessions.
# Note:
#  ----&gt; If a worker dies, the load balancer will check its state
#        once in a while. Until then all work is redirected to peer
#        workers.
worker.worker1.type=lb
<xsl:variable name="first" select="//instances/instance[@type='app_server'][1]/@name"
/>worker.worker1.balance_workers=<xsl:for-each select="//instances/instance[@type='app_server']"
    ><xsl:variable name="name" select="./@name"
   /><xsl:if test="$name != $first">,</xsl:if><xsl:value-of select="$name"/></xsl:for-each>
worker.worker1.sticky_session=True
worker.worker1.method=Session

#
#------ DEFAULT JNI WORKER DEFINITION---------------------------------
#---------------------------------------------------------------------
#

#
# Defining a worker named inprocess and of type jni
# Note that the name and the type do not have to match.
#
worker.inprocess.type=jni

#
#------ CLASSPATH DEFINITION -----------------------------------------
#---------------------------------------------------------------------
#

#
# Additional class path components.
#
worker.inprocess.class_path=$(workers.tomcat_home)$(ps)lib$(ps)tomcat.jar

#
# Setting the command line for tomcat. 
# Note: The cmd_line string may not contain spaces.
#
worker.inprocess.cmd_line=start

# Not needed, but can be customized.
#worker.inprocess.cmd_line=-config
#worker.inprocess.cmd_line=$(workers.tomcat_home)$(ps)conf$(ps)server.xml
#worker.inprocess.cmd_line=-home
#worker.inprocess.cmd_line=$(workers.tomcat_home)

#
# The JVM that we are about to use
#
# This is for Java2
#
# Windows
#worker.inprocess.jvm_lib=$(workers.java_home)$(ps)jre$(ps)bin$(ps)classic$(ps)jvm.dll
# IBM JDK1.3 
#worker.inprocess.jvm_lib=$(workers.java_home)$(ps)jre$(ps)bin$(ps)classic$(ps)libjvm.so
# Unix - Sun VM or blackdown
#worker.inprocess.jvm_lib=$(workers.java_home)$(ps)jre$(ps)lib$(ps)i386$(ps)classic$(ps)libjvm.so
worker.inprocess.jvm_lib=$(workers.java_home)$(ps)jre$(ps)lib$(ps)i386$(ps)server$(ps)libjvm.so

#
# And this is for jdk1.1.X
#
#worker.inprocess.jvm_lib=$(workers.java_home)$(ps)bin$(ps)javai.dll


#
# Setting the place for the stdout and stderr of tomcat
#
worker.inprocess.stdout=$(workers.tomcat_home)$(ps)logs$(ps)inprocess.stdout
worker.inprocess.stderr=$(workers.tomcat_home)$(ps)logs$(ps)inprocess.stderr

#
# Setting the tomcat.home Java property
#
#worker.inprocess.sysprops=tomcat.home=$(workers.tomcat_home)

#
# Java system properties
#
# worker.inprocess.sysprops=java.compiler=NONE
# worker.inprocess.sysprops=myprop=mypropvalue

#
# Additional path components.
#
# worker.inprocess.ld_path=d:$(ps)SQLLIB$(ps)bin
#
</content>
</file>

</xsl:template>

</xsl:stylesheet>










