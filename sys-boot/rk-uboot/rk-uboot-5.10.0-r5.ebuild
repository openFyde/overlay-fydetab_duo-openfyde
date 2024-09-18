# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="7"

EGIT_REPO_URI="https://github.com/rockchip-linux/u-boot.git"
#EGIT_BRANCH="linux-5.10-gen-rkr5"
EGIT_COMMIT="ed9121993cefbf482e546795983ab0805903267a"

inherit git-r3

DESCRIPTION="empty project"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="sys-boot/rk-uboot-resource"

DEPEND="${RDEPEND}
  sys-boot/rk-uboot-dev-binary
"

src_prepare() {
  default
  eapply ${FILESDIR}/rk5/*.patch
}

src_compile() {
  export RKBIN_TOOLS=${ROOT}/build/rkbin/tools
  einfo "RKBIN:${RKBIN_TOOLS}"
  export CROSS_COMPILE_ARM64=/usr/bin/aarch64-cros-linux-gnu-
  echo "/usr/bin/aarch64-cros-linux-gnu-" > .cc
  ./make.sh rk3588s_fydetab_duo
  echo $PV > .uboot_version
  ./make.sh --spl
  ARG_SPL_BIN=spl/u-boot-spl.bin \
  ARG_TPL_BIN=`ls ${RKBIN_TOOLS}/../bin/rk35/rk3588_ddr_lp4*.bin` \
  ./make.sh --idblock
}

src_install() {
  insinto /boot
  doins uboot.img
  doins .uboot_version
  doins rk3588_spl_loader_v1.*.bin
  doins idblock.bin
}
