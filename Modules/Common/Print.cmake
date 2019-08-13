include_guard(GLOBAL)

function(notice)
  if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.15)
    message(NOTICE "${ARGN}")
  else()
    message("[${CMAKE_CURRENT_LIST_FILE}]: ${ARGN}")
  endif()
endfunction()

function(trace)
  if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.15)
    list(JOIN ARGN " " text)
    message(TRACE "${text}")
  endif()
endfunction()

function(error)
  list(JOIN ARGN " " text)
  message(FATAL_ERROR "${.red}${text}${.default}")
endfunction()

function(warning)
  list(JOIN ARGN " " text)
  message(WARNING "${.yellow}${text}${.default}")
endfunction()

function(info)
  print("${.cyan}${ARGN}${.default}")
endfunction()

function(success)
  print("${.lime}${ARGN}${.default}")
endfunction()

function (failure)
  print("${.crimson}${ARGN}${.default}")
endfunction()

function(print)
  list(JOIN ARGN " " text)
  message(STATUS "${text}")
endfunction()
