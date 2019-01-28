include_guard(GLOBAL)
include(FindPackageHandleStandardArgs)

macro (check_package package)
  find_package_handle_standard_args(${package} ${ARGN})
  if (NOT ${package}_FOUND)
    return()
  endif()
endmacro()
