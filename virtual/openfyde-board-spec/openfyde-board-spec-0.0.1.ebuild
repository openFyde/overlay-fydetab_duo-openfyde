# Copyright (c) 2018 The Fyde OS Authors. All rights reserved.
# Distributed under the terms of the BSD

EAPI=7

DESCRIPTION="empty project"
HOMEPAGE="https://fydeos.io"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
  chromeos-base/chromeos-bsp-inaugural
  chromeos-base/chromeos-bsp-inaugural-openfyde
  chromeos-base/chromeos-bsp-fydetab_duo-openfyde
  chromeos-base/fydeos-firmware-update
"

DEPEND="${RDEPEND}"
