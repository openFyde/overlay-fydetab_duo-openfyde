# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_PROJECT="chromiumos/platform/gestures"
CROS_WORKON_LOCALNAME="platform/gestures"
CROS_WORKON_USE_VCSID=1

inherit toolchain-funcs cros-debug cros-sanitizers cros-workon

DESCRIPTION="Gesture recognizer library with DistanceFilterInterpreter for FydeTab Duo"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/gestures/"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="~*"
IUSE="-asan +X"

RDEPEND="chromeos-base/gestures-conf:=
	chromeos-base/libevdev:=
	dev-libs/jsoncpp:=
	virtual/udev"
DEPEND="dev-cpp/gtest:=
	X? ( x11-libs/libXi:= )
	${RDEPEND}"

# The last dir must be named "gestures" for include path reasons.
S="${WORKDIR}/gestures"

src_prepare() {
	default

	# Copy DistanceFilterInterpreter source files
	cp "${FILESDIR}/distance_filter_interpreter.h" include/ || die "Failed to copy header file"
	cp "${FILESDIR}/distance_filter_interpreter.cc" src/ || die "Failed to copy implementation file"

	# Apply patch
	eapply "${FILESDIR}/0001-add-distance-filter-interpreter.patch"
}

src_configure() {
	cros_optimize_package_for_speed
	sanitizers-setup-env
	export USE_X11=$(usex X 1 0)
	tc-export CXX PKG_CONFIG
	cros-debug-add-NDEBUG
	default
}

src_compile() {
	emake clean  # TODO(adlr): remove when a better solution exists
	emake
}

src_test() {
	SANITIZE_GESTURES=yes emake test

	if ! use x86 && ! use amd64 ; then
		einfo "Skipping tests on non-x86 platform..."
	else
		# This is an ugly hack that happens to work, but should not be copied.
		LD_LIBRARY_PATH="${SYSROOT}/usr/$(get_libdir)" \
		./test || die
	fi
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)" install
}