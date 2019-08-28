include_guard(GLOBAL)

function (ixm_find_include)
  parse(${ARGN}
    @ARGS=? COMPONENT
    @ARGS=* HINTS)
  ixm_find_common_check(INCLUDE ${ARGN})
  ixm_find_common_names(include)
  ixm_find_common_hints(hints)
  
  set(library ${CMAKE_FIND_PACKAGE_NAME}::${CMAKE_FIND_PACKAGE_NAME})
  set(package ${CMAKE_FIND_PACKAGE_NAME})
  if (COMPONENT)
    set(library ${CMAKE_FIND_PACKAGE_NAME}::${COMPONENT})
    set(package ${CMAKE_FIND_PACKAGE_NAME}_${COMPONENT})
  endif()

  set(variable ${package}_INCLUDE_DIR)
  find_path(${variable} NAMES ${REMAINDER} HINTS ${HINTS} ${hints})

  set(required-component ${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_${COMPONENT})
  set(name ixm::find::${CMAKE_FIND_PACKAGE_NAME})
  if (NOT DEFINED COMPONENT)
    dict(INSERT ${name} VARIABLES APPEND ${variable})
  elseif (${required-component})
    dict(INSERT ${name} REQUIRED APPEND ${COMPONENT})
  endif()

  if (NOT ${variable})
    return()
  endif()

  set(value "${${variable}}")
  mark_as_advanced(${variable})

  if (COMPONENT)
    dict(INSERT ${name} ${COMPONENT} APPEND ${variable})
  endif()

  if (TARGET ${library})
    set_property(TARGET ${library} APPEND
      PROPERTY
        INTERFACE_INCLUDE_DIRECTORIES "${value}")
  endif()
endfunction()
