# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="7"

DESCRIPTION="update spl loader to fix the issue of sdcard tray"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

S=${FILESDIR}

src_install() {
  insinto /opt/fydetab_duo-firmware
  doins idblock.bin
  exeinto /opt/fydetab_duo-firmware
  doexe update_idblock.sh
}
