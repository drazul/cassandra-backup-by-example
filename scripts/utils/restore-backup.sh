#!/bin/bash

set -e

backup_name=${1:-latest}
keyspace_name=${2:-my_custom_keyspace}
table_name=${3:-my_table-089bd870c38511eb8fe8cb54ec2c663c}

backup_folder=/backup

echo "Restoring data from latest manual snapshot"
mkdir -p /tmp/snapshot/${keyspace_name}
ln -sf ${backup_folder}/${keyspace_name}/${table_name}/latest /tmp/snapshot/${keyspace_name}/${table_name}

sstableloader -d localhost /tmp/${keyspace_name}/${table_name}

echo "Restoring data from incremental backups"
mkdir -p /tmp/incremental-backup/${keyspace_name}
ln -sf ${backup_folder}/${keyspace_name}/${table_name}/incremental-backup-latest /tmp/incremental-backup/${keyspace_name}/${table_name}

sstableloader -d localhost /tmp/incremental-backup/${keyspace_name}/${table_name}

echo "Ask cassandra to repair the table"
nodetool repair -- ${keyspace_name} $(echo ${table_name} | cut -d'-' -f1)
