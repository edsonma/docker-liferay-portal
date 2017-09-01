FROM mdelapenya/liferay-portal:7-ce-ga4-tomcat-hsql
MAINTAINER Manuel de la Peña <manuel.delapenya@liferay.com>

ENV LIFERAY_ORACLE_DRIVER_VERSION=1.0.0
ENV TOMCAT_DIR=$LIFERAY_HOME/tomcat-8.0.32

ENV DOCKERIZE_VERSION v0.5.0

USER root

RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

USER liferay

RUN \
  cd /tmp; \
  wget http://central.maven.org/maven2/it/dontesta/labs/liferay/portal/db/liferay-portal-database-all-in-one-support/${LIFERAY_ORACLE_DRIVER_VERSION}/liferay-portal-database-all-in-one-support-${LIFERAY_ORACLE_DRIVER_VERSION}.jar; \
  cp liferay-portal-database-all-in-one-support-${LIFERAY_ORACLE_DRIVER_VERSION}.jar ${TOMCAT_DIR}/webapps/ROOT/WEB-INF/lib; \
  rm liferay-portal-database-all-in-one-support-${LIFERAY_ORACLE_DRIVER_VERSION}.jar

COPY ./configs/portal-ext.properties $LIFERAY_HOME/portal-ext.properties
COPY ./configs/ojdbc8.jar ${TOMCAT_DIR}/lib/ext

ENTRYPOINT dockerize -wait tcp://oracle:1521 -wait-retry-interval 60s -timeout 60s catalina.sh run
