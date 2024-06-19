#!/usr/bin/env bash

SCRIPT_ROOT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" >/dev/null 2>&1 && pwd)"
readonly SCRIPT_ROOT_DIR

source "$SCRIPT_ROOT_DIR"/lib/camera.sh

set -o errexit
set -o nounset
set -o pipefail

list_upgradable_devices() {
  local result=""
  cameras="$(list_upgradable_camera_devices)"
  result="$cameras"

  # append other types of supported devices here
 
  print_raw_txt_list_as_json "$result"
}

upgrade_device() {
  local id=""
  local find=0
  for id in "${SUPPORTED_CAMERA_DEVICE_IDS[@]}"; do
    if [[ "$id" == "$1" ]]; then
      find=1
      update_camera_firmware "$1"
      break
    fi
  done
  # append other types of supported devices here
  ##
  if ! (( find )); then
    error "Unsupported device ID: $1"
  fi
}

usage() {
  echo "Usage: $0 [-l] [-u <device_id>]"
  echo "  -l              List upgradable devices"
  echo "  -u <device_id>  Upgrade specified device by ID"
  exit 1
}

main() {
  local list_flag=0
  local upgrade_flag=0
  local device_id=""

  while getopts "lu:" opt; do
    case $opt in
      l)
        list_flag=1
        ;;
      u)
        upgrade_flag=1
        device_id="$OPTARG"
        ;;
      *)
        usage
        ;;
    esac
  done

  if (( list_flag )); then
    list_upgradable_devices
  elif (( upgrade_flag )); then
    if [[ -z "$device_id" ]]; then
      error "Missing device ID"
      usage
    fi
    upgrade_device "$device_id"
  else
    usage
  fi
}

main "$@"
