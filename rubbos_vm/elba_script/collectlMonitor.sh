
#!/bin/bash
cd /sshfsmount/elba_script

source set_elba_env.sh


echo "start fine-grained CPU monitoring using collectl "

# remove the previous collectl data in Control node
#rm /tmp/VMelba*
rm /tmp/*raw.gz

for i in "$HTTPD_HOST" "$TOMCAT1_HOST" "$MYSQL1_HOST" "$BENCHMARK_HOST" "$CLIENT1_HOST"
do
  echo $i 
  echo 'start collectl -->'
  ssh $i ' 
	#\rm /tmp/VMelba*
	\rm /tmp/*.raw.gz
	
	collectl -i 0.1 -F30 -scmdn -oTm  -f /tmp > /dev/null &
    '
done

## example of how to replay back the collectl results
#collectl -scdn -p ./VMelba9-20130922-083628.raw  -P -f . -oUmz --from 20130922:08:36-08:39

#scp -r $TOMCAT3_HOST:/var/lib/oprofile/samples/$RUBBOS_RESULTS_DIR_NAME ./
