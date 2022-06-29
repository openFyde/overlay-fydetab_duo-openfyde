#!/bin/bash
CUR_DIR=`dirname $0`
. ${CUR_DIR}/adb_config.sh
main() {
  echo "none" > ${USB_CONFIGFS_DIR}/UDC
  ls ${USB_CONFIGS_DIR} | grep f[0-9] | xargs -I {} rm ${USB_CONFIGS_DIR}/{}
  dblog "post stop exit."
}

main $@
