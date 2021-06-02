#!/bin/bash

backup_name=${1:-latest}
keyspace_name=${2:-my_custom_keyspace}
table_name=${3:-my_table-089bd870c38511eb8fe8cb54ec2c663c}

backup_folder=/backup

mkdir -p /tmp/${keyspace_name}
ln -sf ${backup_folder}/${keyspace_name}/${table_name}/latest /tmp/${keyspace_name}/${table_name}

sstableloader -d localhost /tmp/${keyspace_name}/${table_name}

nodetool repair -- ${keyspace_name} $(echo ${table_name} | cut -d'-' -f1)
