#!/bin/bash

#https://gokhanatil.com/2018/02/build-a-cassandra-cluster-on-docker.html

sudo docker run --name cas1 -p 9042:9042 -e CASSANDRA_CLUSTER_NAME=MyCluster -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch -e CASSANDRA_DC=datacenter1 -d cassandra

echo "Recommended to wait 2 minutes between nodes coming online.  Waiting 30 seconds."
sleep 30

sudo docker run --name cas2 -e CASSANDRA_SEEDS="$(sudo docker inspect --format='{{ .NetworkSettings.IPAddress }}' cas1)" -e CASSANDRA_CLUSTER_NAME=MyCluster -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch -e CASSANDRA_DC=datacenter1 -d cassandra

echo "Recommended to wait 2 minutes between nodes coming online.  Waiting 30 seconds."
sleep 30
 
sudo docker run --name cas3 -e CASSANDRA_SEEDS="$(sudo docker inspect --format='{{ .NetworkSettings.IPAddress }}' cas1)" -e CASSANDRA_CLUSTER_NAME=MyCluster -e CASSANDRA_ENDPOINT_SNITCH=GossipingPropertyFileSnitch -e CASSANDRA_DC=datacenter2 -d cassandra

echo "Waiting 30 seconds for nodes to come online and connect"
sleep 30

echo "Getting cassandra cluster nodetool status:"

sudo docker exec -ti cas1 nodetool status

echo "Installing pip3"

sudo apt-get install python3-pip

echo "Installing cassandra python driver"

sudo pip3 install cassandra-driver

echo "Initializing Cassandra keyspace and table"

python3 cassandra_setup.py

echo "Starting http server"

python3 cassandra_server.py



#sudo docker exec -ti cas1 cqlsh
