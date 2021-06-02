#!/bin/bash

keyspace_name=storage_document

data_folder=./data
backup_folder=./backup
backup_name=latest

docker-compose down | true

find ./data -name commitlog -exec rm -vrf {} +
find ./data -name ${keyspace_name} -exec rm -vrf {} +


for node in $(ls ${backup_folder})
do
  cp -r ${backup_folder}/${node}/${keyspace_name}/${backup_name} ${data_folder}/${node}/data/${keyspace_name}
done

#docker-compose up -d cassandra-0

#sleep 60

docker-compose up -d