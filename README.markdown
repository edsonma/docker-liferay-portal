# About this repo
This repository contains some **nonofficial** pet-projects on how to use Liferay with Docker.

To add support for Oracle database was used [Liferay CE 7.0 Database All In One Driver Support](https://github.com/amusarra/liferay-portal-database-all-in-one-support).

# Usage
To start a container from this image please run following `docker-compose` command, which will start a Liferay Portal 7 GA5 instance running on Tomcat 8.0.32, with a Oracle12c database instance running in another container:

```bash
$ docker-compose up -d
```

You can view output from containers following `docker-compose logs` or `docker-compose logs -f` for follow log output.

# License
These docker images are free software ("Licensed Software"); you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation; either version 2.1 of the License, or (at your option) any later version.

These docker images are distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; including but not limited to, the implied warranty of MERCHANTABILITY, NONINFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with this library; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
