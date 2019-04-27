include_guard(GLOBAL)

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