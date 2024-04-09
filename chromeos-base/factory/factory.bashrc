# Copyright (c) 2024 Fyde Innovations Limited and the openFyde Authors.
# Distributed under the license specified in the root directory of this project.

cros_pre_src_prepare_fydetab_duo_openfyde_patches() {
  eapply -p1 ${FYDETAB_DUO_OPENFYDE_BASHRC_FILEPATH}/patches/*.patch
  cp -f "${FYDETAB_DUO_OPENFYDE_BASHRC_FILEPATH}"/test_lists/* "$S"/py/test/test_lists/ || die "Failed to copy fydetab test_lists json files"
  cp -f "${FYDETAB_DUO_OPENFYDE_BASHRC_FILEPATH}"/scripts/fydeos_factory.sh "$S"/sh || die "Failed to copy fydeos_factory.sh script"

  pushd "$S/bin" || die "Failed to pushd to $S/bin"
  ln -s ../sh/fydeos_factory.sh . || die "Failed to create symlink to fydeos_factory.sh script"
  popd || die "Failed to popd"
}
