#!/bin/bash

docker-compose up -d

docker exec -ti $(basename $(pwd))_cassandra-0_1 bash /scripts/wait-all-nodes-up.sh
