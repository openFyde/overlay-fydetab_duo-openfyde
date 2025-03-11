# Copyright (c) 2024 Fyde Innovations Limited and the openFyde Authors.
# Distributed under the license specified in the root directory of this project.

cros_post_src_install_openfyde_patches_fydetab() {
  # check_serial_number.sh will source serial_number_helper.sh
  insinto /usr/share/cros/init
  doins ${FYDETAB_DUO_OPENFYDE_BASHRC_FILEPATH}/serial_number_helper.sh
}
