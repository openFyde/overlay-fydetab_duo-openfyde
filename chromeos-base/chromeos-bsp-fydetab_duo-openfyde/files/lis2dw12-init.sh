#!/bin/bash
DEVICE=$1
IIO_DEVICE_PATH="/sys/bus/iio/devices/${DEVICE}"

set_sysfs_entry() {
  local name="$1"
  local value="$2"

  echo "${value}" > "${name}"
}

main() {
  for axis in x y z; do
    set_sysfs_entry ${IIO_DEVICE_PATH}/in_accel_${axis}_scale 0.076570
  done
  set_sysfs_entry ${IIO_DEVICE_PATH}/sampling_frequency 50
  chmod 666 /dev/${DEVICE}
  mkdir /dev/cros-ec-accel
  ln -sf ../${DEVICE} /dev/cros-ec-accel/${DEVICE: -1}
}

main $@
