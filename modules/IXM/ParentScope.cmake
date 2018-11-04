include_guard(GLOBAL)

macro (parent_scope)
  foreach(var ${ARGN})
    set(${var} ${${var}} PARENT_SCOPE)
  endforeach()
endmacro ()
