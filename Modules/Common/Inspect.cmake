include_guard(GLOBAL)

#[[ Prints the current value of the given variables ]]
function (inspect)
  foreach (var IN LISTS ARGN)
    if (DEFINED ${var})
      message("${var} := ${${var}}")
    else()
      message("${var} := $<UNDEFINED>")
    endif()
  endforeach()
endfunction()
