
docker ps | awk '{print $1}' | xargs docker rm -f
