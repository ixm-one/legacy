include_guard(GLOBAL)

function (ixm_find_framework name)
  ixm_find_common_check(FRAMEWORK ${ARGN})
  parse(${ARGN} @ARGS=? COMPONENT HEADER @ARGS=* HINTS)
  set(name ${CMAKE_FIND_PACKAGE_NAME})

  set(library ${name}_LIBRARY)
  set(include ${name}_INCLUDE)
  set(target ${name}::${name})

  var(header HEADER ${name}.h)
  set(CMAKE_FIND_FRAMEWORK ONLY)
  find_library(${library} NAMES ${name} HINTS ${hints} ${HINTS})
  find_path(${include} NAMES "${name}/${header}" HINTS ${hints} ${HINTS})

  if (NOT ${library})
    return()
  endif()

  if (NOT ${include})
    return()
  endif()

  mark_as_advanced(${library} ${include})
  add_library(${target} IMPORTED GLOBAL)
  target_include_directories(${target} INTERFACE ${${include}})
  set_target_properties(${target} PROPERTIES IMPORTED_LOCATION ${${library}})
  map(APPEND ixm::find::${CMAKE_FIND_PACKAGE_NAME} FRAMEWORK ${name})
endfunction()
