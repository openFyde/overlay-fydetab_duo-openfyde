# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI="5"

DESCRIPTION="empty project"
HOMEPAGE="http://fydeos.com"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
  chromeos-base/chromeos-bsp-inaugural
  chromeos-base/fydeos-power-daemon-go
  chromeos-base/vpd
  chromeos-base/fydeos-adbd
"
#  chromeos-base/fydeos-adbd
DEPEND="${RDEPEND}"
S=${FILESDIR}

src_install() {
  insinto /etc/init
  doins init/*
  insinto /lib/udev/rules.d
  doins rules/*.rules
  insinto /usr/share/power_manager/board_specific
  doins powerd_prefs/*
  exeinto /lib/udev
  doexe lis2dw12-init.sh
  insinto /etc/camera
  doins camera/*
  exeinto /usr/share/cros/init
  doexe script/*
  insinto /usr/share/chromeos-assets/text/boot_messages
  doins -r boot_messages/*
  insinto /etc/powerd/board
  doins board/*
  insinto /lib/firmware
  doins firmware/*
  insinto /etc/modprobe.d
  doins modprobe.d/*
}
