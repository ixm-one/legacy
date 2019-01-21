include_guard(GLOBAL)

function(error)
  colors()
  message(FATAL_ERROR ${COLOR_RED}${ARGN}${COLOR_RESET})
endfunction()

function(warning)
  colors()
  if (WIN32)
    execute_process(COMMAND "${CMAKE_COMMAND}"
      "-E" "cmake_echo_color" "--yellow" ${ARGN})
  else()
    message(WARNING ${COLOR_YELLOW}${ARGN}${COLOR_RESET})
  endif()
endfunction()

function(info)
  colors()
  message(STATUS ${COLOR_CYAN}${ARGN}${COLOR_RESET})
endfunction()

function(success)
  colors()
  message(STATUS ${COLOR_GREEN}${ARGN}${COLOR_RESET})
endfunction()

function(print)
  colors()
  message(STATUS ${COLOR_BOLD}${ARGN}${COLOR_RESET})
endfunction()
