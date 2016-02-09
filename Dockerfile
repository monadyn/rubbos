FROM busybox 
 
RUN mkdir /webapps 
ADD rubbos.war /webapps/rubbos.war 
ADD mysql.properties /webapps/mysql.properties

RUN mkdir /webapps/Servlet_HTML
ADD author.html /webapps/Servlet_HTML/author.html
ADD browse.html /webapps/Servlet_HTML/browse.html
ADD header.html /webapps/Servlet_HTML/header.html
ADD index.html /webapps/Servlet_HTML/index.html
ADD register.html /webapps/Servlet_HTML/register.html



VOLUME ["/webapps"] 
 
CMD /bin/sh
