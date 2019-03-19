include_guard(GLOBAL)

function (ixm_fetch_vcs_git package)
  parse(${ARGN}
    @FLAGS ALL QUIET
    @ARGS=1 PATH
    @ARGS=? ALIAS TARGET PATCH
    @ARGS=* POLICIES TARGETS OPTIONS)

  # Common operation, could easily be refactored into a separate function
  ixm_fetch_common_status()
  ixm_fetch_vcs_git_recipe(${package})
  ixm_fetch_common_dict(${name} ALL QUIET PATH ALIAS TARGET PATCH POLICIES TARGETS OPTIONS)
  # Common error, could easily be refactored into a separate function
  ixm_fetch_common_check_target()

  if (NOT PATH)
    error("GIT{${package}} requires a 'PATH:' option to know where to clone")
  endif()

  var(target TARGET ${name})
  var(alias ALIAS ${name})

  ixm_fetch_common_exclude()
  ixm_fetch_common_download(${alias} 
    GIT_REPOSITORY ${PATH}
    GIT_SHALLOW ON
    GIT_TAG ${tag})

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
