include_guard(GLOBAL)

# These are macros because they just wrap existing builtin commands

function (message)
  if (NOT IXM_MESSAGE_QUIET)
    _message(${ARGN})
  endif()
endfunction()

macro (fatal)
  message(FATAL_ERROR "${ARGN}")
endmacro ()

macro (error)
  message(SEND_ERROR "${ARGN}")
endmacro()

macro (warning)
  message(WARNING "${ARGN}")
endmacro ()

macro (author)
  message(AUTHOR_WARNING "${ARGN}")
endmacro()

macro (status)
  message(STATUS "${ARGN}")
endmacro()

macro (deprecated)
  message(DEPRECATION "${ARGN}")
endmacro ()

# Alias macros
macro (note)
  message(STATUS "NOTE: ${ARGN}")
endmacro()

macro (info)
  message(STATUS "${ARGN}")
endmacro()

macro (print)
  message(STATUS "${ARGN}")
endmacro()

macro (warn)
  message(WARNING "${ARGN}")
endmacro()
