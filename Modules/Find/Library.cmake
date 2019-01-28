include_guard(GLOBAL)

#Find(LIBRARY BulletMath LinearMath COMPONENT Math)
#Find(LIBRARY BulletCollision COMPONENT Collision)
#Find(LIBRARY BulletDynamics COMPONENT Dynamics)
#Find(LIBRARY BulletSoftbody COMPONENT SoftBody)
#Find(INCLUDE bullet/btBulletCollisionCommon.h)
#Find(CONFIRM)

function (ixm_find_library)
  parse(${ARGN}
    @ARGS=? COMPONENT
    @ARGS=* HINTS)
  ixm_find_common_check(LIBRARY ${ARGN})
  ixm_find_common_names(library)
  ixm_find_common_hints(hints)

  set(variable ${name}_LIBRARY)
  find_library(${variable} NAMES ${REMAINDER} HINTS ${HINTS} ${hints})

  if (NOT ${variable})
    return()
  endif()

  set(value "${${variable}}")
  mark_as_advanced(${variable})
  add_library(${library} IMPORTED GLOBAL)
  set_target_properties(${library} PROPERTIES IMPORTED_LOCATION "${value}")
  map(APPEND ixm::find::${CMAKE_FIND_PACKAGE_NAME} LIBRARY ${library})
  if (COMPONENT)
    target_link_libraries(${CMAKE_FIND_PACKAGE_NAME}::${CMAKE_FIND_PACKAGE_NAME}
      PUBLIC ${library})
  endif()
endfunction()
