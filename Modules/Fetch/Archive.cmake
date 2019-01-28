include_guard(GLOBAL)

function (archive pkg)
  parse(${ARGN}
    @FLAGS INSTALL QUIET
    @ARGS=? TARGET ALIAS
    @ARGS=* POLICIES OPTIONS TARGETS)

  if (DEFINED TARGET AND DEFINED TARGETS)
    error("Cannot pass both TARGET and TARGETS")
  endif()

  ixm_fetch_common_options(${OPTIONS})

  get_filename_component(name ${pkg} NAME_WE)

  get(target TARGET ${name})
  get(alias ALIAS ${name})
  get(install INSTALL EXCLUDE_FROM_ALL)

  fetch(${alias} URL ${pkg})

  ixm_fetch_common_patch(${alias})
  add_subdirectory(${${alias}_SOURCE_DIR} ${${alias}_BINARY_DIR} ${install})

  ixm_fetch_common_target(${target} ${alias})
  parent_scope(${alias}_SOURCE_DIR ${alias}_BINARY_DIR)
endfunction()
