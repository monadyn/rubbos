
source 0set_env.sh

for a_vm in ${VMs[@]}
do
	echo ''
	echo '>>>'
	echo $a_vm

	scp install_collectl.sh ${a_vm}:
        ssh ${a_vm} sh install_collectl.sh


done
