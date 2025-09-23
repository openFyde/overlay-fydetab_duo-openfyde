# Copyright (c) 2022 Fyde Innovations Limited and the openFyde Authors.
# Distributed under the license specified in the root directory of this project.

cros_pre_src_prepare_specific_fydetab_duo_openfyde_patches() {
  if [ "${PV}" == "9999" ]; then
    return
  fi
  eapply "${FYDETAB_DUO_OPENFYDE_BASHRC_FILEPATH}/0001-add-distance-filter-interpreter.patch"
}
