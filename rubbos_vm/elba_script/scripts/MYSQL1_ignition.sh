 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh


echo "  STARTING MYSQL on $HOSTNAME"

cd $MYSQL_HOME
bin/mysqld_safe --defaults-file="$MYSQL_HOME/my.cnf" --datadir=$MYSQL_DATA_DIR --pid-file=$MYSQL_PID_FILE --socket=$MYSQL_SOCKET --port=$MYSQL_PORT --user=root --log-bin=rubbos-bin --max_connections=500 --log-slow-queries 	--long_query_time=1 &
#bin/safe_mysqld --defaults-file="$MYSQL_HOME/my.cnf" --datadir=$MYSQL_DATA_DIR --log=$MYSQL_ERR_LOG --pid-file=$MYSQL_PID_FILE --socket=$MYSQL_SOCKET --port=$MYSQL_PORT --user=root &#--log-bin=rubbos-bin

echo "  MYSQL IS RUNNING on $HOSTNAME"

 
