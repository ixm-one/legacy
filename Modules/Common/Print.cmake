include_guard(GLOBAL)

function(error)
  colorize(text "<red>${ARGN}</>")
  message(FATAL_ERROR ${text})
endfunction()

function(warning)
  colorize(text "<yellow>${ARGN}</>")
  message(WARNING ${text})
endfunction()

function(info)
  print("<cyan>${ARGN}</>")
endfunction()

function(success)
  print("<green>${ARGN}</>")
endfunction()

function (failure)
  print("<crimson>${ARGN}</>")
endfunction()

function(print)
  colorize(text "${ARGN}")
  message(STATUS ${text})
endfunction()
