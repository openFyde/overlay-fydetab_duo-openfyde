#!/bin/bash
USB_GROUP=rockchip
USB_SKELETON=b.1
CONFIGFS_DIR=/sys/kernel/config
USB_CONFIGFS_DIR=${CONFIGFS_DIR}/usb_gadget/${USB_GROUP}
USB_CONFIGS_DIR=${USB_CONFIGFS_DIR}/configs/${USB_SKELETON}

dblog() {
  if [ -n "${UPSTART_JOB}" ]; then
    logger -t "${UPSTART_JOB}" $@
  else
    echo "adbd:" $@
  fi
}
