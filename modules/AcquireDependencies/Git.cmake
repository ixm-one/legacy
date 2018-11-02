include_guard(GLOBAL)

include(ParentScope)

find_package(Git REQUIRED)

macro (__git_args)
  __common_args()
  list(APPEND single DOMAIN)
endmacro()

function(__git_name recipe)
  string(REPLACE "@" ";" result ${recipe})
  list(GET ${result} 0 repository)
  list(GET ${result} 1 tag)
  get_filename_component(name ${repository} NAME)
  if (NOT tag)
    set(tag HEAD)
  endif()
  parent_scope(name repository tag)
endfunction()

macro(__git_provider url dependency)
  __git_args(${ARGN})
  __git_name(${dependency})
  __set_alias(${name})
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endmacro()

macro(__git_acquire name path tag)
  fetch(${name}
    GIT_REPOSITORY ${path}.git
    GIT_TAG ${tag}
    GIT_SHALLOW ON)
endmacro()
