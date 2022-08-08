#!/bin/sh
# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

exec gawk '
match($0, /m4_define\(\[mm_(major|minor|micro)_version\], \[([0-9]+)\]\)/,
      matches) { version[matches[1]] = matches[2] }
END { print version["major"] "." version["minor"] "." version["micro"] }' \
  "$1/configure.ac"
