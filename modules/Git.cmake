include_guard(GLOBAL)

include(ParentScope)
include(AddPackage)
include(Fetch)
include(Print)

find_package(Git REQUIRED)

function (__git_args)
  set(option PACKAGE)
  set(single ALIAS)
  set(multi)
  cmake_parse_arguments(ARG "${option}" "${single}" "${multi}" ${ARGN})
  parent_scope(ARG_PACKAGE ARG_ALIAS ARG_UNPARSED_ARGUMENTS)
endfunction()

macro (__git_package name)
  if (ARG_PACKAGE)
    info("Package - ${name}")
    add_package(${${name}_SOURCE_DIR} ${${name}_BINARY_DIR} EXCLUDE_FROM_ALL)
  endif()
endmacro()

macro (__git_name repository)
  set(name ${ARG_ALIAS})
  if (NOT ARG_ALIAS)
    get_filename_component(name ${repository} NAME)
  endif()
endmacro()

macro (__git website repository tag)
  __git_args(${ARGN})
  __git_name(${repository})
  git(${name} "${website}/${repository}" ${tag})
  __git_package(${name})
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endmacro()

function (git name path tag)
  fetch(${name}
    GIT_REPOSITORY ${path}.git
    GIT_TAG ${tag}
    GIT_SHALLOW ON
    ${ARGN})
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endfunction ()

function (gitssh host repository tag)
  __git_args(${ARGN})
  __git_name(${repository})
  git(${name} "git@${host}:${repository}" ${tag})
  __git_package(${name})
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endfunction()

function (github repository tag)
  __git("https://github.com" ${repository} ${tag} ${ARGN})
endfunction()

function (gitlab repository tag)
  __git("https://gitlab.com" ${repository} ${tag} ${ARGN})
endfunction ()

function (bitbucket repository tag)
  __git("https://bitbucket.com" ${repository} ${tag} ${ARGN})
endfunction ()
