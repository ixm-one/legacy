include_guard(GLOBAL)

#[[ Prints the current value of the given variable ]]
macro(debug)
  foreach(var ${ARGN})
    if (DEFINED ${var})
      message("${var} := ${${var}}")
    else()
      message("${var} := $<UNDEFINED>")
    endif()
  endforeach()
endmacro()

