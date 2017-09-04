FROM mdelapenya/liferay-portal:7-ce-ga4-tomcat-hsql

# Set maintainer of the docker image
MAINTAINER Antonio Musarra <antonio.musarra@gmail.com>
LABEL maintainer="Antonio Musarra <antonio.musarra@gmail.com>"

ENV WEB_SERVER_PROTOCOL=http
ENV URL_SECURITY_MODE=ip

USER root

RUN \
  mkdir /deploy \
  && chown liferay:liferay /deploy

COPY ./configs/portal-ext.properties $LIFERAY_HOME/portal-ext.properties
COPY ./configs/entrypoint.sh $CATALINA_HOME/bin

RUN chmod +x $CATALINA_HOME/bin/entrypoint.sh

RUN \
  chown liferay:liferay $CATALINA_HOME/bin/entrypoint.sh \
  && chown liferay:liferay $LIFERAY_HOME/portal-ext.properties

USER liferay

VOLUME ["/deploy"]
ENTRYPOINT ["entrypoint.sh"]
