 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

# Check scp to all servers
echo "*** checking scp to all servers *********************************"

ssh -o StrictHostKeyChecking=no -o BatchMode=yes $CONTROL_HOST "hostname"
ssh -o StrictHostKeyChecking=no -o BatchMode=yes $BENCHMARK_HOST "hostname"
ssh -o StrictHostKeyChecking=no -o BatchMode=yes $CLIENT1_HOST "hostname"
ssh -o StrictHostKeyChecking=no -o BatchMode=yes $HTTPD_HOST "hostname"
ssh -o StrictHostKeyChecking=no -o BatchMode=yes $TOMCAT1_HOST "hostname"
ssh -o StrictHostKeyChecking=no -o BatchMode=yes $MYSQL1_HOST "hostname"

ssh -o StrictHostKeyChecking=no -o BatchMode=yes hpd1 "hostname"
#ssh -o StrictHostKeyChecking=no -o BatchMode=yes localhost "hostname"

 
