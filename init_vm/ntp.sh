sudo yum install ntp ntpdate ntp-doc -y
sudo  chkconfig ntpd on
sudo ntpdate ntp1.lsu.edu
sudo  /etc/init.d/ntpd start
