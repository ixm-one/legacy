include_guard(GLOBAL)
find_package(Git REQUIRED)

function (ixm_fetch_git_package package)
  parse(${ARGN}
    @FLAGS ALL QUIET
    @ARGS=1 SCHEME SEPARATOR
    @ARGS=? ALIAS TARGET PATCH SUFFIX
    @ARGS=* POLICIES TARGETS OPTIONS)
  if (DEFINED TARGETS AND DEFINED TARGET)
    error("Cannot pass both TARGET and TARGETS")
  endif()

  ixm_fetch_git_recipe(${package} ${SCHEME})

  var(target TARGET ${name})
  var(alias ALIAS ${name})

  var(suffix SUFFIX .git)

  set(all EXCLUDE_FROM_ALL)

  if (ALL)
    unset(all)
  endif()

  set(path "${SCHEME}${DOMAIN}${SEPARATOR}${repository}${suffix}")

  FetchContent_Declare(${alias}
    GIT_REPOSITORY ${path}
    GIT_TAG ${tag}
    GIT_SHALLOW ON)
  FetchContent_GetProperties(${alias})
  if (NOT ${alias}_POPULATED)
    FetchContent_Populate(${alias})
  endif()

  #[[ PATCH ]]
  ixm_fetch_common_patch(${alias})

  #[[ PACKAGE ]]
  ixm_fetch_common_options("${OPTIONS}")
  add_subdirectory(${${alias}_SOURCE_DIR} ${${alias}_BINARY_DIR} ${all})
  #[[ TARGET ]]
  ixm_fetch_common_target(${target} ${alias})
  upvar(${alias}_SOURCE_DIR ${alias}_BINARY_DIR)
endfunction()

function (ixm_fetch_git_recipe package scheme)
  if (scheme MATCHES "ssh://")
    string(REPLACE ":" ";" recipe "${package}")
    list(GET recipe 0 server)
    list(GET recipe 1 recipe)
    set(DOMAIN ${server} PARENT_SCOPE)
    string(REPLACE "@" ";" result ${recipe})
    list(APPEND result HEAD)
    list(GET result 0 repository)
    list(GET result 1 tag)
    get_filename_component(name ${repository} NAME)
    upvar(repository tag name)
  else()
    string(REPLACE "@" ";" result ${package})
    list(APPEND result HEAD)
    list(GET result 0 repository)
    list(GET result 1 tag)
    get_filename_component(name ${repository} NAME)
    debug(name tag repository)
    upvar(name tag repository)
  endif()
endfunction()

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
  ixm_fetch_common_patch(${alias})

  #[[ PACKAGE ]]
  ixm_fetch_common_options(${OPTIONS})
  get(IXM_MESSAGE_QUIET QUIET OFF)
  add_subdirectory(${${alias}_SOURCE_DIR} ${${alias}_BINARY_DIR} ${install})
  set(IXM_MESSAGE_QUIET OFF)

  #[[ TARGET ]]
  ixm_fetch_common_target(${target} ${alias})
  parent_scope(${alias}_SOURCE_DIR ${alias}_BINARY_DIR)
endfunction()
