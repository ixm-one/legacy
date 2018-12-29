include_guard(GLOBAL)

include(FindPackageHandleStandardArgs)

function (check_find_package package)
  argparse(${ARGN}
    @FLAGS COMPONENTS
    @ARGS=? VERSION)

  if (NOT DEFINED COMPONENTS AND NOT DEFINED VERSION AND NOT DEFINED REMAINDER)
    fatal("check_find_package requires any of: COMPONENTS VERSION ...")
    return()
  endif()

  if (NOT REMAINDER)
    fatal("check_find_package requires at least one variable")
    return()
  endif()

  if (DEFINED ${package}_VERSION)
    set(VERSION VERSION_VAR ${package}_VERSION)
  endif()

  if (DEFINED COMPONENTS)
    set(COMPONENTS HANDLE_COMPONENTS)
  endif ()

  if (DEFINED VERSION)
    set(VERSION VERSION_VAR ${package}_${VERSION})
  endif()

  if (REMAINDER)
    list(APPEND REQUIRED REQUIRED_VARS)
  endif()

  foreach (var IN LISTS REMAINDER)
    list(APPEND REQUIRED ${package}_${var})
  endforeach()

  find_package_handle_standard_args(${package}
    ${REQUIRED} ${VERSION} ${COMPONENTS})
  parent_scope(${package}_FOUND)
endfunction ()
