
source 0set_env.sh

for a_vm in ${VMs[@]}
do
	echo ''
	echo '>>>'
	echo $a_vm

	scp ./mount.sh ${a_vm}:
	ssh ${a_vm} sh mount.sh


done
