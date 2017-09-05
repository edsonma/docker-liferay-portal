FROM mdelapenya/liferay-portal:7-ce-ga4-tomcat-hsql

# Set maintainer of the docker image
MAINTAINER Antonio Musarra <antonio.musarra@gmail.com>
LABEL maintainer="Antonio Musarra <antonio.musarra@gmail.com>"

ENV WEB_SERVER_PROTOCOL=http
ENV URL_SECURITY_MODE=ip
ENV CONTAINER_DIR=/wedeploy-container

USER root

RUN apt-get update \
  && apt-get install tree

COPY ./configs/portal-ext.properties $LIFERAY_HOME/portal-ext.properties
COPY ./configs/entrypoint.sh $CATALINA_HOME/bin

RUN chmod +x $CATALINA_HOME/bin/entrypoint.sh

RUN \
  chown liferay:liferay $CATALINA_HOME/bin/entrypoint.sh \
  && chown liferay:liferay $LIFERAY_HOME/portal-ext.properties

USER liferay

ENTRYPOINT ["entrypoint.sh"]
