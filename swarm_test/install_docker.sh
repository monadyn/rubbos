uname -r



#yum update

tee /etc/yum.repos.d/docker.repo <<- 'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF


yum install lvm2 -y



yum install docker-engine -y


service docker start

#chkconfig docker on
docker version

yum list installed | grep docker


