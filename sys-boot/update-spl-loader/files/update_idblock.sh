#!/bin/bash
SELF_DIR=`dirname $0`
EMMC=/dev/mmcblk0
IDBLOCK=${SELF_DIR}/idblock.bin

die() {
  echo "Err: $@"
  exit 1
}

need_update() {
  local target_md5sum=`xxd -l 256 -s $((512 * 64 + 0x800)) $EMMC | md5sum`
  local source_md5sum=`xxd -l 256 -s 0x800 -o 0x8000 $IDBLOCK | md5sum`
  [ "${source_md5sum}" != "${target_md5sum}" ]
}

check_env() {
  [ `id -u` -eq 0 ] || die "need runing as root."
  [ -b "$EMMC" ] || die "no EMMC found."
  [ -f "$IDBLOCK" ] || die "no idblock.bin found."
}

main() {
  check_env
  local force_update=$1
  local check_update=$1
  if [ "$check_update" == "--need-update" ]; then
    if need_update; then
      echo "1"
    else
      echo "0"
    fi
    exit 0
  fi
  if need_update || [ "${force_update}" == "--force" ]; then
    echo "Updating SPL loader..."
    dd if=${IDBLOCK} of=$EMMC seek=64 conv=fsync
    echo "The SPL loader is updated."
  else
    echo "The SPL loader is already updated. Or add --force to ignore version checking."
  fi
}

main $@
