#!/bin/bash
CUR_DIR=`dirname $0`
. ${CUR_DIR}/adb_config.sh
PID=0x0006
USB_ATTRIBUTE=0x409
USB_STRINGS_DIR=${USB_CONFIGFS_DIR}/strings/${USB_ATTRIBUTE}
USB_FUNCTIONS_DIR=${USB_CONFIGFS_DIR}/functions
USB_FUNCTIONS_CNT=1

function_init()
{
  dblog "function_init"
  mkdir -p ${USB_FUNCTIONS_DIR}/ffs.adb
  mkdir -p ${USB_FUNCTIONS_DIR}/ffs.ntb
  mkdir -p ${USB_FUNCTIONS_DIR}/acm.gs6
  mkdir -p ${USB_FUNCTIONS_DIR}/mass_storage.0
}

configfs_init()
{
  dblog "Debug: configfs_init"
  mkdir -p /dev/usb-ffs

  #mount -t configfs none ${CONFIGFS_DIR}
  mkdir ${USB_CONFIGFS_DIR} -m 0770
  echo 0x2207 > ${USB_CONFIGFS_DIR}/idVendor
  echo $PID > ${USB_CONFIGFS_DIR}/idProduct
  echo 0x0310 > ${USB_CONFIGFS_DIR}/bcdDevice
  echo 0x0200 > ${USB_CONFIGFS_DIR}/bcdUSB
  mkdir ${USB_STRINGS_DIR}   -m 0770
  SERIAL=`cat /proc/cpuinfo | grep Serial | awk '{print $3}'`
  if [ -z $SERIAL ];then
    SERIAL=0123456789ABCDEF
  fi
  echo $SERIAL > ${USB_STRINGS_DIR}/serialnumber
  echo "rockchip"  > ${USB_STRINGS_DIR}/manufacturer
  echo "rk3xxx"  > ${USB_STRINGS_DIR}/product

  function_init

  mkdir ${USB_CONFIGS_DIR}  -m 0770
  mkdir ${USB_CONFIGS_DIR}/strings/${USB_ATTRIBUTE}  -m 0770

  echo 0x1 > ${USB_CONFIGFS_DIR}/os_desc/b_vendor_code
  echo "MSFT100" > ${USB_CONFIGFS_DIR}/os_desc/qw_sign
  echo 500 > ${USB_CONFIGS_DIR}/MaxPower
  ln -s ${USB_CONFIGS_DIR} ${USB_CONFIGFS_DIR}/os_desc/b.1
}

syslink_function() {
  ln -s ${USB_FUNCTIONS_DIR}/$1 ${USB_CONFIGS_DIR}/f${USB_FUNCTIONS_CNT}
  let USB_FUNCTIONS_CNT=USB_FUNCTIONS_CNT+1
}

pre_run_binary() {
  dblog "pre_run_binary"
	mkdir -p /dev/usb-ffs/adb -m 0770
  mount -o uid=2000,gid=2000 -t functionfs adb /dev/usb-ffs/adb
}


main() {
  dblog "pre-start"
  configfs_init
  syslink_function ffs.adb
  pre_run_binary
}

main $@
