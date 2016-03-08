setenforce 0
sudo service iptables status
echo systemctl stop firewalld
sudo service iptables stop
echo '-->'
sudo service iptables status
