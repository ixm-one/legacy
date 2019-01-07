include_guard(GLOBAL)

include(FindPackageHandleStandardArgs)

# TODO: Add a REQUIRED flag
macro (find_library name)
  _find_library(${name} ${ARGN} ${IXM_FIND_OPTIONS})
endmacro()

# TODO: Add a REQUIRED flag
# TODO: Add a "type" argument (aka PROGRAM/LIBRARY flag maybe instead)
function (find_component name type)
  list(APPEND IXM_${IXM_FIND_PACKAGE}_COMPONENTS ${name})
  if (REQUIRED)
    list(APPEND IXM_${IXM_FIND_PACKAGE}_REQUIRED_COMPONENTS)
  endif()
  parent_scope(IXM_${IXM_FIND_PACKAGE}_REQUIRED_COMPONENTS)
  parent_scope(IXM_${IXM_FIND_PACKAGE}_COMPONENTS)
endfunction()

# TODO: Add a REQUIRED flag
function (find_header)
endfunction()

# TODO:
function (find_version)
endfunction()

function (find_check package)
  if (IXM_${package}_REQUIRED_COMPONENTS)
    list(APPEND args HANDLE_COMPONENTS)
  endif()
  foreach (entry IN LISTS IXM_${package}_REQUIRED_COMPONENTS)
    list(APPEND args ${package}_${entry})
  endforeach()
  find_package_handle_standard_args(${package}
    REQUIRED_VARS ${IXM_${package}_REQUIRED})
  return(NOT ${package}_FOUND)
endfunction()
