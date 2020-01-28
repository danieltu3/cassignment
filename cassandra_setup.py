from cassandra.cluster import Cluster

cluster = Cluster()
session = cluster.connect()
session.execute("CREATE KEYSPACE timestamp_keyspace WITH replication = {'class':'NetworkTopologyStrategy', 'datacenter1': 1, 'datacenter2' : 1};")
session.execute("CREATE TABLE timestamp_keyspace.timestamp_table (ping_time timestamp primary key, message text);")