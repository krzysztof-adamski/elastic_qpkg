#!/bin/sh
CONF=/etc/config/qpkg.conf
QPKG_NAME="Elk"
QPKG_ROOT=`/sbin/getcfg $QPKG_NAME Install_Path -f ${CONF}`

function create_env()
{
  PACKAGE_DIR=`/sbin/getcfg "${QPKG_NAME}" Install_Path -d "" -f ${CONF}`

  #Elasticsearch environment
  rm -rf /usr/local/elasticsearch
  ln -s ${PACKAGE_DIR} /usr/local/elasticsearch
}

function remove_env()
{

  PACKAGE_DIR=`/sbin/getcfg "${QPKG_NAME}" Install_Path -d "" -f ${CONF}`
  
  #stopp elasticsearch
  #remove symlink
  rm -rf /usr/local/elasticsearch

}


case "$1" in
  start)
    ENABLED=$(/sbin/getcfg $QPKG_NAME Enable -u -d FALSE -f $CONF)
    if [ "$ENABLED" != "TRUE" ]; then
        echo "$QPKG_NAME is disabled."
        exit 1
    fi
    create_env
    ;;

  stop)
    remove_env
    ;;

  restart)
    $0 stop
    $0 start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
esac

exit 0
