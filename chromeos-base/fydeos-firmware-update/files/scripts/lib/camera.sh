#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

source "$SCRIPT_ROOT_DIR"/lib/common.sh

declare -r CAMERA_FIRMWARE_UPDATE_TOOL_BIN="/usr/bin/camera_firmware_update_tool"
declare -r SUPPORTED_CAMERA_DEVICE_IDS=( "1bcf:28c4" )

_get_current_camera_firmware_version() {
  local id="$1"
  local version=""
  version=$(lsusb -d "$id" -v  | grep bcdDevice | awk '{print $2}' || echo "")
  echo "$version"
}

_stop_cros_camera_service() {
  info "Stopping cros-camera service"
  initctl stop cros-camera || { error "Failed to stop cros-camera service"; return 1; }
  sleep 2
  info "cros-camera service stopped"
}

_start_cros_camera_service() {
  info "Starting cros-camera service"
  initctl start cros-camera || { warn "Failed to start cros-camera service"; return 1; }
  sleep 2
  info "cros-camera service started"
}

_local_check_for_update() {
  local id="$1"
  local result=""
  local version=""

  result=$(_query_firmware_version_info "$id")
  if [[ -z "$result" ]]; then
    debug "No upgradable firmware found for camera device: $id"
    return 1
  fi
  if ! _basic_validate_firmware "$result"; then
    error "Failed to validate firmware metadata"
    return 1
  fi

  version=$(echo "$result" | awk -F ',' '{print $2}')

  local current_version=""
  current_version=$(_get_current_camera_firmware_version "$id")
  if ! _is_newer_version "$current_version" "$version"; then
    debug "Camera firmware is up to date: $current_version"
    return 1
  fi

  echo "$result"
  return 0
}

_pre_update_camera_firmware() {
  _print_preparing
  _stop_cros_camera_service
}

_update_camera_firmware() {
  local id="$1"
  local file="$2"

  local vendor_id=""
  local product_id=""
  vendor_id=$(echo "$id" | cut -d: -f1)
  product_id=$(echo "$id" | cut -d: -f2)
  local ok="true"
  if [[ -z "$vendor_id" ]]; then
    error "vendor_id is empty"
    ok="false"
  fi
  if [[ -z "$product_id" ]]; then
    error "product_id is empty"
    ok="false"
  fi
  if [[ ! -f "$file" ]]; then
    error "file not found: $file"
    ok="false"
  fi
  if [[ "$ok" = "false" ]]; then
    return 1
  fi
  _print_writing
  "$CAMERA_FIRMWARE_UPDATE_TOOL_BIN" -V "$vendor_id" -P "$product_id" -u "$file"
}

_post_update_camera_firmware() {
  _print_almost_done
  _start_cros_camera_service
}

list_upgradable_camera_devices() {
  local name=""
  local result=""
  for id in "${SUPPORTED_CAMERA_DEVICE_IDS[@]}"; do
    if result=$(_local_check_for_update "$id" 2> /dev/null); then
      name=$(get_device_name "$id")
      combine_print_id_name_and_detail "$id" "$name" "$result"
    fi
  done
}

update_camera_firmware() {
  local id="$1"
  local result=""
  if ! result=$(_local_check_for_update "$id"); then
    error "Failed to check for camera firmware update"
    return 1
  fi
  local file=""
  file=$(echo "$result" | awk -F ',' '{print $1}')
  _pre_update_camera_firmware
  if _update_camera_firmware "$id" "$file"; then
    info "Successfully updated camera firmware"
  else
    error "Failed to update camera firmware"
  fi
  _post_update_camera_firmware
}
