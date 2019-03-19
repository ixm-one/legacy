include_guard(GLOBAL)

# Defines COLOR variables in PARENT_SCOPE
# We actually only define BOLD so the colors stand out :v
function(colors)
  # TODO: Initial configuration 
  if (WIN32 AND NOT CMAKE_GENERATOR STREQUAL "Ninja")
    return()
  endif()
  set(PREFIX COLOR_)
  string(ASCII 27 esc)
  set(${PREFIX}RESET "${esc}[m" PARENT_SCOPE)
  set(${PREFIX}BOLD "${esc}[1m" PARENT_SCOPE)
  set(${PREFIX}RED "${esc}[1;31m" PARENT_SCOPE)
  set(${PREFIX}GREEN "${esc}[1;32m" PARENT_SCOPE)
  set(${PREFIX}YELLOW "${esc}[1;33m" PARENT_SCOPE)
  set(${PREFIX}BLUE "${esc}[1;34m" PARENT_SCOPE)
  set(${PREFIX}MAGENTA "${esc}[1;35m" PARENT_SCOPE)
  set(${PREFIX}CYAN "${esc}[1;36m" PARENT_SCOPE)
endfunction()

#[[ For my friends across the pond :) ]]
macro(colours)
  colors(${ARGN})
endmacro()
