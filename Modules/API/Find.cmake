include_guard(GLOBAL)

import(IXM::Find::*)

# Meant for packages and items stored on the host system
function(find action)
  ixm_find_common_check(${action} ${ARGN})
  if (action STREQUAL "FRAMEWORK")
    ixm_find_framework(${ARGN})
  elseif (action STREQUAL "PROGRAM")
    ixm_find_program(${ARGN})
  elseif (action STREQUAL "LIBRARY")
    ixm_find_library(${ARGN})
  elseif (action STREQUAL "INCLUDE")
    ixm_find_include(${ARGN})
  else()
    log(FATAL "find(${action}) is not a valid operation")
  endif()
endfunction()
