#!/bin/bash

tmpfile=$(mktemp)

cat << EOF > ${tmpfile}

CREATE KEYSPACE IF NOT EXISTS my_custom_keyspace
WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 3};

USE my_custom_keyspace;

CREATE TABLE IF NOT EXISTS my_table (
    id int,
    k int,
    v text,
    PRIMARY KEY (id)
);

INSERT INTO my_table (id, k, v) VALUES (0, 0, 'val0');
INSERT INTO my_table (id, k, v) VALUES (1, 1, 'val1');
INSERT INTO my_table (id, k, v) VALUES (1, 2, 'val2');
INSERT INTO my_table (id, k, v) VALUES (2, 2, 'val3');

CREATE TABLE IF NOT EXISTS my_table_2 (
    id int,
    k int,
    v text,
    PRIMARY KEY (id)
);

INSERT INTO my_table_2 (id, k, v) VALUES (0, 0, 'val0');
INSERT INTO my_table_2 (id, k, v) VALUES (1, 1, 'val1');
INSERT INTO my_table_2 (id, k, v) VALUES (2, 2, 'val2');

EOF

docker run -ti -v ${tmpfile}:${tmpfile} --rm --network host cassandra:3 cqlsh localhost 9042 --file ${tmpfile}

echo "Created keyspace with name 'my_custom_keyspace' and tables 'my_table' and 'my_table_2' with few rows"
