#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

source "$SCRIPT_ROOT_DIR"/lib/common.sh

declare -r UBOOT_PHONY_DEVICE_ID="u-boot"
declare -r UBOOT_PHONY_FIRMWARE_FILE="/tmp/u-boot-placeholder.img" # won't be used, but the UI need a absolute path to call the updater
declare -r UBOOT_UPDATER_BIN="/sbin/u-boot-updator.sh"

declare -r TARGET_UBOOT_VERSION_FILE="/boot/.uboot_version"

declare -r UBOOT_VERSION_KEY="uboot_version"

_get_current_uboot_version_from_vpd() {
  local version=""
  version=$(vpd -g "$UBOOT_VERSION_KEY" 2>/dev/null || echo "0.0.0")
  echo "$version"
}

_get_target_uboot_version() {
  local version=""
  if [[ -f "$TARGET_UBOOT_VERSION_FILE" ]]; then
    version=$(cat "$TARGET_UBOOT_VERSION_FILE")
  fi
  if [[ -z "$version" ]]; then
    version="0.0.0"
  fi
  echo "$version"
}

_local_check_for_uboot_update() {
  local version=""

  version=$(_get_target_uboot_version)
  local current_version=""
  current_version=$(_get_current_uboot_version_from_vpd)
  if ! _is_newer_version "$current_version" "$version"; then
    debug "u-boot firmware is up to date: $current_version"
    return 1
  fi

  echo "$version"
  return 0
}

list_upgradable_uboot() {
  if [[ ! -f "$UBOOT_UPDATER_BIN" ]] || [[ ! -x "$UBOOT_UPDATER_BIN" ]]; then
    return
  fi
  local name='Universal Boot Loader'
  local id="$UBOOT_PHONY_DEVICE_ID"
  local file="$UBOOT_PHONY_FIRMWARE_FILE"
  local checksum="placeholder"
  local version=""
  if version=$(_local_check_for_uboot_update 2> /dev/null); then
    echo "$id,$name,$file,$version,$checksum"
  fi
}

update_uboot() {
  _print_preparing
  if [[ ! -f "$UBOOT_UPDATER_BIN" ]] || [[ ! -x "$UBOOT_UPDATER_BIN" ]]; then
    return 1
  fi
  sleep 0.3
  _print_writing
  if "$UBOOT_UPDATER_BIN"; then
    info "Successfully updated u-boot firmware"
  else
    error "Failed to update u-boot firmware"
  fi
  _print_almost_done
}
