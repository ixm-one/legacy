include_guard(GLOBAL)

find_package(Git REQUIRED)

# TODO: On successful 'clone', set the specific package to have its updates
#       disconnected unless something is set.
function (ixm_fetch_git_clone name repository tag)
  parse(${ARGN} @ARGS=1 DOMAIN SEPARATOR SUFFIX SCHEME)
  fetch(${name}
    GIT_REPOSITORY ${SCHEME}${DOMAIN}${SEPARATOR}${repository}${SUFFIX}
    GIT_TAG ${tag}
    GIT_SHALLOW ON)
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endfunction()

function (gitclone pkg)
  parse(${ARGN}
    @FLAGS INSTALL QUIET
    @ARGS=1 DOMAIN SCHEME
    @ARGS=? SEPARATOR SUFFIX ALIAS TARGET PATCH
    @ARGS=* POLICIES TARGETS OPTIONS)

  if (DEFINED TARGETS AND DEFINED TARGET)
    error("IXM::Fetch: Cannot pass both TARGET and TARGETS")
  endif()

  ixm_fetch_recipe(${pkg})

  get(suffix SUFFIX .git)
  get(sep SEPARATOR "/")
  get(target TARGET ${name})
  get(alias ALIAS ${name})
  get(install INSTALL EXCLUDE_FROM_ALL)

  #[[ FETCH ]]
  ixm_fetch_git_clone(
    ${alias} ${repository} ${tag}
    SCHEME ${SCHEME}
    DOMAIN ${DOMAIN}
    SEPARATOR ${sep}
    SUFFIX ${suffix})

  #[[ PATCH ]]
  ixm_fetch_apply_patch(${alias})

  #[[ PACKAGE ]]
  ixm_fetch_apply_options(${OPTIONS})
  get(IXM_MESSAGE_QUIET QUIET OFF)
  add_subdirectory(${${alias}_SOURCE_DIR} ${${alias}_BINARY_DIR} ${install})
  set(IXM_MESSAGE_QUIET OFF)

  #[[ TARGET ]]
  ixm_fetch_apply_target(${target} ${alias})
  parent_scope(${alias}_SOURCE_DIR ${alias}_BINARY_DIR)
endfunction()
