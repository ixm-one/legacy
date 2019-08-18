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
    log(FATAL "Cannot call invoke() with non-existant command '${name}'")
  endif()
  set(call "${CMAKE_BINARY_DIR}/IXM/Invoke/${name}.cmake")
  if (NOT EXISTS "${call}")
    string(CONFIGURE [[@name@(${ARGN})]] content @ONLY)
    file(WRITE "${call}" "${content}")
  endif()
  locals(old-locals)
  include(${call})
  locals(current)
  list(REMOVE_ITEM current ${old-locals} old-locals)
  upvar(${current})
endfunction()

#[[Works like set() but with a default value if the lookup value is undefined]]
macro(var var lookup)
  set(__@default ${ARGN})
  if (DEFINED ${lookup})
    set(__@default ${${lookup}})
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
Sets all variables in the current scope to a list. Intended for internal
use and debugging purposes
]]
function (locals out-var)
  get_directory_property(locals VARIABLES)
  set(${out-var} ${locals} PARENT_SCOPE)
endfunction()

#[[
This function is used to condense a multiline generator expression into a
single line and then place it into the output variable `out-var`. If a newline
is needed, make sure the entire generator expression section is a "quoted"
argument.
]]
function (genexp out-var)
  if (NOT ARGN)
    error("genexp() requires at least one parameter")
  endif()
  string(REPLACE ";" "" genexp ${ARGN})
  set(${out-var} "${genexp}" PARENT_SCOPE)
endfunction()
