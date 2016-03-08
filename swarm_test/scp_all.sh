echo haha
for a_vm in hshan-httpd hshan-mysql hshan-tomcat hshan-client hshan-bench hshan-control
do
	echo ''
	echo '>>>'
	echo $a_vm
	scp ./sysstat-11.2.0.tar.gz ${a_vm}:/root/softwares
      


done
