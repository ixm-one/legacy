include_guard(GLOBAL)

include(ParentScope)
include(Fetch)

find_package(Git REQUIRED)

function (git name path tag)
  fetch(${name}
    GIT_REPOSITORY ${path}.git
    GIT_TAG ${tag}
    GIT_SHALLOW ON
    ${ARGN})
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endfunction ()

function (github repository tag)
  get_filename_component(name ${repository} NAME)
  git(${name} "https://github.com/${repository}" ${tag})
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endfunction()

function (gitlab repository tag)
  get_filename_component(name ${repository} NAME)
  git(${name} "https://gitlab.com/${repository}" ${tag})
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endfunction ()

function (bitbucket repository tag)
  get_filename_component(name ${repository} NAME)
  git(${name} "https://bitbucket.com/${repository}" ${tag})
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endfunction ()
