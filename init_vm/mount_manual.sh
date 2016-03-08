echo '-->'
#sshfs -o reconnect hshan@hdp1:/home/hshan/rubbos/rubbos/rubbos_vm /sshfsmount
sudo mount  -t nfs HDP1:/home/hshan/rubbos/rubbos/rubbos_vm/elba_script  /sshfsmount/elba_script 
sudo mount -t nfs HDP1:/home/hshan/soft   /sshfsmount/softwares
ls -la /sshfsmount/elba_script
