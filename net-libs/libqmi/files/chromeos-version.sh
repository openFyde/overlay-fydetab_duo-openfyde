#!/bin/sh
# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

awk '
  match($0, "^ *version *: *.([0-9.]+)", v) {
    print v[1]
    exit
  }
' "$1/meson.build"
