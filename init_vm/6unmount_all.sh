
source 0set_env.sh

for a_vm in ${VMs[@]}
do
	echo ''
	echo '>>>'
	echo $a_vm

	scp ./unmount.sh ${a_vm}:
	ssh ${a_vm} sh unmount.sh


done
