# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="eac4e822bd2b7afbe020e2fc65847819abf7c7ce"
CROS_WORKON_TREE=("f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "4fc7c463ce102d1dff62e86baffad4a67ea2c940" "1232b5450992d3c45a88234d53a5afd4729a33fc" "6e0df3e9b16fadbd0dbe467416fa812fa4733002" "379618bb76af3b056fdbf5a781ea3bd4152ca237" "fefa46dc07b1045ed94377bd79f0ec4cac20f50a" "79cdd007ff69259efcaad08803ef2d1498374ec4")
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
	media-libs/rockchip-mpp"

DEPEND="${RDEPEND}
	media-libs/libyuv
	virtual/pkgconfig"

src_prepare() {
	default
	epatch "${FILESDIR}/0001-try_convert_mjpeg_to_nv12_first.patch"
}

src_install() {
	platform_src_install
	cros-camera_dohal "${OUT}/lib/libcamera_hal.so" usb.so
}

platform_pkg_test() {
	local tests=(
		image_processor_test
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		# TODO(b/193747946): Remove the condition once we solve the camera
		# libraries missing when running with asan enabled issue.
		if ! use asan; then
			platform_test run "${OUT}/${test_bin}"
		fi
	done
}
