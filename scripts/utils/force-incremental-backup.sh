#!/bin/bash

backup_folder=/backup
data_location=/var/lib/cassandra/data

snapshot_prefix=snapshot
snapshot_name=${snapshot_prefix}-$(date +%d-%m-%YT%H-%M)
keyspace_name=$1

echo "Force enable incremental backups"
nodetool enablebackup

echo "Flushing data to force to create a new incremental backup"
nodetool flush -- ${keyspace_name}
echo "Force to compact storage"
nodetool compact -- ${keyspace_name}

while [ $(nodetool verify -- ${keyspace_name}) ]
do
  echo "Waiting for snapshot completion. Waiting 10 seconds"
  sleep 10;
done

for incremental_backup_folder in $(find ${data_location}/${keyspace_name} -name backups)
do
  table_name=$(basename $(dirname ${incremental_backup_folder}))

  echo "Moving files for latest incremental backup for table ${table_name}"
  cp -r ${incremental_backup_folder}/* ${backup_folder}/${keyspace_name}/${table_name}/incremental-backup-latest
done