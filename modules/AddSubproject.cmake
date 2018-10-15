include_guard(GLOBAL)

include(Fetch)

function (add_subproject name)
  fetch(${name} ${ARGN})
  add_subdirectory(${${name}_SOURCE_DIR} ${${name}_BINARY_DIR} EXCLUDE_FROM_ALL)
endfunction ()
