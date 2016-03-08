#sudo yum -y rpm
sudo yum update
sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org 
sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm 
sudo yum -y --enablerepo=elrepo-kernel install kernel-ml

sudo awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg

sudo grub2-set-default 0


#yum install  lynx -y
