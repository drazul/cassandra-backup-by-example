#!/bin/bash

for container_id in $(docker-compose ps -q)
do
  echo "Enabling backup on ${container_id}"
  docker exec -ti ${container_id} nodetool enablebackup

  echo "Backup status on ${container_id}"
  docker exec -ti ${container_id} nodetool statusbackup
done
