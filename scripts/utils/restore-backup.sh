#!/bin/bash

backup_folder=/backup
data_location=/var/lib/cassandra/data

keyspace_name=example


echo "Deleting commitlog and table data"
rm -rf $(basedir ${data_location})/commitlog

for table in ${data_location}
do
  rm -rf ${table}/*
done