#!/bin/bash

OEM_PATH=/usr/share/oem
LICENCE=${OEM_PATH}/.oem_licence

die() {
  logger -t "${JOB}" "Error:" "$@"
  exit 1 
}

get_serial_number() {
  grep 'Serial' /proc/cpuinfo  | awk '{print $3}' | tr -d ' '
}

is_booting_from_usb() {
  udevadm info "$(rootdev -d)" | grep ID_BUS |grep -q usb
}

remount_oem_writable() {
  mount -o remount,rw "$OEM_PATH"
}

remount_oem_readonly() {
  mount -o remount,ro "$OEM_PATH"
}

count_chars() {
  printf "%s" "$1" | wc -c
}

update_serial_number() {
	local serial=$1
  vpd -i RO_VPD  \
    -s "serial_number=${serial}"
  dump_vpd_log --force
}

check_vpd() {
  if [ ! -s "${LICENCE}" ]; then
    gzip -d /usr/share/cros/init/vpd.gz -c > ${LICENCE}
  fi
}

check_serial_number() {
  local serial=""
  local new_sn=""
  serial=$(vpd -i RO_VPD -g serial_number 2>/dev/null)
  new_sn=$(get_serial_number)
  if [ -z "$new_sn" ]; then 
    exit 1
  fi
  if [ "$serial" != "$new_sn" ]; then
    if is_booting_from_usb; then
      update_serial_number "$new_sn"
    elif [ -z "$serial" ]; then
      update_serial_number "$new_sn"
    fi
  fi
}

remount_oem_writable || die "Remount OEM partition failed"
check_vpd || die "Cann't init vpd system"
check_serial_number
remount_oem_readonly
