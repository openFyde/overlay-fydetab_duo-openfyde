# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="04097b9df3be67662e26f4a7452ddbf989a7158b"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "1f22ae3a4502e0dc175469f0df6450948deffc72" "a53bc615581cf8788aac6fdd098852105814f321" "c59d8cb1b3b7e53be20c0e3f7eb12f63fcf3cfdd" "f68717b40d354c9177e42200d2719b3dce39e48f" "f7a3d73092dcec2f55cfbdaf263fbe773244cbd9" "8d6f8fdce76674dc4f63f7b19f50a8b8b141218f")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE=".gn camera/build camera/common camera/hal/usb camera/include camera/mojo common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/hal/usb"

inherit cros-camera cros-workon platform

DESCRIPTION="Chrome OS USB camera HAL v3."

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="asan"

RDEPEND="
	chromeos-base/cros-camera-android-deps
	chromeos-base/cros-camera-libs
	dev-libs/re2
	media-libs/libsync
	virtual/jpeg:0="

DEPEND="${RDEPEND}
	media-libs/libyuv
	virtual/pkgconfig"

platform_pkg_test() {
	platform test_all
}

PATCHES=( "${FILESDIR}/0001-try_convert_mjpeg_to_nv12_first.patch" )
