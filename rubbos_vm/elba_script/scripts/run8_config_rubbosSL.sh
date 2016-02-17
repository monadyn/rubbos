
cd /sshfsmount/elba_script
source set_elba_env.sh

cd /sshfsmount/elba_script/scripts












ssh $TOMCAT1_HOST /tmp/TOMCAT1_rubbosSL_configure.sh 

exit(0)
ssh $CONTROL_HOST /tmp/CONTROL_rubbos_exec.sh 

