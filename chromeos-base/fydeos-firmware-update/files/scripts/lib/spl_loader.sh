#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

source "$SCRIPT_ROOT_DIR"/lib/common.sh

declare -r SPL_LOADER_PHONY_DEVICE_ID="spl-loader"
declare -r SPL_LOADER_PHONY_FIRMWARE_FILE="/tmp/spl-loader-placeholder.img" # won't be used, but the UI need a absolute path to call the updater
declare -r SPL_LOADER_UPDATER_BIN="/opt/fydetab_duo-firmware/update_idblock.sh"
declare -r SPL_LOADER_PHONY_VERSION="1.0.0"

_local_check_for_spl_loader_update() {
  local result=""
  result=$("$SPL_LOADER_UPDATER_BIN" --need-update)
  if [[ "$result" == "1" ]]; then
    echo "$SPL_LOADER_PHONY_VERSION"
    return 0
  fi
  debug "$SPL_LOADER_UPDATER_BIN output: $result, no need to update SPL Loader"
  return 1
}

list_upgradable_spl_loader() {
  if [[ ! -f "$SPL_LOADER_UPDATER_BIN" ]] || [[ ! -x "$SPL_LOADER_UPDATER_BIN" ]]; then
    return
  fi
  local name="SPL Loader"
  local id="$SPL_LOADER_PHONY_DEVICE_ID"
  local file="$SPL_LOADER_PHONY_FIRMWARE_FILE"
  local checksum="placeholder"
  local version=""
  if version=$(_local_check_for_spl_loader_update 2> /dev/null); then
    echo "$id,$name,$file,$version,$checksum"
  fi
}

update_spl_loader() {
  _print_preparing
  if [[ ! -f "$SPL_LOADER_UPDATER_BIN" ]] || [[ ! -x "$SPL_LOADER_UPDATER_BIN" ]]; then
    return
  fi
  sleep 0.3
  _print_writing
  if "$SPL_LOADER_UPDATER_BIN"; then
    info "Successfully updated spl-loader"
  else
    error "Failed to update spl-loader"
  fi
  _print_almost_done
}
