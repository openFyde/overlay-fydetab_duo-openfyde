# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="7"

EGIT_REPO_URI="https://github.com/rockchip-linux/rkbin.git"
EGIT_BRANCH="master"

inherit git-r3
DESCRIPTION="rockchip rkbin git repo"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

src_install() {
  diropts -m777
  keepdir /build/rkbin
  insinto /build/rkbin/RKBOOT
  doins RKBOOT/RK3588*
  insinto /build/rkbin/RKTRUST
  doins RKTRUST/RK3588*
  insinto /build/rkbin/bin
  doins -r bin/rk35
  insinto /build/rkbin
  insopts -m755
  doins -r tools
}
