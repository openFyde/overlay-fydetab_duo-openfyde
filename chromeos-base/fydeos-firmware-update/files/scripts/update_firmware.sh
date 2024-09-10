#!/usr/bin/env bash

SCRIPT_ROOT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" >/dev/null 2>&1 && pwd)"
readonly SCRIPT_ROOT_DIR

source "$SCRIPT_ROOT_DIR"/lib/camera.sh
source "$SCRIPT_ROOT_DIR"/lib/uboot.sh
source "$SCRIPT_ROOT_DIR"/lib/spl_loader.sh

set -o errexit
set -o nounset
set -o pipefail

list_upgradable_devices() {
  local result=""
  local cameras=""
  cameras="$(list_upgradable_camera_devices)"
  result="$cameras"
  local uboot=""
  uboot="$(list_upgradable_uboot)"
  result="$(printf "%s\n%s" "$result" "$uboot")"
  local spl_loader=""
  spl_loader="$(list_upgradable_spl_loader)"
  result="$(printf "%s\n%s" "$result" "$spl_loader")"
  # append other types of supported devices here
 
  print_raw_txt_list_as_json "$result"
}

upgrade_device() {
  local target_id="$1"
  local id=""
  local find=0
  for id in "${SUPPORTED_CAMERA_DEVICE_IDS[@]}"; do
    if [[ "$id" == "$target_id" ]]; then
      find=1
      update_camera_firmware "$target_id"
      break
    fi
  done
  if [[ "$target_id" == "$UBOOT_PHONY_DEVICE_ID" ]]; then
    find=1
    update_uboot
  fi
  if [[ "$target_id" == "$SPL_LOADER_PHONY_DEVICE_ID" ]]; then
    find=1
    update_spl_loader
  fi
  # append other types of supported devices here

  if ! (( find )); then
    error "Unsupported device ID: $target_id"
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
