#!/bin/bash

echo "Check 'my_custom_keyspace.my_table' doesn't exist"
docker run -ti --rm --network host cassandra:3 cqlsh localhost 9042 -e 'select * from my_custom_keyspace.my_table;'

echo "Restoring 'my_custom_keyspace.my_table' schema from latest manual snapshot"
snapshot_location=backup/cassandra-node-0/my_custom_keyspace/my_table-089bd870c38511eb8fe8cb54ec2c663c/latest/schema.cql
docker run -ti -v $(pwd)/${snapshot_location}:/${snapshot_location} --rm --network host cassandra:3 cqlsh localhost 9042 --file /${snapshot_location}


snapshot_path=backup/cassandra-node-0/my_custom_keyspace/my_table-089bd870c38511eb8fe8cb54ec2c663c/snapshot-02-06-2021T13-28
for container_id in $(docker-compose ps -q)
do
  echo "Restoring SSTables from container ${container_id}"
  docker exec -ti ${container_id} bash /scripts/restore-backup.sh
done

echo "Check if the table 'my_custom_keyspace.my_table' was restored"
docker run -ti --rm --network host cassandra:3 cqlsh localhost 9042 -e 'select * from my_custom_keyspace.my_table;'
