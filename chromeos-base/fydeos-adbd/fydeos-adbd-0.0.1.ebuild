# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="5"

DESCRIPTION="FydeOS adbd service"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="arm arm64"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"

S=$FILESDIR

src_install() {
  exeinto /usr/sbin
  if use arm; then
    newexe binary/adbd-32 adbd
  else
    newexe binary/adbd-64 adbd
  fi
  exeinto /usr/share/cros/init
  doexe script/*.sh
  insinto /etc/init
  doins init/init_adbd_service.conf
}
