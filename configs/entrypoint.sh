#!/bin/bash
set -e

echo "Applying the liferay configuration via portal-ext.properties"
echo "The two environment variables are: {WEB_SERVER_PROTOCOL, URL_SECURITY_MODE}"

sed -i -e "s/web\.server\.protocol=http$/web\.server\.protocol=$WEB_SERVER_PROTOCOL/g" $LIFERAY_HOME/portal-ext.properties
sed -i -e "s/redirect\.url\.security\.mode=ip$/redirect\.url\.security\.mode=$URL_SECURITY_MODE/g" $LIFERAY_HOME/portal-ext.properties

echo "Content of the portal-ext.properties after applying the changes."

cat $LIFERAY_HOME/portal-ext.properties

echo "Starting Liferay..."
catalina.sh run
