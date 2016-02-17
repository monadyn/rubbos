yum install -y wget 
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/c/collectl-4.0.2-1.el7.noarch.rpm

rpm -Uvh collectl-4.0.2-1.el7.noarch.rpm


wget http://mirror.centos.org/centos/7/os/x86_64/Packages/perl-Sys-Syslog-0.33-3.el7.x86_64.rpm
yum install -y perl-Sys-Syslog

wget http://mirror.centos.org/centos/7/os/x86_64/Packages/perl-IO-Compress-2.061-2.el7.noarch.rpm
yum install -y  perl-IO-Compress
rpm -Uvh collectl-4.0.2-1.el7.noarch.rpm

yum install -y collectl
