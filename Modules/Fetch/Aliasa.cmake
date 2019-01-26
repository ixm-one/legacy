include_guard(GLOBAL)

function (ixm_fetch_aliasa_package package)
  parse(${ARGN}
    @FLAGS ALL QUIET
    @ARGS=1 PROVIDER
    @ARGS=? ALIAS TARGET PATCH
    @ARGS=* POLICIES TARGETS OPTIONS)
  if (DEFINED TARGETS AND DEFINED TARGET)
    error("IXM::Aliasa: Cannot pass both TARGET and TARGETS")
  endif()
  ixm_fetch_aliasa_recipe(${package})

  var(target TARGET ${name})
  var(alias ALIAS ${name})

  set(all EXCLUDE_FROM_ALL)
  if (ALL)
    unset(all)
  endif()

  FetchContent_Declare(${alias} URL "https://${PROVIDER}.aliasa.io/${package}")
  FetchContent_GetProperties(${alias})
  if (NOT ${alias}_POPULATED)
    FetchContent_Populate(${alias})
  endif()

  #[[ PATCH ]]
  ixm_fetch_apply_patch(${alias})

  #[[ PACKAGE ]]
  ixm_fetch_apply_options("${OPTIONS}")
  add_subdirectory(${${alias}_SOURCE_DIR} ${${alias}_BINARY_DIR} ${all})
  #[[ TARGET ]]
  ixm_fetch_apply_target(${target} ${alias})

  upvar(${alias}_SOURCE_DIR ${alias}_BINARY_DIR)
endfunction()

function (ixm_fetch_aliasa_recipe package)
  string(REPLACE "@" ";" result ${package})
  list(APPEND result HEAD) # small trick to make sure we safely get this
  list(GET result 0 repository)
  list(GET result 1 tag)
  get_filename_component(name ${repository} NAME)
  upvar(name repository tag)
endfunction()


