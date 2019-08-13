include_guard(GLOBAL)

#[[ Prints the current value of the given variable ]]
macro(inspect)
  foreach (var ${ARGN})
    if (DEFINED ${var})
      message("${var} := ${${var}}")
    else()
      message("${var} := $<UNDEFINED>")
    endif()
  endforeach()
endmacro()

macro(debug)
  message(DEPRECATION "COMMAND debug() is deprecated. Please use inspect() instead")
  inspect(${ARGN})
endmacro()

