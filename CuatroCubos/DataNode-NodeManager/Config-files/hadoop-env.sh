#!/bin/bash

export JAVA_HOME=${JAVA_HOME}
export HADOOP_CLIENT_OPTS="-Xmx1G \${HADOOP_CLIENT_OPTS}"
export HADOOP_OPTS="\${HADOOP_OPTS}"

# --- Configuración de RAM para Daemons de HDFS ---
# 1 GB para el NameNode
export HADOOP_NAMENODE_HEAPSIZE=1024
# 1 GB para cada DataNode
export HADOOP_DATANODE_HEAPSIZE=1024

# --- Configuración de RAM para Daemons de YARN ---
# 1 GB para el ResourceManager
export YARN_RESOURCEMANAGER_HEAPSIZE=1024
# 1 GB para cada NodeManager
export YARN_NODEMANAGER_HEAPSIZE=1024

export HDFS_NAMENODE_USER=hdadmin
export HDFS_DATANODE_USER=hdadmin
export HDFS_SECONDARYNAMENODE_USER=hdadmin
export YARN_RESOURCEMANAGER_USER=hdadmin
export YARN_NODEMANAGER_USER=hdadmin