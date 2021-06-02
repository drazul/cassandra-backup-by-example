#!/bin/bash

snapshot_name=snapshot-$(date +%d-%m-%YT%H-%M)

keyspace_name=my_custom_keyspace

for container_id in $(docker-compose ps -q)
do
  echo "Make snapshot ${snapshot_name} on ${container_id}"
  docker exec -ti ${container_id} bash /scripts/create-snapshot.sh "${snapshot_name}" "${keyspace_name}"
done
