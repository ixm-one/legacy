include_guard(GLOBAL)

find_package(Git REQUIRED)

macro (__git_args)
  __common_args()
  list(APPEND single DOMAIN)
endmacro()

function(__git_name recipe)
  string(REPLACE "@" ";" result ${recipe})
  list(APPEND result HEAD) # Small trick to make sure we safely get this
  list(GET result 0 repository)
  list(GET result 1 tag)
  get_filename_component(name ${repository} NAME)
  if (NOT repository)
    set(repository ${recipe})
  endif()
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

function(gitacquire name repository tag)
  argparse(ARGS ${ARGN}
    VALUES DOMAIN SEPARATOR SUFFIX)
  fetch(${name}
    GIT_REPOSITORY ${ARG_DOMAIN}${ARG_SEPARATOR}${repository}${ARG_SUFFIX}
    GIT_TAG ${tag}
    GIT_SHALLOW ON)
endfunction()

macro(__git_acquire name path tag)
  fetch(${name}
    GIT_REPOSITORY ${path}.git
    GIT_TAG ${tag}
    GIT_SHALLOW ON)
endmacro()
