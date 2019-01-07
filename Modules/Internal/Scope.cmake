include_guard(GLOBAL)

macro(ixm_upvar)
  foreach(var ${ARGN})
    if (DEFINED ${var})
      set(${var} "${${var}}" PARENT_SCOPE)
    endif()
  endforeach()
endmacro()

function (ixm_internal name value)
  set(${name} "${value}" CACHE INTERNAL "${ARGN}")
endfunction()

# This is *not* for forcing values
function (ixm_cache name value type)
  set(${name} "${value}" CACHE ${type} "${ARGN}")
endfunction()
