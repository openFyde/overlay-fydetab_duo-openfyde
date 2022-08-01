#!/bin/sh
OEM_PATH=/usr/share/oem
SHIPPING_MODE_KEY=shipping_mode
VPD="/usr/sbin/vpd -i RW_VPD"
SBS_PATH="/sys/devices/platform/fead0000.i2c/i2c-5/5-000b/shipping_mode"

die() {
  logger -t "set_battery_mode" "Error:" $@
  exit 1
}

remount_oem_writable() {
    mount -o remount,rw "$OEM_PATH"
}

remount_oem_readonly() {
    mount -o remount,ro "$OEM_PATH"
}

set_shipping_mode() {
  local mode=$1
  remount_oem_writable
  $VPD -s ${SHIPPING_MODE_KEY}=${mode}
  remount_oem_readonly
}

get_shipping_mode() {
  local mode=$($VPD -g ${SHIPPING_MODE_KEY} 2>/dev/null)
  if [ -z "$mode" ]; then
    set_shipping_mode 0
    echo 1
  fi
  echo $mode
}

main() {
  local mode=$(get_shipping_mode)
  if [ "$mode" -eq 1 ]; then
    set_shipping_mode 0
    /bin/sync
    /usr/bin/sleep 1
    echo 16 > $SBS_PATH
  fi
}

main
