#!/bin/bash
set -e

snapshot_prefix=snapshot
snapshot_pattern_name=${snapshot_prefix}-[0-9]{2}-[0-9]{2}-[0-9]{2}T[0-9]{2}-[0-9]{2}
keypsace_name=storage_document

backup_folder=/backup
data_folder=/var/lib/cassandra/data

threshold=2

for container_id in $(docker-compose ps -q)
do
  echo "Delete snapshots older than ${threshold} minutes"
  docker exec -ti ${container_id} bash -c 'find '${data_folder}' -name "*snapshot*" -cmin +'${threshold}' | egrep "snapshot-[0-9]{2}-[0-9]{2}-[0-9]{4}T[0-9]{2}-[0-9]{2}" | xargs rm -vrf'
done
