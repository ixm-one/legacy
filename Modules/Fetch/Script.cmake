include_guard(GLOBAL)

function (ixm_fetch_script_subdirectory package)
  parse(${ARGN}
    @FLAGS ALL QUIET
    @ARGS=? TARGET ALIAS PATCH
    @ARGS=* POLICIES TARGETS OPTIONS)
  if (DEFINED TARGETS AND DEFINED TARGET)
    error("Cannot pass both TARGET and TARGETS")
  endif()

  ixm_fetch_apply_options(${OPTIONS})

  set(source_dir "${PROJECT_SOURCE_DIR}/${IXM_SUBPROJECT_DIR}/${name}")
  set(binary_dir "${PROJECT_BINARY_DIR}/${IXM_SUBPROJECT_DIR}/${name}")

  var(target TARGET "${name}")
  var(alias ALIAS "${name}")

  set(all EXCLUDE_FROM_ALL)
  if (ALL)
    unset(all)
  endif()

  add_subdirectory(${source_dir} ${binary_dir} ${all})

  ixm_fetch_apply_target(${target} ${alias})

  set(${alias}_SOURCE_DIR ${source_dir} PARENT_SCOPE)
  set(${alias}_BINARY_DIR ${binary_dir} PARENT_SCOPE)
endfunction()

function (ixm_fetch_script_command package)
  parse(${ARGN}
    @ARGS=? ALIAS
    @ARGS=1 COMMAND)

  ixm_fetch_apply_package(${package})
  var(alias ALIAS ${name})

  ixm_fetch_apply_options(${OPTIONS})
  invoke(${COMMAND} ${package} ${REMAINDER})
  if (NOT DEFINED ${alias}_SOURCE_DIR OR NOT DEFINED ${alias}_BINARY_DIR)
    error("'${COMMAND}' must defined ${alias}_SOURCE_DIR and"
      "${alias}_BINARY_DIR in the parent scope.")
  endif()
endfunction()
