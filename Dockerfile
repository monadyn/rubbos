FROM busybox 
 
RUN mkdir /webapps 
ADD rubbos.war /webapps/rubbos.war 
ADD mysql.properties /webapps/mysql.properties
VOLUME ["/webapps"] 
 
CMD /bin/sh
