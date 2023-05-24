# overlay-fydetab_duo-openfyde

![Logo badge](https://img.shields.io/endpoint?url=https%3A%2F%2Fopenfyde-badge-wivuxrq8xzvh.runkit.sh%2F) ![Release badge](https://img.shields.io/github/v/release/openFyde/overlay-fydetab_duo-openfyde?label=latest%20release%20image)

<br>

## Introduction
Same as Chromium OS, openFyde adopts the [Portage build and packaging system](https://wiki.gentoo.org/wiki/Portage) from Gentoo Linux. openFyde uses Portage with certain customisations to support building multiple targets (bootable OS system images) across different hardware architectures from a shared set of sources.

A **board** defines a target type, it can be either for a family of hardware devices or specifically for one type of device. For example, The board `amd64-openfyde` is a target type for an openFyde system image that aims to run on most recent PCs with amd64(x86_64) architecture; whilst the `rpi4-openfyde` board is a target type specifically for the infamous single-board computer [Raspberry Pi 4B](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/). We usually append `-openfyde` to the board name in openFyde to differentiate between its siblings for FydeOS. 

Each board has a corresponding **overlay** that defines the configuration for it. This includes details like CPU architecture, kernel configuration, as well as additional packages and USE flags.

<br>

## About this repository
This repository is the overlay for the `fydetab_duo-openfyde` board, it's part of the openFyde open-source project.

This repository contains the following packages:

| Packages                   | Description        | Reference |
|----------------------------|--------------------|-----------|
| chromeos-base/device-appid | Setup device appid |           |
| chromeos-base/fydeos-adbd  | Setup FydeOS adbd service |    |
| chromeos-base/chromeos-bsp-fydetab_duo-openfyde | Setup board BSP | |
| net-misc/modemmanager-next | Modem and mobile broadband management libraries | |
| virtual/fydeos-board-spec  | Setup board dependency|        |
| kconfigs/tablet-12c-5_10-def-* | kernel config  |           |

<br>

## About the board `fydetab_duo-openfyde`

 - This board specifically targets the [Fydetab Duo](https://wiki.fydetabduo.com/wiki/Main_Page).
 
 
   ![Fydetab Duo](https://madeforfydeos.com/wp-content/uploads/2022/12/Frame-116-1.png)

<br>

###### Copyright (c) 2023 Fyde Innovations and the openFyde Authors. Distributed under the license specified in the root directory of this repository.
