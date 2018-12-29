include_guard(GLOBAL)

#[[ Basically set() with a fallback value]]
macro(get var lookup default)
  set(${var} ${default} ${ARGN})
  if (DEFINED ${lookup} AND ${lookup})
    set(${var} ${${lookup}} ${ARGN})
  endif()
endmacro()
