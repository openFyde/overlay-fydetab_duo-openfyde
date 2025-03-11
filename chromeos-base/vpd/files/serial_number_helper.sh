#!/bin/bash

get_serial_number() {
  local sn=""
  sn=$(grep 'Serial' /proc/cpuinfo  | awk '{print $3}' | tr -d ' ')
  if [[ -z "$sn" ]] || [[ "$sn" = "0000000000000000" ]]; then
    sn=$(cat /proc/device-tree/serial-number)
  fi
  echo "$sn"
}
