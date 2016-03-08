
source 0set_env.sh

for a_vm in ${VMs[@]}
do
	echo ''
	echo '>>>'
	echo $a_vm

	ssh ${a_vm}  ls /sshfsmount -LR


done
