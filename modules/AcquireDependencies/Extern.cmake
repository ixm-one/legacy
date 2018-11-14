include_guard(GLOBAL)

set(IXM_EXTERN_DIR extern)

#[[ Intended for projects embedded within your project ]]
function (extern name)
  argparse(ARGS ${ARGN}
    OPTIONS INSTALL QUIET
    VALUES TARGET ALIAS
    LISTS POLICIES TARGETS SETTINGS)
  ixm_acquire_verify_args()
  ixm_acquire_apply_settings(${ARG_SETTINGS})
  ixm_acquire_apply_policies(${ARG_POLICIES})

  set(source_dir ${PROJECT_SOURCE_DIR}/${IXM_EXTERN_DIR}/${name})
  set(binary_dir ${PROJECT_BINARY_DIR}/${IXM_EXTERN_DIR}/${name})

  get(target ARG_TARGET ${name})
  get(alias ARG_ALIAS ${name})
  get(ADD_PACKAGE_ARGS ARG_INSTALL EXCLUDE_FROM_ALL)

  get(IXM_MESSAGE_QUIET ARG_QUIET OFF)

  info("IXM::AD: Adding - ${name}")
  add_package(${source_dir} ${binary_dir} ${ADD_PACKAGE_ARGS})
  set(IXM_MESSAGE_QUIET OFF)

  ixm_acquire_apply_target(${target} ${alias})

  set(${alias}_SOURCE_DIR ${source_dir} PARENT_SCOPE)
  set(${alias}_BINARY_DIR ${binary_dir} PARENT_SCOPE)
endfunction()
