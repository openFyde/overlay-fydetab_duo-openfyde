EAPI=7

DESCRIPTION="contains the firmware assets and update tools"
HOMEPAGE="https://fydeos.io"

LICENSE="BSD-Fyde"
SLOT="0"
KEYWORDS="*"
IUSE=""

S=${FILESDIR}

src_install() {
  exeinto /usr/bin
  doexe bin/*

  insinto /usr/share/fydeos-assets/firmwares
  doins -r firmwares/*

  insinto /usr/share/fydeos-firmware-update
  doins -r scripts/*
  fperms +x /usr/share/fydeos-firmware-update/update_firmware.sh
  dosym /usr/share/fydeos-firmware-update/update_firmware.sh /usr/bin/fydeos-update-firmware
}
