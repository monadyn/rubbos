
source 0set_env.sh
for a_vm in ${VMs[@]}
do
	echo ''
	echo '>>>'
	echo $a_vm
	scp ./sysstat-11.2.0.tar.gz ${a_vm}:/root/softwares
	scp /etc/hosts ${a_vm}:/etc/hosts
	scp ./mount_manual.sh ${a_vm}:      
	scp ./known_hosts ${a_vm}:.ssh      


done
