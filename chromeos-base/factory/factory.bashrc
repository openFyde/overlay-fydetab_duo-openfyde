# Copyright (c) 2024 Fyde Innovations Limited and the openFyde Authors.
# Distributed under the license specified in the root directory of this project.

cros_pre_src_prepare_fydetab_duo_openfyde_patches() {
  eapply -p1 ${FYDETAB_DUO_OPENFYDE_BASHRC_FILEPATH}/*.patch
}
