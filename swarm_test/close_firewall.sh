setenforce 0
service iptables status
echo systemctl stop firewalld
service iptables stop
echo '-->'
service iptables status
