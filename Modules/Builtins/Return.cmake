include_guard(GLOBAL)

# Provides a return() that can take a condition
macro (return)
  if ((${ARGC} AND (${ARGN}) OR (NOT ${ARGC})))
    _return()
  endif()
endmacro()
