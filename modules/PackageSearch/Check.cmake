include_guard(GLOBAL)

include(FindPackageHandleStandardArgs)

function (check_find_package package)
  set(option COMPONENTS)
  set(single VERSION)
  set(multi)
  cmake_parse_arguments(ARG "${option}" "${single}" "${multi}" ${ARGN})

  any_of(args DEFINED ARG_COMPONENTS ARG_VERSION ARG_UNPARSED_ARGUMENTS)
  if (NOT args)
    error("check_find_package requires any of: COMPONENTS VERSION ...")
    return()
  endif()

  if (NOT ARG_UNPARSED_ARGUMENTS)
    error("check_find_package requires at least one variable")
    return()
  endif()

  if (DEFINED ${package}_VERSION)
    set(VERSION VERSION_VAR ${package}_VERSION)
  endif()

  if (DEFINED ARG_COMPONENTS)
    set(COMPONENTS HANDLE_COMPONENTS)
  endif ()

  if (DEFINED ARG_VERSION)
    set(VERSION VERSION_VAR ${package}_${ARG_VERSION})
  endif()

  if (ARG_UNPARSED_ARGUMENTS)
    list(APPEND REQUIRED REQUIRED_VARS)
  endif()

  foreach (var IN LISTS ARG_UNPARSED_ARGUMENTS)
    list(APPEND REQUIRED ${package}_${var})
  endforeach()

  find_package_handle_standard_args(${package}
    ${REQUIRED} ${VERSION} ${COMPONENTS})
  parent_scope(${package}_FOUND)
endfunction ()
