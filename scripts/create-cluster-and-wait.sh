#!/bin/bash

docker-compose up -d

docker exec -ti cassandra-backup-examples_cassandra-0_1 bash /scripts/wait-all-nodes-up.sh
