#!/bin/bash
set -e

keyspace_name=my_custom_keyspace

for container_id in $(docker-compose ps -q)
do
  echo "Force new incremental backup on ${container_id}"
  docker exec -ti ${container_id} bash /scripts/force-incremental-backup.sh ${keyspace_name}
done

