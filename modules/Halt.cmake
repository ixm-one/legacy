include_guard(GLOBAL)

macro (halt_unless package)
  foreach (var ${ARGN})
    if (NOT ${package}_${var})
      return()
    endif()
  endforeach()
endmacro()
