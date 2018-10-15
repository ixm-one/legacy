include_guard(GLOBAL)

include(FetchContent)
include(ParentScope)

function (fetch name)
  FetchContent_Declare(${name} ${ARGN})
  FetchContent_GetProperties(${name})
  if (NOT ${name}_POPULATED)
    FetchContent_Populate(${name})
  endif ()
  parent_scope(${name}_SOURCE_DIR ${name}_BINARY_DIR)
endfunction ()
