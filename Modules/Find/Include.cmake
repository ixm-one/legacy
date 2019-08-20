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
    set(package ${package}_${COMPONENT})
  endif()

  set(variable ${package}_INCLUDE_DIR)
  #ixm_find_include_hints(hints ${package})
  find_path(${variable} NAMES ${REMAINDER} HINTS ${HINTS} ${hints})

  if (NOT ${variable})
    return()
  endif()

  mark_as_advanced(${variable})
  dict(INSERT ixm::find::${CMAKE_FIND_PACKAGE_NAME} APPEND INCLUDE ${variable})
  if (TARGET ${library})
    target_include_directories(${library} PUBLIC "${${variable}}")
  endif()
endfunction()
