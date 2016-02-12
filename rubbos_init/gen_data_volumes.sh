#!/bin/bash

find_mesos_id () {

  # Parameters
  HOST="$1"
  echo "$1"

  # All running containers
  CONTAINERS=`docker -H $HOST:2375 ps | sed 1d | awk '{print $1}'`
  CONTAINERS_ARRAY=($CONTAINERS)

  echo "$CONTAINERS_ARRAY"
  echo  "for each get MARATHON_ID & MESOS_ID"
  for i in "${CONTAINERS_ARRAY[@]}"
  do  
     MARATHON_APP_ID=$(docker -H $HOST:2375 inspect $i | grep MARATHON_APP_ID | awk -F '[="]' '{print $3}' | awk -F '\/' '{print $2}')
     MESOS_CONTAINER_NAME=$(docker -H $HOST:2375 inspect $i | grep MESOS_CONTAINER_NAME | awk -F '[="]' '{print $3}')

     # Print MESOS_ID only for desired container
     if [[ $MARATHON_APP_ID = $2 ]]; then
        printf "{ \"key\": \"volumes-from\", \"value\": \"%s\" }" $MESOS_CONTAINER_NAME
     fi   
  done
}   

if [ "$#" -lt 2 ]; then
  echo "USAGE: bash gen-data-volumes.sh <host> [<marathon-id>]"
  printf "This script takes at least two arguments (%d given).\n" $#
  echo "exit 1."
  exit 1;
fi  

if [ "$#" -gt 1 ]; then
  for ((i=2;i<$#+1;i++)) 
    do  
      printf "%s" $(find_mesos_id $1 ${!i})
      if [[ $i -ne $# ]]; then
        printf ", "
      else 
        echo
      fi  
    done
fi

