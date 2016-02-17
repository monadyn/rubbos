 

#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh


echo "  CONFIGURING MYSQL on $HOSTNAME"

#start mysql
  mkdir -p $MYSQL_HOME/run
  cp $OUTPUT_HOME/mysql_conf/my.cnf $MYSQL_HOME/my.cnf

  cd $MYSQL_HOME
  bin/mysqld_safe --no-defaults --port=$MYSQL_PORT --datadir=$MYSQL_DATA_DIR --log=$MYSQL_ERR_LOG --pid-file=$MYSQL_PID_FILE --socket=$MYSQL_SOCKET --user=root &
  sleep 3

#set password
  bin/mysqladmin --socket=$MYSQL_SOCKET --user=root password "$ROOT_PASSWORD"
  echo bin/mysqladmin --socket=$MYSQL_SOCKET --user=root password "$ROOT_PASSWORD"

#create database & set privileges

#  ssh localhost "
#    cd /sshfsmount/elba_script
#    source set_elba_env.sh
#    cd $MYSQL_HOME
#    echo 'CREATE DATABASE rubbos;'  | bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD mysql

#    echo 'GRANT ALL PRIVILEGES ON rubbos.* TO \"$ELBA_USER\"@\"%\" IDENTIFIED BY \"$ELBA_PASSWORD\", \"root\"@\"%\" IDENTIFIED BY \"$ROOT_PASSWORD\"; flush privileges; GRANT ALL PRIVILEGES ON rubbos.* TO \"$ELBA_USER\"@\"localhost\" IDENTIFIED BY \"$ELBA_PASSWORD\", \"root\"@\"localhost\" IDENTIFIED BY \"$ROOT_PASSWORD\"; flush privileges;' | bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD mysql
#  "
    cd /sshfsmount/elba_script
    source set_elba_env.sh
    cd $MYSQL_HOME
    echo 'CREATE DATABASE rubbos;'  | bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD mysql

    echo 'GRANT ALL PRIVILEGES ON rubbos.* TO \"$ELBA_USER\"@\"%\" IDENTIFIED BY \"$ELBA_PASSWORD\", \"root\"@\"%\" IDENTIFIED BY \"$ROOT_PASSWORD\"; flush privileges; GRANT ALL PRIVILEGES ON rubbos.* TO \"$ELBA_USER\"@\"localhost\" IDENTIFIED BY \"$ELBA_PASSWORD\", \"root\"@\"localhost\" IDENTIFIED BY \"$ROOT_PASSWORD\"; flush privileges;' | bin/mysql --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD mysql



#stop mysql
  bin/mysqladmin --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD shutdown
  echo bin/mysqladmin --socket=$MYSQL_SOCKET --user=root --password=$ROOT_PASSWORD shutdown

# copy rubbos data files
#  tar xzf $SOFTWARE_HOME/$RUBBOS_DATA_TARBALL --directory=$MYSQL_HOME/data/rubbos
  tar xzf $SOFTWARE_HOME/$RUBBOS_DATA_TARBALL --directory=$MYSQL_HOME/data/
  sleep 5

echo "  DONE CONFIGURING MYSQL on $HOSTNAME"

 
