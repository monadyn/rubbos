
source 0set_env.sh
for a_vm in ${VMs[@]}
do
	echo ''
	echo '>>>'
	echo $a_vm
	scp /etc/hosts ${a_vm}:/etc/hosts
	scp ./known_hosts ${a_vm}:.ssh      


done
