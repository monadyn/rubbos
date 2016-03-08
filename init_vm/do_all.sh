echo haha
source 0set_env.sh
 
for a_vm in ${VMs[@]}
#for a_vm in hshan-httpd hshan-mysql hshan-tomcat hshan-client hshan-bench hshan-control
#for a_vm in  hshan-cjdbc
do
	echo ''
	echo '>>>'
	echo $a_vm
	scp ./do_one.sh ${a_vm}:
	ssh -t ${a_vm} sh do_one.sh
      


done
