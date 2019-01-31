include_guard(GLOBAL)

import(IXM::Check::*)

# Meant for checking the current state of the compiler and code
function (Check action)
  list(APPEND structs CLASS STRUCT)
  if (action STREQUAL ENUM)
    ixm_check_enum(${ARGN})
  elseif (action IN_LIST structs)
    ixm_check_class(${ARGN})
  elseif (action STREQUAL UNION)
    ixm_check_union(${ARGN})
  elseif (action STREQUAL INCLUDE)
    ixm_check_include(${ARGN})
  else()
    error("check(${action}) is not a valid operation")
  endif()
endfunction()
