include_guard(GLOBAL)

macro (breakout var)
  if (NOT ${var})
    return()
  endif()
endmacro()
