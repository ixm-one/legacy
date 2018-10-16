include_guard(GLOBAL)

include(AddPackage)
include(Fetch)

function (add_subproject name)
  fetch(${name} ${ARGN})
  add_package(${${name}_SOURCE_DIR} ${${name}_BINARY_DIR} EXCLUDE_FROM_ALL)
endfunction ()
