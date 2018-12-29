include_guard(GLOBAL)

include(FindPackageHandleStandardArgs)

macro (find_package name)
  string(TOUPPER ${name} pkg)
  set(IXM_FIND_PACKAGE ${name}_)
  set(IXM_FIND_OPTIONS
    HINTS
      ENV ${pkg}_ROOT_DIR
      ENV ${pkg}_DIR
      ENV ${pkg}DIR
      "${${name}_ROOT_DIR}"
      "${${name}_DIR}"
      "${${name}DIR}"
      "${${pkg}_ROOT_DIR}"
      "${${pkg}_DIR}"
      "${${pkg}DIR}")
  unset(pkg)
  _find_package(${name} ${ARGN})
  unset(IXM_FIND_OPTIONS)
  unset(IXM_FIND_PACKAGE)
endmacro()

# TODO: Add a REQUIRED flag
function (find_library name)
  _find_library(${IXM_FIND_PACKAGE}${name} ${ARGN} ${IXM_FIND_OPTIONS})
endfunction()

# TODO: Add a REQUIRED flag
function (find_program name)
  _find_program(${IXM_FIND_PACKAGE}${name} ${ARGN} ${IXM_FIND_OPTIONS})
endfunction()

# TODO: Add a REQUIRED flag
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
