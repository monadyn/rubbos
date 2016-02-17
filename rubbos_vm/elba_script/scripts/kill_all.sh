
#!/bin/bash

cd /sshfsmount/elba_script
source set_elba_env.sh

$OUTPUT_HOME/scripts/stop_all.sh

for i in "$BENCHMARK_HOST" "$HTTPD_HOST" "$TOMCAT1_HOST" "$MYSQL1_HOST"
do
  ssh $i "
        kill -9 -1
    "
done

