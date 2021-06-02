#!/bin/bash

tmpfile=$(mktemp)

cat << EOF > ${tmpfile}

USE my_custom_keyspace;

DROP table my_table;
EOF

docker run -ti -v ${tmpfile}:${tmpfile} --rm --network host cassandra:3 cqlsh localhost 9042 --file ${tmpfile}

echo "Deleted table 'my_table'"
