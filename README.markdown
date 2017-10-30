# About this repo
This repository contains some **nonofficial** pet-projects on how to use Liferay with Docker.

For more information about Liferay Cluster you can read this [Liferay Portal Clustering](https://dev.liferay.com/discover/deployment/-/knowledge_base/7-0/liferay-clustering).

Liferay Portal 7 CE GA5 with JGroups cluster support https://web.liferay.com/community/forums/-/message_boards/message/97704861

https://github.com/juangon/liferay-portal/tree/7.0.4-ga5-cluster-jgroups

portal-cache-ehcache-provider, portal-cache-ehcache

# Usage
To start a container from this image please run following `docker-compose` command, which will start a Liferay Portal 7 GA5 instance running on Tomcat 8.0.32, with a PostgreSQL 10 database instance running in another container:

First start:

```bash
$ docker-compose up -d liferay-portal-node-1
```

After Liferay (on liferay-portal-node-1) is up then:

```bash
$ docker-compose up -d liferay-portal-node-2
```

If you encounter (ERROR: An HTTP request took too long to complete) this issue regularly because of slow network conditions, consider setting COMPOSE_HTTP_TIMEOUT to a higher value (current value: 60).

```bash
$ COMPOSE_HTTP_TIMEOUT=200 docker-compose up
```

You can view output from containers following `docker-compose logs` or `docker-compose logs -f` for follow log output.

# License
These docker images are free software ("Licensed Software"); you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

These docker images are distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; including but not limited to, the implied warranty of MERCHANTABILITY, NONINFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
