#!/bin/bash
CUR_DIR=`dirname $0`
. ${CUR_DIR}/adb_config.sh
main() {
  sleep 1
  UDC=`ls /sys/class/udc/| awk '{print $1}'`
  echo $UDC > ${USB_CONFIGFS_DIR}/UDC
  dblog "exit post-start"
}

main $@
