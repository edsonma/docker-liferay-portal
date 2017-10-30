# Liferay 7 Community Edition GA5 Docker Compose project
On October 23, 2017, [Liferay GA5 was released](https://community.liferay.com/news/liferay-portal-7-0-ce-ga5-release/). The great news was the return of the cluster.

This repository contains a [Docker Compose](https://docs.docker.com/compose/overview/) project that allows you to get within a few minutes a Liferay cluster composed of two working nodes.

This Docker Compose contains this services:

1. lb-haproxy: HA Proxy as Load Balancer
2. liferay-portal-node-1: Liferay 7 GA5 (with cluster support) node 1
3. liferay-portal-node-2: Liferay 7 GA5 (with cluster support) node 2
4. postgres: PostgreSQL 10 database
5. es-node-1 and es-node-2: Elasticsearch Cluster nodes

As for the shared directory for the Liferay document library, I decided to use a shared dock volume instead of NSF.

_Consider that this project is intended for cluster development and testing._


For more information about Liferay Cluster you can read this [Liferay Portal Clustering](https://dev.liferay.com/discover/deployment/-/knowledge_base/7-0/liferay-clustering) on Liferay Developer Network.

The configs directory contains the following items:

1. Cluster OSGi Bundle
  * com.liferay.portal.cache.ehcache.multiple.jar
  * com.liferay.portal.cluster.multiple.jar
  * com.liferay.portal.scheduler.multiple.jar
2. OSGi configs
  * BundleBlacklistConfiguration.config: contains the list of bundles that need not be installed
  * ElasticsearchConfiguration.config: contains elastic cluster configuration
  * AdvancedFileSystemStoreConfiguration.cfg: contains the configuration of the document library
3. Portal properties
  * portal-ext.properties: contains common configurations for Liferay, such as database connection, cluster enabling, document library, etc.
4. HA Proxy
  * haproxy.cfg: It contains the configuration to expose an endpoint http which balances the two Liferay nodes.

## Usage
To start a services from this Docker Compose, please run following `docker-compose` command, which will start a Liferay Portal 7 GA5 with cluster support running on Tomcat 8.0.32:

For the first start, proceed as follows:
```bash
$ docker-compose up -d liferay-portal-node-1
```

You can view output from containers following `docker-compose logs` or `docker-compose logs -f` for follow log output.

After the first Liferay node is on (liferay-portal-node-1), then run:
```bash
$ docker-compose up -d liferay-portal-node-2
```

After the two Liferay nodes are up, then pull the HA Proxy:
```bash
$ docker-compose up -d lb-haproxy
```

For the next start, you can run the only command:
```bash
$ docker-compose up -d
```

If you encounter (ERROR: An HTTP request took too long to complete) this issue regularly because of slow network conditions, consider setting COMPOSE_HTTP_TIMEOUT to a higher value (current value: 60).

```bash
$ COMPOSE_HTTP_TIMEOUT=200 docker-compose up -d
```

After all the services are up, you can reach Liferay this way:

1. Via HA Proxy or Load Balancer at URL http://localhost
2. Accessing directly to the nodes:
  * Liferay Node 1: http://localhost:6080
  * Liferay Node 2: http://localhost:7080

You can access the HA Proxy statistics report in this way: http://localhost:8181 (username/password: liferay/liferay)

In my case, I inserted the following entries on my /etc/ hosts file:

```bash
##
# Liferay 7 CE GA5 Cluster
##
127.0.0.1	liferay-portal-node-1.local
127.0.0.1	liferay-portal-node-2.local
127.0.0.1	liferay-portal.local
127.0.0.1	liferay-lb.local
```
To access Liferay through HA Proxy goto your browser at http://liferay-lb.local

Would you like to see Liferay 7 CE GA5 Cluster in action? Well, then go [Cluster in Action]( https://twitter.com/antonio_musarra/status/924070869336551424)

## JGroups cluster support
This cluster support is limited to EhCache RMI replication. RMI is known to not scale well when increasing the number of cluster nodes. It creates more threads when adding more nodes to the cluster. They can cause server nodes to decrease its performance and even to crash.

[Juan Gonzalez](https://twitter.com/gonpinju) made the needed changes from Liferay 7 CE GA5 sources to change RMI to JGroups.

For more detailed information, I suggest you read [Liferay Portal 7 CE GA5 with JGroups cluster support]( https://web.liferay.com/community/forums/-/message_boards/message/97704861)


# License
These docker images are free software ("Licensed Software"); you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

These docker images are distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; including but not limited to, the implied warranty of MERCHANTABILITY, NONINFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
