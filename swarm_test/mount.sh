echo '-->'
rpm -i http://mirror.symnds.com/distributions/fedora-epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install fuse-sshfs -y
modprobe fuse
lsmod | grep fuse
mkdir -p /sshfsmount

echo 'tbd, need login remote server'
sshfs hshan@hdp1:/home/hshan/rubbos/rubbos/rubbos_vm /sshfsmount
ls -aul /sshfsmount
