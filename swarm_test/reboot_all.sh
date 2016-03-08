echo haha
for a_vm in hshan-httpd hshan-mysql hshan-tomcat hshan-client hshan-bench hshan-control
do
	echo ''
	echo '>>>'
	echo $a_vm
     	nova reboot $a_vm & 


done
