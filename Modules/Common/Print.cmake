include_guard(GLOBAL)

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
