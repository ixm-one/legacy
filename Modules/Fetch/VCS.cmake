include_guard(GLOBAL)

function (ixm_fetch_vcs_git package)
  parse(${ARGN}
    @FLAGS ALL QUIET
    @ARGS=1 PATH
    @ARGS=? ALIAS TARGET PATCH
    @ARGS=* POLICIES TARGETS OPTIONS)

  # Common operation, could easily be refactored into a separate function
  if (NOT QUIET OR NOT IXM_FETCH_QUIET)
    info("[FETCH]: ${package}")
  endif()

  # Common error, could easily be refactored into a separate function
  if (NOT PATH)
    error("GIT{${package}} requires a PATH: to know where to clone")
  endif()

  ixm_fetch_common_check_target()
  ixm_fetch_vcs_git_recipe(${package})

  var(target TARGET ${name})
  var(alias ALIAS ${name})

  ixm_fetch_common_exclude()

  FetchContent_Declare(${alias}
    GIT_REPOSITORY ${PATH}
    GIT_SHALLOW ON
    GIT_TAG ${tag})

  # All functions will share this... It should be possible to place this
  # into Common
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

function (ixm_fetch_vcs_svn package)
  error("Not yet implemented")

  if (NOT PATH)
    error("SVN{${package}} requires a PATH: to know where to checkout")
  endif()
endfunction()

function (ixm_fetch_vcs_cvs package)
  error("Not yet implemented")
  if (NOT PATH)
    error("CVS{${package}} requires a PATH: to know where to checkout")
  endif()
endfunction()

function (ixm_fetch_vcs_hg)
  error("Not yet implemented")
  if (NOT PATH)
    error("HG{${package}} requires a PATH: to know where to clone")
  endif()
endfunction()

function (ixm_fetch_vcs_git_recipe package)
  string(REPLACE "@" ";" result ${package})
  list(APPEND result HEAD)
  list(GET result 0 name)
  list(GET result 1 tag)
  upvar(name tag)
endfunction()
