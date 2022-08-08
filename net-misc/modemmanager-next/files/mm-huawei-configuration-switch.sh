#!/bin/sh
# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# $1 is either "usb_device" or "usb_interface" depending on what triggered this
# script.
# $2 is the full sysfs path to the device/interface.

switch_device_configuration() {
  # expect:
  #  $1 : sysfs path for the device.
  echo 3 > "$1"/bConfigurationValue
}

if [ "$1" = "usb_device" ]
then
  switch_device_configuration "$2"
else
  switch_device_configuration "$(dirname "$2")"
fi
