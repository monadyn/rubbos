echo haha
#for a_vm in hshan-httpd hshan-mysql hshan-tomcat hshan-client hshan-bench hshan-control
for a_vm in hshan-mysql hshan-tomcat hshan-client hshan-bench hshan-control
do
	echo ''
	echo '>>>'
	echo $a_vm
	scp ./do_one.sh ${a_vm}:
	ssh ${a_vm} sh do_one.sh
      


done
