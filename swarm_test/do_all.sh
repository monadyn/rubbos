
source 0set_env.sh

#for a_vm in ${VMs[@]}
for a_vm in node3
do
	echo ''
	echo '>>>'
	echo $a_vm

	scp ./do_one.sh ${a_vm}:
 
	ssh ${a_vm} sh do_one.sh


done
