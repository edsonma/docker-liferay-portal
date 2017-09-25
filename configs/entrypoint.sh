#!/bin/bash
##
# Entrypoint scripts for starting Liferay 7 Community Edition GA 4
# with the support for hot deploy, configs portal properties
# and OSGi Configuration on WeDeploy.
#
# @author Antonio Musarra <antonio.musarra@gmail.com>
#
##
set -e

LIFERAY_DATA=/opt/liferay

main() {
  show_motd
  preparing_liferay_data_directory
  check_liferay_portal_properties_configs_directory
  check_liferay_deploy_directory
  check_liferay_osgi_configs_directory
  overwrite_liferay_portal_properties_from_env
  run
}

show_motd() {
  echo "Starting Liferay 7 Community Edition GA4 instance (HSQL version)."
  echo "LIFERAY_HOME: $LIFERAY_HOME"
  echo
}

preparing_liferay_data_directory() {
  echo "Preparing Liferay data directory layout..."
  echo "Checking Liferay data directory..."
  echo

  if [[ $LIFERAY_CLEAN_DATA_DIR == "true" ]]; then
    echo "Cleaning liferay data directory..."
    echo

    rm -rf /opt/liferay/data
    rm -rf /opt/liferay/deploy
    rm -rf /opt/liferay/osgi
    rm -rf /opt/liferay/configs

    echo "Cleaning liferay data directory...[OK]"
    echo
  fi

  if [[ ! -d "$LIFERAY_DATA/data" ]]; then
    echo "Checking Liferay data directory...[NOT FOUND]"
    echo

    mkdir -p /opt/liferay/data
    mkdir -p /opt/liferay/deploy
    mkdir -p /opt/liferay/osgi
    mkdir -p /opt/liferay/configs

    cp -a $LIFERAY_HOME/osgi/* $LIFERAY_DATA/osgi

    tree -L 2 $LIFERAY_DATA
    echo "Checking Liferay data directory...[CREATED]"
    echo
  fi

  echo "Preparing a symlink for $LIFERAY_HOME..."
  echo

  rm -rf $LIFERAY_HOME/data
  rm -rf $LIFERAY_HOME/deploy
  rm -rf $LIFERAY_HOME/configs
  rm -rf $LIFERAY_HOME/osgi

  ln -s $LIFERAY_DATA/data $LIFERAY_HOME/data
  ln -s $LIFERAY_DATA/deploy $LIFERAY_HOME/deploy
  ln -s $LIFERAY_DATA/osgi $LIFERAY_HOME/osgi
  ln -s $LIFERAY_DATA/configs $LIFERAY_HOME/configs

  mv $LIFERAY_HOME/portal-ext.properties $LIFERAY_DATA/portal-ext.properties
  ln -s $LIFERAY_DATA/portal-ext.properties $LIFERAY_HOME/portal-ext.properties

  tree -L 1 $LIFERAY_HOME

  echo "Preparing a symlink for $LIFERAY_HOME...[DONE]"
  echo "Preparing Liferay data directory layout...[OK]"
  echo "Checking Liferay data directory...[OK]"
  echo
}

check_liferay_portal_properties_configs_directory() {
  echo "Checking Portal properties directory $CONTAINER_DIR/configs..."

  if [[ ! -d "$CONTAINER_DIR/configs" ]]; then
    echo "Checking Portal properties directory $CONTAINER_DIR/configs...[NOT FOUND]"
    echo
  else
    echo "Checking Portal properties directory $CONTAINER_DIR/configs...[FOUND]"
    echo "Copying Portal properties directory $LIFERAY_HOME/configs..."

    tree $CONTAINER_DIR/configs
    mkdir -p $LIFERAY_HOME/configs
    cp -r $CONTAINER_DIR/configs/*.properties $LIFERAY_HOME/configs

    echo "Copying Portal properties directory $LIFERAY_HOME/configs...[OK]"
    echo
  fi

  echo "Checking Portal portal-ext.properties file $CONTAINER_DIR..."

  if [[ ! -f "$CONTAINER_DIR/portal-ext.properties" ]]; then
    echo "Checking Portal portal-ext.properties file $CONTAINER_DIR/...[NOT FOUND]"
    echo
  else
    echo "Checking Portal portal-ext.properties file $CONTAINER_DIR/...[FOUND]"

    cp $CONTAINER_DIR/portal-ext.properties $LIFERAY_DATA/portal-ext.properties

    echo "Checking Portal portal-ext.properties file $CONTAINER_DIR/...[OK]"
    echo
  fi
}

overwrite_liferay_portal_properties_from_env() {
  echo "Applying the liferay configuration via default portal-ext.properties"
  echo "The two environment variables are:
    {
      LIFERAY_WEB_SERVER_PROTOCOL = $LIFERAY_WEB_SERVER_PROTOCOL
      LIFERAY_URL_SECURITY_MODE = $LIFERAY_URL_SECURITY_MODE
      LIFERAY_PUBLISH_GOGO_SHELL = $LIFERAY_PUBLISH_GOGO_SHELL
    }"

  sed -i -e "s/web\.server\.protocol=http$/web\.server\.protocol=$LIFERAY_WEB_SERVER_PROTOCOL/g" $LIFERAY_DATA/portal-ext.properties
  sed -i -e "s/redirect\.url\.security\.mode=ip$/redirect\.url\.security\.mode=$LIFERAY_URL_SECURITY_MODE/g" $LIFERAY_DATA/portal-ext.properties

  if [[ $LIFERAY_PUBLISH_GOGO_SHELL == "true" ]]; then
    sed -i -e "s/module\.framework\.properties\.osgi\.console=localhost:11311$/module\.framework\.properties\.osgi\.console=0\.0\.0\.0:11311/g" $LIFERAY_DATA/portal-ext.properties
  fi

  echo "Content of the portal-ext.properties after applying the changes."
  echo
  cat $LIFERAY_HOME/portal-ext.properties
  echo
}

check_liferay_deploy_directory() {
  echo "Checking deploy directory $CONTAINER_DIR/deploy..."

  if [[ ! -d "$CONTAINER_DIR/deploy" ]]; then
    echo "Checking deploy directory $CONTAINER_DIR/deploy...[NOT FOUND]"
    echo
  else
    echo "Checking deploy directory $CONTAINER_DIR/deploy...[FOUND]"
    echo "Copying bundle to auto deploy directory $LIFERAY_HOME/deploy..."

    tree $CONTAINER_DIR/deploy
    mkdir -p $LIFERAY_HOME/deploy
    cp -r $CONTAINER_DIR/deploy/* $LIFERAY_HOME/deploy

    echo "Copying bundle to auto deploy directory $LIFERAY_HOME/deploy...[OK]"
    echo
  fi
}

check_liferay_osgi_configs_directory() {
  echo "Checking OSGi configuration directory $CONTAINER_DIR/osgi-configs..."

  if [[ ! -d "$CONTAINER_DIR/osgi-configs" ]]; then
    echo "Checking OSGi configuration directory $CONTAINER_DIR/osgi-configs...[NOT FOUND]"
    echo
  else
    echo "Checking OSGi configuration directory $CONTAINER_DIR/osgi-configs...[FOUND]"
    echo "Copying OSGi configuration to directory $LIFERAY_HOME/osgi/configs..."

    tree $CONTAINER_DIR/osgi-configs
    mkdir -p $LIFERAY_HOME/osgi/configs
    cp -r $CONTAINER_DIR/osgi-configs/*.{cfg,config} $LIFERAY_HOME/osgi/configs

    echo "Copying OSGi configuration to directory $LIFERAY_HOME/osgi/configs...[OK]"
    echo
  fi
}

run() {
  exec catalina.sh run
}

main "$@"
