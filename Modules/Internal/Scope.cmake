include_guard(GLOBAL)

macro(upvar)
  foreach(var ${ARGN})
    if (DEFINED ${var})
      set(${var} "${${var}}" PARENT_SCOPE)
    endif()
  endforeach()
endmacro()

# This is for forcing values
function (internal name value)
  cache(INTERNAL ${name} "${value}" "${ARGN}")
endfunction()

# This is *not* for forcing values
function (cache type name value)
  set(${name} "${value}" CACHE ${type} "${ARGN}")
endfunction()
