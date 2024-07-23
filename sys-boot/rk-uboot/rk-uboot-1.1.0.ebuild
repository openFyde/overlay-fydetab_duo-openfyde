# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="7"

EGIT_REPO_URI="https://github.com/rockchip-linux/u-boot.git"
EGIT_BRANCH="next-dev"
EGIT_COMMIT="63c55618fbdc36333db4cf12f7d6a28f0a178017"

inherit git-r3

DESCRIPTION="empty project"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}
  sys-boot/rk-uboot-dev-binary
"

src_prepare() {
  default
  eapply ${FILESDIR}/*.patch
}

src_compile() {
  export RKBIN_TOOLS=${ROOT}/build/rkbin/tools
  einfo "RKBIN:${RKBIN_TOOLS}"
  export CROSS_COMPILE_ARM64=/usr/bin/aarch64-cros-linux-gnu-
  echo "/usr/bin/aarch64-cros-linux-gnu-" > .cc
  ./make.sh rk3588s_fydetab_duo
  echo $PV > .uboot_version
}

src_install() {
  insinto /boot
  doins uboot.img
  doins .uboot_version
}
