include_guard(GLOBAL)

#[[
This function is used to condense a multiline generator expression into a
single line and then place it into the output variable `var`. If a newline is
needed, make sure the entire generator expression section is a "quoted"
argument.
]]
function (genex var)
  if (NOT ARGN)
    error("genex() requires at least one parameter")
  endif()
  string(REPLACE ";" "" genex ${ARGN})
  set(${var} "${genex}" PARENT_SCOPE)
endfunction()
