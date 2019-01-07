include_guard(GLOBAL)

function(error)
  ixm_colors()
  message(FATAL_ERROR ${COLOR_RED}${ARGN}${COLOR_RESET})
endfunction()

function(warning)
  ixm_colors()
  message(WARNING ${COLOR_YELLOW}${ARGN}${COLOR_RESET})
endfunction()

function(info)
  ixm_colors()
  message(STATUS ${COLOR_CYAN}${ARGN}${COLOR_RESET})
endfunction()

function(success)
  ixm_colors()
  message(STATUS ${COLOR_GREEN}${ARGN}${COLOR_RESET})
endfunction()

function(print)
  ixm_colors()
  message(STATUS ${COLOR_BOLD}${ARGN}${COLOR_RESET})
endfunction()
