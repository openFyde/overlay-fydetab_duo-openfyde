#!/usr/bin/env bash

[[ "${_BASE_SCRIPT_SOURCE:-""}" == "yes" ]] && return 0
_BASE_SCRIPT_SOURCE=yes

source "$SCRIPT_ROOT_DIR"/lib/log.sh

set -o errexit
set -o nounset
set -o pipefail

declare -r FIRMWARE_ASSETS_BASE_DIR="/usr/share/fydeos-assets/firmwares"
declare -r FIRMWARE_ASSETS_METADATA_FILE="$FIRMWARE_ASSETS_BASE_DIR/firmwares.json"

_query_firmware_version_info() {
	local device_id="$1"
	local result=""
	result=$(jq -r --arg device_id "$device_id" '.[] | select(.device_id == $device_id) | "\(.file),\(.version),\(.checksum)"' "$FIRMWARE_ASSETS_METADATA_FILE")
	echo "$result"
}

_basic_validate_firmware() {
  local input="$1"
  file=$(echo "$input" | awk -F ',' '{print $1}')
  version=$(echo "$input" | awk -F ',' '{print $2}')
  checksum=$(echo "$input" | awk -F ',' '{print $3}')

  debug "validate, file: [$file], version: [$version], checksum: [$checksum]"

  if [[ -z "$file" ]]; then
    error "firmware file in metadata not found"
    return 1
  fi
  if [[ -z "$version" ]]; then
    error "firmware version in metadata not found"
    return 1
  fi
  if [[ -z "$checksum" ]]; then
    error "firmware checksum in metadata not found"
    return 1
  fi

  if [[ ! -f "$file" ]]; then
    error "firmware file not found: $file"
    return 1
  fi
  local sha256sum=""
  sha256sum=$(sha256sum "$file" | awk '{print $1}')
  if [[ "$sha256sum" != "$checksum" ]]; then
    error "firmware file checksum mismatch, expected: $checksum, actual: $sha256sum"
    return 1
  fi
  return 0
}

_print_preparing() {
  echo "===Preparing==="
}

_print_writing() {
  echo "===Writing==="
}

_print_almost_done() {
  echo "===Almost done==="
}

_verlte() {
	[[ "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]]
}

_verlt() {
	if [[ "$1" = "$2" ]]; then
		return 1
	fi
	_verlte "$1" "$2"
}

_is_newer_version() {
	local current="$1"
	local latest="$2"
	_verlt "$current" "$latest"
}

combine_print_id_name_and_detail() {
  local id="$1"
  local name="$2"
  local detail="$3"
  echo "$id,$name,$detail"
}

get_device_name() {
  local id="$1"
  local name=""
  name=$(lsusb -d "$id" | cut -d' ' -f7- || echo "")
  # if [[ -z "$name" ]]; then
  #   name="$id"
  # fi
  echo "$name"
}

print_raw_txt_list_as_json() {
  local content="$1"
  debug "content: [$content]"
  echo "$content" | jq -Rn '[inputs | select(length > 0) | split(",") | {"device_id": .[0], "device_name": .[1], "file": .[2], "version": .[3], "checksum": .[4]}]'
}
