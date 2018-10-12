include_guard(GLOBAL)

include(FetchContent)
include(ParentScope)

function (fetch name)
  FetchContent_Declare(${name} ${ARGN})
  FetchContent_GetProperties(${name})
  if (${name}_POPULATED)
    FetchContent_Populate(${name})
  endif ()
endfunction ()
