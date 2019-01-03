include_guard(GLOBAL)

# Defines COLOR variables in PARENT_SCOPE
# Can optionally take a PREFIX
# We actually only define BOLD to stand out :v
function(ixm_colors)
  set(PREFIX ARGV0)
  if (NOT PREFIX)
    set(PREFIX COLOR_)
  endif()
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
