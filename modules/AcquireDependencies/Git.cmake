include_guard(GLOBAL)

find_package(Git REQUIRED)

function (ixm_acquire_git_name recipe)
  string(REPLACE "@" ";" result ${recipe})
  list(APPEND result HEAD) # Small trick to make sure we safely get this
  list(GET result 0 repository)
  list(GET result 1 tag)
  get_filename_component(name ${repository} NAME)
  parent_scope(name repository tag)
endfunction()

function (ixm_acquire_git_fetch name repository tag)
  argparse(ARGS ${ARGN}
    VALUES DOMAIN SEPARATOR SUFFIX SCHEME)
  fetch(${name}
    GIT_REPOSITORY ${ARG_SCHEME}${ARG_DOMAIN}${ARG_SEPARATOR}${repository}${ARG_SUFFIX}
    GIT_TAG ${tag}
    GIT_SHALLOW ON)
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endfunction()

function (gitacquire pkg)
  argparse(ARGS ${ARGN}
    OPTIONS INSTALL QUIET
    VALUES TARGET ALIAS DOMAIN SUFFIX SCHEME
    LISTS POLICIES TARGETS SETTINGS)
  ixm_acquire_verify_args(DOMAIN SCHEME)
  ixm_acquire_git_name(${pkg})
  ixm_acquire_apply_settings(${ARG_SETTINGS})
  ixm_acquire_apply_policies(${ARG_POLICIES})

  get(suffix ARG_SUFFIX .git)
  get(sep ARG_SEPARATOR /)
  get(target ARG_TARGET ${name})
  get(alias ARG_ALIAS ${name})
  get(ADD_PACKAGE_ARGS ARG_INSTALL EXCLUDE_FROM_ALL)

  get(IXM_MESSAGE_QUIET ARG_QUIET OFF)
  #[=[ ACQUIRE ]=]
  info("IXM::AD: Acquiring - ${pkg}")
  ixm_acquire_git_fetch(
    ${alias} ${repository} ${tag}
    SCHEME ${ARG_SCHEME}
    DOMAIN ${ARG_DOMAIN}
    SEPARATOR ${sep}
    SUFFIX ${suffix})

  #[=[ PACKAGE ]=]
  ixm_acquire_apply_patch(${alias})

  info("IXM::AD: Adding - ${alias} from ${pkg}")
  add_package(${${alias}_SOURCE_DIR} ${${alias}_BINARY_DIR} ${ADD_PACKAGE_ARGS})
  set(IXM_MESSAGE_QUIET OFF)

  #[=[ TARGET ]=]
  ixm_acquire_apply_target(${target} ${alias})
  parent_scope(${alias}_SOURCE_DIR ${alias}_BINARY_DIR)
endfunction()
