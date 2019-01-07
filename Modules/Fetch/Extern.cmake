include_guard(GLOBAL)

# TODO: Move to Vars module
set(IXM_EXTERN_DIR extern)

#[[ Intended for projects embedded within your project ]]
function (extern name)
  ixm_parse(${ARGN}
    @FLAGS INSTALL QUIET
    @ARGS=? TARGET ALIAS
    @ARGS=* POLICIES TARGETS OPTIONS)

  if (DEFINED TARGETS AND DEFINED TARGET)
    error("Cannot pass both TARGET and TARGETS")
  endif()

  ixm_fetch_apply_options(${OPTIONS})

  set(source_dir ${PROJECT_SOURCE_DIR}/${IXM_EXTERN_DIR}/${name})
  set(binary_dir ${PROJECT_BINARY_DIR}/${IXM_EXTERN_DIR}/${name})

  get(target TARGET ${name})
  get(alias ALIAS ${name})
  get(install INSTALL EXCLUDE_FROM_ALL)

  add_subdirectory(${source_dir} ${binary_dir} ${install})

  ixm_acquire_apply_target(${target} ${alias})

  set(${alias}_SOURCE_DIR ${source_dir} PARENT_SCOPE)
  set(${alias}_BINARY_DIR ${binary_dir} PARENT_SCOPE)
endfunction()
