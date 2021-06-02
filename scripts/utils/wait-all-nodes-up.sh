#!/bin/bash

nodes_up=$(nodetool status | grep "UN" | wc -l)
total_nodes=3

while [ "${nodes_up}" -ne "${total_nodes}" ]
do
  echo "Waiting all nodes are up ${nodes_up}/${total_nodes}"
  sleep 10
  nodes_up=$(nodetool status | grep "UN" | wc -l)
done

echo "All ${nodes_up}/${total_nodes} nodes are up"
