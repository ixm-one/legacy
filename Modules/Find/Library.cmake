include_guard(GLOBAL)

function (ixm_find_library)
  parse(${ARGN}
    @FLAGS DEFAULT
    @ARGS=? COMPONENT
    @ARGS=* HINTS INCLUDE)
  ixm_find_common_check(LIBRARY ${ARGN})
  ixm_find_common_names(library)
  ixm_find_common_hints(hints)

  set(variable ${name}_LIBRARY)
  find_library(${variable} NAMES ${REMAINDER} HINTS ${HINTS} ${hints})

  set(required-component ${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_${COMPONENT})
  set(name ixm::find::${CMAKE_FIND_PACKAGE_NAME})
  if (NOT DEFINED COMPONENT)
    dict(APPEND ${name} VARIABLES ${variable})
  elseif (${required-component})
    dict(APPEND ${name} REQUIRED ${COMPONENT})
  endif()

  if (NOT ${variable})
    return()
  endif()

  set(value "${${variable}}")
  mark_as_advanced(${variable})
  add_library(${library} UNKNOWN IMPORTED GLOBAL)
  set_target_properties(${library} PROPERTIES IMPORTED_LOCATION "${value}")
  if (COMPONENT)
    dict(APPEND ${name} ${COMPONENT} ${variable})
  endif()
endfunction()
