include_guard(GLOBAL)

## Useful for libraries like nlohmann::json
function (archive pkg)
  argparse(ARGS ${ARGN}
    OPTIONS INSTALL QUIET
    VALUES TARGET ALIAS
    LISTS POLICIES TARGETS SETTINGS)
  ixm_acquire_verify_args()
  ixm_acquire_apply_settings(${ARG_SETTINGS})
  ixm_acquire_apply_policies(${ARG_POLICIES})

  get_filename_component(name ${pkg} NAME_WE)

  get(target ARG_TARGET ${name})
  get(alias ARG_ALIAS ${name})
  get(ADD_PACKAGE_ARGS ARG_INSTALL EXCLUDE_FROM_ALL)

  get(IXM_MESSAGE_QUIET ARG_QUIET OFF)
  #[=[ ACQUIRE ]=]
  info("IXM::AD: Acquiring - ${pkg}")
  # TODO: support HASH=<N> for download verification
  fetch(URL ${pkg})

  #[=[ PACKAGE ]=]
  ixm_acquire_apply_patch(${alias})
  info("IXM::AD: Adding - ${alias} from ${pkg}")
  add_package(${${alias}_SOURCE_DIR} ${${alias}_BINARY_DIR} ${ADD_PACKAGE_ARGS})
  set(IXM_MESSAGE_QUIET OFF)

  #[=[ TARGET ]=]
  ixm_acquire_apply_target(${target} ${alias})
  parent_scope(${alias}_SOURCE_DIR ${alias}_BINARY_DIR)
endfunction()
