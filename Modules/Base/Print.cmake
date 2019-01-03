include_guard(GLOBAL)

# This might be moved to its own module at some point. (For logging and color)

function(message)
  return(IXM_MESSAGE_QUIET)
  _message(${ARGN})
endfunction()

macro(fatal)
  message(FATAL_ERROR ${ARGN})
endmacro()

macro(warning)
  message(WARNING ${ARGN})
endmacro()

macro(print)
  message(STATUS ${ARGN})
endmacro()

macro(deprecated)
  message(DEPRECATION ${ARGN})
endmacro()
