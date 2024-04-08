# Copyright (c) 2024 Fyde Innovations Limited and the openFyde Authors.
# Distributed under the license specified in the root directory of this project.

cros_pre_src_prepare_fydetab_duo_openfyde_patches() {
  eapply -p1 ${FYDETAB_DUO_OPENFYDE_BASHRC_FILEPATH}/patches/*.patch
  pwd
  cp -f "${FYDETAB_DUO_OPENFYDE_BASHRC_FILEPATH}"/test_lists/* "$S"/py/test/test_lists/ || die "Failed to copy fydetab test_lists json files"
}

cros_post_src_install_fydetab_duo_openfyde_extra() {
  exeinto /usr/bin/
  doexe "${FYDETAB_DUO_OPENFYDE_BASHRC_FILEPATH}"/scripts/fydeos_factory.sh
}
