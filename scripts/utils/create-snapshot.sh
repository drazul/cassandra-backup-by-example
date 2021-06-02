#!/bin/bash

set -e

backup_folder=/backup
data_location=/var/lib/cassandra/data

snapshot_name=${1:-snapshot-$(date +%d-%m-%YT%H-%M)}
keyspace_name=${2:-my_custom_keyspace}

bash /script/force-incremental-backup.sh ${keyspace_name}

echo "Creating snapshot ${snapshot_name}"
nodetool snapshot ${keyspace_name} --tag ${snapshot_name}

while [ $(nodetool verify -- ${keyspace_name}) ]
do
  echo "Waiting for snapshot completion. Waiting 10 seconds"
  sleep 10;
done

for snapshot_data_path in $(find ${data_location}/${keyspace_name} -name ${snapshot_name})
do
  table_name=$(basename $(dirname $(dirname ${snapshot_data_path})))

  backup_destination_folder=${backup_folder}/${keyspace_name}/${table_name}
  mkdir -p ${backup_destination_folder}

  incremental_backup_folder=$(dirname $(dirname ${snapshot_data_path}))/backups
  echo "Remove old incremental backup folder"
  rm -rf ${incremental_backup_folder}
  mkdir -p ${incremental_backup_folder}

  echo "Moving latest to latest-old"
  rm -rf ${backup_destination_folder}/latest-old
  mkdir -p ${backup_destination_folder}/latest # to not crash first time
  mv ${backup_destination_folder}/latest ${backup_destination_folder}/latest-old

  echo "Moving snapshot ${snapshot_name} for table ${table_name} to its backup location"
  cp -r ${snapshot_data_path} ${backup_destination_folder}/${snapshot_name}
  cp -r ${snapshot_data_path} ${backup_destination_folder}/latest

  echo "Moving incremental backup latest folder to latest-old"
  rm -rf ${backup_destination_folder}/incremental-backup-latest-old
  mkdir -p ${backup_destination_folder}/incremental-backup-latest # to not crash first time
  mv ${backup_destination_folder}/incremental-backup-latest ${backup_destination_folder}/incremental-backup-latest-old

  echo "Moving incremental backup for its backup location"
  cp -r ${incremental_backup_folder} ${backup_destination_folder}/incremental-backup-latest
done
