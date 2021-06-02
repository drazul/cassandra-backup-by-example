#!/bin/bash

for container_id in $(docker-compose ps -q)
do
  echo "List snapshots on ${container_id}"
  docker exec -ti ${container_id} nodetool listsnapshots
done