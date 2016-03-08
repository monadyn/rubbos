sudo rm /tmp/* -rf
sudo chown -R hshan:hshan /tmp
sudo rm /sshfsmount/* -rf

mkdir -p /sshfsmount
cd /sshfsmount
sudo chown -R hshan:hshan .
rm * -rf
sudo yum install nfs-utils nfs-utils-lib -y
mkdir -p /sshfsmount/elba_script 
mkdir -p /sshfsmount/softwares
ls
sudo mount  -t nfs HDP1.cse.lsu.edu:/home/hshan/rubbos/rubbos/rubbos_vm/elba_script  /sshfsmount/elba_script 
sudo mount -t nfs HDP1.cse.lsu.edu:/home/hshan/soft   /sshfsmount/softwares
sudo mount  -t nfs HDP1:/home/hshan/rubbos/rubbos/rubbos_vm/elba_script  /sshfsmount/elba_script 
sudo mount -t nfs HDP1:/home/hshan/soft   /sshfsmount/softwarese
