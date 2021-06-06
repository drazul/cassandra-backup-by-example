# Cassandra backup by example

In this repository you will find a guide, with examples, to understand how we can manage our backups with Cassandra.

## Repository structure

* **docker-compose.yaml**: This file start a cassandra cluster using docker-compose. 
  The cluster mounts outside one data and backup folder by node
* **scripts**: This folder contains all scripts used in this guide
* **scripts/utils**: This folder contains scripts need to be run inside of each container

## Backup Support in Cassandra

Cassandra supports **full backups** (named snapshot) and **incremental backups**, but with some limitations.

Cassandra is a distributed database with a replication factor smaller than the number of nodes in the cluster.
This feature means each node will have a different set of data, and make the backup system more complicated.
In summary, we will need to back up and restore each node in the cluster individually.

Cassandra snapshot (full backup) is managed by the application named *nodetool*.
Nodetool can make snapshots for all or for a set of keyspaces and/or tables. Example:
```bash
nodetool snapshot ${keyspace_name} --tag ${snapshot_name}
```

Cassandra incremental backup is disabled by default and it can be enabled on the configuration file (`cassandra.yaml`), 
setting the value `incremental_backups` to `true`, or using nodetool application `nodetool enablebackup`

## How the backup system works in Cassandra

Cassandra backup system is very simple: it creates a hard link to the SSTable file used to store running data,
so we need to understand cassandra file structure first.

Cassandra manage stored data in a set of files, with an extension '.db', named SSTables.
Cassandra creates a new SSTable when it consolidates data or is forced to flush or compact data. SSTables are immutables.

Cassandra data files are stored by keyspace and by table version. `data_directory/keyspace_name/table_name-UUID`.

Snapshot data is stored in `data_directory/keyspace_name/table_name-UUID/snapshots/snapshot_name`.

Incremental backup data is managed by cassandra adding a hard link to each new SSTable created in the host.
This means the backup folder will store all SSTables, but we only need to store all generated files since latest full backup.
Incremental backup data is stored in in `data_directory/keyspace_name/table_name-UUID/snapshots/backups`.

![](./pictures/snapshot-structure.png)

**Note**: a hard link means referenced data will not be deleted meanwhile one link is still stored in the file system.
That means we will need to delete old data from snapshot folders and maybe backup folders.

