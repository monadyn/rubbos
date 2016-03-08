source 0set_env.sh
echo ${VMs[@]}

for a_vm in ${VMs[@]}
do
	echo ''
	echo '>>>'
	echo $a_vm
	scp ./close_firewall.sh ${a_vm}:
	ssh ${a_vm} sh close_firewall.sh
      


done
