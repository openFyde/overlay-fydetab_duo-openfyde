#!/bin/bash
check_board_bootable_file() {
  if [ ! -f $1 ]; then
    die "$1 doesn't exist."
  fi
}

write_bootable_image() {
  local src_img=$1
  local tar_img=$2
  local offset=$3
  check_board_bootable_file $src_img
  info "write `basename $src_img` ..."
  dd if=${src_img} of=${tar_img} bs=512 seek=$(($offset)) conv=notrunc,fdatasync || die "failed to write $src_img to $tar_img"
}

board_make_image_bootable() {
  local image=$1
  local boot_folder=${BOARD_ROOT}/boot
  local uboot_image=${boot_folder}/uboot.img
  local resource_image=${boot_folder}/resource.img
  local idblock=${boot_folder}/idblock.bin
  check_board_bootable_file $image
  write_bootable_image $idblock $image 0x40
  write_bootable_image $uboot_image $image 0x4000
  write_bootable_image $resource_image $image 0x6004
}
