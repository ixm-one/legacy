include_guard(GLOBAL)

import(IXM::Check::*)

# Meant for checking the current state of the compiler and code
function (Check action)
  if (action STREQUAL ENUM)
    ixm_check_enum(${ARGN})
  elseif (action IN_LIST "CLASS;STRUCT")
    ixm_check_class(${ARGN})
  elseif (action STREQUAL UNION)
    ixm_check_union(${ARGN})
  else()
    error("check(${action}) is not a valid operation")
  endif()
endfunction()
