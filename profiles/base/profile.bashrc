fydetab_duo_openfyde_stack_bashrc() {
  local cfg 

  cfgd="/mnt/host/source/src/overlays/overlay-fydetab_duo-openfyde/${CATEGORY}/${PN}"
  for cfg in ${PN} ${P} ${PF} ; do
    cfg="${cfgd}/${cfg}.bashrc"
    [[ -f ${cfg} ]] && . "${cfg}"
  done

  export FYDETAB_DUO_OPENFYDE_BASHRC_FILEPATH="${cfgd}/files"
}

fydetab_duo_openfyde_stack_bashrc
