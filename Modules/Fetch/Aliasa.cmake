include_guard(GLOBAL)

function (aliasa pkg)
  argparse(${ARGN}
    @FLAGS INSTALL QUIET
    @ARGS=1 PROVIDER
    @ARGS=? ALIAS TARGET
    @ARGS=* POLICIES TARGETS OPTIONS)

  if (DEFINED TARGETS AND DEFINED TARGET)
    fatal("IXM::Aliasa: Cannot pass both TARGET and TARGETS")
  endif()

  ixm_fetch_recipe(${pkg})

  get(target TARGET ${name})
  get(alias ALIAS ${name})
  get(install INSTALL EXCLUDE_FROM_ALL)

  fetch(${alias} URL https://${PROVIDER}.aliasa.io/${pkg})

  #[[ PATCH ]]
  ixm_fetch_apply_patch(${alias})

  #[[ PACKAGE ]]
  ixm_fetch_apply_options(${OPTIONS})
  add_subdirectory(${${alias}_SOURCE_DIR} ${${alias}_BINARY_DIR} ${install})
  #[[ TARGET ]]
  ixm_fetch_apply_target(${target} ${alias})
  parent_scope(${alias}_SOURCE_DIR ${alias}_BINARY_DIR)
endfunction()
