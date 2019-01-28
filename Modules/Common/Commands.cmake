include_guard(GLOBAL)

#[[
Though generic in name this simply checks that a given name and action
will result in a valid invoke
]]
function (verify_actions name action)
  string(TOUPPER ${name} upper)
  get_property(valid-actions GLOBAL PROPERTY IXM_${upper}_ACTIONS)
  if (NOT action IN_LIST valid-actions)
    error("'${name}(${action})' is not a valid operation")
  endif()
  get_property(command GLOBAL PROPERTY IXM_${upper}_${action})
  if (NOT command)
    error("'${name}(${action})' command implementation is missing")
  endif()
  if (NOT COMMAND ${command})
    error("'${name}(${action})' resolves to an invalid command '${command}'")
  endif()
  set(${name} ${command} PARENT_SCOPE)
endfunction()

#[[
This module is for various miscellanous commands that don't really have a
particular theme other than "Used inside of commands to improve the CMake
experience"
]]

function(invoke name)
  if (NOT COMMAND ${name})
    error("Cannot call invoke() with non-existant command '${name}'")
  endif()
  set(call "${CMAKE_BINARY_DIR}/IXM/Invoke/${name}.cmake")
  if (NOT EXISTS "${call}")
    string(CONFIGURE [[@name@(${ARGN})]] content @ONLY)
    file(WRITE "${call}" "${content}")
  endif()
  include(${call})
endfunction()

#[[Works like set() but with a default value if the lookup value is undefined]]
macro(var var lookup default)
  set(__@default ${default} ${ARGN})
  if (DEFINED ${lookup})
    set(__@default ${${lookup}} ${ARGN})
  endif()
  set(${var} ${__\@default})
  unset(__@default)
endmacro()

#[[

Allows placing variables in the parent_scope without having to continually call
`set(var ${var} PARENT_SCOPE)` for each one. Instead, we can pass in as many
as we want :)

]]
macro(upvar)
  foreach(var ${ARGN})
    if (DEFINED ${var})
      set(${var} "${${var}}" PARENT_SCOPE)
    endif()
  endforeach()
endmacro()

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
