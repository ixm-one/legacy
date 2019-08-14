include_guard(GLOBAL)

import(IXM::Check::*)

#[[
Meant for checking the current state of the compiler and code
There are several types of checks
1) Exists (does an include file exist, symbol, compiler flag, linker flag, etc)
2) Is a given entity a specific "type", i.e., what trait does it meet? (std::is_*)
3) If the given entity *exists*, is an attribute of said entity true? (sizeof, alignof)
4) Does my code compile?
5) Does my code run? (not available when cross-compiling)
]]
function (Check action)
  list(APPEND structs CLASS STRUCT)
  if (action STREQUAL ENUM)
    ixm_check_enum(${ARGN})
  elseif (action IN_LIST structs)
    ixm_check_class(${ARGN})
  elseif (action STREQUAL UNION)
    ixm_check_union(${ARGN})
  elseif (action STREQUAL INTEGRAL)
    ixm_check_integral(${ARGN})
  elseif (action STREQUAL POINTER)
    ixm_check_pointer(${ARGN})
  elseif (action STREQUAL INCLUDE)
    ixm_check_include(${ARGN})
  elseif (action STREQUAL SIZEOF)
    ixm_check_sizeof(${ARGN})
  elseif (action STREQUAL ALIGNOF)
    ixm_check_alignof(${ARGN})
  else()
    log(FATAL "check(${action}) is not a valid operation")
  endif()
endfunction()
