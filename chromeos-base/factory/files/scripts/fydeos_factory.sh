#!/bin/bash
#

set -e

BOOT_PART="/dev/mmcblk0p12"
MNT="/tmp/$RANDOM"
SLOT_B_FILE="first-b.txt"

die()
{
    echo "$@"
    exit 1
}

# This function is for ARM device only
# TODO: make it generic
mark_boot_partition()
{
    local p="$BOOT_PART"
    local slot="$1"
    local slotb_path="${MNT}/boot/${SLOT_B_FILE}"

    mkdir $MNT
    mount "$p" $MNT

    if [[ "$slot" == "a" || "$slot" == "A" ]]; then
        rm "$slotb_path" 2>/dev/null || true
    elif [[ "$slot" == "b" || "$slot" == "B" ]]; then
        touch "$slotb_path" 2>/dev/null || true
    else
        die "the parameter must be 'a/b'"
    fi

    echo "Mark slot $slot as bootable"

    umount $MNT
}

main()
{
  #shift
    case "$1" in
    'mark_partition_bootable')
      shift
      mark_boot_partition "$@"
      ;;
    *)
      die "Unknown command: $1"
      ;;
  esac
}

main "$@"
